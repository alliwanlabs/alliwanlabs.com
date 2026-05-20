---
layout: page
title: "AI improves expense report compilation"
recipe: 003
x: expense report compilation
tools: ["Claude", "Gmail API", "Excel/XLSX", "Odoo (or Xero / Concur / Expensify)"]
substrate: data
pattern: "AI-Around-Judgement"
permalink: /recipes/003-expense-report-compilation/
---

> Expense filing is the canonical deferred-work task — small, dull, repeatedly deferred until it's three months stale and worth twice the original headache. A four-step Gmail-sweep → curate → push → merge pipeline collapses what was a biweekly half-day into ~20 minutes of supervision, with the human keeping the inclusion decision.

## Before

A consultant, contractor, or employee with multiple cost lines (cloud subscriptions, AI tools, biz SaaS, travel) needs to submit reimbursable expenses on a fixed cadence (monthly, biweekly, end-of-project). Each cycle requires: locating the receipts (scattered across Gmail, often in HTML emails not attachments), separating reimbursable from personal, transcribing amounts into the company's preferred format (Xero, Concur, Expensify, or a custom Odoo destination), attaching every receipt PDF to the correct line, and producing a single merged document the finance reviewer can audit.

The activity is sub-15-min if you batch it weekly. It is half a day if you defer it a month. It is a full day plus reconstruction archaeology if you defer it a quarter. **The "deferred state" cost compounds non-linearly**, which is exactly why the task gets deferred — every individual deferral feels cheap. The pattern is general: sub-15-min admin tasks lose to meetings and deep work, until they aren't sub-15-min anymore.

Naive AI use here ("Claude, please file my expenses") fails for a specific reason: the inclusion / exclusion decision is judgement, not pattern-matching. A subscription invoice from a cloud provider might be reimbursable (production infra) or not (personal). The AI cannot know — but it can do everything *around* the judgement step, leaving the human to make N quick yes/no calls instead of N+M data-entry tasks.

## The recipe

Four steps. Each produces an artefact. The human owns step 2 (the judgement step) and signs off on step 4.

1. **Sweep — Gmail receipts in a date range.** Prompt Claude (with Gmail MCP access) to scan the inbox for the period (e.g. 2026-06-01 to 2026-06-15) for receipt / invoice patterns: subjects containing "receipt", "invoice", "your order", "payment", "subscription renewed", "thank you for your purchase". Output: a structured list with `date`, `vendor`, `amount`, `currency`, `gmail_message_id`, `attachment_present_y_n`, `inferred_category` (cloud / SaaS / travel / hardware / other), and a one-line `inferred_purpose`.

   ```
   Sweep my Gmail for receipt/invoice/subscription emails between <start_date>
   and <end_date>. For each one, return: date, vendor, amount, currency,
   message ID, whether a receipt PDF is attached, inferred category, and a
   one-line inferred purpose. Be exhaustive — false positives are cheaper
   than false negatives at this stage; I will curate next.
   ```

2. **Curate — y-marked XLSX.** Claude writes the sweep output to an XLSX with one row per candidate expense and an empty `include` column. The human opens the spreadsheet and marks `y` (include in this report) or leaves blank (exclude). This is the **only human-judgement step** and it is fast: each row is a one-character decision, and the rows already carry enough context for the call. **The judgement is portable** — the same y/blank decisions encode the company's specific inclusion rules (e.g. "AI tools and biz SaaS = include; personal travel and family/infra = exclude") without needing to teach Claude the rules in prose.

3. **Push y-marked rows to the destination system.** Claude reads back the XLSX, filters for `include = y`, and pushes to the company's destination (Odoo via MCP; could equally be Xero, Concur, Expensify). One record per included row, linked to the original Gmail message ID for audit traceability.

4. **Merge — single submission PDF.** Claude produces a final PDF with:
   - Cover page (period, totals by currency, totals by category, name + date).
   - One detail page per expense (line item details, inferred purpose, link to source email).
   - The original receipt PDF appended inline after each detail page (or a "receipt is in email body" note for HTML-only receipts).

   This is the artefact the human submits / forwards to the finance reviewer. **The cover page is the audit map**; the per-expense detail pages let the reviewer verify any one line without leaving the document.

## After

Applied as the engineered cure for a previously chronic deferred-work problem (expense filing recurrently deferred 2+ weeks):

- **Biweekly cadence locked**: 15th of month + end-of-month, two ~20-minute supervision sessions instead of one monthly half-day session that kept getting deferred.
- **Re-filing latency dropped from "weeks" to "same fortnight."** The reimbursement loop closes within the same biweekly window, which has its own knock-on effect: cashflow predictability + no quarterly reconstruction sessions.
- **Inclusion error rate at zero** (so far) — the y-mark step makes the inclusion decision *the* explicit step, not a side-effect of data entry, which is when errors typically slip in.
- **Inclusion rule stays portable** — the y-marked XLSX is the durable artefact of what counts as reimbursable for this principal, this employer, this period. Encoded as data, not as prose.

The recipe converts a deferred-work-prone task into a forcing-function task by setting the cadence at "small enough to never feel worth deferring."

## When this works

- **Recurring expense-filing cadences** where the inclusion rules are stable and the principal can make y/blank judgement calls quickly.
- **Receipts that land in email** (the dominant case for cloud subscriptions, online travel, SaaS, AI tools). Less applicable when receipts are physical paper requiring a separate ingestion step.
- **Destination systems with API access** (Odoo, Xero, Concur, Expensify) — the push step needs to be programmable. Fully-manual destination forms degrade the recipe to a 3-step pipeline (sweep → curate → submit-manually) but still preserve most of the value.
- **Principals who keep the inclusion judgement** — the recipe assumes the human owns the y-mark step. Delegating *that* step is delegating the judgement, which is when reimbursable lines start drifting into personal lines (and vice versa).

## When this doesn't

- **First-time runs without a stable inclusion rule.** If you don't yet know what's reimbursable under this employer / contract / period, the recipe will surface candidates faster than you can decide on them. Spend one cycle establishing the rule, then this recipe captures and accelerates it.
- **Cash receipts and paper-only flows** — the sweep step assumes Gmail (or equivalent indexed inbox). Paper receipts need a separate ingestion step (phone snapshot → OCR → manual category) before joining the pipeline.
- **Highly variable formats per period** — recurring SaaS is well-suited; ad-hoc M&A travel with bespoke per-trip receipts is less so. The cover page taxonomy assumes some category stability.
- **When the principal won't open the XLSX.** The recipe lives or dies on the human y-mark step. Skipping it converts the recipe into "Claude files my expenses" — at which point inclusion errors are inevitable and the audit trail breaks at the judgement boundary.

## Pattern

> *This is an example of: **AI-Around-Judgement** — the AI runs every step *around* a single human-judgement step, with the judgement encoded as data (a y-mark, a checkbox, a small rubric output) rather than reproduced in prose for the AI to follow.*

The pattern's defensibility rests on the **explicit human-judgement gate** as a structural element, not as a polite afterthought. Removing the gate is what converts the recipe into an AI-autonomy claim it cannot back. The pattern generalises beyond expense filing to: triage of pull requests, candidate screening for hiring (AI surfaces, human shortlists), email-to-task conversion, document-batch classification, contract-redline review.

The pattern's secret: **encoding judgement as data makes it portable across cadences and across systems.** The y-marked XLSX from this cycle is also the training spec for next cycle, the audit trail for finance review, and the encoded company-specific inclusion rule — all in one artefact. Prose explanations of the rule rot; the data-encoded judgement does not.
