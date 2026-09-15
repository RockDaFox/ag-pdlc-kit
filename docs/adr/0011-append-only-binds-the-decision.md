# ADR-0011 — A record is immutable, the log is append-only, and immutability starts at the commit

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-15 |
| **Supersedes** | — |

## Context

The append-only rule was stated twice in the same paragraph and not the same way: append-only starts at the commit, then, one clause later, that a record becomes one once it is pushed. Three of the four places that carry the rule — the first sentence, `pdlc-decide`'s instructions, and that skill's spec — say commit, and the skill implements it by running `git log` on the file. One subordinate clause said pushed. An agent reading the reference could arrive at either answer, and the answers differ by exactly the window in which an ADR is easiest to want to change.

The ambiguity was not academic. [ADR-0008](0008-one-maintainer-side-check-script.md) was committed in this repository and then edited, to record the outcome of a verification one of its own consequences had called unverified. Under the looser reading that was permitted; under the rule as the product implements it, it was not. The edit was reverted.

Reverting it exposed the second question, which is the more interesting one. ADR-0008's Consequences section says the check script prints a note about an asymmetry between the two marketplace manifests. It no longer does: the asymmetry was verified as correct — Claude Code discovers components from the plugin root, Copilot declares them in the marketplace entry — and the key was dropped from the comparison. The drift rule says a document describing behavior that changed is updated in the same change. Append-only says this document cannot be. The only route the discipline offered was superseding an entire ADR over a resolved footnote.

And underneath that, a third thing, which is the actual cause. The bullet that rotted was not a consequence at all: it was an open question — *whether either host requires the key there is unverified* — filed as though it were an established fact. Settling it took three commands, two hours after the ADR was written. A Consequences section that holds what a decision costs does not decay, because a cost incurred is still a cost incurred. What decays is an assertion nobody checked.

## Decision

**The log is append-only; each record in it is immutable.** The reference stated the two as one thing, and only the second constrains a document someone is holding. A spec is rewritten in place. An ADR is not rewritten at all — not corrected, not updated, not annotated, and that includes its Consequences section.

**Exactly one mutation is authorised:** the superseded record's `Status` row gains `Superseded by ADR-00NN`. That row is a pointer rather than content, and without it a reader has no route from a record to the one that replaced it. Naming it explicitly is part of this decision, because a rule that says "immutable" while silently requiring one edit is a rule that invites a second.

**Immutability starts at the commit, not at the push.** A local commit goes out with the next push of anything else, and nothing can be unpublished; the boundary that cannot be got wrong in the expensive direction is the earlier one. It is also the one an agent establishes with a single command, which is why the skill already implemented it.

**A record is therefore read as dated.** Every present-tense sentence in it is a claim about the day it was written, and the record was accurate on that day. A consequence that has since resolved leaves it accurate; what is true now is state, and goes to `AGENTS.md`, `PRODUCT.md` or the feature's spec. The drift rule governs documents that describe the present, which an ADR does not.

**Nothing unverified is filed as a consequence.** A question the writer can settle is settled before the ADR is written; one that cannot be is stated as a gap, with the condition that would settle it. An assertion parked in a Consequences section is read later as a fact that was established — and since the record is immutable, it stays readable that way forever.

`pdlc-decide` says this where it performs the supersession, because that is where the question arises: **a record is superseded when a decision is reversed, and for nothing else.** A consequence that has resolved is not a reversal, so it produces no ADR at all — the finding is state, and goes where state goes.

## Alternatives weighed

- **Move the boundary to the push** — rejected twice over. It is the reading that would have excused the edit that prompted this decision, which is grounds for suspicion rather than for adoption. And it rests on a state the author does not control: a branch is pushed by a teammate, by a later unrelated push, by a tool.
- **Supersede ADR-0008 with a record that restates it and corrects one bullet** — rejected: the log would gain a decision that decides nothing, and the precedent is that every predicted consequence maturing produces a record. A decision log nobody can skim is a decision log nobody reads.
- **Allow a dated amendment block at the foot of an ADR** — rejected, though it is append-only in form and therefore tempting. It is not immutable: the file changes after it was committed, and a record that can grow can be argued into growing. What it produces is a document whose current meaning has to be assembled by reading it in order, with no single statement of where things stand — which is what the supersession mechanism exists to provide.
- **Leave the ambiguity and let each session resolve it** — rejected: it had already produced one violation, in the repository that distributes the rule.

## Consequences

- ADR-0008 keeps its text, including a consequence that no longer describes the script. That is now correct rather than tolerated. The verified fact lives in `AGENTS.md`'s Traps, where state belongs.
- A typo found in an ADR after committing it stays. The remedy is to read the file and run the check before committing, not to loosen the boundary.
- Someone reconstructing history has to know that an ADR's Consequences are expectations rather than a maintained list, and nothing marks which bullets have since resolved. Accepted: the alternative is a maintained ADR, which is not an ADR.
- The rule is now stated once, so the two readings can no longer diverge. Nothing checks that it stays that way — a future edit reintroducing "pushed" somewhere would not be caught by anything.

---

Drafted with an AI assistant — review before treating as authoritative.
