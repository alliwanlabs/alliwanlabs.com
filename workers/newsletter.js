/**
 * Al Liwan Labs — newsletter subscribe endpoint.
 * Route: alliwanlabs.com/api/subscribe (POST {email})
 * Storage: KV binding NEWSLETTER (key = email, value = {ts, ua}).
 * Deploy: scripts/deploy-newsletter-worker.sh
 */
const EMAIL_RE = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;

function json(body, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname !== "/api/subscribe") return json({ ok: false, error: "not found" }, 404);
    if (request.method !== "POST") return json({ ok: false, error: "method not allowed" }, 405);
    let email;
    try {
      ({ email } = await request.json());
    } catch {
      return json({ ok: false, error: "bad request" }, 400);
    }
    email = (email || "").toLowerCase().trim();
    if (!EMAIL_RE.test(email) || email.length > 254) {
      return json({ ok: false, error: "invalid email" }, 400);
    }
    await env.NEWSLETTER.put(
      email,
      JSON.stringify({ ts: new Date().toISOString(), ua: request.headers.get("user-agent") || "" })
    );
    return json({ ok: true });
  },
};
