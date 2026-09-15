# ADR-0007 — `AGENTS.md` follows the cross-vendor convention, budget included

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-15 |
| **Supersedes** | — |

## Context

A-PDLC Kit writes `AGENTS.md` and calls it "how this repo is written":
commands, architecture, code style, traps, deployment. That shape was chosen
from what is useful to an agent about to write code, not from the published
convention, and the two had never been compared.

The comparison became necessary because of a collision this product had no
answer for. A repository adopting agent tooling often already carries an
`AGENTS.md` shaped as a behavioral contract — Mission, Before changing code,
Scope, Tests, Git, Completion, Evidence, Human gates — rather than as a guide
to the codebase. Same filename, and not one section in common with what this
product writes. `pdlc-init`'s "never overwrite, propose a merge" rule gave no
guidance on which of the two shapes a merge should end up in, which left the
highest-value file in the product resolved by whoever happened to run it.

What the convention actually says settled it. `AGENTS.md` is a cross-vendor
format — launched jointly by the teams behind OpenAI Codex, Google Jules,
Cursor, Factory, Amp and Sourcegraph, now stewarded by the Agentic AI
Foundation — and it is deliberately thin: plain Markdown, no frontmatter, no
required field, nested files where the one nearest the edited code wins.
GitHub's published analysis of more than 2,500 real `AGENTS.md` files names
six zones that separate a file which changes agent behavior from one that does
not — commands, testing, project structure, code style, git workflow,
boundaries — plus an explicit statement of the agent's role as the single
largest differentiator, and a length target of 150 lines.

Held against that list, neither shape was wrong and neither was complete. This
product covered commands, structure and style. A contract of the kind
described above covers role, testing, git and boundaries. They are
complementary halves of one canonical file.

## Decision

`AGENTS.md` as written by A-PDLC Kit follows the convention. The template
carries the six zones in the convention's order, opens with a role statement,
and targets 150 lines. The convention's nested-file mechanism is the
prescribed answer to a repository with several stacks — repo-wide rules at the
root, per-stack rules beside the code — rather than a longer root file.

An existing `AGENTS.md` shaped as an agent contract is treated as the other
half of the same file. `pdlc-init` recognises it by its headings and merges
both into the template's order, preserving the contract's wording rather than
paraphrasing it.

Two kinds of content are excluded, and `pdlc-init` proposes a destination for
each rather than absorbing or dropping it:

- **The shape of a pull-request body** — evidence report, completion
  checklist — goes to a pull-request template, leaving one line under
  Boundaries.
- **Process governance** — gate staffing, metric definitions, escalation
  routing — goes wherever the organisation keeps process. What stays is the
  rule the agent obeys: it does not merge, deploy, touch production data, or
  lift a security control.

The convention is recorded in the discipline reference, once, and the two
skills that write or merge the file apply it from there.

## Alternatives weighed

- **Keep this product's own shape and treat a contract as a competing version
  of the same document** — rejected: it discards the zones a contract is the
  only source for, and boundaries are the zone with the highest measured
  effect on behavior. It also puts the product in the position of having
  invented a format that already exists.
- **Adopt the contract shape and drop this product's sections** — rejected for
  the mirror reason: commands with their real flags is the first thing the
  convention asks for, and traps are the content no other document in the
  four levels will ever hold.
- **Two files, the contract in `AGENTS.md` and this product's content
  alongside it** — rejected: `AGENTS.md` is the file every host loads first,
  and a second file is read only if something links to it and the agent
  follows the link. Splitting trades a length problem for a reliability one.
- **Adopt the six zones but decline the 150-line budget** — rejected as the
  default, because the cost of a long file is paid silently, in context, on
  every session. It is not forbidden: `pdlc-init` reports the line count and
  proposes the nested split, and a team that decides the budget loses to
  keeping a contract whole records that decision in the file. The budget is a
  default with a visible override, not a rule the product enforces.
- **A checker that verifies the section order and the line count** — rejected:
  it needs executable code, against the constraint in `PRODUCT.md`, to enforce
  a convention whose own specification has no required fields.

## Consequences

- The template's opening section, a Claude Code-specific rule about sandbox
  failures, is removed. It was host-specific content under `skills/`, which
  [ADR-0003](0003-provider-neutral-skills-layout.md) forbids, and it sat ahead
  of Commands, which the convention puts first. Anything that rule was doing
  is now nobody's job; if it is needed, it belongs in a host's own
  configuration, not in a document written into a target repository.
- `AGENTS.md` written by this product grows by three sections — Overview,
  Testing, Git — and the 150-line budget therefore binds sooner than before.
  On a multi-stack repository the nested-file split is no longer optional
  advice; it is how the file stays inside the budget.
- The product now depends on an external convention it does not control. If
  the six zones or the length guidance change, the template and the reference
  are wrong until someone notices. Nothing watches for that.
- This repository's own `AGENTS.md` predates the decision and does not follow
  the new order. It is left alone in this change: reshaping it is a separate
  edit, and doing it here would bury the product change in a documentation
  diff.
- A repository carrying a contract and then running `pdlc-init` no longer
  loses either document, but the merge is a proposal every time. There is no
  automatic path, by design — a contract's rules are the kind written to be
  opposable, and quietly rewording one is worse than asking.

---

Drafted with an AI assistant — review before treating as authoritative.
