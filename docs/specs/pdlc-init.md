# Spec — pdlc-init

> Living document: any change to the `pdlc-init` skill is reflected here in
> the same change. Revised 2026-09-15.
>
> Drafted with an AI assistant — review before sharing outside the team.

## Summary

`pdlc-init` installs the four-level discipline on a repository that has
none. It surveys the code, reads the git history, settles the documentation
root, then writes two files: `AGENTS.md` and `PRODUCT.md`. It writes no ADR
and no spec — the decision log starts empty and grows forward
([ADR-0004](../adr/0004-decision-records-are-written-forward.md)). It
finishes by naming what it could not establish.

It runs once per repository. Keeping the documents alive afterwards is
[`pdlc-feature`](pdlc-feature.md)'s job.

## Decisions

1. **The source is the code and the history, never memory or a ticket.**
   Documentation written from intent disagrees with the code quietly, which is
   worse than having none — it is read with the same trust.
2. **`AGENTS.md` is written first.** It is the file with the highest value per
   line for the next agent, and the one that can be grounded most directly in
   evidence: real commands from the task runner's manifest, style the code
   actually exhibits, traps the history shows someone already hit.
3. **Structural choices visible in the code go to `AGENTS.md`, not to an
   ADR.** They are state, and state is what `AGENTS.md` and `PRODUCT.md` are
   for.
4. **No empty directories.** `adr/` and `specs/` are created by their first
   record, not by the installer. An empty directory is a promise nobody made.
5. **Nothing is overwritten**, and an existing product document counts under
   any name — `PRD.md` included. Existing prose is evidence; a merge is
   proposed and the user arbitrates.
6. **The docs root is settled before anything is written**, and recorded in
   `AGENTS.md` when it is not `docs/`
   ([ADR-0002](../adr/0002-docs-root-without-config-file.md)).
7. **The unknowns are reported explicitly** at the end, as a list of what
   needs a human — including anything in `AGENTS.md` written from inference
   rather than evidence. It is an output of the skill, not an admission of
   failure.
8. **The empty log is stated in the report.** On a repository with years of
   history, an empty `adr/` looks like the tool failed. Saying it is by design
   costs one sentence.

## Rejected alternatives

- **Retroactive ADRs and specs** — rejected in
  [ADR-0004](../adr/0004-decision-records-are-written-forward.md).
- **One spec per top-level directory** — rejected: volume destroys trust in
  the set. Twelve specs, nine of them restating what the code already says,
  train every reader to skip all of them.
- **Writing `PRODUCT.md` first** — rejected: product intent is the hardest
  thing to ground in a repository and the least useful to an agent about to
  write code. `AGENTS.md` pays off immediately.
- **Generating documents silently and letting the user review the diff** —
  rejected for the docs root and for any existing file: a merge proposal costs
  one question and avoids destroying prose that was someone's afternoon.
- **A configuration file to hold the docs root** — rejected in
  [ADR-0002](../adr/0002-docs-root-without-config-file.md).

## Known gaps

| Left out | Add it when |
|---|---|
| No strategy for a repository too large to survey in one pass | A monorepo is attempted and the survey step runs out of context |
| Assumes git; a repository without history yields a thinner `AGENTS.md` | A target project uses another VCS, or none |
| No refresh mode for a repository where A-PDLC Kit already ran | The documents have drifted enough that re-deriving beats editing |
| No migration for a repository initialised at 0.1.0, whose product document is named `PRD.md` | A repository on the old name asks for it. The skill treats the file as existing prose and proposes a merge, but never renames it |
| No help for a team that wants to record a genuinely remembered past decision | Someone asks for it. The skill will not write it for them, but it could prompt for what was weighed |
