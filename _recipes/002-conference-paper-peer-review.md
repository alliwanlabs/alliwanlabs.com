---
layout: page
title: "AI improves peer-review of conference papers"
recipe: 002
x: peer review
tools: ["Claude"]
substrate: documents
pattern: "AI-Scaffolded Multi-Pass Review"
permalink: /recipes/002-conference-paper-peer-review/
---

> Reviewing five dense academic papers by a deadline rewards reviewers who skip the deep read and punishes reviewers who do it well. A three-pass AI scaffold — explicitly marked as scaffold, not output — collapses the navigation overhead while keeping the judgement human.

## Before

A program-committee invitation arrives: review N papers by date D. Each paper is 8–15 pages of dense academic content, often outside your immediate sub-field. Doing this *well* means: reading each paper twice, cross-checking the cited references, separating presentational weaknesses from substantive ones, calibrating your confidence honestly, and writing review text that the authors can act on and the PC can defend.

The reviewing economy systematically punishes reviewers who do this well. Time-to-careful-review is measured in hours per paper; the equilibrium across the field has drifted toward short, generic, low-engagement reviews because the deep version is unaffordable for active researchers. The papers most damaged by this drift are the ones at the borderline of accept — papers where the verdict depends on whether the reviewer actually grappled with the argument.

Naive AI use (paste the PDF, ask "is this a good paper, draft a review") makes the situation worse: it produces fluent generic reviews indistinguishable from low-engagement human ones, and trains the reviewer to stop reading.

## The recipe

Three passes, each producing an explicit artefact, each explicitly marked as scaffold for the reviewer's editing — never as the final output.

1. **Inputs** — gather:
   - The papers (as PDFs).
   - The conference's review template / recommendation scale / confidentiality rules (EasyChair, OpenReview, etc.).
   - Your own positioning (sub-field, declared expertise, any COIs).

2. **Pass 1 — section-by-section first-pass scaffold.** For each paper, prompt:

   ```
   This is paper #<N>, "<title>", submitted to <venue>. Produce a first-pass
   structured scaffold with these 8 sections:
   1. One-paragraph plain-English summary of the argument.
   2. The claimed contribution (in the authors' words, then in plainer terms).
   3. The method / argument structure, section by section.
   4. Strengths (bullets, ≥3, each anchored to a specific passage).
   5. Weaknesses (bullets, ≥3, each anchored to a specific passage).
   6. References to cross-check (which citations carry the load? which look suspicious or missing?).
   7. Preliminary verdict (Accept / Weak Accept / Borderline / Weak Reject / Reject) with one-line reasoning.
   8. Confidence calibration (1–5) with what would shift it.

   Mark this as AI SCAFFOLD throughout. The reviewer will edit in their own voice.
   ```

3. **Pass 2 — deep close-PDF-read second-pass.** After your own substantive read of the paper (the scaffold from Pass 1 is the navigation aid for *your* read — it tells you which sections to slow down on), prompt:

   ```
   I've now read paper #<N> closely. Here are my notes: <your notes>.
   Produce a second-pass scaffold that:
   - Refines the argument summary based on close reading.
   - Replaces Pass 1 strengths/weaknesses with NUMBERED versions tied to specific
     pages/equations/sections, NOT generic claims.
   - Cross-checks the references I flagged in Pass 1, noting any miscitation or
     missing-citation patterns.
   - Names any "verdict drift" — has the recommendation shifted from Pass 1, and why?
   - Surfaces anything the first pass missed that the close read revealed.

   Mark as AI SCAFFOLD.
   ```

4. **Pass 3 — full review draft, EasyChair-shaped (or venue-equivalent).** Once Pass 2 stabilises, prompt:

   ```
   Draft a full <venue> review for paper #<N> in this shape:
   - Recommendation: <Accept / Weak Accept / …>
   - Confidence: <1–5>
   - Summary for authors: <plain-language, respectful, ≤200 words>
   - Detailed comments for authors: numbered, addressing each strength and weakness
     from Pass 2.
   - Confidential comments to PC: anything that shouldn't go to authors, including
     COI disclosures, cross-paper observations, and confidence-calibration notes.

   Mark every section as AI SCAFFOLD. The reviewer will paste this into <venue>
   only after editing in their own voice.
   ```

5. **Output handling** — the reviewer reads the Pass 3 scaffold, edits it in their voice, removes the AI SCAFFOLD markers, and pastes into the venue. The scaffold is never the final output; it is the *first draft of the reviewer's text*. The audit trail (all three passes, in dated files per paper) stays in a working folder for the reviewer's own record.

## After

Applied across five papers for a 2026 academic conference in the AI-and-cognition cluster:

- **All five scaffolded ahead of the conference's final-buffer deadline**; halfway nudge beaten by one day.
- **Verdict drift caught between Pass 1 and Pass 2** in multiple cases — e.g. one paper softened from `Accept` to `Weak Accept` once the close read surfaced that the math novelty was modest and the abstract overclaimed relative to the body. Without the second pass, the first-pass instinct would have been published.
- **Cross-paper observations surfaced for the PC** (thematic clusters between adjacent papers; complementary readings between papers on related topics) — observations only visible when reviewing several papers in one session, which the scaffold made tractable.
- **Confidence calibration made explicit** — Medium-Low (2/5) on one paper with a second-reviewer recommendation to PC; Medium (3/5) on another. The recipe makes self-honesty about confidence a checkbox the reviewer cannot quietly skip.
- **COI disclosure** pre-drafted as part of Pass 3 where the reviewer's own intellectual proximity to the topic warranted it.

The recipe converts what would have been ~25 hours of reviewer time into ~10 hours of reviewer-judgement time on top of ~2 hours of AI-scaffold runtime, with the *increase* in review quality going to the borderline papers — exactly the ones the reviewing economy normally fails.

## When this works

- **Multi-paper review under deadline pressure**, where scaffold overhead amortises across papers.
- **Sub-fields adjacent to but not exactly the reviewer's**, where the scaffold provides orientation that the reviewer would otherwise spend hours building from scratch.
- **Venues with structured review forms** (EasyChair, OpenReview, etc.) where Pass 3 can be shaped directly to the form's slots.
- **Reviewers who insist on substantive engagement** and want AI to compress the navigation cost, not the judgement.

## When this doesn't

- **Single-paper reviews.** Scaffold overhead exceeds the value when N=1.
- **Math-heavy proofs requiring rendered notation.** AI handles LaTeX source poorly when the paper relies on equation chains; reviewer must read the rendered PDF directly and bring notes back to Pass 2.
- **Papers in non-Latin scripts or low-resource languages** where the AI's reading reliability is degraded.
- **When the reviewer skips Pass 2 — the substantive read.** Without the close read, Pass 3 is a fluent generic review and the recipe has degenerated into the failure mode it was designed to prevent. **The "AI SCAFFOLD" marking is load-bearing**: if you stop marking it, you will start submitting it.
- **Reviews where verdict drift between Pass 1 and Pass 2 cannot be honoured** (e.g. extreme time pressure, conference politics). The recipe assumes the reviewer can revise their first instinct based on the close read.

## Pattern

> *This is an example of: **AI-Scaffolded Multi-Pass Review** — AI generates the navigation aid and the draft, human provides the substantive judgement and the ownership; the scaffold is explicitly marked as scaffold so that the reviewer cannot accidentally submit it as final output.*

The pattern generalises beyond peer review to any high-stakes judgement task where (i) the artefact under review is long and structured, (ii) the reviewer's judgement is the load-bearing output, and (iii) the navigation cost is currently driving low-engagement defaults. Examples: grant review, hiring committee assessments, board-paper review, internal architecture reviews, legal due-diligence reads.

The pattern's defensibility rests on the **explicit "AI SCAFFOLD" marking** as a friction surface. Removing the marking is what converts the recipe into the failure mode it was designed to replace. This is the recipe's hard rule.
