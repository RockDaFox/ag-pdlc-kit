# Spec — pdlc-build

> **Status: Shipped**
>
> Living document: any change to the `pdlc-build` skill is reflected here in the same change. Revised 2026-11-05.

## Summary

`pdlc-build` turns a spec into code, tests and an evidence block, test-first. It derives the test list from the behavior the spec states, writes each test, runs it, confirms it fails for the reason stated, implements against that failure, returns to green, then reports what it ran, what it covered and what it left.

It is the first skill of the kit's second family: three skills record what is decided, this one carries out the work a record authorises, and [`pdlc-review`](pdlc-review.md) holds the result to a standard afterwards. Like them it is instruction to the model and ships nothing executable, with one difference that matters — the commands it has the agent run are the repository's own test, lint and build commands, not only git's. `docs/PRODUCT.md` §4 named the commands a skill runs and they were all git's; [ADR-0014](../adr/0014-a-skill-may-run-discovered-repository-commands.md) widened that to the repository's own test, lint, typecheck and build commands, discovered and never invented, and [ADR-0015](../adr/0015-review-corrections-enter-the-build-loop.md) supersedes it to carry the same grant without naming its holders — the surface is the loop, not a list of skills that reach it.

Its input is a spec, never a paraphrase of one: `{docs_root}/specs/<feature>.md` carrying `Status: Draft`, which is what [ADR-0012](../adr/0012-a-spec-precedes-the-implementation-it-governs.md) made available. Two entry points reach the loop for a build:

- **Inside [`pdlc-feature`](pdlc-feature.md)**, at its step 6, on the spec the go-ahead was just given on. `pdlc-feature` keeps the reconciliation that follows.
- **Standalone**, on a scope settled elsewhere — a `Draft` spec committed in an earlier session, a ticket already specified, a bug with a known cause.

The loop itself lives in `skills/_pdlc-shared/build-loop.md` so that both entry points state it once ([ADR-0010](../adr/0010-shared-reference-split-by-need.md)).

## Decisions

1. **The build loop is a skill, and `pdlc-feature` delegates to it rather than absorbing it.** The loop is identical whether the scope came from a clarification round or arrived already settled, and the second case is common — a ticket, a plan from another session, a bug fix. Folding the loop into `pdlc-feature` would leave that case with no route, or with a route through four steps it has to skip.
2. **Test-first is an ordering requirement, not a recommendation.** An implementer that writes code and then tests is grading its own homework: the test that results confirms what the implementation does, not what the spec asked for. Writing it before the implementation exists to read removes the failure mode structurally instead of asking the agent to resist it. The reason this is firmer for an agent than the same discipline is for a human is the self-reference, not rigour.
3. **The red is read, not merely observed.** A test failing on an import error, a typo or a missing fixture is not exercising the behavior; one failing on a false assertion is. The loop states the failure it expects before running, and a failure for any other reason sends the test back rather than forward into implementation. Without this, the red step reduces to a ritual that any broken file passes.
4. **The spec is the input, read from disk and not from memory.** It is a file, so it is re-readable mid-task, survives the session, and can be picked up by a different agent — which is why it is committed at the go-ahead rather than held in a message. The test list starts from the behavior it states, and its non-goals bind the suite as much as its behavior does: no test inside them. Beyond the lines it names, the agent adds the cases it finds worth a test (decision 15).
5. **A repository that contradicts the spec stops the build.** A pattern absent where the spec assumed one, an assumption a test disproves: the skill reports the discrepancy and returns for a new go-ahead. It never reconciles a wrong assumption on its own initiative, because a quiet repair is a scope decision taken without a record. This is the counterweight to a spec existing before the code — the spec is a contract under test, not an authority.
6. **It owns no document when it runs inside `pdlc-feature`.** The reconciliation, the ADR and `PRODUCT.md` stay with that skill's step 7. One record, one writer.
7. **Standalone, it routes what the build decided through the three tests.** A build with no `pdlc-feature` around it still produces decisions that constrain later code, and those must not fall on the floor because of which entry point was used. It loads `decision-records.md` in that case only, applies the scope, reversal-cost and lifetime tests, and writes the spec entry or the ADR they select. Where the build decided nothing worth a record, it says so and writes nothing.
8. **Standalone with a `Draft` spec on disk, that spec is the input and the skill reconciles it.** This is the resumed-work case and the handoff case, and it is the reason the draft is committed at all. A `Shipped` spec for the same feature is a different situation: the work is a change to shipped behavior, so the spec is rewritten in place, not drafted again.
9. **Standalone with no spec at all, the scope is restated and confirmed, not re-derived.** The skill states in a few lines what it understands the work to be and waits. It does not open a clarification round: two skills that both interrogate would leave the kit with a weaker `pdlc-feature` that wins by being nearer to hand.
10. **The evidence block is session and pull-request output, never a spec section.** Commands run, their output, which acceptance criterion each test covers, what was left. That is perishable state — a passing count is true for one commit — and the spec records decisions.
11. **It runs the repository's own commands, discovered, never invented.** Test, lint and typecheck commands come from `AGENTS.md` or from the task runner's manifest, with their real flags, which is the rule `pdlc-init` already follows when it writes them down. The skill ships no per-stack command table: it would be an invented example that rots, and this is a skill where a guessed command does something rather than merely reading wrong. [ADR-0014](../adr/0014-a-skill-may-run-discovered-repository-commands.md) recorded the widening this decision needed against `docs/PRODUCT.md` §4's git-only constraint, and [ADR-0015](../adr/0015-review-corrections-enter-the-build-loop.md) carries it forward unchanged in substance.
12. **`pdlc-feature` loads `build-loop.md` at step 6, not at the start.** The clarification round has no use for build instructions, and a session that stops at the go-ahead would have paid for them anyway — ADR-0010's reasoning applied inside a single invocation rather than across skills.
13. **The loop is performed, not narrated.** The red step is a check the agent runs, not a message it sends: a test failing before its implementation exists is the expected outcome, so a line reporting it — or reporting which file comes next — pays output tokens for what the reader already knows. The failure expected at step 1 lives in the test's name and assertion, which are re-readable; the red reaches the user once, in the evidence block. Mid-loop output is reserved for what is not expected: a red for the wrong reason, a contradiction, a missing command. This is ADR-0010's economy applied to output rather than input — the loop is long, and a per-step account of it is paid again for every behavior the spec names.
14. **Each test cites a line of the spec's Behavior section, and asserts the result that line states.** A test passes the loop's other checks — in scope, red for the stated reason — and can still check nothing the spec asked for: an internal call, a mock answering itself. Naming the line before writing makes the link between spec and test explicit, and asserting what a caller would see keeps the test on the behavior rather than on the implementation. The evidence block reports one row per line with its test, so an uncovered line and a test with no line are both visible. This narrows the gap without closing it: the agent that writes the test still judges whether it fits the line, and [`pdlc-review`](pdlc-review.md) makes the independent reading of the tests against the lines, on demand.
15. **The agent adds the tests it finds relevant, and decides nothing the spec leaves open.** A spec cannot list every boundary, empty input or failing dependency, and an agent that stops at the listed lines tests only what the author thought of. A found test cites the line it extends and is marked as found in the evidence block. When its expected result follows from that line, it is written and implemented. When the result is a choice the spec does not make, the loop writes no test and no code for it and reports it as a proposed Behavior line, because a quiet decision there is the scope decision decision 5 forbids. A found test green on its first run is kept only if it asserts something the line's own test does not, and is reported as such.
16. **In a repository that uses OpenSpec, the input is an open change, and the loop runs on it unchanged.** The repository uses OpenSpec when an `openspec/` directory sits at its root, unless its `AGENTS.md` says it keeps the kit's own specs ([ADR-0021](../adr/0021-a-repository-that-uses-openspec-keeps-its-specs-there.md)). The change, `openspec/changes/<change>/`, is read from disk like a spec. Its scenarios are the Behavior lines, and a test cites a requirement and a scenario by name. The out-of-scope part of `proposal.md` is the non-goals, and `tasks.md` gives the order of work. The test-first loop is the reason a team runs this skill rather than OpenSpec's apply command, so nothing in it is relaxed.
17. **The skill runs the OpenSpec CLI when it is installed, and never does its work by hand.** `openspec validate <change> --strict --no-interactive` runs before the first test, and a failure stops the build, because a malformed change is a spec problem. After the loop, each divergence goes to the change's `design.md` as a rejected alternative, and finished tasks are ticked in `tasks.md`. Once the user approves the commit, `openspec archive <change> --yes` merges the deltas into `openspec/specs/`, in the same commit as the code. That is the reconciliation `Shipped` stands for in the kit's own specs. Without the CLI, the change stays open and the skill says so. Merging deltas by hand would reimplement OpenSpec's archive, and a wrong merge corrupts the specs it owns. A change not yet committed gets the go-ahead and the commit [ADR-0012](../adr/0012-a-spec-precedes-the-implementation-it-governs.md) asks for, before the loop.

## Behavior

The loop, once a spec is in hand:

1. Derive the test list from the spec's Behavior section — at least one test per numbered line, then the edge cases worth a test around them, none inside the non-goals.
2. For each: state the Behavior line covered and the failure expected, write the test against the result that line states, run it, confirm that failure. Silently — only an unexpected red or a contradiction is reported before the end.
3. Implement against that failure only.
4. Run the targeted tests, then the repository's lint, typecheck and build where they exist.
5. Inspect the diff, then report the evidence block.

Done is not reportable while any of these is missing: each test confirmed red before its implementation existed, every Behavior line covered by a test or named as left, the targeted tests green, the repository's own checks run, the diff inspected, and the remaining limitations named. "Tests pass" without the command and its output is a claim, not evidence.

The lines below cover a repository that uses OpenSpec only.

- **B1** — No change is named and one change is open: the skill builds that change. Several are open: it lists them and asks which one.
- **B2** — No change is open and the request is a feature: the skill names OpenSpec's propose command and writes nothing.
- **B3** — The change is not committed: the skill asks for a go-ahead on it, and commits it before the first test.
- **B4** — The CLI is installed: `openspec validate <change> --strict --no-interactive` runs before the first test. A failure stops the build, and its output is shown.
- **B5** — The CLI is missing: the skill says that validation and archive will not run, then runs the loop.
- **B6** — The evidence block has one row per scenario of the change, named by requirement and scenario.
- **B7** — A result the change leaves open is reported as a proposed scenario, and no test or code decides it.
- **B8** — After the loop: each divergence is a line under Rejected alternatives in the change's `design.md`, and each finished task is ticked in `tasks.md`.
- **B9** — The user approves the commit and the CLI is installed: `openspec archive <change> --yes` runs first, and the commit holds the code, the merged specs and the archived change.
- **B10** — The user approves the commit and the CLI is missing: the commit holds the code and the open change, and the skill says to archive it with OpenSpec's archive command.
- **B11** — The archive command fails: the skill shows its output, commits nothing, and waits.
- **B12** — Nothing is written under `{docs_root}/specs/`.

## Rejected alternatives

- **A mode or flag of `pdlc-feature`** — rejected: the standalone entry point never passes through the question round, so the mode would be the skill's most common use and its least natural one. A skill reached by a flag is a skill the user has to know exists.
- **Restating the loop in both skills** — rejected by the repository's own rule: a rule appearing in two skills moves into the reference, because two copies drift.
- **A cross-skill referral — `pdlc-feature` telling the user to invoke `/pdlc-build`** — rejected: it breaks the flow at the one point where continuity is the whole value, immediately after the go-ahead. The existing referral to [`pdlc-decide`](pdlc-decide.md) for supersession works because that is a separate act the user chooses to take, not the next step of one they just authorised.
- **Taking the recap as input** — the shape this skill was first designed around, and obsolete before it was written: [ADR-0012](../adr/0012-a-spec-precedes-the-implementation-it-governs.md) replaced the recap with the spec. A message cannot be re-read mid-build, does not survive the session, and is transmissible to nobody.
- **A hook or a pre-commit check enforcing test-first** — rejected: `docs/PRODUCT.md` §5 closes that route, and it would be enforcement on a repository the product does not own. The kit instructs; the discipline holds by agreement, as it does everywhere else here.
- **Having `pdlc-build` write the spec in every case, including under `pdlc-feature`** — rejected: two writers for one record. The record belongs to whichever skill holds the decision, and inside a feature that is `pdlc-feature`.
- **Writing no record at all in standalone use** — rejected, and it was the live alternative: cheaper, and it keeps the skill single-purpose, but it makes whether a decision is recorded depend on which entry point the user happened to choose. That is the accident the routing tests exist to remove.
- **Shipping a per-stack command table** — rejected: it duplicates what `AGENTS.md` states for the repository it runs on, it goes stale silently, and every row would be an example borrowed from somewhere.
- **Leaving the build of an OpenSpec change to OpenSpec's apply command** — rejected: the change would be built with no test read red first and no evidence block, which is what this skill exists to provide.
- **Merging an OpenSpec change's deltas by hand when the CLI is missing** — rejected: it reimplements OpenSpec's archive, and a wrong merge corrupts the specs OpenSpec owns.
- **Never running the OpenSpec CLI, and leaving the archive to the user** — rejected: the archive is the reconciliation, and the kit holds that it happens in the same change as the code.

## Known gaps

| Left out | Add it when |
|---|---|
| Nothing limits how many found tests a unit accumulates, and each costs a pass through the loop | A build is caught padding a unit with tests that add nothing |
| Nothing verifies the test was really written and red first, or that it fits the Behavior line it cites; the evidence block is the agent's own account | The evidence block is caught overstating itself, and a check on a repository the product owns becomes acceptable |
| No rule for a suite too slow to sit inside the loop | A repository is worked on where the targeted run takes minutes rather than seconds |
| No handling of a flaky test, which produces a red that means nothing | A build stops on one and the loop draws the wrong conclusion |
| Concurrency is not addressed: two builds in flight on one clone collide | The isolation skill exists and can own that rule rather than this one restating it |
| Nothing routes a finished build into [`pdlc-review`](pdlc-review.md); reaching it is a step the user takes, by that skill's own decision 1 | Forgetting that step costs more than the automatic gate the kit deliberately did not impose |
| A spec written before the template required a Behavior section has none to cite; the loop derives the lines from its Decisions and states them first | Such a build produces a test that misses what the spec meant |
| The OpenSpec CLI flags are those of its documentation on 2026-11-05; no OpenSpec version is pinned or checked | A CLI release renames or drops `validate --strict` or `archive --yes` |
| A change whose `.openspec.yaml` names another schema than `spec-driven` may have no scenarios or no `tasks.md` | A team using a custom schema runs the skill on a change |
| Nothing has run the skill on a real OpenSpec repository | It is run on one |
