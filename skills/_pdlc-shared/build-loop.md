# The build loop

Read [`doc-discipline.md`](doc-discipline.md) first: `{docs_root}` and the
routing test. This loop's only input is a spec already on disk —
`{docs_root}/specs/<feature>.md`, carrying `Status: Draft` — read fresh each
time it is needed, never from a paraphrase held in the conversation: a file
survives the session and is re-readable mid-task; a message is neither.

Two callers reach this same loop: [`pdlc-build`](../pdlc-build/SKILL.md),
standalone, and [`pdlc-feature`](../pdlc-feature/SKILL.md), at its own step 6,
on the spec the go-ahead was just given on. Whichever decisions the build
itself produces still need routing — read
[`decision-records.md`](decision-records.md) too, unless the caller already
carries it.

## The commands

Test, lint, typecheck and build commands come from the repository being
worked on, discovered and never invented: `AGENTS.md` if it names them,
otherwise the task runner's manifest, with their real flags. No stack gets a
guessed example here: a wrong guess in this one place executes something,
rather than merely reading wrong.

A repository with no test suite gives the loop nothing to run. Say so, and
fall back to a stated, executed verification — the build, a lint pass, a
manual check named as exactly that — rather than inventing a suite. A red
step that ran no command is not reportable as one.

## The loop

For each behavior the spec names, in the order the spec states it:

1. **State the failure expected**, in one line, before writing anything: what
   assertion is expected to fail, and why. "Something breaks" is not a stated
   failure.
2. **Write the test** for that behavior only — none beyond what the spec
   names, and nothing inside its non-goals.
3. **Run it, and read why it failed.** A red for the reason just stated
   clears this step. A red from an import error, a typo, or a missing fixture
   is not exercising the behavior; fix the test and run it again rather than
   moving on with a false red.
4. **Implement against that failure, and nothing else.** A change the failing
   test does not require is scope the spec did not authorise.
5. **Run the test again and confirm it is green for the reason implemented** —
   not because it was weakened, not because an unrelated change happened to
   satisfy it.

Steps 1–5 are performed, not narrated — see below.

Once every behavior has cleared its own pass through 1–5:

6. **Run the repository's lint, typecheck and build commands**, where they
   exist, over the whole change.
7. **Inspect the diff.** Anything in it beyond what the spec's behaviors
   required is either removed or is a discrepancy — see below.
8. **Report the evidence block.**

## What is said while the loop runs

Nothing, ordinarily. A test that fails before its implementation exists is
the loop working as designed, and a line announcing it — or announcing which
file is about to be written next — spends output on the one outcome that was
expected. The failure expected at step 1 is stated in the test's own name and
assertion, where it is re-readable; the red and its reason reach the user
once, in the evidence block, as evidence rather than commentary.

Mid-loop, a surprise is worth a line and nothing else is: a red for a reason
other than the one expected, a repository that contradicts the spec, a
command that does not exist. Progress through 1–5 is read from the diff and
the evidence block, not from a running account of it.

## A repository that contradicts the spec

A pattern the spec assumed and the repository does not have; an assumption a
test disproves; a behavior unreachable the way the spec describes it: stop.
State the discrepancy in one line — what the spec assumed, what the
repository shows instead — and return for a new go-ahead rather than
reconciling it. A quiet repair is a scope decision taken on the loop's own
initiative; the spec is a contract under test here, not an authority that
overrides what a test just showed.

## Evidence block

Session and pull-request output, never a spec section: a passing count is
true for one commit, and a spec records decisions, not state. For each
behavior — the command run, its result, and which acceptance criterion it
covers. Then the repository's lint, typecheck and build output. Then what was
left: a non-goal reached, a gap the spec already names, anything a
discrepancy above returned for.

Done is not reportable while any of this is missing: every test read red
before its implementation existed, the targeted tests green, the repository's
own checks run, the diff inspected, the remaining limitations named. "Tests
pass" without the command and its output is a claim, not evidence.
