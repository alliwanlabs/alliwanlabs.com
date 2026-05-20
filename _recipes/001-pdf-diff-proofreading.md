---
layout: page
title: "AI improves proofreading laidout PDFs against source"
recipe: 001
x: proofreading
tools: ["Claude"]
substrate: documents
pattern: "Two-Source Deterministic Diff"
permalink: /recipes/001-pdf-diff-proofreading/
---

> When a designer hand-transfers regulated text into a laidout PDF, errors slip in that visual proofreading reliably misses. Feed both versions to Claude and ask for drift — the AI is the comparator, not the writer.

## Before

A designer (e.g. a marketing studio handling a Banking KID, a translator delivering a brochure, a regulator's communications team finalising compliance copy) receives source text — typically Word, markdown, or unstyled HTML — and produces a laidout PDF.

In the transfer, errors creep in: dropped words at line breaks, autocorrect substitutions, OCR artefacts when the source was scanned, copy-paste truncations, drift between paragraphs that look visually identical but differ in punctuation or wording.

Human proofreading of the laidout PDF is unreliable here for a specific reason: the design draws the eye away from text fidelity. Readers see the *visual integrity* of the page and infer textual fidelity. The errors are systematically the ones that don't break the layout — which means they don't trip visual review.

The stakes are highest in regulated documents (KIDs, prospectuses, drug inserts, terms-of-service) where a missing "not" can be a regulatory finding.

## The recipe

1. **Inputs** — gather two artefacts:
   - The **source** text (unlaidout): Word doc, markdown, or plain text — whatever the designer received.
   - The **laidout PDF** as delivered.
2. **The AI step** — feed both files to Claude and use this prompt:

   ```
   I'm giving you two documents:
   - Document A: the source text (unlaidout)
   - Document B: a laidout PDF version of the same content

   The text in B is meant to be faithful to A. The designer hand-transferred it,
   so errors are possible: dropped words, changed wording, autocorrect substitutions,
   line-break-induced drift, missing punctuation.

   Compare the two and return a corrections list. For each drift point, give me:
   - The location (page or section in B)
   - The source text from A
   - The drifted text from B
   - A one-line note on why it matters (especially if regulatory)

   Be exhaustive. Ignore styling, line breaks, page numbers, and pagination —
   only flag text content drift.
   ```

3. **Output handling** — send the corrections list directly to the designer. Do not re-write the laidout document yourself; the designer owns layout and uses the list as the punch-list. Keep the original AI output in your sent-to-designer email so the audit trail is intact.

## After

Applied twice in May 2026 against Banking KIDs from a regulated-content design partner:

- **PDF #1** (Banking KID, May 2026): caught a count of text-drift errors that visual proofreading by both the author and the designer's team had missed. Errors were the line-break-and-autocorrect category — invisible to humans because the page looked correct.
- **PDF #2** (Banking KID, May 2026): same method, comparable error class caught. Recipe holds across documents in the same content family.

The recipe converts a slow, error-prone, eye-fatigue-bounded process (visual proofreading) into a fast, deterministic, exhaustive comparison. Time-to-corrections drops from hours-of-careful-reading to minutes-of-prompt-and-review.

## When this works

- The laidout document is meant to be **faithful** to a source — no creative interpretation, summarisation, or restyling expected.
- The source exists as text you can hand to the AI (Word, markdown, plain text, or a clean OCR).
- The drift class is at the word/phrase level — missing, changed, added text — not at the semantic level.
- Regulatory or compliance stakes make exhaustive comparison worth the price of running the recipe.

## When this doesn't

- **When the laidout version is meant to interpret the source** (e.g. a summary brochure derived from a full prospectus). The diff approach treats deviation as error; here deviation is the work.
- **When the source itself is suspect.** Garbage source produces a garbage corrections list — the recipe assumes the source is the ground truth.
- **When the PDF is image-based** (scanned, no embedded text). The OCR step before the diff introduces its own drift, and you end up comparing two OCRs.
- **For pure stylistic / typographic drift.** The recipe ignores styling by design. If the question is "did the designer match the brand font weight on heading 3," this is not the recipe.
- **For very long documents** (>50 pages dense). Token budgets get tight, and recall on the corrections list degrades. Chunk the document by chapter or section.

## Pattern

> *This is an example of: **Two-Source Deterministic Diff** — using AI as the exhaustive comparator between a canonical artefact and a derived artefact, where the value comes from the AI's tirelessness, not its judgement.*

The pattern generalises beyond PDFs: translation-checking against a glossary, code-review against a spec, contract-vs-redline comparison, slide-deck-vs-talking-points alignment. Anywhere there is a canonical source and a derived artefact that should preserve the source, the same shape applies.

The pattern is **load-bearing because of what the AI is and isn't doing**: it is not interpreting, judging, or generating — it is comparing. Human judgement remains essential downstream (which corrections are worth fixing, which are acceptable drift); the AI step is the unglamorous exhaustive read that humans cannot reliably perform.
