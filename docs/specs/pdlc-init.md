# Spec — pdlc-init

> **Status: Shipped**
>
> Living document: any change to the `pdlc-init` skill is reflected here in
> the same change. Revised 2026-10-21.

## Summary

`pdlc-init` installs the four-level discipline on a repository that has
none. It surveys the code, reads the git history, settles the documentation
root, then writes two files: `AGENTS.md` and `PRODUCT.md`. It writes no ADR
and no spec — the decision log starts empty and grows forward
([ADR-0004](../adr/0004-decision-records-are-written-forward.md)). It
finishes by naming what it could not establish.

It runs once per repository. Keeping the documents alive afterwards is
[`pdlc-feature`](pdlc-feature.md)'s job.

It also offers a pre-commit hook, installed only if the user agrees. The hook
refuses a commit that adds an AI-assistance notice to a document, so a
document an agent drafted cannot be committed before a human has read it and
removed the notice. On a repository already initialised, the hook is the only
thing it offers.

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
9. **`AGENTS.md` is written to the cross-vendor convention** — six zones in
   its order, a role statement, 150 lines
   ([ADR-0007](../adr/0007-agents-md-follows-the-cross-vendor-convention.md)).
   The line count is measured with `wc -l`, never estimated, and reported; a
   multi-stack repository gets the nested split rather than one long root
   file.
10. **An existing `AGENTS.md` shaped as an agent contract is merged, not
    arbitrated against.** The two shapes cover complementary halves of the
    convention's six zones, so the merge keeps both, in the template's order,
    preserving the contract's wording. A pull-request body shape and process
    governance are proposed a destination instead of being absorbed; the user
    decides, and a declined proposal leaves the content where it was.
11. **Path-scoped instruction files found in the repository are left alone.**
    They are the nested-`AGENTS.md` mechanism in one host's dialect, they
    work, and converting them belongs to their owner rather than to a
    bootstrap run. Their presence is reported.
12. **It loads two reference files, not the whole discipline.**
    `doc-discipline.md` and
    [`state-documents.md`](../../skills/_pdlc-shared/state-documents.md). It
    writes no ADR and no spec, so it needs neither the routing tests nor the
    regulated-data record, and the skill says so rather than leaving the
    omission to be read as an oversight
    ([ADR-0010](../adr/0010-shared-reference-split-by-need.md)).

13. **The hook is offered, never installed by default.** It changes how
    every commit in the clone behaves, so the user says yes first. It is the
    one file the product installs that runs on a repository it documents.
14. **The hook looks for a fixed marker, `<!-- ai-draft -->`, not for the
    notice's wording.** The notice is translated with the document, and the
    marker is not. Every template carries the marker on the line above the
    notice.
15. **It checks only the lines a commit adds, in files under `{docs_root}`
    and in `AGENTS.md`.** An ADR committed with its notice keeps it
    ([ADR-0013](../adr/0013-notice-removed-by-the-review-before-commit.md)),
    and editing its `Status` row must still be possible. Outside those files
    the marker may appear for another reason.
16. **The check is one POSIX sh script shipped in `skills/_pdlc-shared/`,
    copied into the clone's git directory and called from
    `.git/hooks/pre-commit`.** Nothing is versioned and no git setting is
    changed. Each clone installs it for itself. It also runs by hand on a
    project repository, and it checks the AI notice and nothing else. The
    kit's own `scripts/check.sh` stays maintainer tooling for this repository
    ([ADR-0008](../adr/0008-one-maintainer-side-check-script.md)).
17. **An existing pre-commit hook gets the call added, right after its
    shebang, or as its first line when it has none.** An `exit` or `exec`
    further down cannot skip it there. A hook with no shebang is run by git
    with sh, and hook managers write such files. When
    `core.hooksPath` is set, as hook managers do, the hook edited is the one
    in that path. A hook that is not a shell script is not edited: the skill
    shows the command it has to run, and writes nothing.
18. **The call does nothing when the check file is missing.** A hook in a
    versioned directory reaches every clone, and a clone that never installed
    the check must still commit.
19. **The install is the bundled script run with `--install`, and it makes
    the hook it creates executable.** Git ignores a hook that is not
    executable. An existing hook keeps its mode: making a disabled hook
    executable would turn on code its owner had switched off. Running this
    script is the one command a skill runs outside git and the build loop
    ([ADR-0019](../adr/0019-the-kit-ships-one-check-that-runs-on-a-documented-repository.md)).
20. **No skill removes the notice or the marker itself.** When the hook
    refuses a commit a skill was making, the skill reports it and waits for
    the human. Removing them is the human's review.
21. **`git commit --no-verify` still goes through, and the install says so.**
    Git offers no way to forbid it. The hook makes forgetting the review
    impossible, not deciding to skip it.

## Behavior

The lines below cover the hook only.

- **B1** — At the end of a first run, or on a repository already initialised:
  the skill asks whether to install the hook, and writes nothing about it
  before a yes.
- **B2** — The user says no: no file under the git directory changes.
- **B3** — Yes, and no pre-commit hook exists: the clone gets the check file
  and a pre-commit hook that calls it, both executable.
- **B4** — Yes, and a pre-commit shell hook exists: the call is added right
  after its shebang, or as its first line when it has none, and the rest of
  the hook is unchanged byte for byte.
- **B5** — Yes, and `core.hooksPath` is set: the pre-commit hook in that path
  is the one created or edited.
- **B6** — Yes, and the existing hook is not a shell script: nothing is
  written, and the skill shows the file to copy and the command the hook
  has to run.
- **B7** — Yes, and the hook already calls the check: nothing is added twice,
  and the skill says the hook is already installed.
- **B8** — A commit adds a line holding `<!-- ai-draft -->` to a file under
  `{docs_root}` or to `AGENTS.md`: the commit is refused, and the message
  names each file and says the notice has to be read and removed first.
- **B9** — A commit edits a file that already held the marker, without
  adding a line holding it: the commit goes through.
- **B10** — A commit adds the marker to a file outside `{docs_root}` and
  `AGENTS.md`: the commit goes through.
- **B11** — The pre-commit hook runs in a clone where the check file is
  missing: the commit goes through.
- **B12** — After installing: the skill states the files written or edited,
  and that `git commit --no-verify` bypasses the hook.
- **B13** — A skill's commit is refused by the hook: the skill reports the
  refusal and the files named, removes nothing, and waits.
- **B14** — The check is run by hand at the root of a project repository: it
  names each file under `{docs_root}` or `AGENTS.md` where a line not yet
  committed holds the marker — staged, unstaged or in a new file — and exits
  with an error. With none, it says so and exits cleanly.
- **B15** — The check is run outside a git repository: it says so and exits
  with an error, without reading any file.

## Rejected alternatives

- **Installing the hook by hand from instructions** — rejected by the user:
  `pdlc-init` installs it, with consent.
- **A dedicated skill for the hook** — rejected by the user in favour of
  `pdlc-init`.
- **A versioned hooks directory with `core.hooksPath`** — rejected: it turns
  off every hook in `.git/hooks`, and collides with hook managers that set
  the same option.
- **Leaving an existing hook alone and showing the line to add** — rejected
  by the user in favour of adding the call. It is kept for a hook that is not
  a shell script.
- **Matching the notice's English wording, and never translating it** —
  rejected by the user: the notice is translated with the document, and a
  fixed marker carries the check.
- **The agent writing the hook files itself, following the skill's
  instructions** — the shape this spec was drafted around, and replaced
  during the build by the bundled script run with `--install`. Each edge
  case of an existing hook would otherwise be settled by the model's
  judgement on every install.
- **Inserting the call after the first line of every hook** — drafted, and
  changed during the build: a hook with no shebang starts with a command, so
  the call goes before it.
- **`chmod +x` on every file the install touches** — drafted, and narrowed
  during the build to the hook it creates: the check is run with `sh`, and an
  existing hook that is not executable was switched off by its owner.
- **Appending the call at the end of an existing hook** — rejected: an
  `exit` or `exec` earlier in the hook skips it silently.
- **Running the kit's `scripts/check.sh` on a project repository** —
  rejected: its other checks are about the kit itself, its manifests and its
  skills, and a project repository needs the notice check alone.
- **Checking links, headings and the ADR log on a project repository too** —
  rejected by the user: the notice is the one check wanted there.
- **The hook refusing a commit on every finding, a dead link included** —
  rejected: an urgent code commit should not wait on a documentation detail.
- **Checking every line of every staged file** — rejected: an ADR committed
  with its notice keeps it, so any later edit to it would be refused.

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
- **Treating an existing agent contract as a competing `AGENTS.md` and asking
  the user to pick one** — rejected in
  [ADR-0007](../adr/0007-agents-md-follows-the-cross-vendor-convention.md):
  whichever the user picks, the zones the other one covered are lost, and the
  question is unanswerable as asked because both are incomplete.
- **Converting path-scoped instruction files into nested `AGENTS.md` files
  automatically** — rejected: it is a host migration disguised as a
  documentation bootstrap, and it breaks the tooling that reads them without
  anything in this skill's remit to justify it.

## Known gaps

| Left out | Add it when |
|---|---|
| No strategy for a repository too large to survey in one pass | A monorepo is attempted and the survey step runs out of context |
| Assumes git; a repository without history yields a thinner `AGENTS.md` | A target project uses another VCS, or none |
| No refresh mode for a repository where Ag-PDLC Kit already ran | The documents have drifted enough that re-deriving beats editing |
| No migration for a repository initialised at 0.1.0, whose product document is named `PRD.md` | A repository on the old name asks for it. The skill treats the file as existing prose and proposes a merge, but never renames it |
| No check that the merged `AGENTS.md` follows the section order it was written to | Section order is judgment, so a check would need a model reading the file, not a command. The line budget is no longer a gap: it is measured with `wc -l` ([ADR-0008](../adr/0008-one-maintainer-side-check-script.md) draws the line between a command an agent runs and a file the product ships) |
| A clone without the hook commits a notice unchecked; the hook is per clone | A notice reaches a shared branch from a clone that never installed the hook |
| No automated test covers the script, at the user's request; it was tried by hand once, in throwaway repositories | A change to the script breaks a case that trial covered |
| A document that quotes the marker as text is refused like a notice | A spec or `AGENTS.md` needs to mention the marker literally |
| A hook manager that rewrites its hook file drops the added call | A manager is met that regenerates the hook on install |
| No removal or update path for the hook | The check changes, or a user asks to remove it |
| Contract recognition is by section heading, so a contract naming those sections differently is merged as ordinary prose | A real repository is met whose contract headings do not match |
