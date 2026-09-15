---
name: pdlc-feature
description: Build a feature from a loose request while capturing the decisions it produces. Clarifies ambiguities as questions before any code, recaps scope and waits for explicit go-ahead, implements, then records what was decided and what was rejected in a spec (and an ADR when the decision is structural). Use when the user describes a feature to build, or invokes /pdlc-feature followed by that description.
---

# New feature

The clarification round of a feature request is where its decisions are made —
and where the rejected alternatives exist for the last time. Nobody writes them
down afterwards, because by then only the surviving option feels real. This
skill builds the feature and keeps that record in the same pass.

A decision that arrives without code — a stack settled before anything is
built, an architecture approved before the work is split, an earlier ADR being
reversed — has no implementation to ride along on. That is
[`pdlc-decide`](../pdlc-decide/SKILL.md).

Read [`doc-discipline.md`](../_pdlc-shared/doc-discipline.md) before
writing any document: it defines which file a given sentence belongs in, and
how to resolve `{docs_root}`.

## Before forming an opinion

Read the request in the full context of the repo:

- `AGENTS.md` (and `CLAUDE.md`, `CONTRIBUTING.md`, `README.md`) — the
  conventions this feature must follow, and `{docs_root}` if it is named there.
- `{docs_root}/PRODUCT.md` — what the product already does.
- `{docs_root}/specs/` — an existing spec for this feature or an adjacent one.
- `{docs_root}/adr/` — structural decisions that already constrain the answer.
- The code that already does something similar.

If the repo has none of these, say so and offer to run `pdlc-init` first. Do
not refuse to proceed — a repo without documentation is exactly where the first
spec is worth the most; just write it against the conventions the code actually
shows.

An empty `adr/` or a missing `specs/` is normal on a freshly initialised repo,
not a sign that something went wrong: the log starts at installation and grows
forward.

## Process

1. **Read the request.** Do not plan file changes yet.
2. **List every open point** — anything ambiguous, underspecified, or where
   more than one reasonable implementation exists: behavior, scope, UX, data
   model, failure modes.
3. **Ask, before planning.** Use discrete-choice questions where the options
   are clear, plain text for open-ended points. Batch everything into as few
   rounds as possible; do not trickle questions one at a time.
4. **Recap** in a few lines: what gets built, explicit non-goals, the files and
   areas it touches, how it fits existing conventions, and — named explicitly —
   which spec is created or updated and whether an ADR is warranted.
5. **Wait for an explicit go-ahead.** No code before that.
6. **Implement**, following the repo's conventions without re-opening anything
   settled in the recap.
7. **Record the decisions**, in the same change as the code. Never as a
   follow-up: by the next session the rejected options are gone, and no later
   pass can recover them.

## What to record, and where

Apply the ADR-or-spec tests from the discipline reference. In short: if the
decision constrains code outside this feature, or undoing it would mean a
migration, it is an ADR; otherwise it belongs in the feature's spec.

**The spec** — `{docs_root}/specs/<feature>.md`, from
[`../_pdlc-shared/templates/spec.md`](../_pdlc-shared/templates/spec.md)
when it does not exist yet:

- The decisions taken, each with the reason that made it win.
- The alternatives raised during step 3 and rejected, each with why. This is
  the section that only exists if written now.
- Known gaps, each with the condition that should bring it back.

**An ADR** — `{docs_root}/adr/NNNN-<title>.md`, from
[`../_pdlc-shared/templates/adr.md`](../_pdlc-shared/templates/adr.md),
numbered one above the highest existing file, starting at `0001`. Write one
only for a decision that passes the tests; a feature usually produces none.
Never edit an existing ADR to change its decision — supersede it, and let
[`pdlc-decide`](../pdlc-decide/SKILL.md) walk the two-file mechanic rather
than repeating it here.

**`{docs_root}/PRODUCT.md`** — only if the feature changes what the product
does for a user, and then in the present indicative: the section describes the
behavior now shipped, not the intention behind it. Add or amend the relevant
section; do not restate the spec.

**`AGENTS.md`** — only if the work produced a rule that now applies repo-wide:
a framework trap, a convention the next contributor must follow. That a first
attempt failed is not a rule; the rule it produced is.

## Worth a question

- Behavior the request leaves open: edge cases, empty and error states,
  permissions, who can trigger it.
- A decision a spec or ADR would normally record, that the request does not
  settle.
- Two or more plausible approaches with materially different tradeoffs.
- **Whether the feature touches personal, health or payment data.** Ask it in
  the same round as the rest, before the recap, and ask it as a question of
  fact — not as a judgment about which regime applies, which is not this
  skill's to make. A yes routes the answer to the organisation's
  data-protection or compliance function and fills the spec's Regulated data
  section; the discipline reference holds the five fields. If the answer has
  not come back by the go-ahead, say plainly in the recap that the work is
  proceeding without it, and record it as unanswered.

## Not worth a question

- Anything already settled by repo conventions, an existing ADR, or the
  surrounding code — follow it silently.
- Cosmetic wording, unless the request is about copy.
