# ADR-0001 — Distribution as a Claude Code plugin from a git marketplace

| | |
|---|---|
| **Status** | Superseded by [ADR-0003](0003-provider-neutral-skills-layout.md) |
| **Date** | 2026-09-14 |
| **Supersedes** | — |

## Context

Croakness is a separate project, activated on other repositories. How it
reaches a target repository determines how it is updated, and updating is the
whole difficulty: a documentation discipline is worthless if each project runs
a different vintage of it.

Claude Code loads plugins from a git-based marketplace. A repository can host
both the marketplace manifest and the plugin it lists.

## Decision

The repository is both the marketplace and the plugin. `.claude-plugin/
marketplace.json` at the root lists one plugin, sourced from
`./plugins/croakness`, which holds its own `.claude-plugin/plugin.json`, the
skills, the templates and the discipline reference.

A target repository receives only its own documentation. Nothing from the
Croakness is copied into it; the skills and templates stay in the plugin and are
reached through `${CLAUDE_PLUGIN_ROOT}`.

## Alternatives weighed

- **An installer script copying templates and `.claude/` into the target** —
  rejected: every project freezes the version it was installed with, and the
  discipline drifts project by project. That is the failure mode this decision
  exists to avoid.
- **A git submodule or a symlink from the target repository** — rejected: git
  friction on every clone and every CI checkout, and path fragility for a
  benefit the marketplace already provides.
- **Plugin at the repository root, marketplace source `"./"`** — rejected on
  lack of evidence, not on principle: both marketplaces installed locally
  (`claude-plugins-official` and the desktop upload channel) source plugins
  from a subdirectory, and nothing available here confirms `"./"` validates.
  Worth revisiting if it does — it would remove the nesting.

## Consequences

- Updating every project that uses Croakness means updating one repository.
- A rename means keeping two manifests in sync; the version number lives in
  `plugin.json` only.
- The plugin's own documentation (this file and its siblings) sits at the
  repository root, outside the plugin directory, and is not shipped to target
  repositories. Croakness therefore dogfoods its own discipline without
  polluting what it distributes.
- Anyone installing it needs Claude Code plugin support. There is no fallback
  path for another agent, and adding one would mean revisiting this ADR.

---

Drafted with an AI assistant — review before treating as authoritative.
