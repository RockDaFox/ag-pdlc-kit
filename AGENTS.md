# Ag-PDLC Kit

How this repository is written. What the product does is in
[`docs/PRODUCT.md`](docs/PRODUCT.md); why it is built this way is in
[`docs/adr/`](docs/adr/); what each skill decides is in
[`docs/specs/`](docs/specs/). This file repeats none of it.

## Commands

```
sh scripts/check.sh
```

Run it before committing, and prefer it to verifying by hand: its output is
two tokens where reading the same files is several thousand. It catches what
breaks silently — a manifest disagreeing with its three siblings, a
supersession recorded on one side only, a skill no host can discover, a dead
link, a heading written twice, an ADR about to be committed with its review
marker still on. It reports, never fixes, and writes nothing. No
skill invokes it and none ever will
([ADR-0008](docs/adr/0008-one-maintainer-side-check-script.md)).

```
sh scripts/bump-version.sh major|minor|patch|X.Y.Z
```

Bumps `version` in both `plugin.json` manifests together, refusing to run if
they already disagree — run `scripts/check.sh` first in that case.

Nothing else to run — no build, no dependencies, no test suite.

To exercise a change, install from a local checkout and start a new session —
both hosts install the same tree through their own marketplace:

```
/plugin marketplace add <absolute path to this repository>
/plugin install ag-pdlc-kit@ag-pdlc-kit
```

Components are discovered at session start, so a change needs a new session,
not a reinstall.

## Architecture

The repository root is the plugin, the content is host-neutral, and each host
gets a manifest pair pointing at the same tree
([ADR-0003](docs/adr/0003-provider-neutral-skills-layout.md)):

```
.claude-plugin/              Claude Code
├── marketplace.json         one plugin, sourced from "./"
└── plugin.json
.github/plugin/              GitHub Copilot — same two files, its own location
.vibe/                       Vibe — same two files, its own location
├── marketplace.json
└── plugin.json
skills/
├── _pdlc-shared/            four reference files + templates; not a skill
├── pdlc-init/SKILL.md       one directory per skill, named exactly SKILL.md
├── pdlc-feature/SKILL.md
├── pdlc-decide/SKILL.md
├── pdlc-build/SKILL.md
└── pdlc-review/SKILL.md
scripts/check.sh             maintainer tooling; no skill invokes it
scripts/bump-version.sh      maintainer tooling; no skill invokes it
AGENTS.md, docs/             this repository's own documentation
```

`skills/` is the product; everything else is packaging or documentation.
Adding a host means adding a manifest pair, never copying anything out of
`skills/`.

`_pdlc-shared/` has no `SKILL.md`, so no host discovers it as a skill. The
skills reach it by relative path, which resolves the same whether the tree
sits in a Claude Code plugin directory or under `~/.agents/skills/`.

## Documentation

Four levels, each stating a thing once:

- [`AGENTS.md`](AGENTS.md) — this file: how the repo is written.
- [`docs/PRODUCT.md`](docs/PRODUCT.md) — what the product does and why, as
  delivered; descriptive, not a requirements document
  ([ADR-0005](docs/adr/0005-product-document-is-descriptive.md)).
- [`docs/adr/`](docs/adr/) — structural decisions, dated and append-only:
  never rewritten, superseded by a later one.
- [`docs/specs/`](docs/specs/) — per-skill decisions, rejected alternatives
  and known gaps. Living documents, rewritten when the skill changes.

The discipline itself is in
[`skills/_pdlc-shared/`](skills/_pdlc-shared/): `doc-discipline.md` holds what
every skill needs, `state-documents.md` and `decision-records.md` hold what
only some do, so no session loads instructions it will not use
([ADR-0010](docs/adr/0010-shared-reference-split-by-need.md)). `build-loop.md`
holds the test-first loop, read by `pdlc-build`, by `pdlc-feature` at its own
step 6 and by `pdlc-review` once corrections are selected — never at the
start. This repository follows the discipline it
distributes, so those files are both the product and the rule this repo is
held to.

Documentation is in English, specs and ADRs included. A change to a skill's
behavior updates its spec in the same change; a change to a reference file is
a product change, and shows up in `docs/PRODUCT.md` or an ADR.

## Code style

- **Nothing under `skills/` may be host-specific.** No `${CLAUDE_PLUGIN_ROOT}`,
  no `.github/` path, no assumption about where the tree is installed.
  Bundled files are reached by paths relative to the skill's own directory —
  that is the one idiom that works on every host
  ([ADR-0003](docs/adr/0003-provider-neutral-skills-layout.md)).
- **Examples are invented, never borrowed.** No example from a real project
  anywhere under `skills/` — not a domain term, not a table name, not a file
  path. This tree is installed on repositories carrying client context, so a
  leaked example is a confidentiality problem before it is a style problem.
- **`{docs_root}` is the placeholder for the documentation root** in skill
  instructions ([ADR-0002](docs/adr/0002-docs-root-without-config-file.md)).
  A document written into a target repository carries the resolved path.
- **The product-level document is `PRODUCT.md`, and "requirements" is never a
  section title.** It describes shipped behavior in the present indicative;
  what shapes the product without being behavior is a constraint
  ([ADR-0005](docs/adr/0005-product-document-is-descriptive.md)).
- **An `AGENTS.md` this product writes follows the cross-vendor convention**
  — six zones in its order, a role statement, 150 lines
  ([ADR-0007](docs/adr/0007-agents-md-follows-the-cross-vendor-convention.md)),
  stated once in `state-documents.md`. This file does not follow that order
  yet.
- **Templates are commented skeletons, not tutorials.** Guidance inside a
  template is an HTML comment, short, and about what goes in the section — not
  about why the discipline exists. That is stated once, in the reference.
- **Skills link to the reference rather than restating it.** A rule that
  appears in two skills has to move into the reference; two copies drift.
- **Prose is not hard-wrapped**; a paragraph is one line
  ([ADR-0009](docs/adr/0009-prose-is-not-hard-wrapped.md)). Files written
  before that decision stay wrapped at 79 columns, and an edit inside one
  keeps that file's wrapping — a file mixing both reads worse than either.
- Kebab-case for every directory and file name except `SKILL.md`, `AGENTS.md`,
  `PRODUCT.md` and the manifests.
- ADR filenames are `NNNN-kebab-title.md`, numbered one above the highest
  existing file, and the number is never reused.

## Traps

- **Component directories live at the plugin root, not inside
  `.claude-plugin/`.** Only the manifests go there. A `skills/` directory
  nested under it is silently ignored.
- **A skill's entry file must be named `SKILL.md`.** A `README.md` in a skill
  directory is not discovered.
- **Four manifests, one name, two versions.** `.claude-plugin/` and
  `.github/plugin/` each hold a `marketplace.json` and a `plugin.json`.
  Renaming touches all four; releasing touches both `plugin.json`. The check
  script is what notices when they disagree.
- **`_pdlc-shared/` is reached by relative path.** A host that loads a
  `SKILL.md` without its surrounding directory leaves every skill with dead
  links and no error.
- **The two hosts' marketplace entries differ on purpose.** Copilot declares
  `skills` in its plugin entry, Claude Code discovers components from the
  plugin root. Aligning them is not a fix.

## Deployment

None. Distribution is the git repository itself. Bump `version` in both
`plugin.json` files for a release with `sh scripts/bump-version.sh`. The
manifests are where the version lives and the only place it appears: no
document restates it, because a number written twice is a number that drifts.
Committing an ADR is what makes it a record — before that it is a draft
([`decision-records.md`](skills/_pdlc-shared/decision-records.md)).
