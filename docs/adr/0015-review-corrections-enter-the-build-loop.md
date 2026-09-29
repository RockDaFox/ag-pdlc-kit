# ADR-0015 — A review's corrections are applied through the build loop, not beside it

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-29 |
| **Supersedes** | [ADR-0014](0014-a-skill-may-run-discovered-repository-commands.md) |

## Context

[ADR-0014](0014-a-skill-may-run-discovered-repository-commands.md) widened the commands a skill may run from git's alone to a repository's own test, lint, typecheck and build commands, discovered and never invented. It scoped that grant by naming its holders in its Decision: "the build loop (`pdlc-build`, and `pdlc-feature` at its own step 6)". That was right on the day it was written, for the reason the record states — the constraint it relaxed "was correct for every skill that existed when it was written", and the build loop was the only place in the kit where a skill changed a repository's code and then had to say something true about the result.

`docs/specs/pdlc-review.md` ends that coincidence. The review applies the corrections the user selected, so it changes code, and a correction made for readability can break a test. Something has to prove the tree it hands back, at the exact moment the user is about to commit it.

Two ways to give it that. Grant the skill the commands directly, so it edits and then runs lint, typecheck and the suite over the result — the smaller change, and the one the spec's draft assumed. Or route each correction through the loop that already exists for precisely this: state the failure expected, read it, implement against it, return to green, then the repository's own checks over the whole change. The second is not a way of borrowing the permission. It is a different standard applied to the correction itself.

## Decision

**Every correction a review applies enters the build loop; none is applied beside it.** `pdlc-review` executes nothing on its own authority. It reads, grades, and sequences what the user selected; [`build-loop.md`](../../skills/_pdlc-shared/build-loop.md) is what changes the code and what proves it.

A correction maps onto the loop the way a behavior does. Each one takes its own pass through steps 1 to 5, and the closing steps run once over the whole set, exactly as they already do for the behaviors a spec names. What a correction carries decides how much of its pass is real work: one that changes behavior brings a new expected failure and takes the pass as written; one that changes no behavior — a shape made clearer, a hand-rolled helper replaced by what the library already provides — has no failure to state, and what must hold is that the existing suite is still green for the same reasons afterwards. A pass with nothing to assert is said to have nothing to assert; it is not dressed in a test written to have run one.

**`build-loop.md` gains a third caller and a second kind of input.** Its input has been a spec on disk. A review finding — where it is, what is wrong, what the correction is — is now the other, and the rule that the input is read rather than recalled holds for both: a finding the user selected is one they were shown in writing.

**The grant ADR-0014 made is unchanged in substance and restated without its enumeration.** A repository's own test, lint, typecheck and build commands, discovered from `AGENTS.md` or the task runner's manifest with their real flags, never invented, the set exhaustive — executed inside the build loop and nowhere else. This supersedes ADR-0014 rather than amending it because that record named its holders inside its Decision, and a record is not edited to add one.

`docs/PRODUCT.md` §4 is reworded: the execution surface is the build loop, and which skills reach it is not part of the constraint.

## Alternatives weighed

- **Grant `pdlc-review` the commands directly and let it verify its own edits** — the shape the spec's draft assumed, and rejected once it was written out. It buys the weaker half of what the loop already offers: the review would establish that nothing broke, which is not the same as establishing that the correction did what it claimed, and a behavior-changing correction would ship with nothing behind it. It also adds a second execution surface to a product whose auditability is one of its selling points.
- **Supersede ADR-0014 with the same enumeration plus a third name** — rejected: the enumeration is the part that would keep needing a new record, and a log of records that decide nothing already decided is the noise `decision-records.md` says the log exists to stay clear of.
- **Apply the corrections with no verification, leaving it to a later `pdlc-build`** — rejected: it returns a modified, unverified tree at the moment of highest consequence, and it makes the review's value conditional on a step nothing guarantees will happen.
- **Run the loop's closing steps once per correction rather than once per review** — rejected: `build-loop.md` already settles this for behaviors, and a correction is not more expensive to prove than a behavior. Repeating lint, typecheck and build per finding would make a review of a dozen details cost more than the build that produced them.
- **Widen the command set to whatever a skill judges useful** — rejected again, for the reason ADR-0014 gave and which has not changed.

## Consequences

- **A correction that changes behavior now arrives with a test.** That is more than the review was asked for and more than a human reviewer's comment usually carries, and it is the real return on routing through the loop rather than around it.
- **`build-loop.md` is no longer only about building a spec**, while its name and its opening sentence both say spec. The file states its second input; the mismatch between the name and the wider role is left standing rather than renaming a file every skill reaches by relative path. A reader arriving at it from `pdlc-review` meets that friction.
- **`pdlc-review` has no execution surface of its own.** Someone auditing what this product runs on their machine reads `build-loop.md` and nothing else, which is a smaller surface than the alternative would have left.
- **A correction with nothing to assert gets a pass through the loop that proves little on its own**, and leans entirely on the closing steps. The honest version of that pass says so; the dishonest version writes a test to have written one, and nothing here can prevent that beyond stating it.
- `scripts/check.sh` still does not verify that a command a skill ran was discovered rather than invented, and gains no ability to do so here.
- "The product installs nothing executable" is unaffected, for the reason ADR-0014 gave: what runs is a command already present in the target repository.
- ADR-0014 keeps every word and stays accurate about its own date. Only its `Status` row changes, to point here.
