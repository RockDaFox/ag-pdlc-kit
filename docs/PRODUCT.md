# Product — A-PDLC Kit

> Product document: what A-PDLC Kit does and why, as delivered. **Written
> 2026-09-14 alongside the first version of the plugin, revised 2026-09-15** —
> not by reading the code and history, which did not exist yet. The sections
> describe what ships; the gap between intent and delivered is for a later
> revision to close. Nothing here is a requirement addressed to work still to
> come.
>
> Design decisions for the two skills live in the specs:
> [`specs/pdlc-feature.md`](specs/pdlc-feature.md) and
> [`specs/pdlc-init.md`](specs/pdlc-init.md). Structural decisions live
> in [`adr/`](adr/). Repository conventions are in [`AGENTS.md`](../AGENTS.md).
> This document repeats none of them.
>
> Drafted with an AI assistant — review before sharing outside the team.

## 1. Executive summary

A-PDLC Kit installs a documentation discipline on a code repository, and ships
the skills that keep it alive. It runs on Claude Code and on GitHub Copilot,
from a single set of files.

It is internal tooling, not a deliverable: it is not sold, licensed or handed
to anyone outside the organisation. The repositories it documents are another
matter — engagement repositories are in scope — which is why nothing it ships
carries an example borrowed from a real project, and why every document it
generates says it was AI-drafted.

The problem it addresses: a coding agent has the code, never the reasons. Git
history records what changed, not what was decided nor what was rejected;
comments rot; the deliberation behind a feature dies in the conversation where
it happened. The observable consequence on any repository of moderate age is
that settled questions get re-opened, options rejected for good reasons get
retried, and a bug that was deliberately fixed comes back.

The answer is four documents, each stating a thing **once**: `AGENTS.md` (how
the repo is written), `PRODUCT.md` (what the product does and why), `adr/`
(structural technical decisions, dated and never rewritten), `specs/` (a
feature's decisions, its rejected alternatives, its known gaps). The
stated-once rule is the central invariant: a sentence that could sit in two
files sits in one, and the others link to it.

The second invariant is that **records are written forward**. What is readable
from the code — state — can be generated at any time. What is not — why one
option won over another — is only recorded at the moment it is decided.
A-PDLC Kit never backfills
([ADR-0004](adr/0004-decision-records-are-written-forward.md)).

Implementation status in 0.2.0: two skills — `pdlc-init` (bootstrap) and
`pdlc-feature` (record) — four templates, and one shared discipline reference.
No executable code: the product is Markdown plus two JSON manifests.

## 2. Users

- **The developer installing A-PDLC Kit** on an existing repository. They run
  `pdlc-init` once, read what came out, correct it, commit it.
- **The coding agent** that works on the repository afterwards. It is the
  first reader of the four documents, and the reason they are structured
  rather than narrative.
- **The human newcomer**, reading the same files for the same reasons.

No roles, no accounts, no notion of a team in the product: A-PDLC Kit is a
set of files in a repository.

## 3. Functional behavior

### 3.1 Bootstrap documentation on an existing repository

The `pdlc-init` skill reads a repository's code and git history, then
writes `AGENTS.md` and `PRODUCT.md`. It describes what is actually delivered,
never what an old ticket announced.

It writes no ADR and no spec. Those record decisions, and a repository does
not preserve decisions — it preserves the surviving choice and destroys the
alternatives. Structural choices visible in the code are state, and state goes
in `AGENTS.md`.

Three guardrails are part of the behavior, not of the implementation:

- **Nothing is overwritten.** An existing `AGENTS.md` or product document —
  under any name — is read and a merge is proposed; the user arbitrates.
- **No empty directories.** `adr/` and `specs/` are created by their first
  record.
- **The unknowns are reported.** The skill ends by listing, separately, what
  it could not establish and what needs a human — including anything written
  from inference rather than evidence. That list is an expected output, not a
  failure.

### 3.2 Record a feature's decisions

The `pdlc-feature` skill takes an informal request and builds it, keeping the
record of what it decides. The sequence: read the repo, list the open points,
ask in as few rounds as possible, recap scope and non-goals, **wait for an
explicit go-ahead**, implement, then write the spec — decisions taken,
alternatives rejected with their reason, known gaps — in the same change as
the code.

The value is in the timing: the clarification round is the only moment at
which the rejected alternatives still exist. Once the feature ships, only the
surviving option feels real, and any later reconstruction is fiction.

When a decision reaches beyond the feature, it becomes an ADR instead of a
spec entry. The three arbitration tests — scope, reversal cost, lifetime — are
stated once, in the discipline reference.

### 3.3 Ship the skeletons

Four templates (`AGENTS.md`, `PRODUCT.md`, `adr.md`, `spec.md`) bundled with
the skills and read at runtime. They are commented skeletons, not tutorials:
the discipline is stated once, in the reference beside them.

The product-level template is `PRODUCT.md`, not `PRD.md`, and its sections are
descriptive: present indicative, shipped behavior, and no section titled
"requirements" anywhere
([ADR-0005](adr/0005-product-document-is-descriptive.md)).

### 3.4 Adapt to a repository that already uses `docs/`

The documentation root defaults to `docs/`. A repository where that directory
is taken puts A-PDLC Kit elsewhere and records it in `AGENTS.md`, in one
line. No configuration file is created
([ADR-0002](adr/0002-docs-root-without-config-file.md)).

### 3.5 Run on more than one host

The same `skills/` tree serves Claude Code and GitHub Copilot. Nothing in it
is host-specific: bundled files are reached by paths relative to the skill's
own directory, and no host-provided variable is used. Both hosts have a plugin
marketplace and both install the repository whole; only the location of the
manifest pair differs
([ADR-0003](adr/0003-provider-neutral-skills-layout.md)).

There is exactly one copy of every instruction. A per-provider copy, however
it is generated, is the failure this rule exists to prevent.

## 4. Constraints

- **No executables.** No build, no dependency, no runtime, no script run on
  the user's machine. This is deliberate and keeps the kit cheap to audit
  before it is installed on a repository someone else owns. It also rules out
  the obvious solution to multi-provider support, which is a sync script.
- **A-PDLC Kit does not act, it instructs.** Everything it produces goes
  through the model, and therefore through the user's validation at the
  checkpoints the skills define.
- **Every generated document carries the AI-assistance notice** and a reminder
  to review before sharing with a third party.

## 5. Out of scope

| Left out | Add it when |
|---|---|
| Backfilling decisions on an existing repository | Never, by design ([ADR-0004](adr/0004-decision-records-are-written-forward.md)). A human who remembers the alternatives may still write the record by hand |
| Doc-versus-code drift detection | The two skills have enough mileage to tell a real false positive from noise. An audit that cries wolf is ignored within a fortnight |
| Hooks reminding to update a spec | Forgetting happens often enough to justify the noise |
| A blocking pre-commit check | Never, barring an explicit request from a team that wants it |
| API or code-reference documentation generation | Never: that level is produced by language tooling, not by a decision discipline |
| Hosts beyond Claude Code and Copilot | One is actually used. Others reading the same `SKILL.md` format will likely work already; none is claimed until tested |
| A check that the four manifests agree | Releasing gets missed often enough to matter. It would need executable code, so it would need ADR-0003 revisited |
