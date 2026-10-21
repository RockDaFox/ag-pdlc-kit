# ADR-0018 — Ag-PDLC Kit serves the whole product team, across the product development life cycle

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-10-21 |
| **Supersedes** | — |

## Context

Until this date the kit described itself as the toolbox of the agentic developer: in `README.md`, in `docs/PRODUCT.md` §1, and in the context of [ADR-0012](0012-a-spec-precedes-the-implementation-it-governs.md). `docs/PRODUCT.md` §2 named three users: the developer installing the kit, the coding agent, and a human newcomer to the repository.

Its five skills serve the software part of the product development life cycle: they specify, build, review, and record the decisions taken on the way. A product team also has roles that write no code — a product owner, a delivery lead, a designer — and the cycle has phases before and after the build that no skill reached. The question of who the kit is for came up while designing the first skill for those roles, `pdlc-report`.

## Decision

**Ag-PDLC Kit serves the whole product team: the developers, and the roles that write no code.** It covers the product development life cycle, and building the software is one part of it.

A skill does not have to be run by a coding agent, and does not have to work on a repository. A skill may work on documents the user supplies.

The target host follows the skill's user. A skill of the software cycle is for developers and is run by a coding agent, so it targets the developer hosts the kit supports today and nothing else. A skill meant for the roles that write no code is meant to run in the AI tools those roles use — Claude Cowork, Vibe Work, Microsoft 365 Copilot — as well.

A candidate skill is judged on its value to a product team working with agents, not on its place in the software cycle.

What does not change: nothing under `skills/` is host-specific ([ADR-0003](0003-provider-neutral-skills-layout.md)), the documentation discipline and its four levels stay as they are, and the five shipped skills keep their behavior.

## Alternatives weighed

- **A separate kit for the product roles, beside this one** — rejected; the reason was not stated at decision time.
- **Keeping the kit for developers, with the product roles using other tools** — rejected; the reason was not stated at decision time.

## Consequences

- The three hosts the kit supports — Claude Code, GitHub Copilot, Vibe — are developer tools. A role that writes no code has to install one of them to use the kit, until another host is tested.
- Whether Claude Cowork, Vibe Work and Microsoft 365 Copilot load a `SKILL.md` and resolve its relative links into `skills/_pdlc-shared/` is not verified. It is settled host by host, when one is tested. Until then `docs/PRODUCT.md` §5 claims none of them.
- The kit now has two host targets, chosen per skill. A skill that reads `skills/_pdlc-shared/` is bound by whatever the least capable of its target hosts can load.
- A skill that works without a repository has no `{docs_root}`, no git history and no `AGENTS.md` to read. It states what it reads instead, and the rules written in terms of a repository do not reach it.
- A skill for the roles that write no code asks its questions and writes its output without developer vocabulary: no diff, commit, branch or failing test in what the user sees.
- A skill no developer would invoke is now in scope. The five shipped skills no longer define what the kit is for.
