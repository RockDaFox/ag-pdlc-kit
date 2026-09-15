# <project>

<!-- How this repo is written. Conventions and traps, not product behavior
     and not deliberations — those live in PRODUCT.md, the ADRs and the
     specs. -->

## Priority rule — sandbox failures

If a command fails because of the sandbox (permission/access errors caused by
sandboxing, not by the command itself), do **not** ask to re-run it outside
the sandbox. Instead, give the exact command to the user and let them run it.

## Commands

<!-- The real commands, read from the task runner's manifest, never guessed.
     One line each, saying what it does. -->

## Architecture

<!-- A paragraph: the shape of the codebase and where things live. Enough to
     locate code, not a tour. The reasons behind the structure are in the
     ADRs — link, do not restate. -->

## Documentation

Four levels, each stating a thing once:

- [`AGENTS.md`](AGENTS.md) — this file: how the repo is written.
- [`docs/PRODUCT.md`](docs/PRODUCT.md) — what the product does and why, as
  delivered. Descriptive, never a list of requirements for future work.
- [`docs/adr/`](docs/adr/) — structural technical decisions, dated and
  append-only. An ADR is never rewritten; a later one supersedes it.
- [`docs/specs/`](docs/specs/) — per-feature decisions, rejected alternatives
  and known gaps. Living documents, rewritten when the feature changes.

<!-- Adjust the paths above if this repo's documentation root is not docs/. -->

Before implementing or modifying a feature that has a matching spec, read it
first — it records the decisions actually made, the alternatives rejected, and
the known gaps. A change that alters behavior a spec or `PRODUCT.md`
describes updates that document **in the same change**, rather than letting it
drift.

## Code style

<!-- Rules the code actually exhibits, each with its reason when the reason is
     not obvious. A rule nobody follows in the code is a wish, not a rule. -->

## Traps

<!-- Every framework, platform or tooling behavior that has already cost
     someone an afternoon here. This section is the highest-value part of the
     file. A trap that will bite again is repo-wide and belongs here, not in
     the spec of whichever feature happened to hit it first. -->

## Deployment

<!-- Target environment, where the infrastructure files live, how migrations
     run, what CI does. -->
