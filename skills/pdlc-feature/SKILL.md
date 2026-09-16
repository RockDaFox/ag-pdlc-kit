---
name: pdlc-feature
description: Build a feature from a loose request while capturing the decisions it produces. Clarifies ambiguities as questions before any code, writes the spec — decisions taken, alternatives rejected, non-goals — and waits for an explicit go-ahead on it, implements against it, then reconciles it with what shipped (and writes an ADR when a decision is structural). Use when the user describes a feature to build, or invokes /pdlc-feature followed by that description.
---

# New feature

The clarification round of a feature request is where its decisions are made —
and where the rejected alternatives exist for the last time. Nobody writes them
down afterwards, because by then only the surviving option feels real. This
skill writes that record before the code, where it serves twice over — as the
contract the work is authorised against and as the context the implementation
and its tests are written from — then reconciles it with what shipped.

A decision that arrives without code — a stack settled before anything is
built, an architecture approved before the work is split, an earlier ADR being
reversed — has no implementation to ride along on. That is
[`pdlc-decide`](../pdlc-decide/SKILL.md).

Read [`doc-discipline.md`](../_pdlc-shared/doc-discipline.md) before writing
any document: it defines which file a given sentence belongs in, and how to
resolve `{docs_root}`. Read
[`decision-records.md`](../_pdlc-shared/decision-records.md) before writing
the spec or an ADR — it holds the routing tests, append-only, and the
regulated-data record.

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
4. **Write the spec, and commit it.** It replaces the recap rather than
   following it — the same content, in a file instead of a message: what gets
   built, explicit non-goals, the decisions taken with the reason each won, the
   alternatives just rejected with the reason each lost, the files and areas
   touched, and how it fits existing conventions. `Status: Draft`. Say in one
   line whether an ADR looks warranted, and do not write it yet.
5. **Wait for an explicit go-ahead on the spec.** What is being approved is the
   spec, not a summary of it. No code before the answer.
6. **Implement against the spec, running the loop
   [`build-loop.md`](../_pdlc-shared/build-loop.md) states** — read it now, not
   before: the clarification round has no use for build instructions, and a
   session that stops at the go-ahead would have paid for them for nothing.
   The loop derives the work and its tests from the spec's behavior, stops at
   its non-goals, and if the repository contradicts it — a pattern absent
   where the spec assumed one, an assumption a test disproves — stops the
   build, reports the discrepancy, and returns to step 3 for a new go-ahead.
   Never reconcile a contradiction silently: that is a scope decision taken
   without a record.
7. **Reconcile the spec with what shipped**, in the same change as the code,
   and set `Status: Shipped`. Record each divergence between the draft and the
   implementation, with what the implementation showed. Then, and only then,
   the ADR the work turned out to warrant. Never leave any of this as a
   follow-up: by the next session the rejected options are gone, and no later
   pass can recover them.

## What to record, and where

Apply the ADR-or-spec tests from the discipline reference. In short: if the
decision constrains code outside this feature, or undoing it would mean a
migration, it is an ADR; otherwise it belongs in the feature's spec.

**The spec** — `{docs_root}/specs/<feature>.md`, from
[`../_pdlc-shared/templates/spec.md`](../_pdlc-shared/templates/spec.md)
when it does not exist yet. Written at step 4, reconciled at step 7; what each
moment holds is stated in
[`../_pdlc-shared/decision-records.md`](../_pdlc-shared/decision-records.md):

- The decisions taken, each with the reason that made it win.
- The alternatives raised during step 3 and rejected, each with why. This is
  the section that only exists if written now.
- Where the implementation diverged from the draft, and what it showed.
- Known gaps, each with the condition that should bring it back.

**An ADR** — `{docs_root}/adr/NNNN-<title>.md`, from
[`../_pdlc-shared/templates/adr.md`](../_pdlc-shared/templates/adr.md),
numbered one above the highest existing file, starting at `0001`. Write one
only for a decision that passes the tests; a feature usually produces none.
Write it at step 7 and never at step 4: a committed ADR is a record and cannot
be corrected, and a decision taken before the work can still move.
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
  the same round as the rest, before the spec is written, and ask it as a
  question of fact — not as a judgment about which regime applies, which is not
  this skill's to make. A yes routes the answer to the organisation's
  data-protection or compliance function and fills the spec's Regulated data
  section; the discipline reference holds the five fields. If the answer has
  not come back by the go-ahead, say plainly in the draft spec that the work is
  proceeding without it, and record it as unanswered.

## Not worth a question

- Anything already settled by repo conventions, an existing ADR, or the
  surrounding code — follow it silently.
- Cosmetic wording, unless the request is about copy.
