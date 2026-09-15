# A-PDLC Kit

How this repository is written. What the product does is in
[`docs/PRODUCT.md`](docs/PRODUCT.md); why it is built this way is in
[`docs/adr/`](docs/adr/); what each skill decides is in
[`docs/specs/`](docs/specs/). This file repeats none of it.

## Commands

```
sh scripts/check.sh
```

Run it before committing. It checks what breaks silently: a manifest
disagreeing with its three siblings, a supersession recorded on one side only,
a skill no host can discover, a link that stopped resolving, a heading written
twice. It reports, never fixes, and writes nothing.

Prefer it to verifying by hand — its output is two tokens, reading the files it
reads is several thousand. It is maintainer tooling: no skill invokes it and
none ever will
([ADR-0008](docs/adr/0008-one-maintainer-side-check-script.md)).

There is nothing else to run — no build, no dependencies, no test suite.

To exercise a change, install from a local checkout and start a new session —
both hosts install the same tree through their own marketplace:

```
/plugin marketplace add <absolute path to this repository>
/plugin install a-pdlc-kit@a-pdlc-kit
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
├── marketplace.json
└── plugin.json
skills/
├── _pdlc-shared/            discipline reference + templates; not a skill
├── pdlc-init/SKILL.md       one directory per skill, named exactly SKILL.md
├── pdlc-feature/SKILL.md
└── pdlc-decide/SKILL.md
scripts/check.sh             maintainer tooling; no skill invokes it
AGENTS.md, docs/             this repository's own documentation
```

Adding a host means adding a manifest pair. It never means copying anything
out of `skills/`.

`skills/` is the product. Everything else is packaging or documentation.

`_pdlc-shared/` has no `SKILL.md`, so no host discovers it as a skill. The
three skills reach it by relative path, which resolves the same whether the
tree sits in a Claude Code plugin directory or under `~/.agents/skills/`.

Because the plugin root is the repository root, `AGENTS.md` and `docs/` ship
with the product. That is intended: an installed A-PDLC Kit carries a worked
example of the format it asks for.

## Documentation

Four levels, each stating a thing once:

- [`AGENTS.md`](AGENTS.md) — this file: how the repo is written.
- [`docs/PRODUCT.md`](docs/PRODUCT.md) — what the product does and why, as
  delivered. Descriptive, not a requirements document
  ([ADR-0005](docs/adr/0005-product-document-is-descriptive.md)).
- [`docs/adr/`](docs/adr/) — structural technical decisions, dated and
  append-only. An ADR is never rewritten; a later one supersedes it.
- [`docs/specs/`](docs/specs/) — per-skill decisions, rejected alternatives
  and known gaps. Living documents, rewritten when the skill changes.

The full discipline is in
[`skills/_pdlc-shared/doc-discipline.md`](skills/_pdlc-shared/doc-discipline.md).
This repository follows the discipline it distributes, so that file is both
the product and the rule this repo is held to.

Documentation is written in English, including the specs and ADRs.

A change to a skill's behavior updates its spec in the same change. A change
to the discipline reference is a change to the product, and shows up in
`docs/PRODUCT.md` or an ADR.

## Code style

- **Nothing under `skills/` may be host-specific.** No `${CLAUDE_PLUGIN_ROOT}`,
  no `.github/` path, no assumption about where the tree is installed.
  Bundled files are reached by paths relative to the skill's own directory —
  that is the one idiom that works on every host
  ([ADR-0003](docs/adr/0003-provider-neutral-skills-layout.md)).
- **Examples are invented, never borrowed.** Nothing under `skills/` may
  contain an example taken from a real project — not a domain term, not a
  table name, not a file path. The kit is internal, but it is installed on
  repositories that carry client context; a leaked example is a
  confidentiality problem before it is a style problem. Generic, plausible,
  made up.
- **`{docs_root}` is the placeholder for the documentation root** in skill
  instructions, defined once in the discipline reference
  ([ADR-0002](docs/adr/0002-docs-root-without-config-file.md)). Documents
  written into a target repository carry the resolved path.
- **The product-level document is `PRODUCT.md`, and "requirements" is never a
  section title.** It describes shipped behavior in the present indicative;
  what shapes the product without being behavior is a constraint
  ([ADR-0005](docs/adr/0005-product-document-is-descriptive.md)).
- **An `AGENTS.md` this product writes follows the cross-vendor convention**
  — six zones in its order, a role statement, 150 lines
  ([ADR-0007](docs/adr/0007-agents-md-follows-the-cross-vendor-convention.md)).
  The convention is stated once in the discipline reference; the skills apply
  it and do not restate it. Note this repository's own `AGENTS.md` does not
  follow that order yet — reshaping it is a separate change.
- **Templates are commented skeletons, not tutorials.** Guidance inside a
  template is an HTML comment, short, and about what goes in the section — not
  about why the discipline exists. That is stated once, in the reference.
- **Skills link to the reference rather than restating it.** A rule that
  appears in two skills has to move into the reference; two copies drift.
- **Prose is not hard-wrapped.** A paragraph is one line; the editor wraps it
  for display ([ADR-0009](docs/adr/0009-prose-is-not-hard-wrapped.md)). Files
  written before that decision are still wrapped at 79 columns and stay that
  way — an edit inside one of them keeps the file's own wrapping, because a
  file mixing both styles reads worse than either. A new file is not wrapped.
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
  Renaming touches all four; releasing touches both `plugin.json`. Nothing
  checks that they agree.
- **`_pdlc-shared/` is reached by relative path.** A host that loads a
  `SKILL.md` without its surrounding directory leaves both skills with dead
  links and no error.

## Deployment

None. Distribution is the git repository itself. Bump `version` in both
`plugin.json` files for a release.

An ADR in the working tree is a draft and may be corrected. Once it is
pushed, it is a record: supersede it, never edit it.
