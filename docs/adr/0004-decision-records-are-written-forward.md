# ADR-0004 — Decision records are written forward, never backfilled

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-14 |
| **Supersedes** | — |

## Context

`croakness-init` reads a repository's code and git history. The first design had
it produce ADRs and specs from what it found, marked
`Accepted (recorded retroactively)` and dated at the commit that introduced
the choice — on the reasoning that a repository's structural choices are
visible and worth capturing.

They are visible. What is not visible is what was weighed against them. A
repository preserves the surviving option and destroys every other; commits
record what changed, not what was considered and dropped.

## Decision

`croakness-init` writes `AGENTS.md` and the PRD, and nothing else. The decision
log starts empty on the day Croakness is installed and only grows forward.

The split is between state and decision. `AGENTS.md` and the PRD describe
state — what the repository contains and what the product does — which is
readable from the code at any time. ADRs and specs record decisions, which are
not. A structural choice already in the code is therefore state: it goes in
the Architecture or Traps section of `AGENTS.md`, and it becomes an ADR only
the day someone decides to change it.

## Alternatives weighed

- **Retroactive records with a distinguishing status** — rejected: a status
  line does not change how a document is read. A reconstructed record has the
  same shape, the same confidence and the same authority as a genuine one,
  while its Alternatives section is invention. One of those in a repository
  devalues every other record in it, which is a steep price for filling a
  directory.
- **Listing detected structural choices as candidate ADRs for a human to
  confirm** — rejected: it is the same backfill with a consent step, and it
  invites writing an Alternatives section from memory months later.
  `AGENTS.md` already captures what those choices are.
- **Generating specs for existing features** — rejected for the same reason,
  and with less excuse: a spec's value is almost entirely in its rejected
  alternatives and known gaps, which is exactly the part that cannot be
  recovered.

## Consequences

- A repository with ten years of history gets an empty `adr/` at install. It
  looks like the tool did little, so the init report states that the empty log
  is by design and says where the first record will come from.
- The value of `croakness-init` concentrates in `AGENTS.md`. If that file is
  weak, the skill has failed — there is no volume of generated documents left
  to hide behind.
- Genuine past decisions that someone still remembers are not captured by the
  tooling. A human who actually remembers the alternatives may write the ADR
  by hand, and it is a real record — the rule binds what Croakness
  generates, not what a team knows.
- `adr/` and `specs/` are not created empty. The first record creates its
  directory, on the day there is something true to put in it.
