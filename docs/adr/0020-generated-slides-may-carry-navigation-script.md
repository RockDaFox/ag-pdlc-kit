# ADR-0020 — A generated report may carry inline script, for slide navigation only

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-10-21 |
| **Supersedes** | — |

## Context

Until `pdlc-report`, everything the kit wrote was Markdown: documents in a repository, read by people and agents, never run. [ADR-0019](0019-the-kit-ships-one-check-that-runs-on-a-documented-repository.md) admitted one executable, a check that runs on a documented repository, and stated that every further check of that kind needs its own record.

`pdlc-report` writes a report for readers outside the repository, and one of its formats is HTML slides ready to present. The user wanted them navigable with the keyboard and shown full screen, which plain HTML and CSS do not give. That needs a few lines of script inside the generated file. The file is not installed in a repository and runs in the reader's browser, not on a machine the kit works on, but it is still something the kit writes that executes.

## Decision

**A report `pdlc-report` writes as HTML slides carries inline JavaScript, for navigation only.** The script moves between slides with the arrow keys, space and page keys, and toggles full screen. It makes no network call, stores nothing, and loads nothing: the file is self-contained, so it opens offline and travels as an attachment.

The skeleton of that script is written in `pdlc-report`'s own `SKILL.md`, and the skill is told to keep it to that. No other output of the kit carries script.

## Alternatives weighed

- **Slides in CSS only, one slide per screen with scroll snapping** — rejected by the user: keyboard navigation and full screen are what make the slides ready to present.
- **A slide library loaded from a CDN** — rejected: the file would fail offline and send a request from the reader's machine, often a client's.

## Consequences

- A report in slides is a file that runs code in its reader's browser. A reviewer about to send one has a script to trust, and the kit's promise is that it navigates and nothing more. Nothing checks that a given report kept to it; the model writes the file.
- The constraint in `docs/PRODUCT.md` §4 now covers two kinds of executable: the check of ADR-0019, which runs on a repository, and this script, which runs in a browser. Any further output carrying script needs its own record.
- A mail filter or a security policy that blocks HTML attachments with script blocks these slides. The one-page HTML and the Markdown formats carry none.
