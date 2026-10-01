# A-PDLC Kit

The toolbox of the agentic developer: the skills you invoke to work with a
coding agent on a real repository. Runs on Claude Code and GitHub Copilot from
one set of files.

The first family of tools in it writes down the reasons, because that is the
gap that bites first. A coding agent has the code, never the reasons. Git
history records what changed, not what was decided nor what was rejected. So
settled questions get re-opened, rejected options get retried, and deliberately
fixed bugs come back. A-PDLC Kit writes the reasons down at the moment they
exist, and hands them back to the next piece of work as its context.

## Four levels, each stating a thing once

| File | Answers |
|---|---|
| `AGENTS.md` | How this repo is written — commands, conventions, traps. |
| `docs/PRODUCT.md` | What the product does, and why, as delivered. |
| `docs/adr/` | Structural technical decisions. Dated, append-only, superseded rather than rewritten. |
| `docs/specs/` | A feature's decisions, its rejected alternatives, its known gaps. Living. |

`PRODUCT.md` is deliberately not a PRD. It describes what the system does
today, in the present indicative, and holds no requirement for work still to
come — a team that owns real product requirements keeps them where they are.

The documentation root defaults to `docs/` and can be anywhere — a repository
that deviates says so in one line of `AGENTS.md`. There is no config file.

## Install

Same command on both hosts, each reading its own manifest from this
repository:

```
/plugin marketplace add git@github.com:RockDaFox/a-pdlc-kit
/plugin install a-pdlc-kit@a-pdlc-kit
```

Other hosts that read the same `SKILL.md` format will probably work from the
`skills/` directory. None has been tested, so none is claimed.

## Use

**`/pdlc-init`** — on a repository that has none of this. Reads the code
and the git history, writes `AGENTS.md` and `PRODUCT.md` from what is
actually delivered, and reports what it could not establish and needs a
human. Run once.

It writes no ADR and no spec, and that is the point. A repository preserves
the choice that survived and destroys the alternatives, so any decision record
derived from it would be invention wearing the same clothes as the real thing.
The decision log starts empty and grows forward.

**`/pdlc-feature <description>`** — for the work afterwards. Surfaces the open
questions before any code, writes the spec and waits for a go-ahead on it,
implements against it, then reconciles it with what shipped, in the same
change as the code. The rejected alternatives are the point: the clarification
round is the last moment they exist. And the spec written before the work is
what the implementation and its tests are built from, rather than an epilogue.

**`/pdlc-decide`** — for a decision that produces no code: a stack settled
before anything is built, an architecture approved before the work is split, a
boundary drawn, an earlier ADR being reversed. Those have no commit to ride
along on, so nothing writes them down. It interviews for what was weighed —
it never supplies the alternatives itself — and it walks the supersession of
an existing ADR, which is two files and never an edit in place.

**`/pdlc-build`** — on a spec ready to build against: inside `/pdlc-feature`,
automatically, at its own step 6; or standalone, on a `Draft` spec already
committed, a ticket, or a bug with a known cause. It derives one test per
behavior the spec states, confirms each is red for the stated reason before
writing the implementation, returns to green, then reports the evidence — the
commands run, their output, what was covered, what was left. Its test, lint
and build commands come from the repository itself, discovered rather than
guessed.

**`/pdlc-review`** — on a change ready to be looked over before it is
committed: the uncommitted working tree by default, or a branch, a commit range
or a path. It reviews the way a tech lead would, against what the repository
has already written down — its conventions, the spec that authorised the work,
the installed version of the libraries the change calls into — and says which
of those it does not have. Every finding is graded blocking, to fix or detail,
fits on one line and is numbered. A finding about a library names what it is
grounded in, or is reported as unverified. Nothing changes until you choose
which findings to apply; those go through the build loop, so a correction that
changes behavior arrives with a test. A substantive finding you decline is
recorded in the spec's Known gaps, so it does not come back at the next review.
Nothing calls it automatically, and it commits nothing.

## Contributing

Read [`AGENTS.md`](AGENTS.md). The repository follows the discipline it
distributes — a change to a skill updates its spec in the same change. Run
`sh scripts/check.sh` before committing; it checks this repository's own
documents and is never invoked by a skill.
