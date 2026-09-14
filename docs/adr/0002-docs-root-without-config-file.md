# ADR-0002 — The documentation root is declared in `AGENTS.md`, not in a config file

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-14 |
| **Supersedes** | — |

## Context

Croakness writes its documents under a root directory. `docs/` is the
obvious default, and it is frequently already taken — by a published
documentation site, by generated API references, by anything a project already
calls its docs. Croakness has to be able to sit elsewhere, which makes the
root a per-repository value that the skills must resolve before writing
anything.

## Decision

The root defaults to `docs/`. A repository that deviates states it in
`AGENTS.md`, in one line under its Documentation section. Resolution order is:
the line in `AGENTS.md`, then an existing directory matching the layout, then
`docs/`.

Plugin instructions refer to it as `{docs_root}`, defined once in the
discipline reference. Documents written into a target repository carry the
resolved path, never the placeholder.

## Alternatives weighed

- **A `.croakness.json` at the target repository root** — rejected: a fifth
  file holding one string, and a second source of truth about how the
  repository is organised. `AGENTS.md` already answers "how is this repo
  written", and the skills already read it first. A config file would be the
  one part of Croakness that is not itself documentation.
- **Hardcoding `docs/`** — rejected: it collides on exactly the repositories
  that document the most, which are the ones worth installing Croakness on.
- **Asking the user on each invocation** — rejected: an answer that has to be
  repeated is not a decision, and the skills would ask it forever.

## Consequences

- Resolution depends on `AGENTS.md` being read before any document is written.
  Both skills state that as their first step; a future skill that forgets it
  will silently write to `docs/`.
- Moving the root after the fact means editing one line in `AGENTS.md` and
  moving the directory. If only the directory moves, resolution falls through
  to discovery, then to `docs/` — wrong, but quietly so.
- Inline links inside the generated documents hold real relative paths, so
  they survive the placeholder never existing on disk.

---

Drafted with an AI assistant — review before treating as authoritative.
