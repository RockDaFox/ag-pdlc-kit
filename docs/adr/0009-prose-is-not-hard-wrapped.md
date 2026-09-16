# ADR-0009 — Prose is not hard-wrapped

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-15 |
| **Supersedes** | — |

## Context

`AGENTS.md` carried "prose wraps at 79 columns" as a style bullet, with nothing recorded about where the number came from or what it bought. Under this repository's own routing that is correct — a convention visible in the files is state, not a decision — but it left a rule no one had ever had to justify.

Its genealogy is not in doubt. Eighty columns descends from the punched card and then the terminal; seventy-nine is eighty minus one, so that a `git diff` line, prefixed with `+` or `-`, still fits in eighty. That argument serves code reviewed in a terminal. It was adopted here for Markdown by habit.

The rule became visible the moment something measured it. [ADR-0008](0008-one-maintainer-side-check-script.md)'s check found eight lines over the limit in a repository that had just been reviewed and called clean — five of them inside committed ADRs, where [ADR-0004](0004-decision-records-are-written-forward.md) forbids the fix. A rule that the repository stating it had broken permanently in five places, without noticing, is a rule worth re-deciding rather than enforcing.

For prose in git, the three available shapes rank by diff quality: one line per sentence, then fixed width, then one line per paragraph. Fixed width sits in the middle and is the only one a script can verify. Nothing ranks it first.

## Decision

Prose in this repository is not hard-wrapped. A paragraph is one line, and the editor wraps it for display. There is no target width.

Files written before this decision stay as they are, and an edit inside a wrapped file keeps that file's wrapping. A file mixing both shapes reads worse than a file in either one.

The check script loses its line-length check, and with it the two mechanisms that existed only to serve it: the canary that proved `grep` was counting characters rather than bytes, and the baseline file that recorded the five lines append-only had made permanent.

## Alternatives weighed

- **Keep 79 columns** — rejected: nothing recorded why it was there, its one live argument serves code review in a terminal, and reflow noise is paid on every correction to a paragraph's first line. Its genuine advantage is that a script can check it; a rule kept because it is checkable is a rule serving its tooling.
- **One line per sentence — semantic line breaks** — rejected for now, and it is the option with the best diffs: a changed sentence shows as one changed line. It is judgment, so nothing verifies it, and its mixture with the existing tree is identical to the mixture this decision accepts. Worth reopening as its own decision rather than folding into this one.
- **Reflow the whole tree to one shape** — rejected: reflowing a committed ADR is a rewrite, which [ADR-0004](0004-decision-records-are-written-forward.md) forbids. Consistency is not available at any price here.

## Consequences

- The repository is permanently mixed: wrapped files and unwrapped files, side by side. `AGENTS.md` states it, so that it reads as a decision rather than as inattention.
- A line reference into a new file — `PRODUCT.md:42` — points at a whole paragraph, and a diff correcting a comma marks that paragraph as changed. This is the cost of the decision and the reason the alternative above is not closed.
- Marginally fewer tokens per paragraph, one newline instead of one per wrapped line. One or two percent; an effect, not a reason.
- The 150-line budget on an `AGENTS.md` is untouched, and is not this rule's business: it belongs to the cross-vendor convention ([ADR-0007](0007-agents-md-follows-the-cross-vendor-convention.md)) and it governs the file written into a target repository, whose template stays wrapped. Worth keeping in view, though — a line budget is a proxy for context cost, and unwrapped lines carry more content per line than the convention's authors were counting.
- Nothing enforces this, and nothing can. It is the first style rule in this repository held by agreement alone.
