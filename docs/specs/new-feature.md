# Spec — new-feature

> Living document: any change to the `new-feature` skill is reflected here in
> the same change. Revised 2026-09-14.
>
> Drafted with an AI assistant — review before sharing outside the team.

## Summary

`new-feature` turns an informal feature request into working code, and writes
down what the work decided. It reads the repository, surfaces every open
point as a question, recaps scope, waits for an explicit go-ahead, implements,
then records the decisions in a spec — and in an ADR when they reach beyond
the feature.

It is a derivative of the user-level `feature` skill, which stops at
implementation. The addition is step 7, and the reason for the whole skill:
the clarification round is where the rejected alternatives exist for the last
time.

The routing between spec and ADR is not decided here. It is stated once in
`skills/_croakness-shared/doc-discipline.md`, and this skill applies it.

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
   `croakness-init` and proceeds anyway, writing the spec against the
   conventions the code actually shows — a repo with no documentation is
   where the first spec is worth the most.
6. **`AGENTS.md` is updated only for a rule that became repo-wide**, and the
   PRD only when user-visible behavior changed. Most features touch neither.
7. **An empty `adr/` is normal, not a symptom.** The log starts at
   installation and grows forward
   ([ADR-0004](../adr/0004-decision-records-are-written-forward.md)); this
   skill is the main thing that fills it, so on a fresh repo it writes
   `0001`.

## Rejected alternatives

- **A hook suggesting a spec update when a spec'd area is touched** —
  rejected: it needs hook configuration, which means something executing on
  the user's machine, against the no-executables constraint in the PRD. It is
  also noisy on exactly the repositories with the most specs.
- **A blocking check before commit** — rejected: Croakness cannot tell a
  behavior change from a rename, so it would block on the second and be
  disabled by the end of the week.
- **Writing the spec before implementing** — rejected: decisions still move
  during implementation, and a spec written from the plan documents the plan,
  not the system.
- **Folding `croakness-init` into this skill** — rejected: bootstrapping reads
  the whole repository and its history, which is a different job with a
  different failure mode, and mixing them would make the common case pay for
  the rare one.

## Known gaps

| Left out | Add it when |
|---|---|
| Nothing enforces step 7 if the session ends after implementation | A real session is observed losing its decisions this way |
| No detection that the new spec overlaps an existing one | Repositories accumulate enough specs for the overlap to be real |
| No handling of a feature spanning several repositories | A monorepo or a split front/back project needs it |
