# ADR-0019 — The kit ships one check that runs on a documented repository: the AI-notice pre-commit hook

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-10-21 |
| **Supersedes** | [ADR-0008](0008-one-maintainer-side-check-script.md) |

## Context

[ADR-0008](0008-one-maintainer-side-check-script.md) created `scripts/check.sh` as maintainer tooling for this repository. It also stated what the "no executables" constraint protects: the product installs nothing and runs nothing on a repository it documents. A script that skills would run on a documented repository was one of the options it rejected.

Every document an agent drafts ends with an AI-assistance notice, and removing it is the human review ([ADR-0013](0013-notice-removed-by-the-review-before-commit.md)). Nothing made that review happen. In this repository `check.sh` reported an ADR still carrying its notice, but only when someone ran it, and only for ADRs. In a documented repository nothing reported anything. The user asked for a check that runs on the project repository and stops the commit, so that a human has to read the document first.

## Decision

**The kit ships one script that runs on a repository it documents: `skills/_pdlc-shared/notice-check.sh`.** It refuses a commit that adds the `ai-draft` marker line under the documentation root or in `AGENTS.md`. It checks nothing else.

`pdlc-init` offers to install it as a git pre-commit hook in the clone, and installs it only on a yes. The install copies the script into the clone's git directory and adds one call to the pre-commit hook. Nothing is versioned and no git setting is changed. The script also runs by hand.

A skill may run this one script, on the user's consent, beside git's commands and the repository's own commands inside the build loop. The install makes the hook it creates executable, and touches the mode of nothing else.

What stays from ADR-0008: `scripts/check.sh` exists, checks this repository only, and no skill invokes it. Its reasons — POSIX sh, no dependency, report rather than fix, a blind check says so — apply to the new script too.

## Alternatives weighed

- **Keep the notice check in `scripts/check.sh`, run by hand** — rejected by the user: the commit has to be stopped in the project repository, not reported in the kit's own.
- **Run the whole of `check.sh` on a project repository** — rejected: its other checks are about the kit, and the user wanted the notice alone checked there.
- **Have the agent write the hook files from instructions, with no script** — rejected during the build: every edge case of an existing hook would be the model's judgement on every install. A script does the same thing every time.
- **Install by default, or ship a versioned hooks directory** — rejected in [`pdlc-init`'s spec](../specs/pdlc-init.md): the hook changes how every commit behaves, so the user says yes first, and a versioned hooks path turns off the hooks already in `.git/hooks`.

## Consequences

- "The product installs nothing executable" is no longer true. Auditing the kit now means reading this script too. It has no dependency, opens no connection, and writes only its own copy and the pre-commit hook.
- The script runs on a machine the product does not own, which is the line ADR-0008 drew. It is crossed for one check, at the user's request and with consent at install. Every further check that would run on a documented repository needs its own record.
- The hook is per clone. A clone that never installed it commits a notice unchecked, and `git commit --no-verify` always goes through.
- The hook edits a pre-commit file it does not own. A hook manager that regenerates that file drops the call without saying so.
- The marker has to stay untranslated in every documented repository. A document that quotes the marker as text is refused like a notice.
- No automated test covers the script, at the user's request. It was tried by hand once before shipping, in throwaway repositories; a later change to it has nothing to run against.
