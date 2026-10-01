# The four-level discipline

Four documents, each stating a thing **once**. A sentence that belongs in two
of them belongs in exactly one, and the others link to it.

```
AGENTS.md                         how the repo is written
{docs_root}/
├── PRODUCT.md                    what the product does, and why
├── adr/
│   └── NNNN-<title>.md           a structural technical decision, dated, immutable
└── specs/
    └── <feature>.md              what a feature decides, living
```

## `{docs_root}`

`{docs_root}` is the repository's documentation root. It is `docs/` unless
that directory is already taken by something else — a published documentation
site, generated API references — in which case it is whatever the repo uses
instead (`documentation/`, `doc/`, `.docs/`).

Resolve it in this order:

1. The Documentation section of `AGENTS.md`, if it names one.
2. An existing directory matching the layout above.
3. `docs/`.

A repo that deviates from `docs/` states it in `AGENTS.md`, in one line. That
file already records how the repo is written and is already the first thing
read; **no second configuration file exists, and none should be invented.**

`{docs_root}` is notation for these instructions. A document written into a
target repository carries the resolved path, never the placeholder.

## Which file

| File | Answers | Lifetime |
|---|---|---|
| `AGENTS.md` | How this repo is written — commands, conventions, traps, and `{docs_root}` when it is not `docs/`. | Changes when a rule becomes repo-wide. |
| `{docs_root}/PRODUCT.md` | What the product does, and why, as delivered. | Changes when behavior visible to a user changes. |
| `{docs_root}/adr/NNNN-*.md` | Why the system rests on *this* technical foundation, and what was weighed against it. | **Never rewritten.** Superseded by a later ADR. |
| `{docs_root}/specs/<feature>.md` | What was decided for this feature, what was rejected, what is knowingly missing. | Rewritten in place when a decision changes. |

The routing test, applied to any sentence you are about to write:

- *"What does this app do?"* → `PRODUCT.md`.
- *"Why this database / this auth / this runtime, and what else was weighed?"*
  → an ADR.
- *"Why does this feature behave like that, and what else was considered?"* →
  a spec.
- *"How do I write code here without breaking things?"* → `AGENTS.md`.

A spec that explains how to write a handler, how a component is wired, or how
the framework behaves is in the wrong file — that belongs in `AGENTS.md`, or in
a comment beside the code it surprises.

## Two companion files, read when they are needed

This file holds what every skill needs. What only some need sits beside it, so
that no session pays for instructions it will not use:

- [`state-documents.md`](state-documents.md) — the cross-vendor convention
  `AGENTS.md` follows, its 150-line budget, and why `PRODUCT.md` is
  descriptive rather than prescriptive. Read it before writing or
  restructuring either file.
- [`decision-records.md`](decision-records.md) — the ADR-or-spec routing
  tests, append-only and supersession, and the regulated-data record. Read it
  before writing either kind of record.

## Records are written forward, never backwards

`AGENTS.md` and `PRODUCT.md` describe **state**, so they can be written at
any time from the code: what the repo contains is readable today.

ADRs and specs record **decisions** — what was weighed, what was rejected, why
one option won — and none of that survives in a repository. The code shows the
surviving choice and nothing else. So the decision log starts on the day
A-PDLC Kit is installed and only grows forward; nothing is backfilled.

A structural choice already visible in the code is not a missing ADR. It is
state, and it belongs in the Architecture or Traps section of `AGENTS.md`. It
becomes an ADR only the day someone decides to change it — and that ADR
records the new decision, not the old one.

This is not a limitation to work around. A reconstructed decision record reads
exactly like a genuine one and is trusted exactly as much, while its
Alternatives section is invention. One of those in a repository poisons every
other record in it.

## Writing rules

These apply to all four levels.

- **Present indicative.** Describe what the system does. Not "add a constant",
  "flag in review", "we should" — those are leftover task notes, and they read
  as false the moment the work is done. (An ADR's Context section is the one
  place the past tense is legitimate: it records the situation at decision
  time.)
- **The rule and its reason, not the mechanics.** "Cancelling an order releases
  the reserved stock, because the reservation is written at checkout and not at
  payment" belongs in a spec; which callback fires it does not.
- **Name files and symbols, never `file:line`.** Line numbers rot within a
  commit or two and then quietly mislead.
- **A repo-wide trap is a repo-wide rule.** A framework trap that will bite
  again goes in `AGENTS.md`, not in the spec of whichever feature happened to
  hit it first.
- **A failed attempt is not a decision.** Only the decision it produced is
  worth keeping.
- **Rejected alternatives carry their reason.** "One screen with a client-side
  toggle, rather than two routes — a second navigation is not worth paying for
  a choice between two short forms." Without the reason, the next reader
  re-litigates it.
- **Known gaps are stated, with their trigger.** What was left out, and the
  condition under which it should be added. A gap nobody wrote down comes back
  as a bug report.

## Plain wording

The reader is a teammate who was not in the session, and reads each sentence
once. A document that needs a second reading to be understood has not done its
job, however accurate it is.

- **One idea per sentence, 25 words at most.** No chain of clauses joined by
  semicolons or dashes. A sentence that needs a second reading is split in two.
- **A verb for the action, not a noun built from it.** "The service retries
  the payment", not "retrying of the payment is performed by the service".
- **The common word.** "Use", "so", "because" — not "leverage", "in order to",
  "ensures that".
- **What happens, not an image for it.** "A stale entry is served after the
  update", not "the cache drifts".
- **The rule first, its reason in one clause after it.** How the decision was
  reached is not part of it. An option that was weighed and lost goes in
  Rejected alternatives, in one line.

## Language

Write in the language the repository already documents in — check existing
`README.md`, `PRODUCT.md`, or commit messages before choosing. If the repo
has no prose yet, ask. Section headings follow the language of the body; the
templates ship in English and are meant to be translated, not obeyed
literally.

## Drift

A change that alters behavior a document describes updates that document **in
the same change**. A spec that no longer matches the code is worse than no
spec: it is read with the same trust and it is wrong. The ADR exception is not
an exception to this rule — a superseded ADR is still accurate about the past,
and its `Status` line says so.

## AI-assisted authoring

A document written or revised with an AI assistant carries a line saying so,
and a reminder that it needs review before it goes to a third party. Keep the
line in the document header, not buried at the bottom.

**The line stays until a human has read the document, and removing it is that
review.** So a document still carrying it is one nobody has checked, which is
the only thing the line is good for. Kept on every document forever, it
distinguishes nothing and is skipped as boilerplate.

**For an ADR, that review happens before the commit, and removing the line is
part of it.** A record is immutable once committed, so the line has to go while
the file is still a draft — a human validates the record, strips the notice,
then commits. A notice found on a committed ADR stays, in the same position as
a typo found on one.
