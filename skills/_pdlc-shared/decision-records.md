# Recording a decision

Read [`doc-discipline.md`](doc-discipline.md) first: it holds the four levels,
`{docs_root}`, the routing test and the writing rules. This file holds what is
needed only when a decision is being recorded.

## ADR or spec

The two record decisions, so the boundary has to be explicit. Three tests, in
order — the first that answers, decides:

1. **Scope.** Does the decision constrain code outside this feature? A
   database, a runtime, an auth mechanism, a deployment target, a directory
   layout, a dependency the whole repo now carries → ADR. Behavior a user can
   observe in one feature → spec.
2. **Reversal cost.** Would undoing it mean a migration, a rewrite, or a
   coordinated release? → ADR. Would it mean editing a handful of files? →
   spec.
3. **Lifetime.** Does it stay true once the feature is deleted? → ADR.

**The log is append-only; each record in it is immutable.** The two are not
the same statement, and only the second constrains a document you are holding.
A spec is rewritten in place whenever the feature changes. An ADR is not
rewritten at all: when a structural decision is reversed, a new ADR carries
`Supersedes ADR-0004` and says what changed and why, and the old one keeps
every word of its text.

One mutation is authorised, and exactly one: the superseded ADR's `Status` row
gains `Superseded by ADR-0012`. That row is a pointer, not content — without
it a reader has no way to find the record that replaced this one. Nothing else
in the file is touched, on any pretext.

Rewriting an ADR in place destroys the only record of why the previous choice
looked right at the time, which is the entire reason to keep them. Correcting
one is the same act as rewriting it.

Immutability starts at the commit, not at the push. An ADR still in the
working tree is a draft and may be corrected freely; committed, it is a record
— a local commit goes out with the next push of anything else, and nothing can
be unpublished. Run `git log` on the file to tell the two apart. Superseding a
draft written an hour ago documents nothing but the writing of it.

Because a record is immutable, it is read as **dated**. Every present-tense
sentence in it is a claim about the day it was written, and a reader takes it
as history rather than as status. That is the trade: a log you can trust to
have not been revised is a log whose entries age.

What a Consequences section holds is what the decision costs and what it
forecloses — the price of the option that won, which is what a later reader
weighs on the day they consider reversing it. That is the section's whole
value, and it is why an ADR without one is a case for the decision rather
than a record of it.

What it does not hold is an unverified claim. A question the writer could have
settled is settled before the ADR is written, not parked in it; one that
cannot be settled is stated as a gap, with the condition that would settle it.
An assertion filed as a consequence is read later as a fact that was
established.

A consequence that later resolves — a behavior the record predicted that then
changed — is therefore not a defect in it, and not a reason to supersede it
either. The record was accurate on its date and stays untouched; what is true
now is state, and goes where state lives. Superseding an ADR over a resolved
footnote adds a record that decides nothing, which is the noise the log exists
to stay clear of.

A spec has no such constraint: it describes the feature as it stands today, and
it is rewritten whenever the feature changes. A spec that rests on an ADR links
to it rather than restating the reasoning.

## A spec is written before the work, and reconciled after

A spec is written at two moments, and they do different jobs.

**Before the work**, once the scope is agreed: the decisions taken, the
alternatives raised and rejected with their reasons, the behavior expected, the
non-goals. It carries `Status: Draft`, and once the user has reviewed and
approved it, is committed as it stands, because it is two things at once —
the contract the work is authorised against, and the context the
implementation and its tests are written from. A contract that exists only
inside a session is available neither to the session after it nor to a second
agent working in parallel; but a contract nobody has looked at yet is not a
contract, so the commit waits for that review.

**After the work**, in the same change as the code: the spec is reconciled with
what shipped, and its `Status` becomes `Shipped`. Where the draft and the
implementation diverged, the divergence is recorded — the decision as drafted,
what the implementation showed, and which one the code follows. That entry is a
rejected alternative with evidence behind it, which is worth more than one
rejected in discussion.

A spec written before the work and never reconciled documents the plan rather
than the system, and does it with the authority of a record. The second moment
is not optional.

**An ADR is not written before the work.** Immutability starts at the commit,
so a committed draft freezes a decision that can still move and leaves
supersession as the only way out of a wording chosen too early. An ADR that a
piece of work produces is written when what it decides is settled, which is
with the code.

## Regulated data

A feature that touches personal, health or payment data — or anything else
that looks like it falls under a data-protection or financial regime — raises
a question this discipline does not settle, and that an agent settles even
less. The rule is procedural: the question is raised before the work is
planned, the answer comes from the organisation's data-protection or
compliance function, and the spec records that the exchange happened.

Five fields, in the feature's spec, under a heading of their own:

| Field | Holds |
|---|---|
| Date | When the question was raised. |
| Trigger | What in the feature looked regulated, in one line. |
| Consulted | The function that answered — a function, not a person's name. |
| Decision | The answer, including any condition attached to it. |
| Reference | Where the answer is recorded outside this repository. |

The section is present or absent; it is never filled with a reading of what a
regime requires, because that reading is legal advice and nothing here gives
it. A question raised and not yet answered is recorded
as unanswered, saying so plainly if the work proceeded anyway — that is a
finding, and the reason the field exists at all.
