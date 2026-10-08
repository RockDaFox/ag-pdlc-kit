# Writing `AGENTS.md` and `PRODUCT.md`

Read [`doc-discipline.md`](doc-discipline.md) first: it holds the four levels,
`{docs_root}`, the routing test and the writing rules. This file holds what is
needed only when one of the two state documents is being written or
restructured.

## `AGENTS.md` follows the cross-vendor convention

`AGENTS.md` is not this product's invention. It is the cross-vendor format for
instructing coding agents: plain Markdown, no frontmatter, no required field,
and nested files where the one nearest the edited code wins. Ag-PDLC Kit writes
that file rather than one of its own, and stays inside the convention. Two
properties of it shape every `AGENTS.md` written or merged here.

**Six zones, and a role.** The content that earns its place is: commands —
real ones, with their flags — testing, project structure, code style, git
workflow, and boundaries, meaning what the agent must never touch. A statement
of the agent's role, one or two lines at the top, does more for behavior than
any other line in the file. Traps belong with boundaries: a platform behavior
that has already cost someone an afternoon is the most valuable thing the file
can carry, and the thing no other document will record.

**A hundred and fifty lines.** Past that the important content is buried, and
every session pays for the rest in context. An `AGENTS.md` longer than the
repository's `README.md` is too long. The pressure valve is not a thinner
style section — it is the nested file: repo-wide rules at the root, per-stack
rules in an `AGENTS.md` beside the code they govern.

That number is counted, never estimated — `wc -l` on the file — and the count
is reported to the user. It is what decides whether the file splits, so a
guess either forces a split nothing needed or waves through a two-hundred-line
file while announcing a hundred and forty.

Two kinds of content are turned away, because both are read as belonging here
and neither does:

- **The shape of a pull-request body** — an evidence report, a completion
  checklist, a required diff summary. That is an output format, and it belongs
  in a pull-request template, where the author is looking when they need it.
- **Process governance** — who staffs an approval, how a metric is computed,
  what happens when the approver is away. What belongs here is only the rule
  the agent obeys, stated once under boundaries: it does not merge, it does
  not deploy, it does not touch production data, it does not lift a security
  control. The process serving that rule lives wherever the organisation keeps
  process.

## `PRODUCT.md` is descriptive, not prescriptive

It states what the product does **today**, in the present indicative, and it
is written from the code rather than from intent. It holds no requirement
addressed to work still to come: a requirement is a demand made of a system
that does not exist yet, and the same sentence, once shipped, is a
description. A section written in the future or the conditional tense belongs
in a ticket.

Hence the name. `PRD.md` denotes a product *requirements* document — written
before the build, prescriptive, an input to engineering — which is the
opposite genre, and a name many organisations already use for exactly that.
A repository whose product team owns real PRDs keeps them where they are;
`PRODUCT.md` does not compete with them and does not replace them.

The word "requirements" therefore does not appear as a section title. What
shapes the product without being behavior — volume, latency, availability,
regulatory obligations, supported environments — is a **constraint**, and says
so.
