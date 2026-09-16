# ADR-0008 — One maintainer-side check script, and "no executables" means the product surface

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-09-15 |
| **Supersedes** | — |

## Context

`PRODUCT.md` constrains A-PDLC Kit to no executables. No ADR ever decided that: it appears in [ADR-0001](0001-distribution-as-claude-code-plugin.md) and [ADR-0003](0003-provider-neutral-skills-layout.md) only as the reason an installer script and a per-provider sync script were rejected. So what the constraint protects was never stated precisely, and it came to be read as "this repository contains no code" — a considerably stronger claim than anything that was decided.

Two measurements do not survive that wider reading.

The skills already run commands on the user's machine. `pdlc-init` reads the history with `git log --oneline`; it always did. Whatever the constraint forbids, it is not an agent running a command to read a repository.

And verifying this repository by hand is both expensive and unreliable. The careful pass on record used a byte-counting tool for a rule about characters, reported ten violations that were not there, missed eight that were, and spent several thousand tokens of context arriving at that answer. Context spent on counting is context not spent on the work.

The token asymmetry is the decisive part. A check that runs as a command puts its output in the context and nothing else — one line, two tokens. A check performed by reading files puts the files in the context: around eight hundred tokens for the four manifests alone, before anything is concluded from them.

This repository is also the product's worked example. The plugin root is the repository root, so an installed A-PDLC Kit carries these documents ([ADR-0003](0003-provider-neutral-skills-layout.md)). A supersession recorded on one side only, or a skill no host can discover, is a defect in the demonstration rather than a blemish on it.

## Decision

`scripts/check.sh` exists: POSIX sh, no dependency, reads the repository and writes nothing, not even a temporary file. It reports and never fixes.

It checks only what breaks silently — the four manifests agreeing, a supersession recorded on both sides, ADR numbering and the Status and Date rows, a skill's `name` matching its directory, relative links, a heading written twice. A check for something a reader would notice anyway is noise, and noise trains its own dismissal.

When it cannot read what it needs, it says so and counts that as a finding. A manifest reformatted enough to defeat textual extraction produces "this check is blind", never a pass. A check that goes quiet is worse than no check, because it is trusted.

Nothing under `skills/` invokes it and nothing ever will. It is not product surface: it ships as no capability, no skill mentions it, and a repository A-PDLC Kit is installed on never runs it. The command is listed under Commands in this repository's `AGENTS.md`, and that is the whole enforcement mechanism — no hook, no pipeline.

The constraint in `PRODUCT.md` is reworded to say what it actually protects: **the product installs nothing and runs nothing on a repository it documents.**

## Alternatives weighed

- **Keep verifying by hand** — rejected on both measurements above: it spends the context the task needs, and the one careful attempt on record was wrong in both directions at once.
- **Python rather than sh** — rejected: `python3` is not guaranteed on a machine, and on macOS the stub prompts a toolchain install instead of running. `sh` is guaranteed. The price is real and paid in the script: sh has no JSON parser, so the manifests are compared textually, which is why every comparison had to be given a blind branch.
- **`jq`** — rejected: a dependency, in a script whose argument is that it needs nothing. It happens to be present on the machine this was written on only because a recent macOS ships it.
- **Ship the checks as a script the skills run on the repository they document** — rejected: it assumes a runtime on a machine the product does not own, which is exactly the case the constraint exists for. Where a deterministic check would help a target repository, the skill names a command the agent already has — `wc -l` for the 150-line budget — rather than shipping a file to run.
- **A pipeline that runs it on push** — rejected as unavailable, not as unwanted. This repository has no pipeline from its host, so a GitHub workflow would sit in the tree and never fire.
- **A checker for the `AGENTS.md` written into a target repository**, which [ADR-0007](0007-agents-md-follows-the-cross-vendor-convention.md) rejected for needing executable code — not reopened. That check would run on someone else's machine, which is the line this decision does not cross.

## Consequences

- "The repository is Markdown and two JSON manifests" stops being true, in `AGENTS.md` and in `PRODUCT.md`. Auditing the kit now means reading a shell script. It has no dependency, opens no connection and writes no file, which is the most that can be offered in exchange.
- The script ships inert into every installation, because the plugin root is the repository root. Nothing invokes it. The cost is an audit read, not a behavior.
- Nothing runs it automatically. It works because it is written under Commands, where an agent editing this repository reads it. A human maintainer will forget it, and that is accepted rather than solved.
- The asymmetry between the two marketplace plugin entries — `skills` declared in one and absent from the other — is printed as a note on every run. Whether either host requires the key there is unverified, so nothing was changed; the note keeps the question in view instead of it being rediscovered later.
- Every future check has to earn its place against the same two questions: does it catch something that breaks silently, and does it cost less context than reading the files would. Most candidates fail the first.
