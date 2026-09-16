---
name: pdlc-build
description: Turn a spec into code, tests and an evidence block, test-first — derive the test list from the behavior the spec states, write each test, run it, confirm it fails for the reason stated, implement against that failure, return to green, then report what ran, what it covered and what was left. Reached from pdlc-feature at its own step 6, or standalone on a Draft spec already committed, a ticket already specified, or a bug with a known cause. Use when a spec is ready to build against, or when the user invokes /pdlc-build.
---

# Build a spec

A spec written before the work is a contract and a source of context at once:
what the go-ahead was given on, and what the implementation and its tests are
written from. This skill is what reads that contract and carries it out —
one test per behavior it states, each one read red before it is made green,
nothing beyond what the spec authorised.

Read [`doc-discipline.md`](../_pdlc-shared/doc-discipline.md) first, then
[`build-loop.md`](../_pdlc-shared/build-loop.md) — the loop itself, its
commands rule, and the evidence block, run identically from either entry
point. Read [`decision-records.md`](../_pdlc-shared/decision-records.md) too
when running standalone: that is the one case where this skill, rather than
`pdlc-feature`, routes what the build decided. Running inside `pdlc-feature`,
skip it — that skill already carries it.

## Two ways in

- **Inside [`pdlc-feature`](../pdlc-feature/SKILL.md)**, at its own step 6, on
  the spec the go-ahead was just given on. That skill keeps the reconciliation
  that follows — the spec's `Status`, `PRODUCT.md`, `AGENTS.md` and any ADR
  stay with its step 7, and this skill writes none of them in that case.
- **Standalone**, on a scope settled elsewhere: a `Draft` spec already
  committed in an earlier session, a ticket already specified, a bug with a
  known cause. This is the ordinary case, not a fallback for when
  `pdlc-feature` was skipped.

## Before the loop starts

The input is the spec file itself, `{docs_root}/specs/<feature>.md`, read from
disk — never a summary of it carried in the conversation. If there is no such
file and no description of a scope already settled elsewhere, that is a
feature request, not a build: it belongs to `pdlc-feature`, which opens the
clarification round this skill does not.

Standalone, the spec can be in one of three states:

**`Status: Draft` already on disk.** The resumed-work case and the handoff
case — a session picks up work committed by an earlier one, or by a different
agent. Run the loop against it, then reconcile it and set `Status: Shipped`,
exactly as `pdlc-feature` would at its own step 7.

**`Status: Shipped`, and the request changes what it describes.** The work is
a change to shipped behavior. Rewrite the spec in place rather than drafting a
new one for the same feature — a second spec per feature is the drift the
stated-once rule exists to prevent.

**No spec at all, and the scope came from elsewhere** — a ticket, a bug with a
known cause. State in a few lines what the work is understood to be, from what
was given, and wait for confirmation before the loop runs. This is not a
clarification round: if what was given does not actually settle the scope, say
that plainly and point at `pdlc-feature` rather than guessing or asking
questions of your own — asking is that skill's job, and a second skill that
also asks leaves the kit with a weaker `pdlc-feature`, the one that is nearer
to hand.

## Running the loop

[`build-loop.md`](../_pdlc-shared/build-loop.md) states it once, because it is
identical regardless of which entry point reached it: the test list derived
from the spec's behavior, the failure stated and read before the code exists
to make it pass, the implementation scoped to that failure, the repository's
own lint, typecheck and build commands, and the evidence block. If the
repository contradicts the spec, the loop stops and returns for a new
go-ahead rather than reconciling the discrepancy on its own — follow that rule
from there, not from a summary of it here.

## What the build decided

Inside `pdlc-feature`, the reconciliation and any ADR are that skill's step 7;
this skill writes nothing there.

Standalone, a build still produces decisions that constrain later code — an
assumption the repository forced, an approach the loop's own contradiction
step rejected. Those do not fall on the floor for want of a `pdlc-feature`
wrapper around them: apply the scope, reversal-cost and lifetime tests from
`decision-records.md`, and write the spec entry or the ADR they select. Where
the build decided nothing worth a record, say so and write nothing — a
decision log padded to match a process is worse than one with a gap in it.

## Finishing

Report the evidence block `build-loop.md` defines, then the spec's new state —
reconciled to `Shipped`, rewritten in place, or the scope just confirmed if
none existed — and any record just written. Remind the user that anything
drafted here was AI-drafted and needs review before it is treated as
authoritative; for an ADR, that review has to happen before the commit that
makes it immutable.
