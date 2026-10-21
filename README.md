# Ag-PDLC Kit

The toolbox of a product team working with AI agents: developers, and the
roles that write no code — product owners, delivery leads, designers. It
covers the product development life cycle, of which building the software is
one part. Runs on Claude Code and GitHub Copilot from one set of files, and on
Vibe through the Claude Code manifest.

The skills shipped today serve the software part, for developers and their
coding agent. A coding agent has the code, never the reasons: git history
records what changed, not what was decided or rejected. So settled questions
get re-opened and rejected options get retried. These skills write the reasons
down when they exist and hand them back to the next piece of work. Markdown
only, nothing executable.

## Install

```
/plugin marketplace add git@github.com:RockDaFox/ag-pdlc-kit
/plugin install ag-pdlc-kit@ag-pdlc-kit
```

Start a new session afterwards: skills are discovered at session start.

## Use

These five skills are for developers and run in a coding agent. No skill for
the roles that write no code ships yet.

| Skill | When | You get |
|---|---|---|
| `/pdlc-init` | Once, on a repository that has none of this | `AGENTS.md`, `docs/PRODUCT.md`, and a list of what needs a human |
| `/pdlc-feature <description>` | Building something from a loose description | Questions first, then a spec you approve (reviewed first if you ask), then the code and tests |
| `/pdlc-decide` | A decision that produces no code: a stack, a boundary, reversing an ADR | An ADR, a spec entry, or a line in `AGENTS.md` |
| `/pdlc-build` | A spec, ticket or bug is ready to build | Test-first implementation and an evidence block |
| `/pdlc-review [target]` | Before committing; reviews the code by default, or a spec if you name one or when `/pdlc-feature` offers it after writing the spec, with the exact command | Graded findings; you pick which to apply |

Typical path: `/pdlc-init` once, then `/pdlc-feature` for each feature, then
`/pdlc-review` before the commit. `/pdlc-build` already runs inside
`/pdlc-feature`; call it yourself only when the scope was settled elsewhere.

Generated documents start with an AI-assistance notice. Read the document, then
delete the notice: that is the review.

## What it writes

| File | Answers |
|---|---|
| `AGENTS.md` | How the repo is written — commands, conventions, traps. |
| `docs/PRODUCT.md` | What the product does, and why, as delivered. |
| `docs/adr/` | Structural decisions. Dated, append-only, superseded rather than rewritten. |
| `docs/specs/` | A feature's decisions, rejected alternatives and known gaps. Living. |

The docs root defaults to `docs/`; a repository that uses another says so in
one line of `AGENTS.md`.

## More

- [`docs/PRODUCT.md`](docs/PRODUCT.md) — what the kit does and leaves out.
- [`docs/specs/`](docs/specs/) — what each skill decides.
- [`docs/adr/`](docs/adr/) — why it is built this way.
- Contributing: read [`AGENTS.md`](AGENTS.md), run `sh scripts/check.sh` before
  committing.
