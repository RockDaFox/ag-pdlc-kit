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

## `PRODUCT.md` is descriptive, not prescriptive

It states what the product does **today**, in the present indicative, and it
is written from the code rather than from intent. It holds no requirement
addressed to work still to come: a requirement is a demand made of a system
that does not exist yet, and the same sentence, once shipped, is a
description. A section written in the future or the conditional tense belongs
in a ticket.

Hence the name. `PRD.md` denotes a product *requirements* document — written
before the build, prescriptive, an input to engineering — which is the
opposite genre, and a name many organisations already use for exactly that.
A repository whose product team owns real PRDs keeps them where they are;
`PRODUCT.md` does not compete with them and does not replace them.

The word "requirements" therefore does not appear as a section title. What
shapes the product without being behavior — volume, latency, availability,
regulatory obligations, supported environments — is a **constraint**, and says
so.

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

An ADR is **append-only**. When a structural decision is reversed, the old ADR
keeps its text and gains `Status: Superseded by ADR-0012`; the new one carries
`Supersedes ADR-0004` and says what changed and why. Rewriting an ADR in place
destroys the only record of why the previous choice looked right at the time —
which is the entire point of keeping them.

Append-only starts at the commit. An ADR still in the working tree is a draft
and may be corrected freely; once it is pushed, someone may have read it and
it is a record. Superseding a draft written an hour ago documents nothing but
the writing of it.

A spec has no such constraint: it describes the feature as it stands today, and
it is rewritten whenever the feature changes. A spec that rests on an ADR links
to it rather than restating the reasoning.

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
