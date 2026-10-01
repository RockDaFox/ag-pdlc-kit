# Product — A-PDLC Kit

> Product document: what A-PDLC Kit does and why, as delivered. **Written
> 2026-09-14 alongside the first version of the plugin, revised 2026-09-16** —
> not by reading the code and history, which did not exist yet. The sections
> describe what ships; the gap between intent and delivered is for a later
> revision to close. Nothing here is a requirement addressed to work still to
> come.
>
> Design decisions for a skill live in its spec, under [`specs/`](specs/).
> Structural decisions live in [`adr/`](adr/). Repository conventions are in
> [`AGENTS.md`](../AGENTS.md). This document repeats none of them.

## 1. Executive summary

A-PDLC Kit is the toolbox of the agentic developer: the skills a team invokes
to work with a coding agent on a real repository, from one set of files that
runs on both Claude Code and GitHub Copilot.

It is internal tooling, not a deliverable: it is not sold, licensed or handed
to anyone outside the organisation. The repositories it documents are another
matter — engagement repositories are in scope — which is why nothing it ships
carries an example borrowed from a real project, and why every document it
generates says it was AI-drafted.

The first family of tools in it installs a documentation discipline and keeps
it alive, because that is the gap that bites first: a coding agent has the
code, never the reasons. Git history records what changed, not what was decided
nor what was rejected; comments rot; the deliberation behind a feature dies in
the conversation where it happened. The observable consequence on any
repository of moderate age is that settled questions get re-opened, options
rejected for good reasons get retried, and a bug that was deliberately fixed
comes back.

That discipline is four documents, each stating a thing **once**:
`AGENTS.md` (how the repo is written), `PRODUCT.md` (what it does and why), `adr/`
(structural technical decisions, dated and never rewritten), `specs/` (a
feature's decisions, its rejected alternatives, its known gaps). The
stated-once rule is the central invariant: a sentence that could sit in two
files sits in one, and the others link to it.

The second invariant is that **records are written forward**. What is readable
from the code — state — can be generated at any time. What is not — why one
option won over another — is only recorded at the moment it is decided.
A-PDLC Kit never backfills
([ADR-0004](adr/0004-decision-records-are-written-forward.md)).

The discipline is the first family in the toolbox and not the whole of it: what
the kit is for is wider than what it currently ships. What ships is below and
in section 3; what is deliberately absent, with the condition that would bring
it in, is in section 5.

Implementation status: five skills — `pdlc-init` (bootstrap),
`pdlc-feature` (record a decision that arrives with code), `pdlc-decide`
(record one that does not), `pdlc-build` (carry out the work a spec
authorises, test-first) and `pdlc-review` (hold the result to a standard
before it is committed) — four templates, and a shared reference of four
files: three for the documentation discipline, each skill loading only the
ones it uses ([ADR-0010](adr/0010-shared-reference-split-by-need.md)), and one
for the build loop, read by `pdlc-build`, by `pdlc-feature` at its own step 6,
and by `pdlc-review` once corrections are selected. The product itself is
Markdown plus two JSON manifests and installs
nothing executable; the repository carries one maintainer-side check script,
which is not product surface and which no skill invokes
([ADR-0008](adr/0008-one-maintainer-side-check-script.md)).

## 2. Users

- **The developer installing A-PDLC Kit** on an existing repository. They run
  `pdlc-init` once, read what came out, correct it, commit it.
- **The coding agent** that works on the repository afterwards. It is both the
  first reader of the four documents — the reason they are structured rather
  than narrative — and what executes the skills: every tool in the kit is
  instruction addressed to it, not a program run beside it.
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
ask in as few rounds as possible, write the spec — decisions taken,
alternatives rejected with their reason, expected behavior, non-goals, known
gaps — and commit it as a draft, **wait for an explicit go-ahead on that
spec**, implement against it, then reconcile it with what shipped, in the same
change as the code.

The value is in the timing, twice over. The clarification round is the only
moment at which the rejected alternatives still exist: once the feature ships,
only the surviving option feels real, and any later reconstruction is fiction.
And a spec written before the work is the context the implementation and its
tests are written from, rather than an epilogue nobody reads
([ADR-0012](adr/0012-a-spec-precedes-the-implementation-it-governs.md)). The
spec is the artefact the go-ahead is given on; the divergences between it and
what actually shipped are recorded at the end, because a rejected alternative
carrying evidence outranks one rejected in discussion.

An ADR is not written early. A committed record is immutable
([ADR-0011](adr/0011-append-only-binds-the-decision.md)), so a decision that
can still move is not engraved before the work confirms it.

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

### 3.4 Build a spec, test-first

The `pdlc-build` skill turns a spec into code, tests and an evidence block.
It derives one test per behavior the spec states, writes it, runs it,
confirms it fails for the reason stated, implements against that failure,
returns to green, then runs the repository's lint, typecheck and build
commands and reports what ran, what it covered and what it left.

Two entry points reach that loop for a build, stated once in
`skills/_pdlc-shared/build-loop.md`: inside `pdlc-feature`, at its own step 6,
on the spec the go-ahead was just given on; and standalone, on a scope settled
elsewhere — a `Draft` spec committed earlier, a ticket, a bug with a known
cause. Standalone, the skill also routes what the build decided through the
scope, reversal-cost and lifetime tests and writes the spec entry or the ADR
they select; inside `pdlc-feature`, that reconciliation stays with that
skill's own step 7.

Test, lint, typecheck and build commands are discovered from the repository —
`AGENTS.md` or the task runner's manifest — never invented, which is the one
point where this skill's execution surface is wider than every other skill's
([ADR-0014](adr/0014-a-skill-may-run-discovered-repository-commands.md)). A
repository with no test suite gets a stated, executed verification instead of
an invented one.

The loop is performed rather than narrated: an expected red is the loop
working, so it is not announced as it happens and neither is what comes next.
Mid-loop output is reserved for a red for the wrong reason, a repository that
contradicts the spec, or a command that does not exist; everything else
reaches the user once, in the evidence block at the end.

### 3.5 Review a change before it is committed

The `pdlc-review` skill reads a diff and reports what an experienced tech
lead would raise on it: code quality, the repository's own conventions,
correct use of the libraries the change calls into, readability and
maintainability for a human, and whether the change stayed inside what its
spec authorised. It reports graded findings, asks which ones to apply, and
sends each one the user selected into the build loop, which is what changes
the code and what proves the change.

It is invoked on demand and nothing calls it automatically. A review before
a commit is the user's step to take, not a gate the product imposes —
section 5's refusal of a blocking pre-commit check is unchanged by this
skill existing.

Five behaviors are the point rather than the implementation:

- **It reviews against what the repository has written down.** The code
  style zone of `AGENTS.md` for the conventions, the governing spec for the
  scope the work was authorised against, and the dependency versions
  actually installed for how a library is meant to be used. It ships no
  quality checklist of its own, for the reason `pdlc-build` ships no
  command table. Sources the repository does not have are named as missing
  rather than passed over.
- **A library finding is grounded or it is marked unverified.** The
  installed version decides — manifest and lockfile, then the source, type
  definitions or docstrings in the tree, then that version's published
  documentation. A misremembered API produces the most confident wrong
  finding a model can emit, and it is indistinguishable from a grounded one
  unless the grounding is stated.
- **Findings are graded and one line each** — blocking, to fix, detail. The
  grade is the bar: a review that raises everything at equal weight is read
  once and skipped afterwards.
- **A substantive finding the user declines goes into the governing spec's
  Known gaps**, so it is not re-raised at every later review. Declined
  details leave nothing behind, and where no spec governs the change
  nothing is written.
- **A correction is applied through the build loop, never beside it**
  ([ADR-0015](adr/0015-review-corrections-enter-the-build-loop.md)). Each
  one is a unit of work there, exactly as a behavior the spec names is: a
  correction that changes behavior arrives with a test, one that changes
  none says it has nothing to assert, and the loop's closing steps run once
  over the set. The skill executes nothing on its own authority, so it adds
  no execution surface to the product.

The skill commits nothing. The review ends on a working tree, and the
commit stays with whoever owns it.

### 3.6 Ship the skeletons

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
apply rather than left empty. A spec stays within 200 lines, counted
with `wc -l` and reported. Every document is worded plainly: one idea
per sentence, the common word, the rule before its reason.

### 3.7 Adapt to a repository that already uses `docs/`

The documentation root defaults to `docs/`. A repository where that directory
is taken puts A-PDLC Kit elsewhere and records it in `AGENTS.md`, in one
line. No configuration file is created
([ADR-0002](adr/0002-docs-root-without-config-file.md)).

### 3.8 Run on more than one host

The same `skills/` tree serves Claude Code and GitHub Copilot. Nothing in it
is host-specific: bundled files are reached by paths relative to the skill's
own directory, and no host-provided variable is used. Both hosts have a plugin
marketplace and both install the repository whole; only the location of the
manifest pair differs
([ADR-0003](adr/0003-provider-neutral-skills-layout.md)).

There is exactly one copy of every instruction. A per-provider copy, however
it is generated, is the failure this rule exists to prevent.

The same reasoning governs how much of the shared reference a skill loads. The
documentation discipline is three files — what every skill needs, what a
skill writing `AGENTS.md` or `PRODUCT.md` needs, what a skill writing a
decision record needs — and a skill names the ones it uses
([ADR-0010](adr/0010-shared-reference-split-by-need.md)). The build loop is a
fourth, separate file for a separate concern, read by `pdlc-build`, by
`pdlc-feature` at its own step 6, and by `pdlc-review` only once the user has
selected corrections to apply. An agent's context is the scarce resource:
instructions loaded and never applied are paid for on every invocation, and
they displace the repository being documented.

## 4. Constraints

- **The product installs nothing executable.** No build, no dependency, no
  runtime, and nothing it writes into a repository it documents can be run.
  This keeps the kit cheap to audit before it is installed on a repository
  someone else owns, and it rules out the obvious solution to multi-provider
  support, which is a sync script. This repository carries one maintainer-side
  script that checks its own documents; it ships inert, no skill invokes it,
  and it never runs on a documented repository
  ([ADR-0008](adr/0008-one-maintainer-side-check-script.md)).
- **The commands a skill has an agent run are git's, plus — inside the build
  loop — the repository's own.** Reading a repository was never in question:
  `pdlc-init` has always used `git log`. Since
  [ADR-0012](adr/0012-a-spec-precedes-the-implementation-it-governs.md) a
  skill also has the agent commit — `pdlc-feature` commits the draft spec
  the go-ahead is given on, and the reconciled spec with the code.
  [ADR-0014](adr/0014-a-skill-may-run-discovered-repository-commands.md)
  widened the surface to a repository's own test, lint, typecheck and build
  commands, discovered from `AGENTS.md` or the task runner's manifest and
  never invented, and
  [ADR-0015](adr/0015-review-corrections-enter-the-build-loop.md) supersedes
  it to place that surface in the build loop rather than in a list of skills
  — `pdlc-build`, `pdlc-feature` at its own step 6 and `pdlc-review` all
  reach the same loop, and none of them executes anything outside it. The
  set is exhaustive; nothing else is executed, and nothing is executed
  without the user having approved the work it verifies.
- **A-PDLC Kit does not act, it instructs.** Everything it produces goes
  through the model, and therefore through the user's validation at the
  checkpoints the skills define.
- **Every generated document carries the AI-assistance notice** and a reminder
  to review before sharing with a third party. The notice stays until a human
  has read the document, and removing it is that review — so a document still
  carrying one has not been checked. On an ADR that review precedes the commit,
  because a committed record is immutable
  ([ADR-0013](adr/0013-notice-removed-by-the-review-before-commit.md)).
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
| Doc-versus-code drift detection | The skills have enough mileage to tell a real false positive from noise. An audit that cries wolf is ignored within a fortnight |
| Isolation for several agent tasks at once — a worktree per task | Agent sessions are actually run in parallel on one clone often enough to collide. The rule such a skill would carry is which seam the tasks are split along, not the git commands, which the hosts already run |
| Bounded-context scope fences and a per-context glossary | A repository the kit is installed on is genuinely structured in contexts, and an agent is caught inventing domain vocabulary a glossary would have refused |
| Hooks reminding to update a spec | Forgetting happens often enough to justify the noise |
| A blocking pre-commit check | Never, barring an explicit request from a team that wants it |
| API or code-reference documentation generation | Never: that level is produced by language tooling, not by a decision discipline |
| Hosts beyond Claude Code and Copilot | One is actually used. Others reading the same `SKILL.md` format will likely work already; none is claimed until tested |
| A consistency check running on a documented repository | Never as product surface: it would execute on a machine the product does not own. This repository checks its own documents with maintainer tooling that ships inert and that no skill invokes ([ADR-0008](adr/0008-one-maintainer-side-check-script.md)) |
