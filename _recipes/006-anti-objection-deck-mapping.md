---
layout: page
title: "AI improves anti-objection mapping for high-stakes decks and proposals"
recipe: 006
x: anti-objection mapping
tools: ["Claude"]
substrate: documents
pattern: "Adversarial Stakeholder Modelling"
permalink: /recipes/006-anti-objection-deck-mapping/
---

> A deck or proposal that names specific decision-makers will be evaluated by those specific decision-makers — each of whom carries a position, a history, and a set of priors that determine which slides land and which trigger pushback. Model each decision-maker's likely objections *before* the room, slide by slide; pre-empt them in the artefact itself; walk in having already absorbed the easy challenges into your design.

## Before

A senior professional has a "must approve" deck, an investment memo, a board paper, or a regulatory submission. The artefact is aimed at named decision-makers: a specific CEO, a specific committee, a specific regulator. Approval is the load-bearing outcome; if the decision-makers do not approve, the work behind the deck does not happen.

The instinct is to optimise the deck for *clarity* — make the argument as crisp and well-supported as possible, and trust that good arguments persuade. This is necessary but not sufficient. Approval is not a function of argument quality alone; it is a function of how the argument *interacts with the priors, incentives, and prior commitments of the people in the room*. Two equally crisp decks land differently with the same audience depending on which incidental objections each fails to pre-empt.

The systematic failure mode: you walk into the room with a strong deck, get challenged on objections you had not pre-empted (sometimes objections the decision-maker has *publicly held* for months — visible in their emails, prior decisions, organisational position), and spend the meeting defending instead of advancing. The deck does not get rejected; it gets *deferred for revisions* — the worst outcome, because momentum is lost and the next meeting starts cold.

Naive AI use ("Claude, write me an investor deck") produces a generic deck that has the structural form but none of the stakeholder modelling. It would also be the same deck for any company in your category — which is what generic looks like when the audience is specific.

## The recipe

Four steps. Steps 1 and 2 happen before deck drafting; steps 3 and 4 are iterative as the deck approaches lock.

1. **Name the decision-makers explicitly.** Not "the board." Specifically: each named person, their role, their decision authority (vote, veto, advisory), their relationship to the proposal author, their public positions on adjacent topics. Pull this from real sources — meeting notes, prior emails, public statements, organisational position. Write it down. The AI will need it.

2. **Per-decision-maker objection modelling.** For each named person, prompt:

   ```
   I'm preparing a "<deck-or-proposal-type>" titled "<title>" for approval by:

   <named decision-maker>:
   <one paragraph: their role, decision authority, known positions
   on adjacent topics, prior interactions with the proposal author,
   any priors they have publicly committed to>

   The core proposal is: <one-paragraph summary>.

   Model this person's likely objections from their position.
   For each objection:
   - State the objection in their voice (charitably — assume they
     are smart, informed, acting in good faith from their position).
   - Identify which prior, incentive, or commitment generates it.
   - Rate severity (showstopper / significant / minor).
   - Suggest how the deck could pre-empt it: data point, framing
     choice, slide order, what to acknowledge openly, what to defer
     to appendix.

   Be exhaustive on the significant-or-above objections. Better to
   surface six and dismiss three than miss the one I'll be ambushed by.
   ```

   Repeat for every named decision-maker. **Do not merge them.** Each person's objection set is shaped by their specific position; merging into a single "stakeholder view" loses precisely the structural detail the recipe is designed to surface.

3. **Anti-objection map — the integration artefact.** Consolidate the per-person objection sets into a single map keyed by *deck slide*:

   ```
   For each slide in the deck draft, list:
   - Which objections (from the per-person sets) this slide triggers
     or addresses.
   - Whether the slide currently pre-empts those objections or leaves
     them exposed.
   - For exposed objections: a one-line suggested revision.

   At the end, list any objections that no slide currently addresses
   — these need a new slide, a new framing, or an explicit "we are
   not addressing this" decision.
   ```

   This is the artefact the deck author works from. Each revision pass closes the highest-severity exposed objections first.

4. **Cold-read sanity check.** Before the deck locks, ask the AI to *read the deck cold* — without the objection map, as if it were one of the decision-makers — and produce a fresh objection list. Compare to the original modelled set. **Net new objections in the cold read are the recipe's most valuable output**: they are the ones you had blind spots on. Add them to the map; revise again.

## After

Applied 3+× across April–May 2026 on high-stakes internal proposals:

- **A "must approve" ELT deck** for a new operating-entity proposal — slide-by-slide anti-objection map with five named decision-makers modelled independently. Per-slide map identified that the original draft had three slides exposed to a significant objection from a single named decision-maker that the proposal author was structurally well-positioned to pre-empt with a data point already available. Revised before sharing.
- **An entity-structure proposal cycle** — anti-objection mapping surfaced that an apparently-uncontroversial slide on cost lines was the slide most likely to trigger a specific decision-maker's prior commitment to a particular organisational shape. The revision absorbed the objection by reframing the slide rather than removing the content.
- **A half-day equity-strategy prep** — anti-objection map identified the equity-pool sizing slide as carrying the load of multiple compounding objections; the resulting revision sequenced the proposal to lead with the framing, not the number, materially shifting the meeting's centre of gravity.

The recipe's effect is not "more persuasive decks" — it is **shifted meeting agendas**. Meetings that would have spent 30 minutes on the objections-the-deck-failed-to-pre-empt now spend 30 minutes on the next-level questions, because the easy challenges were already absorbed. The proposal author arrives at the meeting having already heard the predictable objections (from the AI's voice-of-each-decision-maker pass) and having decided how to handle each one in the artefact itself.

## When this works

- **Approvals with named decision-makers** whose positions you can characterise honestly. The recipe lives on the quality of the per-person modelling; vague "the board will object to…" is not the recipe.
- **Decision-makers with discoverable priors** — public statements, prior emails, prior decisions, organisational position. The richer the prior set, the more accurate the modelling.
- **Structured artefacts** — decks, memos, board papers, regulatory submissions — where the artefact is fixed before the meeting and revision happens beforehand. The recipe is for *pre-meeting hardening*, not live debate.
- **Stakes high enough to justify the time**. The recipe is not free; it adds hours to deck preparation. Worth it for "must approve" decisions; overkill for routine status updates.

## When this doesn't

- **Cold rooms / unknown attendees** — the recipe degrades to category modelling ("what would a typical VC ask"), which is necessary but not the recipe's actual edge. The edge comes from *named* decision-makers.
- **Exploratory conversations** where the goal is to elicit positions, not to navigate known ones. Anti-objection modelling pre-supposes you know the positions; if eliciting them is the goal, the recipe is the wrong tool.
- **When the modelling becomes a caricature.** Honesty matters here: if the per-person paragraphs slide into "this person always objects to X for political reasons," the model is wrong and the resulting map will mis-predict. The recipe requires charitable modelling — assume the decision-maker is smart, informed, and acting in good faith from their position. Caricatures produce decks that lose anyway, but more arrogantly.
- **When the deck author edits the anti-objection map into the deck itself.** The map is a *working document*; the deck is the *output*. A deck that visibly performs its anti-objection mapping ("we anticipated you might ask…") reads as defensive. The map informs slide design; it does not become slide content.

## Pattern

> *This is an example of: **Adversarial Stakeholder Modelling** — for any persuasive artefact aimed at named decision-makers, AI generates per-person objection sets from each decision-maker's specific position, the human consolidates these into a per-slide map, and the artefact is revised to pre-empt the highest-severity objections before the meeting.*

The pattern generalises beyond decks and proposals to: investor pitch preparation (named partners, named funds, known portfolio commitments), litigation strategy (named opposing counsel, named judge, prior rulings), product launch (named press contacts, named analyst-relations targets, known frame preferences), political-economy work (named regulators, named legislators, known constituency positions), and any context where approval, alignment, or coverage is gated on identifiable individuals.

The pattern's defensibility rests on **modelling each decision-maker independently and charitably**. Merging into a single "stakeholder view" loses structural detail; uncharitable modelling produces decks that lose. The recipe's hard rule: per-person paragraphs are written *as if you were that person reading them*, not *as if you were the proposal author predicting them*.

The recipe **pairs with Recipe 002's verdict-drift discipline**: in both cases, the AI's most valuable output is the *change* between first instinct and informed second pass. In peer review, it is "Pass 1 said Accept, Pass 2 said Weak Accept, because X." In anti-objection mapping, it is "cold-read identified an objection the per-person modelling missed, because Y." Treating these drift moments as gold is the meta-recipe across the library.
