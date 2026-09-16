# ADR-0012 — A spec is written before the implementation it governs, and reconciled with what shipped

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-16 |
| **Supersedes** | — |

## Context

`pdlc-feature` wrote the spec at the end of its flow, after the code. Writing it before was weighed on 2026-09-15 and rejected, and the reason recorded in that skill's spec was sound: decisions still move during implementation, and a spec written from the plan documents the plan rather than the system.

That reason rested on a premise that no longer holds. At the time, a spec had exactly one consumer — the person or agent reading the repository later — and for that consumer, only the final state matters. The kit's scope has since widened from a documentation discipline to the toolbox of the agentic developer, which gives a spec a second consumer: the build itself. An agent about to write a test needs the behavior, the non-goals and the rejected options as input, on disk, re-readable mid-task. Nothing in the kit provided that.

Two observations made the ordering worth re-deciding rather than reaffirming.

The recap at step 4 already held what a spec holds — behavior, explicit non-goals, files touched, which decisions are being taken — and it was discarded once the user answered. The kit was producing the artefact and throwing it away, then reproducing it from memory an hour later.

And a spec written only at the end preserves the final state alone. What moved during implementation — a decision revised because a test proved an assumption wrong — left no trace at all, although it is the most informative thing a session produces: it is a rejected alternative with evidence attached, which is stronger than one rejected in discussion.

## Decision

**A feature's spec is written at the go-ahead, and it is what the user gives the go-ahead on.** It replaces the recap rather than joining it: same content, in `{docs_root}/specs/<feature>.md` instead of in a message. The build reads it as its context, and the tests derive from the behavior it states.

**It is committed at the go-ahead, carrying `Status: Draft`.** A contract that survives only in a session is no contract: the session ends, a second agent picks the work up, the work is resumed tomorrow. The cost — a commit in the history describing behavior that does not exist yet — is paid explicitly by the `Status` row rather than left for a reader to discover.

**It is reconciled with what shipped, in the same change as the code, and its `Status` becomes `Shipped`.** This is what answers the 2026-09-15 objection: the document that lands with the code describes the system, not the plan. Where the two differ, the difference is recorded — the decision as drafted, what the implementation showed, and which one the code now follows. That entry is the point of the two-moment shape, not a side effect of it.

**An ADR is not written at the go-ahead.** Immutability starts at the commit ([ADR-0011](0011-append-only-binds-the-decision.md)), so committing an ADR draft would freeze a decision that can still move, and leave supersession as the only route out of a wording chosen before the work was done. An ADR arising from a feature is written when what it decides is settled, which is with the code. `PRODUCT.md` is unaffected for the same reason in reverse: it describes shipped state, so it is written at ship.

## Alternatives weighed

- **Keep the spec after the implementation** — rejected: it leaves the build with no durable input, and it keeps the kit generating the recap and discarding it. It was the right choice while the spec had one consumer, and the record of why is in `pdlc-feature`'s spec, which is rewritten in place rather than deleted.
- **Write the spec before and treat it as final** — rejected, and this is the variant the 2026-09-15 reasoning genuinely defeats. A spec that is never reconciled documents the plan, and worse, it documents it with the authority of a record.
- **Keep the recap as a message and let the build work from that** — rejected: it is not re-readable mid-build, it does not survive the session, and it cannot be handed to a second agent. Its one advantage is that it commits nothing, which the `Status` row buys more cheaply.
- **Write the spec before but leave it uncommitted until the code lands** — rejected: a cleaner history, and consistent with ADR-0011 without adding anything to it, but the draft is then lost with the session and transmissible to nobody. The handoff is the reason the spec moved earlier in the first place.
- **Write the ADR at the go-ahead too, for symmetry** — rejected: see the Decision. Symmetry here would cost the ability to change a decision that is still being made.
- **Let the user choose the commit boundary per feature** — rejected: one more question in a flow that already has a question round, for an arbitration that would be answered the same way nearly every time.

## Consequences

- The history contains commits that describe unshipped behavior. Anyone reading the repository at such a commit sees a spec marked `Draft`, and nothing else distinguishes it.
- A feature now takes at least two commits. Work abandoned after the go-ahead leaves a `Draft` spec in the tree, and nothing removes it or notices it is stale.
- The spec template gains a `Status` row, so the three specs already in this repository get one. They are `Shipped`, and they were written after their implementations — this decision does not rewrite that history, it only starts applying from the next feature.
- `scripts/check.sh` does not verify the `Status` row, nor that a `Shipped` spec was reconciled rather than merely relabelled. The discipline holds by agreement, as most of it does.
- A spec on disk before the code exists can be read by the build as authority rather than as a contract under test. The counterweight belongs to the build loop — a repository that contradicts the spec stops the work and returns for a new go-ahead — and it is stated there, not here.
- The go-ahead now costs a file write before the user has approved anything. A user who declines has a spec file to discard; that is cheaper than the alternative and it is not free.

---

Drafted with an AI assistant — review before treating as authoritative.
