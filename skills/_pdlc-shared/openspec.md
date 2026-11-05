# A repository that uses OpenSpec

Read [`doc-discipline.md`](doc-discipline.md) first: it says when a repository uses OpenSpec. This file holds what a skill needs only in that case.

In such a repository, OpenSpec holds the feature specs. The kit writes nothing under `{docs_root}/specs/`. `PRODUCT.md`, the ADRs and `AGENTS.md` stay with the kit, unchanged. The kit does not install OpenSpec and does not suggest it.

## Where each part of a spec lives

| In the kit's spec | In OpenSpec |
|---|---|
| A spec in `Status: Draft` | An open change, `openspec/changes/<change>/` |
| A Behavior line (B1, B2...) | A scenario of the change's delta specs, cited by requirement and scenario name |
| A proposed Behavior line | A proposed scenario |
| Non-goals | The out-of-scope part of the change's `proposal.md` |
| Decisions, Rejected alternatives, Known gaps, Regulated data | Sections of the change's `design.md` |
| The order of the work | The change's `tasks.md` |
| Reconciliation, and `Status: Shipped` | The archive: the deltas merge into `openspec/specs/`, and the change moves to `openspec/changes/archive/YYYY-MM-DD-<change>/` |
| A shipped spec | `openspec/specs/<capability>/spec.md`, with the `design.md` of each archived change for the reasons |

## Who writes what

- OpenSpec's propose command writes a change. No skill writes a `proposal.md` or a delta spec.
- No skill edits `openspec/specs/`. Those files change only when a change is archived.
- A skill may add to the `design.md` of an open change — a decision, a rejected alternative, a known gap — and tick a finished task in its `tasks.md`.
- A change archived in an earlier commit is history. Nothing writes in it.

OpenSpec's commands are spelled differently on each host. Name the command — explore, propose, archive — and let the user's host spell it.

## The CLI

The CLI is installed when `openspec --version` succeeds. When it is, a skill runs it rather than doing its work by hand:

```
openspec validate <change> --strict --no-interactive
openspec archive <change> --yes
```

When it is not, say so. A change is never archived by hand: merging deltas reimplements OpenSpec, and a wrong merge corrupts the specs it owns. The change stays open until someone archives it with OpenSpec.

## The rules offered to OpenSpec's configuration

OpenSpec adds the rules in `openspec/config.yaml` to the prompt of the artifact they are keyed by. These rules make a change record what the kit records in its own specs. `pdlc-init` offers them; they are written in the repository's documentation language, and added beside any rule already present.

```yaml
rules:
  proposal:
    - Before writing, ask whether the change touches personal, health or payment data. Ask it as a question of fact, not as a judgment about which regime applies.
  specs:
    - Each scenario states one result a test can assert from outside — a return value, an output, a stored record, a response. Never name a function or a call.
    - Cover the empty and error states, and who may trigger what.
  design:
    - Add a "Rejected alternatives" section, one line per option weighed and lost, with the reason it lost.
    - Add a "Known gaps" table with two columns, "Left out" and "Add it when".
    - If the change touches personal, health or payment data, add a "Regulated data" section with five fields — Date, Trigger, Consulted, Decision, Reference. The answer comes from the organisation's data-protection or compliance function, and an unanswered question is recorded as unanswered.
```
