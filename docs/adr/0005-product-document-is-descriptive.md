# ADR-0005 — The product-level document is `PRODUCT.md`, descriptive and as-built

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-15 |
| **Supersedes** | — |

## Context

The product-level document was named `PRD.md` and its third section was titled
"Functional requirements", while the comment immediately under that title
instructed the writer to use the present indicative and describe what the
system does. The template contradicted itself in two consecutive lines, and
section 4 repeated the slip by calling constraints "non-functional
requirements".

The contradiction was not cosmetic. A PRD is a product *requirements*
document: written before the build, prescriptive, an input to engineering, and
its value lies in stating what does not exist yet. The document this product
generates is the opposite genre — descriptive, derived from the code and the
git history, an output.
[ADR-0004](0004-decision-records-are-written-forward.md) had already
classified it as **state** rather than decision, which is the same
observation from another angle.

Two consequences were already observable. The product is installed on client
repositories, and many organisations have a product function that owns the
term PRD for genuinely prescriptive documents held elsewhere; a `docs/PRD.md`
describing the existing system is a homonym of a different genre. And the
whole argument of this product is that a document read with unearned trust is
worse than an absent one — a mislabelled genre commits that error in the one
place every reader looks first, the filename.

## Decision

The document is `PRODUCT.md`. It states what the product does today, in the
present indicative, and holds no requirement addressed to work still to come.
The word "requirements" is not a section title anywhere: functional sections
describe *behavior*, and what shapes the product without being behavior is a
*constraint*.

The genre is stated once, in the discipline reference, alongside the reason
the name `PRD.md` is refused. A repository whose product team owns real PRDs
keeps them where they are; `PRODUCT.md` neither competes with them nor
absorbs them.

## Alternatives weighed

- **Keep `PRD.md` and fix only the internal vocabulary** — rejected: the
  filename is what sets the reader's expectation before a single line is
  read, including an agent's prior about what a file called `PRD.md`
  contains. Correcting the section titles while leaving the mislabel on the
  cover fixes the cheap half of the problem.
- **Ship `PRODUCT.md` with a `PRD.md` pointing at it** — rejected: two names
  for one document, which the stated-once rule forbids everywhere else, and
  the redirect would outlive anyone's memory of why it exists.
- **Rename `specs/` to `decisions/` in the same pass** — rejected: "spec" is
  loose in common usage but not wrong for a living design document, whereas
  `decisions/` sitting beside `adr/` would put two registries of decisions
  side by side and blur exactly the boundary the reference works hardest to
  keep sharp.

## Consequences

- A repository initialised before this decision carries `docs/PRD.md`.
  Nothing migrates it: `pdlc-init` treats the file as existing prose and
  proposes a merge, never a rename. The rename is a manual, one-line job.
- `pdlc-init`'s description no longer carries "PRD" as a trigger word, so a
  user asking in those terms may not reach the skill. Deliberate: the word
  names the genre this document is not.
- [ADR-0001](0001-distribution-as-claude-code-plugin.md) and
  [ADR-0004](0004-decision-records-are-written-forward.md) use the former
  name in their prose. They are not edited — an ADR is accurate about the
  situation at its date, and that is what the append-only rule protects.
- The vocabulary is now a repository convention, recorded in `AGENTS.md`, and
  binds every future template and skill.

---

Drafted with an AI assistant — review before treating as authoritative.
