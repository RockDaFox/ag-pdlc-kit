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

Implementation status in 0.3.1: three skills — `pdlc-init` (bootstrap),
`pdlc-feature` (record a decision that arrives with code) and `pdlc-decide`
(record one that does not) — four templates, and a shared reference in three
files, each skill loading only the ones it uses
([ADR-0010](adr/0010-shared-reference-split-by-need.md)). The product itself
is Markdown plus two JSON manifests and installs
nothing executable; the repository carries one maintainer-side check script,
which is not product surface and which no skill invokes
([ADR-0008](adr/0008-one-maintainer-side-check-script.md)).

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
  under any name — is read and a merge is proposed; the user arbitrates. An
  `AGENTS.md` already written as a behavioral agent contract is a recognised
  case: the two shapes cover complementary halves of the `AGENTS.md`
  convention's six zones, so the merge keeps both rather than choosing
  ([ADR-0007](adr/0007-agents-md-follows-the-cross-vendor-convention.md)).
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

The question round also establishes whether the feature touches personal,
health or payment data. That is asked as a question of fact; which regime
governs the answer is not the product's judgment to make. A yes fills the
spec's Regulated data section with five fields — date, trigger, the function
consulted, the answer, and where it is recorded — and an escalation still
outstanding at the go-ahead is recorded as unanswered rather than blocking the
work or vanishing.

### 3.3 Record a decision that produces no code

The `pdlc-decide` skill records a decision taken outside an implementation: a
technical foundation chosen before anything is built, an architecture approved
before work is split, a boundary drawn, a dependency the repository agrees to
carry. Those have no commit to ride along on, which is why they went
unrecorded before this skill existed.

It routes the decision with the same three tests, interviews for what the
record needs and the user has not supplied, and writes an ADR, a spec entry,
or a line in `AGENTS.md` when the decision turns out to be state. Three
behaviors are the point rather than the implementation:

- **The alternatives come from the user.** Anything they cannot answer is
  recorded as unanswered. A decision being reconstructed from the code is
  declined and redirected to `AGENTS.md`, because that is the request that
  produces a plausible invented record.
- **It records, it does not decide.** Asked for a recommendation, it gives one
  as analysis and writes nothing until the user has chosen.
- **It performs supersession**, which the discipline states as a rule and
  nothing previously carried out: the new ADR gains `Supersedes`, the old one
  gains a `Status` line and keeps every other word. Whether the old ADR is a
  record or still a draft is established from git, not from its date.

### 3.4 Ship the skeletons

Four templates (`AGENTS.md`, `PRODUCT.md`, `adr.md`, `spec.md`) bundled with
the skills and read at runtime. They are commented skeletons, not tutorials:
the discipline is stated once, in the reference beside them.

The product-level template is `PRODUCT.md`, not `PRD.md`, and its sections are
descriptive: present indicative, shipped behavior, and no section titled
"requirements" anywhere
([ADR-0005](adr/0005-product-document-is-descriptive.md)).

The `AGENTS.md` template carries the cross-vendor convention's six zones in
its order — commands, testing, project structure, code style, git workflow,
boundaries — opens with a statement of the agent's role, and targets 150 lines
([ADR-0007](adr/0007-agents-md-follows-the-cross-vendor-convention.md)). That
budget is measured — `wc -l` on the file — and the count reported, never
estimated: it is what decides whether the file splits into nested files. The
spec template carries the Regulated data section, deleted when it does not
apply rather than left empty.

### 3.5 Adapt to a repository that already uses `docs/`

The documentation root defaults to `docs/`. A repository where that directory
is taken puts A-PDLC Kit elsewhere and records it in `AGENTS.md`, in one
line. No configuration file is created
([ADR-0002](adr/0002-docs-root-without-config-file.md)).

### 3.6 Run on more than one host

The same `skills/` tree serves Claude Code and GitHub Copilot. Nothing in it
is host-specific: bundled files are reached by paths relative to the skill's
own directory, and no host-provided variable is used. Both hosts have a plugin
marketplace and both install the repository whole; only the location of the
manifest pair differs
([ADR-0003](adr/0003-provider-neutral-skills-layout.md)).

There is exactly one copy of every instruction. A per-provider copy, however
it is generated, is the failure this rule exists to prevent.

The same reasoning governs how much of the shared reference a skill loads. It
is three files — what every skill needs, what a skill writing `AGENTS.md` or
`PRODUCT.md` needs, what a skill writing a decision record needs — and a
skill names the ones it uses
([ADR-0010](adr/0010-shared-reference-split-by-need.md)). An agent's context
is the scarce resource: instructions loaded and never applied are paid for on
every invocation, and they displace the repository being documented.

## 4. Constraints

- **The product installs nothing and runs nothing.** No build, no dependency,
  no runtime, and nothing written into a repository it documents is
  executable. This keeps the kit cheap to audit before it is installed on a
  repository someone else owns, and it rules out the obvious solution to
  multi-provider support, which is a sync script. What it never forbade is an
  agent running a command to read a repository — `pdlc-init` has always used
  `git log`. This repository carries one maintainer-side script that checks
  its own documents; it ships inert, no skill invokes it, and it never runs on
  a documented repository
  ([ADR-0008](adr/0008-one-maintainer-side-check-script.md)).
- **A-PDLC Kit does not act, it instructs.** Everything it produces goes
  through the model, and therefore through the user's validation at the
  checkpoints the skills define.
- **Every generated document carries the AI-assistance notice** and a reminder
  to review before sharing with a third party.
- **The product gives no legal, financial or regulatory reading.** It
  establishes whether a feature touches regulated data, names the function
  that answers, and records the answer. Which regime applies, and what it
  demands, is not something any skill here asserts.
- **`AGENTS.md` conforms to a convention the product does not control**
  ([ADR-0007](adr/0007-agents-md-follows-the-cross-vendor-convention.md)). If
  the convention's zones or its length guidance move, the template and the
  reference are wrong until someone notices; nothing watches for it.

## 5. Out of scope

| Left out | Add it when |
|---|---|
| Backfilling decisions on an existing repository | Never, by design ([ADR-0004](adr/0004-decision-records-are-written-forward.md)). A human who remembers the alternatives can have `pdlc-decide` interview them and write the record; what it will not do is supply the alternatives itself |
| Doc-versus-code drift detection | The two skills have enough mileage to tell a real false positive from noise. An audit that cries wolf is ignored within a fortnight |
| Hooks reminding to update a spec | Forgetting happens often enough to justify the noise |
| A blocking pre-commit check | Never, barring an explicit request from a team that wants it |
| API or code-reference documentation generation | Never: that level is produced by language tooling, not by a decision discipline |
| Hosts beyond Claude Code and Copilot | One is actually used. Others reading the same `SKILL.md` format will likely work already; none is claimed until tested |
| A consistency check running on a documented repository | Never as product surface: it would execute on a machine the product does not own. This repository checks its own documents with maintainer tooling that ships inert and that no skill invokes ([ADR-0008](adr/0008-one-maintainer-side-check-script.md)) |
