# Spec — pdlc-feature

> Living document: any change to the `pdlc-feature` skill is reflected here in
> the same change. Revised 2026-09-15.
>
> Drafted with an AI assistant — review before sharing outside the team.

## Summary

`pdlc-feature` turns an informal feature request into working code, and writes
down what the work decided. It reads the repository, surfaces every open
point as a question, recaps scope, waits for an explicit go-ahead, implements,
then records the decisions in a spec — and in an ADR when they reach beyond
the feature.

It is a derivative of the user-level `feature` skill, which stops at
implementation. The addition is step 7, and the reason for the whole skill:
the clarification round is where the rejected alternatives exist for the last
time.

The routing between spec and ADR is not decided here. It is stated once in
`skills/_pdlc-shared/doc-discipline.md`, and this skill applies it.

## Decisions

1. **The spec is written by this skill, at the end of its own flow** — not by
   a hook watching for edits, not by a check at commit time. Judging whether a
   decision is worth engraving is not automatable, and a spec too many rots
   the set as surely as a spec missing.
2. **The rejected alternatives come from the question round**, and are written
   while it is fresh. Reconstructing them after the feature ships produces
   fiction: only the surviving option still feels real.
3. **An explicit go-ahead gates the code.** The recap is not a notification;
   the skill stops there until the user answers.
4. **The documents are written in the same change as the code**, never as a
   follow-up task. A follow-up is a task note, and task notes are the thing
   this repository exists to stop producing.
5. **An undocumented repository is not refused.** The skill offers
   `pdlc-init` and proceeds anyway, writing the spec against the
   conventions the code actually shows — a repo with no documentation is
   where the first spec is worth the most.
6. **`AGENTS.md` is updated only for a rule that became repo-wide**, and
   `PRODUCT.md` only when user-visible behavior changed — in the present
   indicative, describing what now ships. Most features touch neither.
7. **An empty `adr/` is normal, not a symptom.** The log starts at
   installation and grows forward
   ([ADR-0004](../adr/0004-decision-records-are-written-forward.md)); this
   skill is the main thing that fills it, so on a fresh repo it writes
   `0001`.
8. **Regulated data is asked about in the question round, as a question of
   fact.** Whether the feature touches personal, health or payment data is
   knowable; which regime governs it is not this skill's to judge. A yes
   routes the answer to the organisation's data-protection or compliance
   function and fills the spec's Regulated data section; the five fields are
   stated once, in the discipline reference.
9. **An unanswered escalation does not block, and does not go unrecorded.**
   The recap says the work is proceeding without the answer, and the spec
   records the question as unanswered. Blocking would get the skill
   worked around; silence would lose the only trace that the question was
   ever raised.
10. **A decision arriving without code leaves this skill.**
    [`pdlc-decide`](pdlc-decide.md) holds it, and holds the supersession
    mechanic that this skill previously only named as a rule.

## Rejected alternatives

- **A hook suggesting a spec update when a spec'd area is touched** —
  rejected: it needs hook configuration, which means something executing on
  the user's machine, against the no-executables constraint in `PRODUCT.md`.
  It is also noisy on exactly the repositories with the most specs.
- **A blocking check before commit** — rejected: A-PDLC Kit cannot tell a
  behavior change from a rename, so it would block on the second and be
  disabled by the end of the week.
- **Writing the spec before implementing** — rejected: decisions still move
  during implementation, and a spec written from the plan documents the plan,
  not the system.
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

## Known gaps

| Left out | Add it when |
|---|---|
| Nothing enforces step 7 if the session ends after implementation | A real session is observed losing its decisions this way |
| No detection that the new spec overlaps an existing one | Repositories accumulate enough specs for the overlap to be real |
| No handling of a feature spanning several repositories | A monorepo or a split front/back project needs it |
| Nothing verifies the regulated-data answer ever arrived, once a spec records the question as unanswered | A spec is found carrying an unanswered escalation long after the feature shipped |
| The whole flow — question round, recap, go-ahead — runs at the same weight for a one-line change as for a new subsystem | A real session is observed paying the full ceremony on a trivial fix |
