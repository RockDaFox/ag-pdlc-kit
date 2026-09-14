# Croakness

How this repository is written. What the product does is in
[`docs/PRD.md`](docs/PRD.md); why it is built this way is in
[`docs/adr/`](docs/adr/); what each skill decides is in
[`docs/specs/`](docs/specs/). This file repeats none of it.

## Commands

There are none. The repository is Markdown and two JSON manifests — no build,
no dependencies, no tests to run.

To exercise a change, install from a local checkout and start a new session —
both hosts install the same tree through their own marketplace:

```
/plugin marketplace add <absolute path to this repository>
/plugin install croakness@croakness
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
├── _croakness-shared/       discipline reference + templates; not a skill
├── croakness-init/SKILL.md  one directory per skill, named exactly SKILL.md
└── new-feature/SKILL.md
AGENTS.md, docs/             this repository's own documentation
```

Adding a host means adding a manifest pair. It never means copying anything
out of `skills/`.

`skills/` is the product. Everything else is packaging or documentation.

`_croakness-shared/` has no `SKILL.md`, so no host discovers it as a skill. The
two skills reach it by relative path, which resolves the same whether the tree
sits in a Claude Code plugin directory or under `~/.agents/skills/`.

Because the plugin root is the repository root, `AGENTS.md` and `docs/` ship
with the product. That is intended: an installed Croakness carries a worked
example of the format it asks for.

## Documentation

Four levels, each stating a thing once:

- [`AGENTS.md`](AGENTS.md) — this file: how the repo is written.
- [`docs/PRD.md`](docs/PRD.md) — what the product does and why.
- [`docs/adr/`](docs/adr/) — structural technical decisions, dated and
  append-only. An ADR is never rewritten; a later one supersedes it.
- [`docs/specs/`](docs/specs/) — per-skill decisions, rejected alternatives
  and known gaps. Living documents, rewritten when the skill changes.

The full discipline is in
[`skills/_croakness-shared/doc-discipline.md`](skills/_croakness-shared/doc-discipline.md).
This repository follows the discipline it distributes, so that file is both
the product and the rule this repo is held to.

Documentation is written in English, including the specs and ADRs.

A change to a skill's behavior updates its spec in the same change. A change
to the discipline reference is a change to the product, and shows up in the
PRD or an ADR.

## Code style

- **Nothing under `skills/` may be host-specific.** No `${CLAUDE_PLUGIN_ROOT}`,
  no `.github/` path, no assumption about where the tree is installed.
  Bundled files are reached by paths relative to the skill's own directory —
  that is the one idiom that works on every host
  ([ADR-0003](docs/adr/0003-provider-neutral-skills-layout.md)).
- **Examples are invented, never borrowed.** Nothing under `skills/` may
  contain an example taken from a real project — not a domain term, not a
  table name, not a file path. Croakness is installed on client
  repositories; a leaked example is a confidentiality problem before it is a
  style problem. Generic, plausible, made up.
- **`{docs_root}` is the placeholder for the documentation root** in skill
  instructions, defined once in the discipline reference
  ([ADR-0002](docs/adr/0002-docs-root-without-config-file.md)). Documents
  written into a target repository carry the resolved path.
- **Templates are commented skeletons, not tutorials.** Guidance inside a
  template is an HTML comment, short, and about what goes in the section — not
  about why the discipline exists. That is stated once, in the reference.
- **Skills link to the reference rather than restating it.** A rule that
  appears in two skills has to move into the reference; two copies drift.
- Prose wraps at 79 columns. Kebab-case for every directory and file name
  except `SKILL.md`, `AGENTS.md`, `PRD.md` and the manifests.
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
- **`_croakness-shared/` is reached by relative path.** A host that loads a
  `SKILL.md` without its surrounding directory leaves both skills with dead
  links and no error.

## Deployment

None. Distribution is the git repository itself. Bump `version` in both
`plugin.json` files for a release.

An ADR in the working tree is a draft and may be corrected. Once it is
pushed, it is a record: supersede it, never edit it.
