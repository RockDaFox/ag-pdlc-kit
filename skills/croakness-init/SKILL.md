---
name: croakness-init
description: Bootstrap the Croakness documentation discipline on an existing repository — writes AGENTS.md and a PRD by reading the code and the git history, so they describe what is actually delivered rather than what was once intended, and opens an empty decision log that grows from today. Use when a repo has no PRD, no specs and no AGENTS.md, or when the user asks to set up, install or initialise Croakness on a project.
---

# Croakness init

Documentation written from a repo's code and history describes what was
actually shipped. Documentation written from memory or from an old ticket
describes what someone once intended — and quietly disagrees with the code.
This skill only does the first.

Read [`doc-discipline.md`](../_croakness-shared/doc-discipline.md) first: it
defines the four levels, which file a given sentence belongs in, and how to
resolve `{docs_root}`.

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
5. **Never overwrite.** If `AGENTS.md` or a PRD already exists, read it,
   propose a merge, and let the user decide. Existing prose is evidence, not
   clutter.

## What to create

Use the templates in [`../_croakness-shared/templates/`](../_croakness-shared/templates/),
translated into the repo's documentation language, with `{docs_root}` resolved
to its real path.

**`AGENTS.md`** at the repo root — the highest-value file, write it first. How
this repo is written: the real commands (from the task runner's manifest, not
guessed), the architecture in a paragraph, the code style the code actually
exhibits, and every trap the history shows someone already hit. A rule you
cannot point at evidence for does not go in. Its Documentation section names
`{docs_root}`, says what each level holds, and states that the decision log
starts from the Croakness installation.

**`{docs_root}/PRD.md`** — what the product does and why, as delivered. State
the implementation status honestly, including features that exist but were
never in any plan, and the scope deliberately left out.

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
or spec arrives with the next piece of work — through `new-feature`, or by
hand.

Remind the user that these documents were AI-drafted from the repo and need
review before they are treated as authoritative or shared outside the team.
