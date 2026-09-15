# <project>

<!-- One or two lines naming the agent's role in this repository, in the
     imperative. This is the highest-leverage content in the file: a stated
     role changes behavior, a generic preamble does not.

     Section order below follows the cross-vendor AGENTS.md convention —
     commands early, boundaries explicit. Keep the whole file under 150
     lines; per-stack rules go in a nested AGENTS.md beside the code they
     govern, not here. See doc-discipline.md.

     How the repo is written. Not product behavior and not deliberations —
     those live in PRODUCT.md, the ADRs and the specs. -->

## Overview

<!-- What the project is, and the stack with versions: "Python 3.12, FastAPI,
     PostgreSQL 16" — not "a Python API". Two or three lines. -->

## Commands

<!-- The real commands, read from the task runner's manifest, never guessed.
     Flags included: `pytest -q tests/unit`, not "run pytest". One line each,
     saying what it does. -->

## Testing

<!-- How to run the whole suite, how to run one test, what gets mocked and
     what talks to something real. The rule for when a change needs a test,
     if this repo has one. -->

## Architecture

<!-- A paragraph: the shape of the codebase and where things live. Enough to
     locate code, not a tour. The reasons behind the structure are in the
     ADRs — link, do not restate. -->

## Code style

<!-- Only what deviates from the language's defaults or from what the
     formatter already enforces. Rules the code actually exhibits, each with
     its reason when the reason is not obvious. A rule nobody follows in the
     code is a wish, not a rule. -->

## Git

<!-- Branch naming, commit message format, whether history is rebased or
     merged, what must never be committed. -->

## Boundaries

<!-- What must never be touched: generated directories, vendored code,
     production configuration, anything holding a credential.

     Then the human gates, as rules rather than as process — the agent does
     not merge, does not deploy, does not touch production data, does not
     lift a security control. Who approves and how is process, and does not
     belong in this file.

     The shape of a pull-request body does not belong here either. If this
     repo requires an evidence report, that is one line here and a
     pull-request template holding the actual form. -->

## Traps

<!-- Every framework, platform or tooling behavior that has already cost
     someone an afternoon here. With Boundaries, the highest-value part of
     the file. A trap that will bite again is repo-wide and belongs here, not
     in the spec of whichever feature happened to hit it first. -->

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

## Deployment

<!-- Target environment, where the infrastructure files live, how migrations
     run, what CI does. -->
