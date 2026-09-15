# ADR-0010 — The shared reference is split by need

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-15 |
| **Supersedes** | — |

## Context

`skills/_pdlc-shared/doc-discipline.md` held the whole discipline, and all three skills read it whole: about 2,970 tokens on every invocation, measured rather than estimated.

Measured by need, the file divided cleanly. The core — `{docs_root}`, the routing test, the writing rules, language, drift, records written forward — is 118 of its 239 lines and every skill uses all of it. The convention `AGENTS.md` follows and the genre of `PRODUCT.md` are used only by a skill writing one of those two files. The ADR-or-spec tests, append-only and the regulated-data record are used only by a skill writing a decision record.

The clearest case is `pdlc-init`. It writes no ADR and no spec by design ([ADR-0004](0004-decision-records-are-written-forward.md)), and it was loading the entire decision-record discipline it is forbidden from applying.

What makes this worth a decision rather than a tidy-up: an agent's context is the scarce resource in this product. Instructions loaded and unused are paid for on every invocation, and they crowd out the repository actually being documented.

## Decision

Three files in `skills/_pdlc-shared/`, each statement still living in exactly one of them:

- `doc-discipline.md` — what every skill needs. It remains the entry point and names the other two, with what each holds and when to read it.
- `state-documents.md` — the cross-vendor convention, the 150-line budget, `PRODUCT.md`'s genre.
- `decision-records.md` — the routing tests, append-only and supersession, the regulated-data record.

Each skill's opening paragraph names the files it needs. `pdlc-init` states explicitly that it needs neither the routing tests nor the regulated-data record, so that the omission reads as a decision rather than an oversight.

Measured against the 2,970 tokens a skill loaded before: `pdlc-init` loads about 2,530, and `pdlc-feature` and `pdlc-decide` about 2,340 — 15 and 21 percent less. Those figures are the split in isolation; [ADR-0011](0011-append-only-binds-the-decision.md) then rewrote the immutability rule in the same session and put roughly 490 tokens back into `decision-records.md`, leaving the two decision skills at about 2,830. The structure is what this decision changes; what is written inside it is a separate question, and precision on the rule governing the whole log was judged worth its cost.

## Alternatives weighed

- **Leave it as one file** — rejected on the measurement, but the saving is 15 to 21 percent and not the near-halving first guessed at: the pointer block and the two new file headers take part of it back. Stated plainly here because an ADR that quotes its optimistic estimate rather than its measured one is advertising.
- **One file per section, six or seven of them** — rejected: every additional file is a link the agent may not follow, and [ADR-0003](0003-provider-neutral-skills-layout.md) already records that a host flattening skill directories breaks every relative link into this directory silently. Three is the fewest that separates the three audiences.
- **Compress the reference instead — keep the rules, cut the reasoning** — rejected, and it deserves its reason: this product exists because the reasoning is the part that does not survive in a repository. A reference reduced to imperatives would be cheaper and would be arguing against its own thesis.
- **Inline what each skill needs into its own `SKILL.md`** — rejected: that is the stated-once rule broken in three places at once, and drift between three copies is the exact failure the rule exists to prevent.

## Consequences

- Each skill now depends on two relative links into `_pdlc-shared/` instead of one. The trap recorded in [ADR-0003](0003-provider-neutral-skills-layout.md) applies unchanged, to one more file apiece.
- `pdlc-feature` and `pdlc-decide` read the same two files. If their needs ever diverge, the seam is in the wrong place and this decision is revisited rather than patched.
- "The discipline reference", in records written before today, now denotes three files. Those records keep their wording; they are accurate about the shape of the product when they were written.
- The saving is a fraction, not an order of magnitude, and it is not durable on its own: a single rule stated more carefully took most of it back within the hour. The reference is still the largest single cost of an invocation — roughly 2,500 of the 6,000 tokens a `pdlc-init` run carries before it has read a line of the target repository. Reducing it further means writing less, not filing it differently, and the alternative above says why that is not free.
- Splitting by need means the total across the three files is larger than the one file was, because each carries a header and the entry point carries pointers. A reader opening all three pays more than before; a skill running one of the three pays less. The design favours the second, which is the one that happens on every invocation.

---

Drafted with an AI assistant — review before treating as authoritative.
