#!/usr/bin/env bash
# Deploy the newsletter subscribe Worker + KV + route for alliwanlabs.com.
# Idempotent. Requires keychain item `dex-cloudflare-workers-token` with scopes:
#   Account · Workers Scripts : Edit
#   Account · Workers KV Storage : Edit
#   Zone (alliwanlabs.com) · Workers Routes : Edit
set -euo pipefail

ACCOUNT_ID="12798e89a91f3136ff64a4801a933631"
ZONE_ID="bb6d453d205c58f6f7e7f8f194d16ff8"     # alliwanlabs.com
SCRIPT_NAME="labs-newsletter"
KV_TITLE="labs-newsletter"
ROUTE_PATTERN="alliwanlabs.com/api/subscribe"
KEYCHAIN_ITEM="dex-cloudflare-workers-token"
HERE="$(cd "$(dirname "$0")" && pwd)"

TOKEN="$(security find-generic-password -s "$KEYCHAIN_ITEM" -w)"
[ -n "$TOKEN" ] || { echo "ERROR: keychain item '$KEYCHAIN_ITEM' empty" >&2; exit 1; }
cf() { curl -s -H "Authorization: Bearer $TOKEN" "$@"; }

echo "1/3 KV namespace…"
KV_ID=$(cf "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/storage/kv/namespaces?per_page=100" \
  | python3 -c "import json,sys; r=json.load(sys.stdin)['result']; print(next((n['id'] for n in r if n['title']=='$KV_TITLE'),''))")
if [ -z "$KV_ID" ]; then
  KV_ID=$(cf -X POST "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/storage/kv/namespaces" \
    -H "Content-Type: application/json" -d "{\"title\":\"$KV_TITLE\"}" \
    | python3 -c "import json,sys; print(json.load(sys.stdin)['result']['id'])")
  echo "  created: $KV_ID"
else
  echo "  exists: $KV_ID"
fi

echo "2/3 Worker script…"
METADATA=$(cat <<EOF
{"main_module":"newsletter.js","bindings":[{"type":"kv_namespace","name":"NEWSLETTER","namespace_id":"$KV_ID"}],"compatibility_date":"2026-07-01"}
EOF
)
cf -X PUT "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/scripts/$SCRIPT_NAME" \
  -F "metadata=$METADATA;type=application/json" \
  -F "newsletter.js=@$HERE/../workers/newsletter.js;type=application/javascript+module" \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print('  uploaded' if d['success'] else d['errors'])"

echo "3/3 Route…"
EXISTS=$(cf "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/workers/routes" \
  | python3 -c "import json,sys; r=json.load(sys.stdin)['result']; print(next((x['id'] for x in r if x['pattern']=='$ROUTE_PATTERN'),''))")
if [ -z "$EXISTS" ]; then
  cf -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/workers/routes" \
    -H "Content-Type: application/json" \
    -d "{\"pattern\":\"$ROUTE_PATTERN\",\"script\":\"$SCRIPT_NAME\"}" \
    | python3 -c "import json,sys; d=json.load(sys.stdin); print('  created' if d['success'] else d['errors'])"
else
  echo "  exists: $EXISTS"
fi

echo "Done. Test: curl -s -X POST https://alliwanlabs.com/api/subscribe -H 'Content-Type: application/json' -d '{\"email\":\"test@example.com\"}'"
echo "List subscribers: cf GET accounts/$ACCOUNT_ID/storage/kv/namespaces/$KV_ID/keys"
