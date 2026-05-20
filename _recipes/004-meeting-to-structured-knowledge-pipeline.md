---
layout: page
title: "AI improves meeting → person-page → tasks pipeline"
recipe: 004
x: meeting capture and knowledge structuring
tools: ["Claude", "Local on-device ASR", "Cloud diarised ASR", "Markdown-based personal knowledge system"]
substrate: conversation
pattern: "Pipeline With Fan-Out"
permalink: /recipes/004-meeting-to-structured-knowledge-pipeline/
---

> Meetings produce four kinds of knowledge — what was said, who said it, what was decided, what was promised — and the value of a meeting decays in hours unless those four are extracted and routed to durable locations. A two-tier transcription pipeline plus a structured-extraction pass plus a cascade-update mechanism converts a 30-minute call into a 90-second supervised round-trip and a permanent knowledge graph entry.

## Before

A professional with many ongoing relationships and projects holds 5–15 meetings a week — calls, working sessions, partner syncs, hiring conversations. Each meeting produces context, decisions, action items, and updates to mental models of people and projects. **Without a pipeline, this context dies.** Within 48 hours: action items are half-remembered; decisions get re-litigated because nobody captured the rationale; the person you spoke to last week is conflated with the person you spoke to two weeks ago.

The naive fix — "write meeting notes" — fails on volume. A diligent note-taker who hand-writes structured notes after every meeting buys ~30 minutes per meeting in note-taking labour, totalling several hours a week of pure overhead, and even then the notes live as text files unreferenced by anything else (no cascade to person pages, no extracted task list, no link to projects). The notes become a write-only graveyard.

Naive AI use — "Claude, summarise this transcript" — produces fluent summaries that compress the wrong things (often the rapport-building moments at the cost of the load-bearing decisions) and *still leaves the cascade problem unsolved* — the summary lives in a text file, not in a graph.

## The recipe

A four-stage pipeline. Stages 1 and 2 run automatically during / immediately after the meeting; stages 3 and 4 run on supervised demand.

1. **Two-tier capture.** A meeting is recorded by *two* transcription tools running in parallel:
   - **Tier A: local, immediate, low-quality.** Runs on-device during the call. Output ready when the call ends. Good enough for "what was said in the first ten minutes" recall, not good enough for downstream structured extraction. (Examples: parakeet, whisper variants running locally.)
   - **Tier B: cloud, batched, high-quality, diarised.** Runs as a batch job within minutes-to-hours of the call. ~50–65% readability improvement over Tier A; named speakers if diarisation is enabled. (Examples: cloud transcription APIs with diarisation.)

   **Always prefer Tier B for downstream extraction.** Tier A is the safety net for immediate post-call review; Tier B is the substrate for everything else.

2. **Hand-off to structured-extraction prompt.** Once Tier B is ready, the transcript is fed to Claude with a prompt that extracts **four kinds of structured knowledge** in parallel:

   ```
   This is a diarised transcript from a meeting on <date> between
   <named participants>. Extract:

   1. KEY_POINTS — 5–10 bullets on what was discussed substantively.
       Skip rapport-building; preserve decisions, framings, disagreements,
       new information.
   2. DECISIONS — explicit decisions made in the meeting, with the
       deciding party and any conditions / open-ends.
   3. ACTION_ITEMS — commitments. For each: who owns it, what specifically
       they committed to, by when (absolute date — convert "next week"
       to YYYY-MM-DD using the meeting date as the anchor), and which
       project or person it links to.
   4. PEOPLE_MENTIONED — every named human or org, with one-line context
       on how they came up (so the person-page reader can locate the
       reference fast).

   Be exhaustive on ACTION_ITEMS — false positives are cheaper than
   false negatives at this stage; the human will curate downstream.

   ⚠️ Verify named entities against the existing people index before
   propagating; cloud ASR hallucinates familiar names into garbled audio
   segments. Don't fabricate.
   ```

3. **Routing — write to durable locations.** Claude writes the extracted structured knowledge to **four locations** in parallel:
   - **Meeting note** in an inbox folder, with the full extracted content as Markdown.
   - **Meeting cache** — a compact YAML index with just the extracted slots. **This is the primary lookup path** for future meeting-context queries; the full note is only opened on demand. Cache also updates a central JSON index for fast cross-meeting search.
   - **Person pages** — each `PEOPLE_MENTIONED` entry updates that person's page with a one-line reference + link to the meeting note, and refreshes their `last_met` frontmatter date.
   - **Tasks file** — each `ACTION_ITEM` becomes a task with a unique ID in the master Tasks file, linked back to the source meeting and to the owner's person page.

4. **Cascade-update mechanism.** When a task is later marked complete (or its status changes), a cascade pass updates *every* file that references that task ID — the meeting note where it originated, the person page where it surfaced, the project / company page where it counts toward an objective, the daily plan if it was scheduled. **One status change, all referencing files updated, audit timestamp embedded.**

## After

Applied 200+× across daily use of a personal knowledge system over 13+ months:

- **Per-meeting overhead:** down from ~30 min hand-extraction to ~90 sec supervised round-trip (read the extracted structured content, fix any hallucinated entity names, confirm the task IDs). The 90 sec is *judgement supervision*, not data entry.
- **Knowledge persists.** A meeting from three months ago is two clicks away: search the person page, find the meeting reference, open the meeting cache YAML, decide whether to open the full note. The decay-in-hours problem is structurally solved.
- **Cascade integrity holds.** When a task is marked done, every referencing file gets the completion timestamp simultaneously — no out-of-sync state between Tasks file, meeting note, and person page.
- **Cross-meeting pattern detection becomes possible** because the meeting cache is queryable. A semantic-search tool finds "what did <person> commit to last quarter?" by scanning compact YAML across hundreds of cache entries instead of opening hundreds of full transcripts.
- **The named-entity hallucination problem is real and addressed.** Cloud ASR hallucinates familiar names into garbled audio segments (e.g., it will render an unclear utterance as a known person's name from the user's address book). The "verify before propagating" instruction is load-bearing — without it, the cascade-update will propagate the hallucination across all four downstream locations.

The recipe converts meetings from a write-only knowledge graveyard into a queryable, time-aware graph that supports recall, planning, and decision context — without converting the principal into a full-time note-taker.

## When this works

- **Recurring relationships and projects** where the same people and topics recur, so the graph gets denser over time. The recipe's value compounds — week 1 it's neutral; month 3 it's load-bearing.
- **Meetings recorded with consent** (everyone in the room knows recording is happening). The recipe is not for surveillance contexts; it is for documented professional contexts.
- **A vault structured for cascade updates** — a PARA-style or Zettelkasten-style folder structure with person pages, project pages, a task file, and a cache directory. Flat-folder note-taking apps work but lose the cascade benefit.
- **Principals who will spend 90 seconds reviewing the extracted output.** The recipe's quality floor is set by the supervision step. If the human won't review, the cascade propagates errors.

## When this doesn't

- **Confidential / privileged contexts** where transcripts must not leave the device (legal, HR, M&A negotiations). Tier B (cloud transcription) is the wrong tool; restrict to Tier A only, accept the readability drop, and consider whether the pipeline is the right shape at all.
- **First three weeks of a vault.** The graph is too sparse for the cascade to add value; per-meeting overhead is the same as hand-extraction without the recall benefit. The recipe rewards stickiness.
- **One-off meetings with people who will never appear again** (cold sales calls, single-conference acquaintances). No graph density to compound; the per-meeting overhead is paid without the downstream benefit.
- **When the entity-verification step is skipped.** This is the failure mode that breaks the recipe: cloud ASR will hallucinate familiar names into garbled audio, the cascade will propagate the hallucinated person reference to four locations, and the audit trail will quietly claim the wrong human said something they did not say. **The verification gate is load-bearing.**

## Pattern

> *This is an example of: **Pipeline With Fan-Out — Single-Pass Extraction, Multi-Destination Routing** — one AI-driven extraction step produces structured slots that are then routed to multiple durable locations in parallel, with a downstream cascade that keeps the locations in sync when any one location's state changes.*

The pattern generalises beyond meeting capture to any context where a single high-bandwidth event (meeting, document, conversation, call) needs to produce structured knowledge across multiple persistent surfaces. Examples: customer-call extraction → CRM + product backlog + account page + churn-risk register; clinical patient encounter → EHR + billing + care-team handoff + family update; investor-pitch session → deal pipeline + investor-relations notes + cap-table risk register.

The pattern's defensibility rests on three structural choices:
1. **Single extraction step, multiple destinations** — not "summarise into X, then summarise into Y" (which compounds error). One extraction with structured slots; the slots route deterministically.
2. **A compact cache as primary lookup** — the full transcript is the archive; the cache is the index. Querying the cache scales; querying transcripts does not.
3. **Cascade-update on state change** — the cost of keeping locations in sync is paid by the *system*, not by the principal. If the principal has to manually propagate a "task done" status across four files, the pipeline collapses within a month.
