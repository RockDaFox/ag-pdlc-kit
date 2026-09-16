# Spec — pdlc-decide

> **Status: Shipped**
>
> Living document: any change to the `pdlc-decide` skill is reflected here in
> the same change. Revised 2026-09-15.
>
> Drafted with an AI assistant — review before sharing outside the team.

## Summary

`pdlc-decide` records a decision that produces no code at the moment it is
taken: a technical foundation chosen before anything is built, an architecture
approved before work is split, a boundary drawn, a dependency the repository
agrees to carry. It routes the decision with the three tests from
`skills/_pdlc-shared/decision-records.md`, interviews for what the record needs
and the user has not supplied, writes an ADR or a spec entry, and reports what
stayed unknown.

It also walks the supersession of an existing ADR, which is the one mechanic
the discipline states as a rule and no skill previously performed.

It is the third way into the decision log, beside
[`pdlc-feature`](pdlc-feature.md), which records decisions that arrive with an
implementation, and [`pdlc-init`](pdlc-init.md), which writes none by design.

## Decisions

1. **Decisions without code get their own skill rather than a mode of
   `pdlc-feature`.** `pdlc-feature`'s whole shape — question round, spec,
   go-ahead, implement, reconcile — is organised around producing a diff. A
   decision with no diff would have to skip four of its five steps, and a
   skill that is mostly skipped is a skill nobody reaches for.
2. **The alternatives come from the user, never from inference.** This is
   [ADR-0004](../adr/0004-decision-records-are-written-forward.md) applied at
   the one point where the rule is easiest to break: the user is present, so
   asking is available, and anything they cannot answer is recorded as
   unanswered rather than filled in.
3. **The skill records, it does not decide.** Where the request is really a
   request for a recommendation, it says so and gives the recommendation as
   analysis, writing nothing until the user has chosen. A record of a decision
   the user did not take is not a record.
4. **A decision reconstructed from the code is refused and redirected.** What
   the code shows is state, and state belongs in `AGENTS.md`. This is the one
   case where the skill declines outright, because it is the case that
   produces a plausible, invented ADR.
5. **Supersession is two edits, and both are required.** The new ADR gains
   `Supersedes`, the old one gains `Status: Superseded by` and keeps every
   other word. Half of this leaves the log asserting two contradictory things
   with equal confidence, which is worse than either alone.
6. **Draft status is established from git, not from the date.** Immutability
   starts at the commit, not at the push
   ([ADR-0011](../adr/0011-append-only-binds-the-decision.md)). The skill runs
   `git log` on the ADR before superseding it, and edits it in place if it was
   never committed — saying that is what it did.
7. **A scoped exception is not a supersession.** One service departing from an
   ADR is a spec entry linking to the ADR and saying why the exception holds.
   The ADR is not touched: it still describes what the rest of the repository
   does.
8. **"There is no decision here" is a valid outcome.** A preference with no
   alternative, or a failed attempt with nothing settled, ends the skill
   without writing. An empty log is cheaper than a log with filler in it.
9. **It loads two reference files, not the whole discipline.**
   `doc-discipline.md` and
   [`decision-records.md`](../../skills/_pdlc-shared/decision-records.md),
   which is where immutability and the supersession mechanic it performs are
   stated ([ADR-0010](../adr/0010-shared-reference-split-by-need.md)).
10. **A supersession is triggered by a reversal and by nothing else.** A
    consequence the old record predicted that has since resolved is not a
    reversal: the skill routes that finding to state and writes no ADR, so the
    log does not grow a record that decides nothing
    ([ADR-0011](../adr/0011-append-only-binds-the-decision.md)).

## Rejected alternatives

- **A `--supersede` flag or second skill for supersession** — rejected:
  superseding is reached from "I am reversing an earlier decision", which is
  how the user thinks about it, not from a separate verb they would have to
  know exists. It is the same job with one more file to touch.
- **Letting the skill write the ADR from the code when the user cannot
  remember** — rejected in
  [ADR-0004](../adr/0004-decision-records-are-written-forward.md). This is the
  request the skill will receive most often and the one it must decline.
- **Recording every decision as an ADR and dropping the spec route** —
  rejected: it would fill `adr/` with feature-level behavior, and an
  append-only log of reversible details is a log nobody reads. The three tests
  already exist for this.
- **Prompting for the ADR's Consequences section from a checklist of common
  costs** — rejected: it produces generic consequences, which read as filler
  and train the reader to skip the section that is hardest to write and
  therefore most valuable.
- **Folding this into a general `pdlc-record` skill also handling
  `PRODUCT.md` updates** — rejected: updating `PRODUCT.md` is describing
  shipped state and needs no interview. Mixing them would make a decision
  record pay for a description.

## Known gaps

| Left out | Add it when |
|---|---|
| No detection that the decision contradicts an existing ADR the user has not mentioned | The decision log in a real repository grows past what a user reliably remembers |
| No check that a superseded ADR is not itself already superseded | A chain of three reversals exists somewhere and the middle link is found wrong |
| Nothing prevents an ADR number colliding with one written concurrently on another branch | Two people write an ADR the same afternoon and the merge is silent |
| No route for a decision taken by a group, where the alternatives were weighed by people not in the session | Someone asks. The skill would have to interview an absent party, which it cannot |
| No handling of a decision that spans several repositories | A shared platform decision needs recording in more than one log |
