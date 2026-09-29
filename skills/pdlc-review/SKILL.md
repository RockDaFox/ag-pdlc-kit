---
name: pdlc-review
description: Review a change the way an experienced tech lead would — code quality, the repository's own conventions, correct use of the libraries in play, readability and maintainability for a human, and whether the change stayed inside what its spec authorised. Reports findings graded blocking, to fix and detail, asks which ones to apply, applies only those, then runs the repository's own checks. Invoked on demand, on the uncommitted working tree or on a target given. Use when a change is ready to be looked over before it is committed, or when the user invokes /pdlc-review.
---

# Review a change

A review is worth what it refuses to say. Asked to look at a diff, a model will always find something, and a list that raises everything at equal weight is read once and skipped thereafter. This skill reviews against what the repository has already written down — its conventions, the spec the work was authorised against, the versions of the libraries actually installed — and grades what it finds, so that the reader's decision is which findings to act on rather than which ones to believe.

Read [`doc-discipline.md`](../_pdlc-shared/doc-discipline.md) first: it resolves `{docs_root}` and holds the routing test, which the last step needs. Read [`build-loop.md`](../_pdlc-shared/build-loop.md) later, and only once the user has selected something — that file is what applies the corrections, and a review the user closes without selecting any has no use for it.

This skill is invoked on demand, and nothing calls it automatically: [`pdlc-build`](../pdlc-build/SKILL.md) ends on its own evidence block and its own ask, and a review before that commit is the user's decision to make, not a gate the kit imposes. The relation runs the other way round — a review does not sit inside the loop, it reaches into it once the user has chosen what to correct.

## What is reviewed

The uncommitted working tree by default — staged and unstaged together, which is the state the moment before a commit. A target given instead is honoured: a branch against the trunk, a commit range, a path.

Read the diff in full and read enough of the code around it to judge each change in place. A hunk read as a fragment produces findings about the fragment.

## What it is reviewed against

Four sources, in this order. Name at the start which of them the repository does not have — a review that silently ran on three sources reads exactly like one that ran on four.

**The conventions**, from the code style zone of `AGENTS.md` and from what the surrounding code actually does. Nothing here ships a quality checklist: a bundled one contradicts the repository the day the two disagree, and it goes stale without anyone noticing. Where the repository has written nothing down, say so and review against the surrounding code rather than declining to run.

**The spec that authorised the work**, `{docs_root}/specs/<feature>.md`, on two questions no style guide answers: whether the diff reaches beyond what was authorised, and whether every behavior the spec states has something covering it. Where no spec governs the change, skip this axis and say it was skipped. Never reconstruct a contract from the code in order to have something to compare against — that is how a plausible invented record gets made.

**The libraries the change calls into**, standard and third party alike, judged on what the installed version provides. See below; this is the axis that needs the most care.

**Tech-lead judgement**, where none of the three settles it: whether a human who did not write this will follow it, whether the next change to it will be safe, whether the shape matches what it is doing.

## Libraries

Establish what the installed version provides before judging a call: the dependency manifest and the lockfile for the version in play, then the installed source, type definitions or docstrings the repository already carries, then the library's published documentation for that version where the tree holds nothing readable.

This is where a review is most dangerous. A misremembered API produces the most confident wrong finding a model can emit, and it reads exactly like a grounded one. So every finding of this kind names what it is grounded in, and a finding that cannot be grounded is reported as unverified rather than asserted. Correcting working code into broken code costs more than having said nothing.

The call that fails is the easy case. The one worth looking for is the call that works while ignoring what the library already provides: a helper written by hand that the standard library has, an entry point the installed version deprecates, a resource left to chance where the documented idiom manages it, an option passed that this version quietly ignores.

## Grading

Every finding carries a grade and fits on one line: where it is, what is wrong, what the correction would be.

- **Blocking** — it should not be committed in this state.
- **To fix** — it should change, and the change can wait for a decision.
- **Detail** — it is worth one line and nothing more.

The grade is the bar, not decoration. It forces the question of how much a finding matters to be answered rather than left to the reader, and the one-line budget is what keeps a detail from being argued over a paragraph. A finding that will not fit in one line is one that needs the user's judgement before anything else — grade it accordingly rather than expanding it.

Number the findings so they can be selected by number.

## After the report

Change nothing until the user has answered. This skill reviews; it does not arbitrate.

**Every selected finding enters the build loop, and none is applied beside it.** This skill chooses and sequences; [`build-loop.md`](../_pdlc-shared/build-loop.md) is what changes the code and what proves the change. A correction is a unit of work there exactly as a behavior is: it takes its own pass through that loop's steps 1 to 5, and the closing steps — the repository's lint, typecheck and build, the diff inspected, the evidence block — run once over the whole set. This skill runs no command on its own authority.

What a correction carries decides what its pass holds. One that changes behavior brings a new expected failure with it and takes the pass as written, so it arrives with a test. One that changes no behavior has no failure to state; say so, and what it owes instead is that the tests already covering that code are green afterwards for the same reasons they were before.

Nothing outside the selected findings changes. Anything noticed along the way and not selected is a finding for the next review, not an edit smuggled into a diff the user believes they scoped.

A substantive finding the user declined goes into the governing spec's Known gaps, with the condition that should bring it back. Without a trace it returns at every later review, which is the re-opening of settled questions this kit exists to prevent. Declined details leave nothing behind: a Known gaps table padded with every nit somebody waved off stops being read, and then the gaps that mattered go with it. Where no spec governs the change, write nothing and say so rather than inventing somewhere to put it.

## Finishing

Report the loop's evidence block, then what was declined and where it was recorded. Findings left unverified are named again here, as unverified — that is the state they are in, not a reservation to bury in the body.

This skill commits nothing. The review ends on a working tree, and the commit stays with whoever owns it: `pdlc-build`'s own ask, `pdlc-feature`'s step 7, or the user directly.

Remind the user that the findings and any Known gaps entry written here were AI-drafted and need review before they are treated as authoritative.
