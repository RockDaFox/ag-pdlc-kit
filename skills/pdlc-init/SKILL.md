---
name: pdlc-init
description: Bootstrap the Ag-PDLC Kit documentation discipline on an existing repository — writes AGENTS.md and PRODUCT.md by reading the code and the git history, so they describe what is actually delivered rather than what was once intended, and opens an empty decision log that grows from today. Use when a repo has no product document, no specs and no AGENTS.md, or when the user asks to set up, install or initialise Ag-PDLC Kit on a project.
---

# Ag-PDLC Kit init

Documentation written from a repo's code and history describes what was
actually shipped. Documentation written from memory or from an old ticket
describes what someone once intended — and quietly disagrees with the code.
This skill only does the first.

Read [`doc-discipline.md`](../_pdlc-shared/doc-discipline.md) first: it
defines the four levels, which file a given sentence belongs in, and how to
resolve `{docs_root}`. Then
[`state-documents.md`](../_pdlc-shared/state-documents.md), which holds the
convention `AGENTS.md` follows, its 150-line budget, and why `PRODUCT.md` is
descriptive. This skill writes no ADR and no spec, so it needs neither the
routing tests nor the regulated-data record.

## What this skill does not do

**It writes no ADR and no spec.** Those record decisions — what was weighed,
what was rejected, why one option won — and none of that is recoverable from
a repository after the fact. The code shows the surviving choice and nothing
else; reconstructing the debate around it produces a confident, plausible,
invented document, which is worse than an absent one.

So the decision log starts empty and grows forward, from the first decision
taken after installation. What the code does show — the persistence layer, the
runtime, the deployment target, the conventions in force — is **state, not
decision**, and it goes in `AGENTS.md` where state belongs.

## Before writing anything

1. **Survey the repo.** Entry points, directory layout, dependency manifests,
   config, CI, test setup, deployment files.
2. **Read the history.** `git log --oneline`, then the commits behind anything
   that still shapes the code today. Use it to get the conventions and the
   traps right, not to reconstruct decisions.
3. **Take inventory of what already exists.** An existing `README.md`,
   `CLAUDE.md`, `CONTRIBUTING.md`, architecture notes, or docs under another
   path. Establish the documentation language from them.
4. **Settle `{docs_root}`.** `docs/` unless it is already occupied by
   something that is not hand-written project documentation — a published
   site, generated references. In that case propose an alternative and let the
   user pick, then record the choice in `AGENTS.md`. Do not create a config
   file for it.
5. **Never overwrite.** If `AGENTS.md` or a product document already exists —
   under any name, `PRD.md` included — read it, propose a merge, and let the
   user decide. Existing prose is evidence, not clutter. An `AGENTS.md`
   written as an agent contract is a particular case, handled below.

## When `AGENTS.md` already exists as an agent contract

A repository may already carry an `AGENTS.md` shaped as a behavioral contract
rather than as a guide to the codebase: sections named Mission, Scope,
Completion, Evidence, Human gates. Recognise it by those headings, and treat
it as **the other half of the same file, not a competing version of it**.

The convention's six zones split cleanly between the two shapes. A contract
usually holds the role statement, testing, git and boundaries; what this skill
derives from the code holds commands, structure, style and traps. Neither is
complete alone. So merge, into the section order of
[`../_pdlc-shared/templates/AGENTS.md`](../_pdlc-shared/templates/AGENTS.md),
and keep every rule the contract states — those were written to be opposable,
which is a reason to preserve the wording rather than paraphrase it.

Three things do not survive the merge unchanged, and the user arbitrates each:

- **A pull-request body shape** — an Evidence section, a Completion
  checklist. Propose moving it to a pull-request template and leaving one line
  under Boundaries. Never silently drop it: if the user declines, it stays.
- **Process governance** — gate staffing, metric definitions, escalation
  routing. Propose the same move, to wherever the repository keeps process.
- **Anything over the 150-line budget once merged.** Report the line count,
  and propose the nested-file split — per-stack rules into an `AGENTS.md`
  beside the code they govern — rather than cutting rules. If the user decides
  the budget loses to keeping the contract whole, record that in the merged
  file in one line, so the next reader knows it was decided and not forgotten.

The repository may also hold path-scoped instruction files — Copilot's
`.github/instructions/*.instructions.md` is the common case. Those are the
same mechanism as a nested `AGENTS.md`, in one host's dialect. Leave them
alone: they work, and converting them is a decision for their owner, not a
side effect of running this skill. Say they were found.

## What to create

Use the templates in [`../_pdlc-shared/templates/`](../_pdlc-shared/templates/),
translated into the repo's documentation language, with `{docs_root}` resolved
to its real path.

**`AGENTS.md`** at the repo root — the highest-value file, write it first. How
this repo is written: the real commands (from the task runner's manifest, not
guessed), the architecture in a paragraph, the code style the code actually
exhibits, and every trap the history shows someone already hit. A rule you
cannot point at evidence for does not go in. Its Documentation section names
`{docs_root}`, says what each level holds, and states that the decision log
starts from the Ag-PDLC Kit installation.

Keep to the template's section order and to the 150-line budget — both come
from the cross-vendor convention, stated once in `state-documents.md`.
Report the line count at the end. A repository with several stacks gets
repo-wide rules at the root and per-stack rules in a nested `AGENTS.md`; do
not let one root file carry every stack in the tree.

**`{docs_root}/PRODUCT.md`** — what the product does and why, as delivered.
Present indicative throughout. State the implementation status honestly,
including features that exist but were never in any plan, and the scope
deliberately left out. If the repository already holds product *requirements*
under any name, they stay where they are: this document describes the system
that exists, and does not absorb a backlog.

**Nothing else.** `{docs_root}/adr/` and `{docs_root}/specs/` are not created
empty: the first ADR and the first spec create them, on the day there is
something true to put in them.

## Finishing

Report what was created, and — separately — what could not be established from
the code and history and needs a human: the intent behind an odd constraint,
the reason behind a workaround, anything in `AGENTS.md` written from inference
rather than evidence. That list is the honest output of this skill, not a
failure.

Say plainly that the decision log is empty by design, and that the first ADR
or spec arrives with the next piece of work — through `pdlc-feature`, or by
hand.

Remind the user that these documents were AI-drafted from the repo and need
review before they are treated as authoritative or shared outside the team.
