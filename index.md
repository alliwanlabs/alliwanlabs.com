---
layout: home
title: "Recipes Are Not Tricks: How To Read This Library"
permalink: /
---

# Recipes Are Not Tricks: How To Read This Library

This is a library of patterns for working with AI in contexts that matter. Each entry — what we call a *recipe* — names a specific kind of work ("AI improves [X]"), gives the procedure that makes it work, shows the data from real applications, and is explicit about where and how it fails.

The library is published by Al Liwan Labs because the question its readers are actually asking is not *"can AI help here?"* but *"will the help survive contact with consequences?"* The answer to the first question is almost always yes. The answer to the second is the substance of this library.

## What this is, and what it deliberately isn't

This is not a productivity blog. It is not a vendor case-study collection. It is not a list of clever prompts. It is not an inspirational call to "embrace AI." Each of those exists already, and each has its place, and none of them is what this library does.

The library's authoring rules are short and hard:

- **Real data points only.** Every recipe has been applied at least once in production. Hypotheses go to a backlog, not the library.
- **Failure modes are mandatory.** No recipe ships without named conditions under which it breaks.
- **Numbers over adjectives.** "Caught 7 errors in a 22-page PDF" beats "significantly improved quality."
- **Pattern names are borrow-able.** Each recipe names an abstract pattern that other recipes — and other readers' contexts — can cite.

If a recipe in this library reads like enthusiasm, it has been edited badly. The recipes are meant to be **load-bearing in regulated, operational, and high-stakes professional work**. Enthusiasm is not the load-bearing element.

## The recurring failure mode of generic AI advice

Most AI workflow advice that exists in 2026 fails on contact with consequences in a specific, predictable way. It is structured around the question *"what can AI do for you?"* and answers with the demonstration: here is a transcript summarised, here is a draft generated, here is a calendar rearranged.

What this framing systematically misses is the **judgement structure** of the work being augmented. In any context where the work has consequences — regulatory filings, peer reviews, expense reimbursements, knowledge graphs, codebase changes, persuasive decks — there is some step that has to be done by a human and some step that should not. The AI is good at one of those steps and bad at the other. The advice that ignores this distinction produces workflows that look like productivity wins for the first three runs and quietly degrade the work output thereafter.

The naive workflow ("paste the document, ask the AI to handle it") is the canonical example. It works on the first occasion because the human is still reading the output critically. It works less well on the second occasion. By the tenth, the human has stopped reading and the workflow has converted what was meant to be augmented judgement into AI autonomy by attrition. The audit trail does not record this; the human, asked, will report that the workflow is "working great."

The library exists because this failure mode is the dominant one in serious professional adoption of AI, and because it is preventable by structural choices in workflow design, not by exhortation to "review the output." Exhortations don't survive month three. Structure does.

## The meta-pattern

Across the six recipes currently in this library, one structural element repeats with notable regularity. We have given it a name and made it explicit:

> **AI-assisted workflows in high-stakes or regulated contexts must structurally name the human-judgement gate, not bury it. The gate is the recipe.**

Each recipe in the library identifies a single step in its procedure that the human owns, and treats every other step as legitimately AI-driven. The owned step is not optional. It is not delegable. It is not "best practice to review the AI output afterward." It is the structural element that makes the recipe work *as a recipe*, distinct from the failure mode it is designed to prevent.

The gates are different in each recipe — a checkbox, a y-mark, a verification step, a marker word, a pre-commitment to write the scoping artefact down before editing, a charitable modelling discipline — but the *role* of the gate is identical across all six. **Remove the gate and you have not got an optimised version of the recipe; you have got the failure mode the recipe was designed to replace.**

This is the library's most important claim. It is also the claim that distinguishes this library from the "tips and tricks" genre. A trick can be applied or not applied. A pattern with a structural gate cannot be partially applied. Either the gate is there and the recipe works, or the gate is not there and what you are running is not the recipe — it is the recipe's failure mode under another name.

## How the six recipes embody the meta-pattern

| # | Recipe | Pattern | The load-bearing gate |
|---|--------|---------|----------------------|
| [001](/recipes/001-pdf-diff-proofreading/) | AI improves proofreading laidout PDFs against source | **Two-Source Deterministic Diff** | The AI is the comparator, *not* the writer — its value comes from tirelessness, not judgement. Removing this constraint converts the recipe from "exhaustive proofread" to "AI re-writing the document." |
| [002](/recipes/002-conference-paper-peer-review/) | AI improves peer-review of conference papers | **AI-Scaffolded Multi-Pass Review** | Every AI output is marked `AI SCAFFOLD` explicitly, as a friction surface. The marker is what prevents the scaffolded draft from being submitted as the reviewer's own work. |
| [003](/recipes/003-expense-report-compilation/) | AI improves expense report compilation | **AI-Around-Judgement** | The human marks `y` in a spreadsheet column. That single judgement step encodes the company's specific inclusion rule as data; skipping it means inclusion errors and a broken audit trail. |
| [004](/recipes/004-meeting-to-structured-knowledge-pipeline/) | AI improves meeting → person-page → tasks pipeline | **Pipeline With Fan-Out** | The entity-verification step. Cloud transcription hallucinates familiar names into garbled audio; without verification, the pipeline propagates the hallucination to four downstream locations simultaneously. |
| [005](/recipes/005-codebase-exploration-before-changes/) | AI improves codebase exploration before changes | **Map-Before-Edit** | The map is *written down* before any code is modified — as a pre-commitment, not an afterthought. Mental maps are unaudited and unsharable; written maps are the structural element. |
| [006](/recipes/006-anti-objection-deck-mapping/) | AI improves anti-objection mapping for high-stakes decks | **Adversarial Stakeholder Modelling** | The per-decision-maker objection paragraphs are written *as if you were that person reading them*, charitably. Caricature modelling produces decks that lose more arrogantly. |

Notice what the gates have in common: **none of them is a "review step" added on at the end**. They are all structural elements of the recipe's middle — points where the AI's contribution stops and the human's judgement starts. The recipes are designed *around* the gates, not in spite of them.

Notice also what the recipes do *not* claim:

- None claims AI autonomy. The human is in the loop, at a named and load-bearing point.
- None claims a 10× speedup. Several claim variance reduction (avoided long tails), shifted agendas (the conversation moves to harder questions), or compounding benefits (the graph gets denser over time). These are honest framings.
- None of them is general-purpose. Each is specific to a kind of work, with named scope conditions and named failure modes. The pattern generalises; the recipe does not.

## What the library is for

For a senior practitioner — a clinician, lawyer, regulator, executive, researcher, engineer, operator — the library is a working reference for designing AI-assisted workflows that survive the calendar. Each recipe is a template you can adapt to your context; each pattern is a name you can use to discuss the design choice with colleagues; each "When this doesn't" section is an early-warning list of failure modes to watch for in your own implementation.

For a team adopting AI in regulated or operational contexts, the library is a vocabulary. "We need a Map-Before-Edit step here" is a shorter sentence than "we need to write down what we expect this change to touch before we touch anything." Both sentences mean the same thing, but only the first compresses to fit in a working meeting. Shared pattern names accelerate the conversations that adoption requires.

For a leader thinking about AI policy in their organisation, the library is an honest baseline of what disciplined AI use looks like in 2026. The temptation in policy contexts is to choose between two unhelpful poles: ban AI use (loses the value), or permit it without structure (loses the discipline). The library suggests a third option: *require structure*. Each recipe is an instance of structure; the meta-pattern is the requirement.

## What's not yet here

The library opens with six recipes covering proofreading, peer review, expense compilation, meeting capture, codebase exploration, and deck preparation. The patterns named so far — Two-Source Deterministic Diff, AI-Scaffolded Multi-Pass Review, AI-Around-Judgement, Pipeline With Fan-Out, Map-Before-Edit, Adversarial Stakeholder Modelling — are the ones that emerged from disciplined application in the author's daily work in late 2025 and the first half of 2026.

More recipes will follow as their substrate accrues. The authoring rules ensure that what arrives next will not be hypothetical; it will be earned by actual use. Candidate substrates in the author's queue include contract-vs-redline comparison, regulatory-submission scoping, hiring-shortlist triage, and slide-deck → talking-points alignment — each of which has the substrate but not yet the discipline of "applied N× in production with a named failure mode."

The library is meant to grow slowly. A library of forty recipes that average two paragraphs of generic advice is worse than a library of six recipes that each survive scrutiny. The latter is what this is.

## How to read the library

Start with the recipe whose `X` matches the work you are trying to improve. Read the **Before** section first — if the failure mode it describes is not the failure mode you experience, this recipe is not for you, regardless of how clever it looks.

Then read the **When this doesn't** section second, *before* the procedure. The point is to disqualify your context fast. If your context is in the "doesn't" list, the recipe will mis-fire when you apply it.

Then — only then — read the procedure and the prompt. Notice the load-bearing gate as you read. If you cannot identify the gate, the recipe is failing as a recipe, and the failure is on the author; please flag it.

Adapt the prompts to your context. The prompts in the library are working artefacts, not sacred text. The pattern is what matters; the prompt is one instantiation of the pattern.

Last: when you find a pattern that holds across multiple recipes in your context, write it down and send it back. The library compounds in value with use, not just with addition.

---

*This is the introduction to the Al Liwan Labs Recipe Library, version 0 (2026-05-20). The library is authored by David Orban. Comments and corrections are welcomed.*
