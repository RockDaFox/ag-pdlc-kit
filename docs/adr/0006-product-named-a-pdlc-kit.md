# ADR-0006 — The product is named A-PDLC Kit, slug `a-pdlc-kit`, skills prefixed `pdlc-`

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-15 |
| **Supersedes** | — |

## Context

The product was called Croakness. The name appeared in four manifests, in two
skill names, in the shared directory `skills/_croakness-shared/`, in two spec
filenames and throughout the prose. It said nothing about what the product
does, and the repository sits in a programme already named Agentic PDLC.

The rename had to settle three identifiers at once, because they are read in
different places and nothing forces them to agree: the marketplace and plugin
`name` in the manifests, the skill directory names that become the invocation
(`/name`), and the shared directory the two skills reach by relative path.

## Decision

The display name is **A-PDLC Kit**. The manifest slug is `a-pdlc-kit`, so
installation reads `/plugin install a-pdlc-kit@a-pdlc-kit`.

The skills are `pdlc-init` and `pdlc-feature`, and the shared directory is
`skills/_pdlc-shared/`. The skill prefix is shorter than the product slug on
purpose: it is typed at every invocation, while the slug is typed once.

The former `new-feature` is renamed in the same pass. An unprefixed, generic
name collides with the user-level `feature` skill it derives from, and a
collision in skill selection is silent.

## Alternatives weighed

The driver for abandoning "Croakness" is not recorded here: the decision
arrived already taken, and inventing the deliberation behind it would be
exactly the fiction
[ADR-0004](0004-decision-records-are-written-forward.md) exists to prevent.
What was weighed is the shape of the new names.

- **Slug `a-pdlc`, with "Kit" living only in the prose** — rejected: shorter
  to type, but the identifier then differs from the name people say, and the
  gap is the kind that quietly produces two names for one thing.
- **Slug `apdlc-kit`** — rejected: reads as one word and avoids a
  three-segment slug, but drops the hyphen that carries the A-for-agentic
  reading.
- **Skills prefixed `a-pdlc-`, matching the product slug exactly** — rejected:
  consistency at the cost of four characters on every invocation. `pdlc-` is
  unambiguous in context and nothing else in a session claims it.
- **Renaming only what carried "croakness", keeping `new-feature`** —
  rejected: it preserves the one name in the set that is generic enough to be
  selected by mistake.

## Consequences

- Anyone who installed 0.1.0 has the old marketplace and plugin entries.
  There is no upgrade path across a rename: they uninstall and reinstall.
- The install command in `README.md` and the `origin` remote both already
  carry the new path. Both are wrong until the repository is itself renamed
  on its host, which is outside this repository's control — and every
  colleague holding a clone re-points their own remote by hand, since nothing
  notifies them.
- [ADR-0001](0001-distribution-as-claude-code-plugin.md) through
  [ADR-0004](0004-decision-records-are-written-forward.md) carry the former
  name and the former paths. They are not edited: each is accurate about the
  situation at its date, and the append-only rule is what makes that
  readable.
- Four manifests now agree on the name, and — for the first time — on the
  `skills` field, which had drifted between `./skills` and `skills/`. Nothing
  enforces it; the trap is recorded in `AGENTS.md`.

---

Drafted with an AI assistant — review before treating as authoritative.
