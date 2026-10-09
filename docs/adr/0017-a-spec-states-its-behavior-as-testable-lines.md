# ADR-0017 — A spec states its behavior as numbered lines a test can assert

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-10-09 |
| **Supersedes** | — |

## Context

[ADR-0012](0012-a-spec-precedes-the-implementation-it-governs.md) made the spec the input of the build, and `build-loop.md` derives one test per behavior the spec names. The spec template did not say where those behaviors are. Its Behavior section was optional, written for what a reader cannot infer, and dropped when the Decisions covered it. A Decision is a rule with its reason, so the loop had to derive tests from sentences that were never written to be tested.

The loop checks that a test is inside the spec's scope and that it fails for the reason stated. Neither check says whether the test asserts what the spec asked for. A test can fail cleanly, and still check an internal call or a mock's own answer. The loop's evidence block also reported "which acceptance criterion" each test covers, and no section of the spec defines one.

The agent that writes the tests is also the one that judges them, which [`docs/specs/pdlc-build.md`](../specs/pdlc-build.md) decision 2 already names as the weak point of test-first for an agent.

## Decision

**The spec's Behavior section is part of every spec, and each line in it is numbered and observable.** A line gives a trigger and a result a test can assert from outside: a return value, an output, a stored record, a response. Empty and error states are lines too. A decision with nothing to observe has no line.

**The build loop starts from those lines and does not stop at them.** Each unit of work cites one line before its test is written, and the agent adds the tests it finds worth having around it — a boundary, an empty input, a failing dependency — each citing the line it extends and marked as found. A found test whose result the line implies is implemented. One whose result the spec leaves open is reported as a proposed Behavior line and not decided. the test asserts the result that line states, and a mock's own answer does not count. The evidence block gives one row per line with its test, so a line with no test and a test with no line are both visible. A spec written before this decision has no numbered lines, and the loop states the results it reads from its Decisions before the first test.

The user's go-ahead on the spec now covers what will be tested. That is the one review of the tests' relevance that happens before they exist, and by someone other than their author.

## Alternatives weighed

- **A `tdd` skill called from the build loop** — rejected: it would restate a loop that already is test-first, which the repository's rule against stating one rule in two places forbids, and a skill calling a skill has no mechanism in the kit. The agent that writes the test would still judge it.
- **A separate Acceptance section next to Behavior** — rejected: the two would overlap, and a rule stated twice in one spec drifts the way it does between two skills.
- **Limiting the build to the lines the spec lists** — rejected: a spec cannot name every case worth a test, and the build would test only what its author thought of.
- **Given/When/Then as the required form** — rejected: it fixes a syntax for a result that one line states, and lengthens a spec held to 500 lines.
- **Leaving Behavior optional and having the loop infer the results from the Decisions** — rejected: the inference is made by the agent that then writes the tests against it, which is the grading of its own work the loop exists to remove.

## Consequences

- Found tests are the agent's own choice, so their relevance is judged by the same agent that writes them. They are marked in the evidence block so a reader can see them, and nothing caps their number.
- A spec carries more lines, within the 500 the kit already allows.
- The loop still relies on the agent's own judgement of whether a test fits the line it cites. This decision makes the link visible and puts the lines under the user's review; it does not verify the link. `pdlc-review` reads the tests against the lines when it is invoked, by an agent that did not write them, and nothing makes the user invoke it.
- The five specs already in this repository keep their current Behavior sections, written for another purpose. They are rewritten into the new form when their skill next changes, not before.
- A behavior that cannot be observed from outside, such as a refactoring or a reorganisation of files, has no line. The loop already treats a correction that changes no behavior as having no test, and that is unchanged.
