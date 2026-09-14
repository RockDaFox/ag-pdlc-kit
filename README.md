# Croakness

A documentation discipline for code repositories, plus the skills that keep it
alive. Runs on Claude Code and GitHub Copilot from one set of files.

A coding agent has the code, never the reasons. Git history records what
changed, not what was decided nor what was rejected. So settled questions get
re-opened, rejected options get retried, and deliberately fixed bugs come
back. Croakness writes the reasons down, at the moment they exist.

## Four levels, each stating a thing once

| File | Answers |
|---|---|
| `AGENTS.md` | How this repo is written — commands, conventions, traps. |
| `docs/PRD.md` | What the product does, and why. |
| `docs/adr/` | Structural technical decisions. Dated, append-only, superseded rather than rewritten. |
| `docs/specs/` | A feature's decisions, its rejected alternatives, its known gaps. Living. |

The documentation root defaults to `docs/` and can be anywhere — a repository
that deviates says so in one line of `AGENTS.md`. There is no config file.

## Install

Same command on both hosts, each reading its own manifest from this
repository:

```
/plugin marketplace add git@github.com:RockDaFox/croakness
/plugin install croakness@croakness
```

Other hosts that read the same `SKILL.md` format will probably work from the
`skills/` directory. None has been tested, so none is claimed.

## Use

**`/croakness-init`** — on a repository that has none of this. Reads the code
and the git history, writes `AGENTS.md` and the PRD from what is actually
delivered, and reports what it could not establish and needs a human. Run
once.

It writes no ADR and no spec, and that is the point. A repository preserves
the choice that survived and destroys the alternatives, so any decision record
derived from it would be invention wearing the same clothes as the real thing.
The decision log starts empty and grows forward.

**`/new-feature <description>`** — for the work afterwards. Surfaces the open
questions before any code, recaps scope, waits for a go-ahead, implements,
then records the decisions and the rejected alternatives in the same change.
The rejected alternatives are the point: the clarification round is the last
moment they exist.

## Contributing

Read [`AGENTS.md`](AGENTS.md). The repository follows the discipline it
distributes — a change to a skill updates its spec in the same change.
