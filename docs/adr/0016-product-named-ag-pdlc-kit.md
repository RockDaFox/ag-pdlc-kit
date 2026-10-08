# ADR-0016 — The product is named Ag-PDLC Kit, slug `ag-pdlc-kit`, and its manifests name an account, not a person

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-10-08 |
| **Supersedes** | [ADR-0006](0006-product-named-a-pdlc-kit.md) |

## Context

[ADR-0006](0006-product-named-a-pdlc-kit.md) settled the product's three identifiers — display name, manifest slug, skill prefix — as A-PDLC Kit, `a-pdlc-kit` and `pdlc-`. Since then the repository moved to a GitHub account whose name is a handle, not a person's name, and the repository directory and the remote both already read `ag-pdlc-kit` while the manifests still said `a-pdlc-kit`: two names for one thing, the exact gap ADR-0006 was written to close.

The six manifests also carried a person's name in their `owner` and `author` fields. The tree is installed into repositories that may hold client context, and a personal name distributed in every installed manifest is information the maintainer did not choose to distribute. The git history carried the same name on every commit, which is the third place the identity lived.

## Decision

The display name is **Ag-PDLC Kit**. The manifest slug is `ag-pdlc-kit`, so installation reads `/plugin install ag-pdlc-kit@ag-pdlc-kit`.

The skill prefix stays `pdlc-` and the shared directory stays `skills/_pdlc-shared/`: ADR-0006's reasoning for a prefix shorter than the slug is untouched by this rename, and nothing here reopens it.

The `owner` and `author` fields in all six manifests carry the account name `RockDaFox` — the name the distribution channel already publishes — and no person's name. The install command in `README.md` points at the GitHub remote the repository actually lives on.

The commit history is rewritten so that no commit carries the former maintainer identity either; the metadata now agrees with the manifests.

## Alternatives weighed

- **Slug only, display name kept as A-PDLC Kit** — rejected: the identifier then differs from the name people say, the same gap ADR-0006 rejected when it was argued the other way.
- **Removing the `owner` and `author` fields rather than filling them** — rejected: the marketplace schema expects an owner, and an absent field is a shape change every host reads differently. An account name is already public by construction, which a missing field is not.
- **Keeping the personal name in the fields** — rejected: the name traveled with every install into repositories the maintainer does not control, and removing it was the request that prompted this record.
- **Rewriting the ADRs that carry the former name** — rejected: append-only is what makes the log readable, and ADR-0006 is accurate about its own date. Only its `Status` row changes, to point here.

## Consequences

- Anyone who installed `a-pdlc-kit` has the old marketplace and plugin entries. As with ADR-0006, there is no upgrade path across a rename: they uninstall and reinstall under `ag-pdlc-kit@ag-pdlc-kit`.
- ADR-0001 through ADR-0015 keep the former name and the former paths in their text. They are not edited: each is accurate about the situation at its date.
- The rewritten history changes every commit hash, so every existing clone diverges from `origin` and each holder re-clones or re-points by hand; nothing notifies them.
- GitHub may serve the former commits by hash from caches and pull requests after the force-push. Removing them fully is outside this repository's control and takes the host's support.
- `scripts/check.sh` still verifies that the six manifests agree on the name; it does not and cannot check what that name is.
