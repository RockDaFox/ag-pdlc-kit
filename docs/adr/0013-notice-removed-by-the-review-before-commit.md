# ADR-0013 — An ADR's AI-assistance notice is removed by the review that precedes its commit

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-16 |
| **Supersedes** | — |

## Context

Every document this repository holds carried a line saying it was AI-drafted and needed review. The rule behind it, in `doc-discipline.md`, had no exit condition: the line went on and stayed on. All twenty-odd documents carried it, the read ones and the unread ones alike, so it distinguished nothing and was read as boilerplate.

That was corrected earlier today: the notice stays until a human has read the document, and removing it is that review. ADRs were made the exception, on the grounds that a record is immutable and read as dated.

The exception was the wrong diagnosis. The twelve ADRs in this log were read by a human before they were committed — what was missing was not permission to remove the notice, it was the removal itself, forgotten at the point in the workflow where it belonged. An ADR in the working tree is a draft and may be corrected freely ([ADR-0011](0011-append-only-binds-the-decision.md)); the notice should have gone then, along with every other correction the review produced.

So there is no standing conflict with immutability to resolve. There is a step that was never named, and twelve files that carry the consequence of it not being named.

## Decision

**An ADR is reviewed before it is committed, and the removal of its AI-assistance notice is part of that review.** The notice marks a record nobody has read; a record ready to be committed has been read. Removing it is the last thing the reviewer does, in the same working tree, before the commit that makes the record immutable.

**After the commit, the notice stays, exactly like every other line.** A notice found on a committed ADR is in the same position as a typo found on one: the remedy is the review that precedes the commit, not an edit afterwards. [ADR-0011](0011-append-only-binds-the-decision.md) is untouched and keeps every word, including its single authorised mutation.

**The twelve ADRs committed before this decision have their notice removed once, now.** They were reviewed; the step that should have stripped the line did not exist yet. This is a one-off correction of an omission in the workflow, not a licence: it applies to the files listed in the commit that carries this record, and to nothing afterwards. The next ADR committed with its notice keeps it.

That distinction is the whole weight of this decision, and it is the one a later reader will be tempted to erode. The precedent being set is *name the missing step*, not *edit the log when the omission is yours*.

## Alternatives weighed

- **Keep the notice on ADRs permanently, as the exception written earlier today** — rejected: it was reasoned from immutability, which was never the obstacle. The notice's job is to mark an unread document; on twelve documents that were read it simply says something false, and it says it on the records a reader is most likely to treat as authoritative.
- **Declare the notice metadata outside the record, removable at any time by whoever reads it** — rejected, and it was the first shape this record took. It resolves the same problem by creating a standing second authorised mutation, permanently, where a one-off correction and a named workflow step are enough. A rule loosened forever to fix twelve files is a bad trade.
- **Leave the twelve as they are, under the strictest reading of ADR-0011** — rejected: consistent, and it preserves the exact defect this decision is about. It would also be the second time this repository chose the letter of append-only over a document that had stopped telling the truth.
- **Supersede ADR-0011** — rejected: it decided four things, none of which changes here. Its own Alternatives section rejected a supersession written to carry one added clause, and that reasoning applies to itself.
- **Strip the notices with no record at all** — rejected: two lines of shell, and it would have left a diff apparently rewriting twelve immutable records with nothing to say why. That is the failure this product exists to prevent.

## Consequences

- The git history shows twelve ADRs modified after their commits. Anyone auditing append-only will find them, and this record is the only thing that explains the diff — which is why the commit message has to point at it.
- Nothing enforces that the one-off pass touched only the notice. `scripts/check.sh` compares the tree against itself, not against what was committed; `git log -p` on those files is the only place the answer lives.
- The no-edit-after-commit rule now has a documented instance of being set aside, with reasons. The reasons are narrow and the instance is closed, but the next person wanting an exception has a precedent to cite, and citing it is easier than reading why it was granted.
- A reviewer who forgets the step again produces a committed ADR whose notice is permanent, and the log carries a record claiming it was never read. `scripts/check.sh` reports an ADR still carrying the line while it is uncommitted, which is the window that matters; it says nothing once the commit has happened, because by then nobody is allowed to act on it. A commit made without running the check is not covered, and after this pass nothing will correct such a record either.
- `doc-discipline.md` and `docs/PRODUCT.md` §4 lose the exception they gained a few hours earlier and gain the workflow step instead. Both are state documents, rewritten in place; the two successive changes live in git, which is where they belong.
