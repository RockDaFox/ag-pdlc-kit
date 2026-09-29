# Spec — pdlc-review

> **Status: Draft**
>
> Living document: any change to the `pdlc-review` skill is reflected here in the same change. Revised 2026-09-29.

## Summary

`pdlc-review` reads a diff and reports what an experienced tech lead would raise on it: code quality, respect of the repository's conventions, correct use of the libraries it leans on, and whether the result is readable and maintainable by a human. Conformance to the spec that authorised the work is one axis of that review, not the whole of it. It reports graded findings, asks which ones to apply, applies only those, then runs the repository's own checks to confirm the corrections broke nothing.

It is the second skill of the kit's second family: the other three record what is decided, [`pdlc-build`](pdlc-build.md) carries out the work a record authorises, and this one holds the result to a standard before it is committed. It closes that skill's last known gap — "no handoff to a review step, because no review skill exists" — and gives the evidence block a consumer inside the kit.

What makes it a kit skill rather than one more generic reviewer is that it reviews against things the repository has written down, not against a checklist it carries: the code style zone of `AGENTS.md` for the conventions, `{docs_root}/specs/<feature>.md` for the scope the work was authorised against, and the dependency versions actually present in the tree for how a library is meant to be used. Tech-lead judgement applies where none of them settles the question. This closes a chain the kit already half-had: `pdlc-init` writes the conventions down, and this skill holds the code to them.

An ADR looks warranted: [ADR-0014](../adr/0014-a-skill-may-run-discovered-repository-commands.md) scopes the discovered-command permission to `pdlc-build` and to `pdlc-feature`'s step 6, and decision 8 below widens it to a third skill. It is not written yet — it belongs at reconciliation, once the build confirms the shape.

## Decisions

1. **It is a skill invoked on demand, not a step inside the build loop.** A tech-lead review carries its own method — what to read, in what order, what to raise and above all what to let go — which is more than a paragraph appended to [`build-loop.md`](../../skills/_pdlc-shared/build-loop.md) can hold. On demand also keeps it usable on a diff no `pdlc-build` produced: a branch from another session, a colleague's work, a change made by hand. Wiring it into the loop would run it on every build, which is the blocking pre-commit check `docs/PRODUCT.md` §5 rules out in spirit even where it is not literally a hook.
2. **It reviews against what the repository has written down, not against a shipped checklist.** The conventions come from the code style zone of `AGENTS.md` and from what the surrounding code actually does. A bundled quality checklist would be an invented example that rots and that contradicts the host repository the day the two disagree — the same reason `pdlc-build` ships no per-stack command table. Where the repository has written nothing down, the review says so and falls back to the surrounding code, rather than refusing to run.
3. **Spec conformance is one axis, not the review.** The spec answers two questions no style guide can: does the diff go beyond what was authorised, and does every behavior it states have something covering it. Where no spec governs the diff, that axis is skipped and stated as skipped — the skill never reconstructs a contract from the code in order to have something to compare against, which is the mechanism that produces a plausible invented record.
4. **Library use is reviewed against the version actually in the tree, never against the model's memory of the API.** Standard library and third party alike: a call is judged on the signature, the contract and the idiom the installed version documents — read from the dependency manifest and lockfile, then from the installed source, type definitions or docstrings the repository already carries, and from the library's published documentation for that version where the tree holds nothing readable. This axis is where a review is most dangerous, because a misremembered API produces the most confident wrong finding a model can emit; so every finding of this kind names what it is grounded in, and anything that cannot be grounded is reported as unverified rather than asserted. The finding to look for is not only the call that fails — it is the one that works while ignoring what the library provides: a hand-rolled helper the standard library already has, a deprecated entry point, a resource left unclosed where the documented idiom manages it, an option passed that the installed version silently ignores.
5. **The default target is the uncommitted working tree, and an explicit target is accepted.** Staged and unstaged changes together, because the skill's first use is the moment before a commit. A branch against the trunk, a commit range or a path is accepted as an argument, because the on-demand shape is worth nothing if it only reaches work that has not been committed yet.
6. **Findings are graded — blocking, to fix, detail — and each one is a single line.** The risk this skill carries is noise, not blindness: a model asked to review always finds something to say. The grade forces it to state how much a finding matters instead of listing everything at equal weight, and the one-line budget — location, problem, proposed correction — stops a detail from being argued over a paragraph. A finding that cannot be stated in one line is a finding that needs the user's judgement before anything else, and it is graded accordingly rather than expanded.
7. **It reports first and changes nothing until the user has chosen.** Same shape as [`pdlc-decide`](pdlc-decide.md): the skill reviews, it does not arbitrate. The user answers with the findings they want applied, and only those are applied — no opportunistic cleanup picked up along the way, which would put unreviewed edits in a diff the user believes they scoped.
8. **It runs the repository's own checks after applying.** A readability correction can break a test, and a review that hands back an unverified tree has moved the problem rather than solved it. The test, lint and typecheck commands are discovered from `AGENTS.md` or the task runner's manifest and never invented, exactly as `build-loop.md` states. This is the point that needs ADR-0014 widened.
9. **A substantive finding the user declines is recorded in the governing spec's Known gaps.** A declined finding is a decision, and without a trace it resurfaces at every later review — the "settled questions get re-opened" failure the kit exists to prevent. The limit is substance: a declined detail leaves nothing behind, because a spec padded with every nit somebody waved off is worse than one with a gap in it. Where no spec governs the diff, nothing is written and the skill says so rather than inventing a place to put it.
10. **It commits nothing.** The review ends on a working tree, and the commit stays with whoever owns it — `pdlc-build`'s own ask, `pdlc-feature`'s step 7, or the user directly. Two writers for one commit is the failure that decision 6 of `pdlc-build` already names for records.

## Behavior

1. Resolve the target: the uncommitted working tree, or the branch, range or path given.
2. Read the sources of truth — the code style zone of `AGENTS.md`, the spec governing the change if one exists, the dependency manifest and lockfile for the versions in play, and the code around the diff. Name which of them were missing.
3. Read the diff in full, with enough surrounding code to judge it in place rather than as fragments.
4. For every library the diff calls into, establish what the installed version actually provides before judging the call.
5. Report the findings, graded and one line each, numbered so they can be selected, with anything unverified marked as such.
6. Ask which to apply. Nothing is edited before the answer.
7. Apply the selected findings, and nothing else.
8. Run the repository's discovered checks, and report what ran.
9. Record the declined substantive findings in the governing spec's Known gaps, where one exists.
10. Close on what was applied, what the checks returned, and what was declined and where it went.

A review is not reportable as done while the target is unstated, the missing sources of truth unnamed, a library finding left ungrounded without being marked, or the checks unrun after an edit.

## Rejected alternatives

- **A step inside `build-loop.md`, before the commit ask** — the first shape considered, and rejected on two counts: it would run on every build whether or not the diff warrants it, and it would leave the review unreachable on any diff that did not come from a `pdlc-build`, which is most of them.
- **Relying on the host's generic review tooling** — rejected: it reviews a diff against general good practice, which is real value but not this one. It knows nothing of this repository's `AGENTS.md`, nothing of the spec that authorised the change, and nothing about which version of a library is installed — and those written sources are the whole reason this skill belongs in the kit.
- **Judging library use from the model's own knowledge of the API** — rejected, and it is the cheap version of decision 4: it reads identically to a grounded finding, it is wrong exactly on the libraries that moved between versions, and a review that confidently corrects working code into broken code costs more than no review at all.
- **Applying the obvious corrections first and showing the result** — rejected: a reviewer that edits before being asked is not a reviewer, and the user would be reading a diff they did not scope in order to find out what was done to it.
- **A hook or a blocking pre-commit gate** — rejected: `docs/PRODUCT.md` §5 closes that route outright, and it would be enforcement on a repository the product does not own.
- **Shipping a language-specific quality checklist with the skill** — rejected for the reason `pdlc-build` gives for not shipping a command table: every row would be an example borrowed from somewhere, and it goes stale silently against the repository it is supposed to serve.
- **Grouping findings by axis — spec, conventions, libraries, readability — instead of grading them** — rejected: the grouping tells the reader where a finding came from, and the decision in front of them is whether it matters enough to fix. Severity answers that question and the axis does not.
- **Recording every declined finding, details included** — rejected: it converts a review into a backlog and turns Known gaps into the noisiest section of every spec, which is how a section stops being read.
- **Writing the review itself into the spec as a record of what was inspected** — rejected: that is perishable state, true of one commit, and the same reason `pdlc-build`'s evidence block is session output rather than a spec section.

## Known gaps

| Left out | Add it when |
|---|---|
| Nothing calibrates the grades; "blocking" is the agent's own judgement, with no stated test behind it | A review is caught grading a detail as blocking, or waving through something that should have stopped a commit, often enough that a test would help |
| A library whose documentation is neither in the tree nor reachable leaves its axis unverifiable, and the review can only say so | That case is common enough on a stack actually worked on that a stated fallback beats repeating "unverified" |
| Nothing checks that the installed version is the one the running code resolves to, so a lockfile disagreeing with what is installed misleads the review | A review is misled by that gap rather than by an ordinary mistake |
| No rule for a diff too large to review in one pass | A review is run on a diff where the finding list stops being actionable, and the skill needs to say so rather than truncate silently |
| The review runs in the session's own context, so the conversation that produced the code can soften it | Running it in a fresh subagent is available on both hosts, and the isolation is shown to change the findings |
| A finding that contradicts `AGENTS.md` itself — a convention the code has collectively outgrown — has no route | That case occurs, and the referral to [`pdlc-decide`](pdlc-decide.md) is worth stating rather than leaving the review to argue with the document |
| Declined findings go unrecorded whenever no spec governs the diff, which is the common standalone case | A place to put them exists that is not a spec, and is not a backlog the kit would then have to own |
