# Spec — pdlc-build

> **Status: Draft** — the work is authorised and not yet shipped. This document becomes `Shipped` when it is reconciled with the skill, in the same change as it.
>
> Living document: any change to the `pdlc-build` skill is reflected here in the same change. Revised 2026-09-16.

## Summary

`pdlc-build` turns a spec into code, tests and an evidence block, test-first. It derives the test list from the behavior the spec states, writes each test, runs it, confirms it fails for the reason stated, implements against that failure, returns to green, then reports what it ran, what it covered and what it left.

It is the first skill of the kit's second family: the other three record what is decided, this one carries out the work a record authorises. Like them it is instruction to the model and ships nothing executable, with one difference that matters — it is the first whose loop expects commands to be run on the repository it is invoked in. `docs/PRODUCT.md` §4 still states that the product runs nothing, carving out only the reading of a repository. That constraint is narrower than the kit's vocation and is being re-decided; **this skill is not shippable until that ADR exists**.

Its input is a spec, never a paraphrase of one: `{docs_root}/specs/<feature>.md` carrying `Status: Draft`, which is what [ADR-0012](../adr/0012-a-spec-precedes-the-implementation-it-governs.md) made available. Two entry points reach the same loop:

- **Inside [`pdlc-feature`](pdlc-feature.md)**, at its step 6, on the spec the go-ahead was just given on. `pdlc-feature` keeps the reconciliation that follows.
- **Standalone**, on a scope settled elsewhere — a `Draft` spec committed in an earlier session, a ticket already specified, a bug with a known cause.

The loop itself lives in `skills/_pdlc-shared/build-loop.md` so that both entry points state it once ([ADR-0010](../adr/0010-shared-reference-split-by-need.md)).

## Decisions

1. **The build loop is a skill, and `pdlc-feature` delegates to it rather than absorbing it.** The loop is identical whether the scope came from a clarification round or arrived already settled, and the second case is common — a ticket, a plan from another session, a bug fix. Folding the loop into `pdlc-feature` would leave that case with no route, or with a route through four steps it has to skip.
2. **Test-first is an ordering requirement, not a recommendation.** An implementer that writes code and then tests is grading its own homework: the test that results confirms what the implementation does, not what the spec asked for. Writing it before the implementation exists to read removes the failure mode structurally instead of asking the agent to resist it. The reason this is firmer for an agent than the same discipline is for a human is the self-reference, not rigour.
3. **The red is read, not merely observed.** A test failing on an import error, a typo or a missing fixture is not exercising the behavior; one failing on a false assertion is. The loop states the failure it expects before running, and a failure for any other reason sends the test back rather than forward into implementation. Without this, the red step reduces to a ritual that any broken file passes.
4. **The spec is the input, read from disk and not from memory.** It is a file, so it is re-readable mid-task, survives the session, and can be picked up by a different agent — which is why it is committed at the go-ahead rather than held in a message. The test list comes from the behavior it states, and its non-goals bind the suite as much as its behavior does: no test beyond what the spec names.
5. **A repository that contradicts the spec stops the build.** A pattern absent where the spec assumed one, an assumption a test disproves: the skill reports the discrepancy and returns for a new go-ahead. It never reconciles a wrong assumption on its own initiative, because a quiet repair is a scope decision taken without a record. This is the counterweight to a spec existing before the code — the spec is a contract under test, not an authority.
6. **It owns no document when it runs inside `pdlc-feature`.** The reconciliation, the ADR and `PRODUCT.md` stay with that skill's step 7. One record, one writer.
7. **Standalone, it routes what the build decided through the three tests.** A build with no `pdlc-feature` around it still produces decisions that constrain later code, and those must not fall on the floor because of which entry point was used. It loads `decision-records.md` in that case only, applies the scope, reversal-cost and lifetime tests, and writes the spec entry or the ADR they select. Where the build decided nothing worth a record, it says so and writes nothing.
8. **Standalone with a `Draft` spec on disk, that spec is the input and the skill reconciles it.** This is the resumed-work case and the handoff case, and it is the reason the draft is committed at all. A `Shipped` spec for the same feature is a different situation: the work is a change to shipped behavior, so the spec is rewritten in place, not drafted again.
9. **Standalone with no spec at all, the scope is restated and confirmed, not re-derived.** The skill states in a few lines what it understands the work to be and waits. It does not open a clarification round: two skills that both interrogate would leave the kit with a weaker `pdlc-feature` that wins by being nearer to hand.
10. **The evidence block is session and pull-request output, never a spec section.** Commands run, their output, which acceptance criterion each test covers, what was left. That is perishable state — a passing count is true for one commit — and the spec records decisions.
11. **It runs the repository's own commands, discovered, never invented.** Test, lint and typecheck commands come from `AGENTS.md` or from the task runner's manifest, with their real flags, which is the rule `pdlc-init` already follows when it writes them down. The skill ships no per-stack command table: it would be an invented example that rots, and this is the one skill where a guessed command does something rather than merely reading wrong.
12. **`pdlc-feature` loads `build-loop.md` at step 6, not at the start.** The clarification round has no use for build instructions, and a session that stops at the go-ahead would have paid for them anyway — ADR-0010's reasoning applied inside a single invocation rather than across skills.

## Behavior

The loop, once a spec is in hand:

1. Derive the test list from the spec — one test per named behavior, none beyond it.
2. For each: state the failure expected, write the test, run it, confirm that failure.
3. Implement against that failure only.
4. Run the targeted tests, then the repository's lint, typecheck and build where they exist.
5. Inspect the diff, then report the evidence block.

Done is not reportable while any of these is missing: each test confirmed red before its implementation existed, the targeted tests green, the repository's own checks run, the diff inspected, and the remaining limitations named. "Tests pass" without the command and its output is a claim, not evidence.

## Rejected alternatives

- **A mode or flag of `pdlc-feature`** — rejected: the standalone entry point never passes through the question round, so the mode would be the skill's most common use and its least natural one. A skill reached by a flag is a skill the user has to know exists.
- **Restating the loop in both skills** — rejected by the repository's own rule: a rule appearing in two skills moves into the reference, because two copies drift.
- **A cross-skill referral — `pdlc-feature` telling the user to invoke `/pdlc-build`** — rejected: it breaks the flow at the one point where continuity is the whole value, immediately after the go-ahead. The existing referral to [`pdlc-decide`](pdlc-decide.md) for supersession works because that is a separate act the user chooses to take, not the next step of one they just authorised.
- **Taking the recap as input** — the shape this skill was first designed around, and obsolete before it was written: [ADR-0012](../adr/0012-a-spec-precedes-the-implementation-it-governs.md) replaced the recap with the spec. A message cannot be re-read mid-build, does not survive the session, and is transmissible to nobody.
- **A hook or a pre-commit check enforcing test-first** — rejected: `docs/PRODUCT.md` §5 closes that route, and it would be enforcement on a repository the product does not own. The kit instructs; the discipline holds by agreement, as it does everywhere else here.
- **Having `pdlc-build` write the spec in every case, including under `pdlc-feature`** — rejected: two writers for one record. The record belongs to whichever skill holds the decision, and inside a feature that is `pdlc-feature`.
- **Writing no record at all in standalone use** — rejected, and it was the live alternative: cheaper, and it keeps the skill single-purpose, but it makes whether a decision is recorded depend on which entry point the user happened to choose. That is the accident the routing tests exist to remove.
- **Shipping a per-stack command table** — rejected: it duplicates what `AGENTS.md` states for the repository it runs on, it goes stale silently, and every row would be an example borrowed from somewhere.

## Known gaps

| Left out | Add it when |
|---|---|
| No route for a repository with no test suite at all — the loop has no red available | Someone runs it on one. The likely answer is to say so and fall back to a stated, executed verification, not to invent a suite |
| No route for a change no test can prove — documentation, a template, this repository itself | The kit gains a skill that edits its own Markdown and finds the loop has nothing to grip |
| Nothing verifies the test was really written and red first; the evidence block is the agent's own account | The evidence block is caught overstating itself, and a check on a repository the product owns becomes acceptable |
| No rule for a suite too slow to sit inside the loop | A repository is worked on where the targeted run takes minutes rather than seconds |
| No handling of a flaky test, which produces a red that means nothing | A build stops on one and the loop draws the wrong conclusion |
| Concurrency is not addressed: two builds in flight on one clone collide | The isolation skill exists and can own that rule rather than this one restating it |
| No handoff to a review step, because no review skill exists | A review skill lands and the evidence block gains a consumer inside the kit |
