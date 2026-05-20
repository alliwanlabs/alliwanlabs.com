---
layout: page
title: "AI improves codebase exploration before changes"
recipe: 005
x: codebase exploration
tools: ["Claude"]
substrate: code
pattern: "Map-Before-Edit"
permalink: /recipes/005-codebase-exploration-before-changes/
---

> Opening an unfamiliar codebase and immediately editing is the canonical move that turns a 30-minute change into a three-day refactor. Feed the AI the repo and the change intent first; ask for an entry-point map and a risk surface; only edit once the map shows the territory.

## Before

A professional inherits or returns to a codebase they did not write recently — a migration target, an open-source dependency, a contractor's deliverable, a project paused for months. The instinct is to open the file the change "obviously" needs, edit it, and run the tests. This instinct is calibrated to the codebases you built yourself and remember; it is mis-calibrated for everything else.

The systematic failure mode: the change you thought touched one file actually touches eight, because the codebase has a shared utility, a configuration cascade, or a build-time generator that the immediate file does not advertise. You discover this halfway through, after the first commit, when the test that should have passed mysteriously does not. Now you're rolling back, re-reading more broadly, and your 30-minute scope has become a three-day exploration with edits scattered through it.

Naive AI use ("Claude, change this file to do X") reproduces the same failure mode at higher speed. The AI confidently edits the file you pointed at; the codebase's hidden coupling produces the same blast-radius surprise; you now have an incident *and* an AI-attribution problem. The AI was not wrong about the file. The exploration *before* the edit was the missing step.

## The recipe

Three steps. The first two run *before* any code is modified. The third step (the actual edit) is the same edit you would have made anyway — but now informed by the map.

1. **State the change intent in one paragraph.** Not "fix the bug." Specifically: what is the observable behaviour before, what is the observable behaviour you want after, what is the surface area you *expect* this touches, and what is your confidence level. Write this down. The AI will need it; you will need it more.

2. **Map-before-edit prompt.** Feed the AI the repo (or the relevant slice) along with your change intent:

   ```
   I need to make the following change to this codebase:

   <change intent paragraph>

   Before I touch any code, map the territory for me:

   1. ENTRY POINTS — which files are the natural starting points for this change?
       Rank by likelihood of being the actual edit target.
   2. DEPENDENCIES — which files / modules / configs are likely to be transitively
       affected? Walk the call graph two hops out from each entry point.
   3. SHARED MACHINERY — are there utilities, generators, codegen steps, or
       configuration cascades that this change will pass through or trigger?
   4. RISK SURFACE — what could go wrong silently? Tests that look passing but
       aren't covering the change; types that are too loose; downstream consumers
       that depend on the current behaviour as a contract.
   5. UNKNOWNS — what would you need to read more closely before recommending
       an edit? Name the specific files / functions / sections.

   Be honest about confidence on each section. I would rather know now that
   the risk surface is murky than discover it after the first edit.
   ```

3. **Edit, informed by the map.** Now do the edit you came to do — but with the map open as a checklist. Cross-reference each "DEPENDENCIES" entry against your edit. Treat any "UNKNOWNS" as work items to resolve before the edit, not after. The map becomes the audit trail for *why* you touched the files you touched and skipped the files you skipped.

   For larger changes, treat the map as a working document — update it as the edit progresses and discovers things the initial map missed. The updated map is the artefact you hand to the next person (including future-you) who needs to revisit this change.

## After

Applied 10+× over a year (2025–2026) across multiple codebases of varying familiarity:

- **An agent-runtime migration** (from container orchestration to systemd, on a VPS) — map identified that the unit file held implicit dependencies on the local user environment that the container-instinct edit would have broken.
- **A web-app VPS migration** — map identified that the Docker compose state, DB restore path, and SSL cert renewal were three independent risk surfaces. Edits sequenced by risk; full DB restore went clean on first try.
- **A multi-container fleet symmetrisation** (five containers, mixed ownership) — map identified the host-script vs container-script split as the load-bearing structural decision. Edits stayed inside the chosen boundary; no container-script proliferation.
- **A causal-model engine refactor with deterministic-engine commitments** — map identified that the determinism guarantee had implicit consequences for every test fixture and config default. Edits ordered by dependency direction; no determinism breaches in the resulting state.
- **A re-runnable video pipeline** — map identified the asset-cache layer as the difference between "fast iterations" and "wait three minutes per change." Edits prioritised the cache layer first; iterations subsequently ran in seconds.

The pattern's effect on time-cost is not a speedup — it is a **variance reduction**. The mapped changes don't go faster; they stop running into the long tail of "this was supposed to take 30 minutes and now it has been three days." The avoided three-day tails are the recipe's compounding value over months of use.

## When this works

- **Codebases you did not write recently** — the map fills in the muscle memory you don't have.
- **Multi-file changes** where the question "which files does this touch?" has a non-obvious answer.
- **Migration / refactor work** where the change crosses module / service / runtime boundaries.
- **Codebases with hidden coupling** — configuration cascades, codegen, monorepo-shared utilities, build-time substitutions. The map surfaces what the file-tree view hides.
- **Codebases you intend to hand back** to someone else — the map is the document you hand back along with the edits, and it is *more valuable than the edits themselves* for the next person.

## When this doesn't

- **Trivial single-file changes** where you know the file, the function, and the expected diff. The map overhead is real; trivial changes don't have the variance to amortise it.
- **Codebases that fit in your head** — the projects you built yourself last week, the small scripts where the entire repo is six files. The map will surface things you already know. (But: be honest about this. The recipe is most useful precisely when your confidence about "fitting in your head" is *over*-confident.)
- **Exploratory throwaway work** where you don't intend the edits to land. Maps assume you care about the consequences.
- **When the map is treated as the deliverable** — the map is the *scoping* artefact, not the edit. A team that produces beautiful maps and never edits has weaponised the recipe against itself. Time-box the map step; if the map is taking longer than the expected edit, the codebase is asking you to slow down, not stop.

## Pattern

> *This is an example of: **Map-Before-Edit** — for any change to a large complex artefact, the AI produces a written map of the territory (entry points, dependencies, shared machinery, risk surface, unknowns) before the editing step begins, and the map becomes the audit trail for which files were touched and which were skipped.*

The pattern generalises beyond codebases to any large complex artefact you need to change without first-hand muscle memory: legal contracts (entry points, cross-reference dependencies, defined-term cascades, indemnity risk surfaces), regulatory submissions (form sections, supporting evidence requirements, cross-jurisdictional dependencies, examiner risk surfaces), organisational restructures (reporting lines, RACI dependencies, comp/equity cascades, attrition risk surface), process documentation (workflow steps, system dependencies, exception-path machinery, audit risk surfaces).

The pattern's defensibility rests on **the act of writing the map before the edit, as a precommitment.** Skipping the map and "just looking" produces a mental map; mental maps are unaudited and unsharable. The written map is *the* mechanism that converts the AI's exploration into something the human can challenge, the team can adopt, and the next person can inherit.

The recipe **pairs with Recipe 002's "AI SCAFFOLD" marker discipline**: in both cases, the AI's output is explicitly the scaffolding for human work, not the work itself. The map is *what is read*, the edit is *what is shipped* — confusing the two is the failure mode.
