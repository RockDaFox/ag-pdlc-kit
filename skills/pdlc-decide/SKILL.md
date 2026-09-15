---
name: pdlc-decide
description: Record a decision that produces no code right now — a technical foundation, an architecture approval, a boundary, a dependency the repo will carry — as an ADR or a spec entry, with the alternatives that lost. Also walks the supersession of an existing ADR, which is append-only and never edited in place. Use when a decision has just been taken or is about to be, when an earlier ADR is being reversed, or when the user invokes /pdlc-decide.
---

# Record a decision

Some decisions arrive with code, and
[`pdlc-feature`](../pdlc-feature/SKILL.md) records those on the way past. The
rest arrive on their own: a stack chosen before anything is built, an
architecture approved before stories are sharded, a boundary drawn between two
parts of the system, a dependency the repository agrees to carry. Those have no
commit to ride along on, so nothing writes them down and the reasoning is gone
by the following week.

This skill is that commit.

Read [`doc-discipline.md`](../_pdlc-shared/doc-discipline.md) first: it holds
the ADR-or-spec tests, the append-only rule, and how to resolve `{docs_root}`.

## What this skill will not do

**It will not reconstruct a decision you cannot remember.** The alternatives
are the part of a record that no repository preserves, and an invented
Alternatives section reads exactly like a real one — which is what makes one
of them poison the whole set
(see the discipline reference on records written forward).

So the alternatives come from the user, never from inference. The rule in
practice:

- The user names what was weighed → transcribe it, with each option's reason
  for losing.
- The user remembers the decision but not the alternatives → the record says
  so, in one line, and stays otherwise complete. The templates already provide
  for this.
- The decision is being reconstructed from the code → stop and say so. What
  the code shows is **state**, and state belongs in `AGENTS.md`. Offer that
  instead.

**It will not decide.** The user decides; this skill interrogates and writes.
Where the request is really a request for a recommendation, say so, give the
recommendation as analysis, and record nothing until the user has chosen.

## Process

1. **Establish that there is a decision.** A preference with no alternative is
   not one. A failed attempt is not one either — only the decision it produced
   is worth keeping. If nothing was actually settled, say so and stop.
2. **Route it.** Apply the three tests from the discipline reference — scope,
   reversal cost, lifetime — and name the outcome before writing: an ADR, an
   entry in an existing spec, or a line in `AGENTS.md` because it turned out
   to be state. Say which test decided it.
3. **Interview for what the record needs and the user has not said.** The
   situation at decision time; the options weighed and why each lost; what
   this costs and what it forecloses, including the unpleasant part. Batch the
   questions into as few rounds as possible.
4. **Write it**, from the template, into `{docs_root}`.
5. **Report** the file written, the test that routed it, and anything the user
   declined to answer that the record now states as unknown.

## Writing the record

**An ADR** — `{docs_root}/adr/NNNN-<title>.md`, from
[`../_pdlc-shared/templates/adr.md`](../_pdlc-shared/templates/adr.md),
numbered one above the highest existing file, starting at `0001`. The number
is never reused. The title names the decision as a choice made, not the
question it answered.

**A spec entry** — the decision belongs to a feature that already has a spec:
add it to that spec's Decisions, and the option that lost to its Rejected
alternatives. Do not create a spec for a feature that does not exist yet; a
decision taken before the feature is either an ADR or premature.

**`AGENTS.md`** — the decision turned out to be a repo-wide rule or a trap.
One line or one paragraph, in the matching section, and nothing in
`{docs_root}`.

## Superseding an ADR

An ADR is never rewritten. Reversing a structural decision touches two files,
and both edits are required — half of this leaves the log saying two
contradictory things with equal confidence:

1. **The new ADR** carries `Supersedes ADR-NNNN` in its header table, and its
   Context says what changed since that decision — not that the old one was
   wrong. It was right for the situation it recorded, which is why the old
   text stays.
2. **The old ADR** keeps every word of its text and gains exactly one change:
   `Status: Superseded by ADR-MMMM`.

Before doing either, check whether the old ADR is a record or still a draft.
Append-only starts at the commit: an ADR still in the working tree may be
corrected freely, and superseding something written an hour ago documents
nothing but the writing of it. Run `git log` on the file — if it has never
been committed, edit it instead and say that is what you did.

A decision that contradicts an ADR without reversing it — a scoped exception,
one service that does it differently — is not a supersession. It is an
entry in that area's spec, linking to the ADR it departs from and saying why
the exception holds. Do not touch the ADR.

## Regulated data

If the decision touches personal, health or payment data, the record carries
the five escalation fields from the discipline reference, and the answer comes
from the organisation's data-protection or compliance function rather than
from this skill. An unanswered question is recorded as unanswered.

## Finishing

Remind the user the record was AI-drafted and needs review before it is
treated as authoritative — and, for an ADR, that it becomes append-only the
moment it is pushed.
