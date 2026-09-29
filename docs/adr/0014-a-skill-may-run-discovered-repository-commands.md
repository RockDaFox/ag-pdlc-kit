# ADR-0014 — A skill may run a repository's own test, lint and build commands, discovered and never invented

| | |
|---|---|
| **Status** | Superseded by [ADR-0015](0015-review-corrections-enter-the-build-loop.md) |
| **Date** | 2026-09-16 |
| **Supersedes** | — |

## Context

`docs/PRODUCT.md` §4 constrains the commands a skill has an agent run to git's, and names them: `pdlc-init` has always used `git log`, and since [ADR-0012](0012-a-spec-precedes-the-implementation-it-governs.md) `pdlc-feature` also commits the draft spec and the reconciled one. That constraint was correct for every skill that existed when it was written — none of them needed anything wider.

`docs/specs/pdlc-build.md` needs one. Its whole reason to exist is test-first: state the failure expected, write the test, run it, confirm it fails for that reason, implement, return to green. None of that is available to a skill that cannot execute the repository's own test command — a red step nobody runs is a claim taken on the agent's word, which is exactly the unverified assertion the discipline refuses to accept from a human record elsewhere in this product (`decision-records.md`: "nothing unverified goes here"). The spec's own Summary names this precisely and stops short of shipping over it: "the commands it has the agent run are the repository's own test, lint and build commands, not git's... widening that to whatever a repository's manifest happens to contain is a different question, and nothing has decided it." `docs/PRODUCT.md` §5 lists the same gap and the same condition: the skill waits on this one decision.

The question is narrow, and the spec already states the shape of its answer in Decision 11 and in its Rejected alternatives — this ADR is that decision recorded, not a new one arrived at independently.

## Decision

**A skill may run a repository's own test, lint, typecheck and build commands, in addition to git's**, where a repository's own tooling already defines them. This widening is scoped to the build loop (`pdlc-build`, and `pdlc-feature` at its own step 6) and changes nothing about every other skill's surface.

**Discovered, never invented.** The command comes from `AGENTS.md` if it names one, otherwise from the task runner's manifest, with its real flags — the same discovery `pdlc-init` already performs when it writes such commands down for a human to read. No skill ships a per-stack command table (`npm test`, `pytest`, ...): a guessed command in this one place executes something, rather than merely reading wrong, which is a stronger reason than the one that already rules out invented examples everywhere else in this product.

**A repository with no discoverable command gives the loop nothing to run.** The skill says so and falls back to a stated, executed verification rather than inventing a suite; it does not report a step as red when no command actually ran.

`docs/PRODUCT.md` §4 is reworded to state both surfaces.

## Alternatives weighed

- **Leave the constraint at git-only, and have `pdlc-build` stop short of running anything, taking the user's word for the test result** — rejected: it turns "the red is read, not merely observed" into an unverifiable claim, which is the exact failure this discipline exists to keep out of a decision record, now let into the one place execution is supposed to prove something.
- **Ship a per-stack command table so no repository command ever has to be discovered** — rejected in the spec itself, and restated here because it is the alternative this decision most directly closes off: the table duplicates what `AGENTS.md` already states for the repository it runs on, it goes stale silently, and unlike every other invented example in this product, a wrong row here does something rather than merely reading wrong.
- **Widen the surface generally, to any command a skill judges useful** — rejected: that is a materially larger and open-ended grant for the same one-line change, and it is not what the spec asked for. The widening is named exhaustively — test, lint, typecheck, build — not opened without a limit.
- **A hook or CI step running the suite instead of the agent** — rejected for the reason [ADR-0008](0008-one-maintainer-side-check-script.md) already gives against enforcement mechanisms: it executes on a repository the product does not own, outside the session the user is approving as it happens.

## Consequences

- `docs/PRODUCT.md` §4 now names two execution surfaces instead of one. A reader auditing what this product can run on their machine has to read both: git commands under every skill, and a repository's own test, lint, typecheck and build commands under the build loop only, on a spec the user has already given a go-ahead on.
- A repository with unusual or broken tooling — a test command that hangs, one that needs a resource the session cannot reach — is not addressed here. `docs/specs/pdlc-build.md`'s own Known gaps name the slow-suite and no-suite cases as still open; this decision only clears the constraint that was keeping the skill from existing, not those gaps.
- `scripts/check.sh` does not verify that a skill only ever ran a discovered command rather than an invented one. The discipline holds by agreement, as `docs/PRODUCT.md` §4 already says of everything else on that list.
- "The product installs nothing executable" is unaffected: nothing is installed by this decision, and a command already present in the target repository is what gets invoked. What changes is which of a repository's own commands a skill following this kit is now permitted to run.
