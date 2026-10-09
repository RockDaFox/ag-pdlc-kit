# Spec — pdlc-feature

> **Status: Shipped**
>
> Living document: any change to the `pdlc-feature` skill is reflected here in
> the same change. Revised 2026-10-09.

## Summary

`pdlc-feature` turns an informal feature request into working code, and writes
down what the work decided. It reads the repository, surfaces every open point
as a question, writes the spec and commits it as a draft, waits for an explicit
go-ahead on that spec, implements against it, then reconciles it with what
shipped — and writes an ADR when a decision reached beyond the feature.

It is a derivative of the user-level `feature` skill, which stops at
implementation. The addition is the record, and the reason for the whole skill:
the clarification round is where the rejected alternatives exist for the last
time.

The routing between spec and ADR is not decided here. It is stated once in
`skills/_pdlc-shared/decision-records.md`, and this skill applies it.

## Decisions

1. **The spec is written by this skill, inside its own flow** — not by a hook
   watching for edits, not by a check at commit time. Judging whether a
   decision is worth engraving is not automatable, and a spec too many rots
   the set as surely as a spec missing.
2. **The rejected alternatives come from the question round**, and are written
   while it is fresh. Reconstructing them after the feature ships produces
   fiction: only the surviving option still feels real.
3. **The spec replaces the recap, and the go-ahead is given on it**
   ([ADR-0012](../adr/0012-a-spec-precedes-the-implementation-it-governs.md)).
   The recap held what a spec holds and was discarded once answered; the skill
   was producing the artefact and throwing it away. What the user approves is
   now the file, which the implementation then reads as its context.
4. **An explicit go-ahead gates the code.** The spec is not a notification;
   the skill stops there until the user answers.
5. **The spec is reconciled with what shipped, in the same change as the
   code**, and the divergences between draft and implementation are part of
   the record — a rejected alternative with evidence behind it outranks one
   rejected in discussion. Nothing is left as a follow-up task: a follow-up is
   a task note, and task notes are the thing this repository exists to stop
   producing.
6. **The ADR is written at the end, never at the go-ahead.** A committed
   record is immutable ([ADR-0011](../adr/0011-append-only-binds-the-decision.md)),
   so an ADR drafted before the work freezes a decision that can still move.
   The spec can be written early precisely because it is rewritten in place.
7. **An undocumented repository is not refused.** The skill offers
   `pdlc-init` and proceeds anyway, writing the spec against the
   conventions the code actually shows — a repo with no documentation is
   where the first spec is worth the most.
8. **`AGENTS.md` is updated only for a rule that became repo-wide**, and
   `PRODUCT.md` only when user-visible behavior changed — in the present
   indicative, describing what now ships. Most features touch neither.
9. **An empty `adr/` is normal, not a symptom.** The log starts at
   installation and grows forward
   ([ADR-0004](../adr/0004-decision-records-are-written-forward.md)); this
   skill is the main thing that fills it, so on a fresh repo it writes
   `0001`.
10. **Regulated data is asked about in the question round, as a question of
    fact.** Whether the feature touches personal, health or payment data is
    knowable; which regime governs it is not this skill's to judge. A yes
    routes the answer to the organisation's data-protection or compliance
    function and fills the spec's Regulated data section; the five fields are
    stated once, in the discipline reference.
11. **An unanswered escalation does not block, and does not go unrecorded.**
    The draft spec says the work is proceeding without the answer and records
    the question as unanswered. Blocking would get the skill worked around;
    silence would lose the only trace that the question was ever raised.
12. **A decision arriving without code leaves this skill.**
    [`pdlc-decide`](pdlc-decide.md) holds it, and holds the supersession
    mechanic that this skill previously only named as a rule.
13. **It loads two reference files, not the whole discipline.**
    `doc-discipline.md` for the routing of a sentence and the writing rules,
    [`decision-records.md`](../../skills/_pdlc-shared/decision-records.md) for
    the ADR-or-spec tests, append-only and the regulated-data record. The
    convention `AGENTS.md` follows is not loaded: this skill appends a
    repo-wide trap to that file, it does not restructure it
    ([ADR-0010](../adr/0010-shared-reference-split-by-need.md)).
14. **Step 6 runs the build loop stated in `build-loop.md`, loaded there and
    not at the start.** The loop is identical whether reached from here or
    standalone from [`pdlc-build`](pdlc-build.md), so it is stated once, in
    the shared reference, rather than kept as this skill's own implicit
    version of it. A session that stops at the go-ahead never pays for build
    instructions it will not use.
15. **The spec is short and plainly worded, by instruction.** The template
    asks for one sentence per decision and one line per rejected alternative.
    `decision-records.md` sets a budget of 500 lines, counted with `wc -l`
    and reported. `doc-discipline.md` holds the wording rules, such as
    one idea per sentence. The kit's five specs have items of 46 words at the
    median and 105 at the 90th percentile, and no instruction asked for less.
16. **The spec has a Non-goals section and none for the files touched.** The
    build loop stops at the non-goals, so they need a fixed place. The files
    touched are in the code, and a list of them goes stale at the next rename.
17. **The spec states its behavior as numbered, observable results.** The
    build writes at least one test per line, so a line has to be something a test can
    assert from outside; a decision's reason is not. The go-ahead at step 5
    now covers what will be tested as well as what was decided, which is the
    one review of the tests' relevance that happens before they exist
    ([ADR-0017](../adr/0017-a-spec-states-its-behavior-as-testable-lines.md)).

## Rejected alternatives

- **A hook suggesting a spec update when a spec'd area is touched** —
  rejected: it needs hook configuration, which means something executing on
  the user's machine, against the no-executables constraint in `PRODUCT.md`.
  It is also noisy on exactly the repositories with the most specs.
- **A blocking check before commit** — rejected: Ag-PDLC Kit cannot tell a
  behavior change from a rename, so it would block on the second and be
  disabled by the end of the week.
- **Writing the spec only after implementing** — this skill's original shape,
  reversed on 2026-09-16
  ([ADR-0012](../adr/0012-a-spec-precedes-the-implementation-it-governs.md)).
  The reason recorded for it was that decisions still move during
  implementation, and that a spec written from the plan documents the plan
  rather than the system. That reason stands against the variant below, but not
  against this one: reconciling the spec at the end answers it, and the spec
  has since gained a consumer the original reasoning did not know about — the
  implementation itself, which needs the behavior and the non-goals as input
  rather than as an epilogue.
- **Writing the spec before the code and never reconciling it** — rejected,
  and it is the variant the original reasoning defeats outright. It is worse
  than a late spec: it describes the plan with the authority of a record.
- **Folding `pdlc-init` into this skill** — rejected: bootstrapping reads
  the whole repository and its history, which is a different job with a
  different failure mode, and mixing them would make the common case pay for
  the rare one.
- **Blocking the go-ahead until a regulated-data escalation comes back** —
  rejected: the answer arrives on someone else's schedule, and a gate that
  stalls for days is a gate people route around. Recording the gap keeps the
  trace without creating the incentive to skip the question entirely.
- **Having the skill assess which regime applies to the data** — rejected:
  that is legal and regulatory advice, which this product does not give at
  any level of confidence. The skill establishes the fact and names who
  answers.
- **A regulated-data section in every spec, empty when it does not apply** —
  rejected: an empty compliance section in ninety specs trains the reader to
  skim past the one that is filled. The section is present or absent.
- **A length budget with no wording rules** — rejected: it cuts earlier but
  does not make a sentence simpler.
- **Wording rules with no budget** — rejected: a line count can be checked and
  reported, a style rule cannot.
- **Wording rules in `decision-records.md`, for specs only** — rejected: ADRs,
  `PRODUCT.md` and `AGENTS.md` show the same noise, and `doc-discipline.md` is
  already read before any write.

## Known gaps

| Left out | Add it when |
|---|---|
| Nothing enforces step 7 if the session ends after implementation | A real session is observed losing its decisions this way |
| A `Draft` spec left behind by work abandoned after the go-ahead, which nothing removes or flags | Enough of them accumulate for a reader to mistake one for shipped behavior |
| Nothing verifies that a spec marked `Shipped` was reconciled rather than relabelled | A spec is found claiming `Shipped` while still describing the draft |
| No detection that the new spec overlaps an existing one | Repositories accumulate enough specs for the overlap to be real |
| No handling of a feature spanning several repositories | A monorepo or a split front/back project needs it |
| Nothing verifies the regulated-data answer ever arrived, once a spec records the question as unanswered | A spec is found carrying an unanswered escalation long after the feature shipped |
| The whole flow — question round, recap, go-ahead — runs at the same weight for a one-line change as for a new subsystem | A real session is observed paying the full ceremony on a trivial fix |
| Nothing enforces the budget or the wording: the model counts and reports | A spec is found well past the budget |
| The effect of the wording rules on a real session is not measured | A spec written in a target repository is read and found still wordy |
| A line budget is bypassed by long paragraphs, since prose is not hard-wrapped | A spec is found under the budget with paragraphs of several sentences |
