# ADR-0021 — A repository that uses OpenSpec keeps its feature specs in OpenSpec

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-11-05 |
| **Supersedes** | — |

## Context

The kit writes its own feature specs, one living file per feature under `{docs_root}/specs/`. OpenSpec is a spec-driven tool that teams adopt for the same job. It keeps the current specs in `openspec/specs/`, and each piece of work as a change in `openspec/changes/<change>/`: a proposal, a design, delta specs whose requirements carry WHEN/THEN scenarios, and a task list. Archiving a change merges its deltas into the specs and moves it to a dated folder. It ships its own commands to propose, apply and archive a change, and a CLI that validates and archives.

A repository that used OpenSpec could not use the kit without holding two sets of specs. The user wanted the kit's spec writing to give way to OpenSpec in that case.

## Decision

**A repository with an `openspec/` directory at its root keeps its feature specs in OpenSpec, unless its `AGENTS.md` says it keeps the kit's own.** The kit then writes nothing under `{docs_root}/specs/`. `PRODUCT.md`, the ADRs and `AGENTS.md` stay with the kit, because OpenSpec has no equivalent. `skills/_pdlc-shared/openspec.md` maps each part of a kit spec to its place in a change, and is read only in such a repository.

OpenSpec writes the change. `pdlc-feature` asks nothing and names OpenSpec's propose command. `pdlc-build` runs its test-first loop on an open change, with the scenarios as Behavior lines. Its reconciliation is the archive, run with OpenSpec's CLI in the same commit as the code. `pdlc-review`, `pdlc-report` and `pdlc-decide` read the change, and write only in its `design.md`. What the kit records and OpenSpec does not — rejected alternatives, known gaps, the regulated-data question — reaches a change through rules `pdlc-init` offers to add to `openspec/config.yaml`.

The scenarios use OpenSpec's WHEN/THEN form. [ADR-0017](0017-a-spec-states-its-behavior-as-testable-lines.md) rejected that form as a requirement for the kit's own specs; it is not superseded, because it still governs them. In an OpenSpec repository the form is OpenSpec's to set.

The skills run the OpenSpec CLI when it is installed: `validate` before the loop and `archive` at the commit. This adds a third kind of command to those a skill has an agent run, beside git's and the repository's own build commands. It runs only in a repository whose team installed OpenSpec, and the archive only once the user has approved the commit.

## Alternatives weighed

- **The kit writes the change itself, in OpenSpec's format, after its own question round** — rejected: the kit would keep a second implementation of OpenSpec's proposal flow, and follow its format from one release to the next.
- **The kit only reads OpenSpec changes, and `pdlc-feature` writes its own specs as before** — rejected: the repository would still hold two sets of specs.
- **OpenSpec's apply command builds the change** — rejected: the change would be built with no test read red first and no evidence block.
- **A custom OpenSpec schema shipped by the kit, with an artifact for decisions** — rejected: each repository would have to install it, and the kit would follow OpenSpec's schema format. The configuration rules reach the same `design.md`.
- **Detection from a line in `AGENTS.md` only** — rejected: the `openspec/` directory already says it, and a second declaration can disagree with it.
- **Never running the CLI, and leaving validation and archive to the user** — rejected: the archive is the reconciliation, which the kit holds to the same change as the code.

## Consequences

- The kit now follows a tool it does not control. Its folder layout, its artifact names and the CLI flags are those of its documentation on 2026-11-05, and nothing checks them against an installed version.
- A change carries the kit's sections only if OpenSpec follows its configuration rules, and nothing checks that it did. The regulated-data question is asked by OpenSpec's propose flow, if at all.
- Without the CLI, a built change stays open until someone archives it with OpenSpec, so the spec and the code can disagree for a while.
- The AI-notice hook checks `{docs_root}` and `AGENTS.md`, not `openspec/`, and OpenSpec writes no notice. A change drafted by an agent carries no mark of it.
- `pdlc-report` restates the OpenSpec layout in its own file, as it does every rule it needs, so that layout is written in two places in the kit.
- No skill has been run on a repository that uses OpenSpec.
