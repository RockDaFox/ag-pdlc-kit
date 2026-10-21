# Spec — pdlc-report

> **Status: Draft** — the work is authorised and not yet shipped.
>
> Living document: any change to the `pdlc-report` skill is reflected here in the same change. Revised 2026-10-21.

## Summary

`pdlc-report` reads what a project recorded over a period — its specs and ADRs — and writes a dated report for a reader who does not read the repository: a sponsor, the end users, or the team. It always reads the specs and ADRs in full, as they stand at the end of the period, and writes the report from them. It takes them from the first source that works: a repository at hand, a link to the repository read with the access the AI tool already has, or the files the user supplies. It places them in the period by the dates they carry. Where git history is at hand, it also tells which of their lines are new in the period. Before it reads anything it has five answers from the user: audience, format, language, period and destination path. It shows a sourced list of what it will include, writes the report once the user has validated that list, and commits nothing.

It reads what [`pdlc-feature`](pdlc-feature.md), [`pdlc-decide`](pdlc-decide.md) and [`pdlc-build`](pdlc-build.md) record, and adds nothing to it. Its user is whoever prepares the report — a product owner, a delivery lead, a consultant — and its output is the first in the kit addressed outside the team. It targets the AI tools those roles use as well as the developer hosts ([ADR-0018](../adr/0018-the-kit-serves-the-whole-product-team.md)).

## Non-goals

- It does not send, publish or share the report. A human does, after review.
- It does not commit the report, and writes nothing under `{docs_root}`.
- It states no progress the records do not hold: no percentage, estimate, forecast or promised date.
- It does not report on a project with no spec and no ADR.
- It gives no regulatory reading of an escalation.
- It keeps no memory of earlier reports.
- It applies no branding or corporate template.
- It serves three audiences only. Support is not one of them.
- It records no decision. That is `pdlc-feature` and `pdlc-decide`.

## Decisions

1. **Three audiences: sponsor, end users, team.** Each needs a different version of the same facts, and these three cover the steering committee, the release and the colleague coming back.
2. **The user chooses the format: Markdown, a one-page HTML document, or HTML slides ready to present.** The report goes where its audience reads it, and a steering committee reads a deck.
3. **The user states the language.** The skill never infers it from the records, because a sponsor often reads another language than the one the project is documented in.
4. **Five answers come before anything is read: audience, format, language, period, destination path.** A report drafted for a guessed audience is filtered for the wrong reader, and that is how internal content leaks.
5. **The period is required, and it is asked as dates.** The end is today unless given. With git, a tag or a commit is accepted as well. The skill keeps no memory of the last report: that would need a state file, which [ADR-0002](../adr/0002-docs-root-without-config-file.md) rules out.
6. **The report is always written from the specs and ADRs read in full, as they stand at the end of the period.** A line out of its document loses what it means: a Behavior line needs its spec's summary, a decision its reason. An ADR falls in the period by its Date row, a spec by its Revised date.
7. **The documents come from the first source that works: a repository at hand, a link to the repository, or files the user supplies.** A link is read with the access the host already has. On a developer host that is a temporary clone, made with the person's own git credentials, which works with any forge and keeps the history. On another host it is that host's connector to the forge, which usually gives the files without their history. The skill names no forge and never asks for a credential. When access fails, it proposes how to set it up, retries once it is, and otherwise asks for the files, which always work.
8. **Git history, when at hand, only narrows what is new.** Comparing two states of `{docs_root}` tells which lines a spec gained in the period, survives squash merges, and reads decisions rather than commit messages. Without git, what a spec added in the period cannot be told from what it already held, and the report says it was built from documents without history.
9. **No source, no line.** Every item traces to a spec line, an ADR, or with git a commit. An item the user adds counts as sourced by the user, and is labelled so in the validation list.
10. **A sourced list is validated before anything is written.** It shows each item with its source, then what the audience filter left out and why. Leaving client content out of an outward document is a human call: the skill proposes and the user decides.
11. **What each audience gets is a fixed table, not the model's judgement per item.** The table is in Behavior. The validation list is where a human corrects it for one report.
12. **Sources appear in the team report only.** A sponsor or a user cannot open a spec, so a reference is noise to them. The reviewer checks the sources in the validation list.
13. **A spec still in `Draft` is reported as in progress, never with a measure of progress.** That the work is authorised is a fact the records hold. How far along it is, is not.
14. **A commit that no spec covers appears in the team report only, and only with git.** Its message is written for developers, and rewriting it for a user would be guesswork.
15. **The report is written to the path the user gives, never under `{docs_root}`, and never committed.** It is a dated snapshot for outside readers. In `{docs_root}` it would be a fifth document restating the specs.
16. **The report carries the kit's AI notice at its end, and a visible line at its head.** The end notice is the one every document carries, marker included. The head line exists because an HTML comment does not show in a browser, and a reader of an outward document has to see it. In the HTML formats the end notice is shown as visible text too, set apart from the content, so it cannot be missed in a browser. The skill removes the head line, the notice and its marker only when the user explicitly asks it to, and that request is the review. A user of an AI assistant edits a file by asking the agent, so the removal has to go through it. The kit's rule that no skill removes the notice governs the documents in the repository, and the report is not one.
17. **Each HTML format is one self-contained file.** CSS and script are inline, and nothing is loaded from the network. The file opens offline, travels as an attachment, and makes no request from a client's machine.
18. **The slides carry JavaScript for navigation.** Keyboard navigation and full screen are what make them ready to present. The script navigates and nothing else: no network call, no storage. A generated file that contains script is new to the kit, so it takes an ADR, written with the code.
19. **The skill is self-contained: it reads no file under `skills/_pdlc-shared/`.** The AI tools it targets are untested, and a host that loads the `SKILL.md` without its directory would leave it with dead links and no error. The few rules it needs — the AI notice, how `{docs_root}` is found — are stated in its own file. That is a deliberate exception to the kit's rule that skills link to the reference rather than restate it.
20. **A project with no spec and no ADR stops the skill.** Without decisions the report would be a reworded change log, and the skill offers `pdlc-init` instead.
21. **Questions waiting for an answer open the sponsor report.** They are what the meeting has to act on.
22. **The skill asks and reports without developer vocabulary.** No commit, branch, diff or tag in what it asks a user who did not mention them first.

## Behavior

- **B1** — Invoked with any of audience, format, language, period start or destination path missing: the skill asks for every missing one in a single round. It reads no file and runs no command before all five are answered.
- **B2** — An audience other than sponsor, end users or team: the skill names the three it serves and asks again.
- **B3** — A format other than Markdown, one-page HTML or HTML slides: the skill names the three and asks again.
- **B4** — A destination under `{docs_root}`: refused, with the reason, and asked again.
- **B5** — A destination where a file already exists: the skill asks before overwriting it, and writes nothing until the user answers.
- **B6** — A period start that is not a date, or with git a tag or commit that cannot be found: the skill says so and asks again.
- **B7** — No repository at hand: the skill asks for a link to the repository or for the files, in the same round as B1.
- **B8** — A link, on a developer host: the skill clones the repository into a temporary directory with the person's own git credentials, reads from it, and deletes it before closing, including when it stops early.
- **B9** — A link, on another host: the skill reads the documents through the host's access to that forge.
- **B10** — A link whose access fails: the skill says which access failed and proposes how to get it — on a developer host, git credentials for that forge; on another host, a connector to that forge authorised on this repository. It says who can grant it: the user, or the organisation's administrator. It gives the steps of the host it runs on only where that host documents them, and otherwise names the setting to look for. It adds that connecting a third-party tool to a client's repository is the organisation's call. It never asks for a credential, and never suggests pasting a token into the conversation.
- **B11** — Access set up after B10: the skill retries the link. The user declines, or access still fails: the skill asks for the files.
- **B12** — Before listing anything: the skill reads in full every spec and ADR under `{docs_root}` as it stands at the end of the period, from the source it reached.
- **B13** — A project with no spec and no ADR: the skill stops, writes nothing, and offers `pdlc-init`.
- **B14** — A period with nothing to report for the chosen audience: the skill says so in plain words, with the reason when the records show it — for example, that no feature was marked delivered in the period — and writes nothing.
- **B15** — Delivered, with git: each Behavior line present at the end of the period and absent at its start, in a spec whose Status is `Shipped` at the end. Without git: the Behavior lines of each `Shipped` spec whose Revised date falls in the period.
- **B16** — Decided, with git: each ADR added in the period, and each Decisions line added in the period to a spec. A rejected alternative added in the period sits under the decision it names, or on its own line. Without git: each ADR whose Date falls in the period, with its alternatives weighed.
- **B17** — Reversed: each ADR marked `Superseded by` an ADR that falls in the period, with the ADR that replaced it.
- **B18** — In progress: each spec whose Status is `Draft` at the end of the period, with its summary and no measure of progress.
- **B19** — Waiting for an answer: each point a record states as unanswered at the end of the period, and each Regulated data section whose Decision is unanswered. An escalation names the function consulted and the date raised, and nothing about what a regime requires.
- **B20** — Deliberately not done: the Non-goals of each spec reported as delivered. With git, each Known gaps row added in the period. Without git, the Known gaps of each spec reported as delivered.
- **B21** — Before writing: the skill shows the validation list. Each item is one line under its report section, with its source named in words a non-developer recognises — the feature or decision it comes from — and the identifier after it in brackets: a spec line, an ADR number, with git a commit, or "user". A second list shows what the audience filter left out, with the reason. Nothing is written before the user answers.
- **B22** — The user removes an item from the list: it is absent from the report. The user adds one: it appears in the report, and in the list as sourced by the user.
- **B23** — Sponsor report: sections in this order — waiting for an answer, delivered, decided, reversed, in progress, deliberately not done. No file path, no code symbol, no technical term the spec does not explain.
- **B24** — End users report: delivered, in the users' terms, then the known limits that affect use. No decision, no ADR, no work in progress, no escalation, no file path, no code symbol.
- **B25** — Team report: every section in B23, with the source of each item, plus — with git — the commits in the period that no spec covers.
- **B26** — Any report: no person's name, commit authors included. No percentage, estimate, forecast or date the records do not hold.
- **B27** — Any report is written in the language the user stated, whatever language the project is documented in.
- **B28** — Any report opens with its title, the audience, the period with its dates, the date it was written, and a visible line saying it was drafted with an AI assistant and must be reviewed before sending. Without git, it also says it was built from documents without history. In the slides, all of this is on the first slide.
- **B29** — A Markdown report ends with the kit's AI notice and its `ai-draft` marker, after a closing rule, as an HTML comment.
- **B30** — An HTML report, page or slides, shows the AI notice as visible text set apart from the content, at the head and again at the end — on the first and the last slide. The `ai-draft` marker stays as a comment above the end notice.
- **B31** — Markdown: one `.md` file at the destination.
- **B32** — One-page HTML: one `.html` file at the destination, CSS inline, no external resource, printable from the browser.
- **B33** — HTML slides: one `.html` file at the destination, one slide per screen. The arrow keys and space move between slides, and a key toggles full screen. CSS and script are inline. The file makes no network request and stores nothing.
- **B34** — Throughout: with git, the skill runs git commands that read only, plus the clone of B8; without, it runs none. It writes only the destination file and that temporary clone, and commits nothing.
- **B35** — The user explicitly asks to remove the AI notice: the skill removes the head line, the end notice and its marker, and changes nothing else. Without that request it never removes them, including while making other changes the user asks for.
- **B36** — Closing: the skill states the path written, how many items it included and how many the filter left out, which sources the period lacked, and that the report has to be reviewed before sending, after which the user asks for the AI notice to be removed.

## Rejected alternatives

- **Writing the report into `{docs_root}` as a dated record** — rejected because it restates the specs in a fifth document, against the stated-once rule.
- **A default destination folder outside `{docs_root}`** — rejected by the user in favour of asking for the path every time.
- **Markdown shown in the chat rather than written to a file** — rejected for the same reason: one destination rule for every format.
- **Writing the report directly and relying on the draft review** — rejected because content is selected before the draft exists, and the draft review comes too late to catch what the filter should have removed.
- **Git only in the first version** — rejected: the skill would not run in the AI tools its users work in, which [ADR-0018](../adr/0018-the-kit-serves-the-whole-product-team.md) targets.
- **Falling back to the files as soon as a link fails** — rejected: a user who could get access in a minute would be left hunting for files in a repository. The skill proposes the setup first.
- **Asking for an access token to read a private repository** — rejected: a token pasted in a conversation stays in its history, held by a third party, with access to a client's repository. Access is the host's to grant, never the skill's.
- **Reading through a named forge's interface** — rejected: the repository may be on any forge, self-hosted included. A clone works with all of them, and a host's connector is the host's business.
- **Supplied documents only, never git** — rejected: where git is at hand it tells exactly what was added in the period, and dates do not.
- **With git, reading the changed lines only** — rejected: a line out of its document loses its meaning, so the documents are read in full in both cases and git only narrows what is new.
- **The AI notice only at the end, as an HTML comment** — rejected: a reader opening the HTML in a browser never sees it.
- **The AI notice only at the head, visible** — rejected: the report would lose the end notice and its marker, which every other document carries.
- **In HTML, a visible line at the head and the end notice kept as an HTML comment** — the previous draft, rejected by the user: in a browser the notice has to be seen at both ends, not left in the source.
- **Never removing the notice, as for the documents in the repository** — rejected: a user of an AI assistant edits a file by asking the agent, so the notice would stay for good. The removal waits for an explicit request instead.
- **Slides in CSS only, with no script** — rejected by the user. Keyboard navigation and full screen are worth the ADR.
- **A slide library loaded from a CDN** — rejected because the file would fail offline and send a request from a client's machine.
- **Reading `doc-discipline.md` like the other skills** — rejected: on a host that does not resolve the link, the skill would lose those rules without saying so.
- **A report built from history alone on a project without specs or ADRs** — rejected because, with no decision in it, nothing distinguishes it from a change log.
- **Remembering the last report's end as the next start** — rejected because it needs a state file ([ADR-0002](../adr/0002-docs-root-without-config-file.md)).
- **Reading commit messages one by one** — rejected because squash merges lose them, and they are written for developers.
- **Inferring the language from the records** — rejected because the audience's language and the project's often differ.
- **Support as a fourth audience in the first version** — left out by the user's choice of scope. It is a known gap.
- **The model judging, item by item, what each audience sees** — rejected because a confidentiality filter left to judgement fails silently. A fixed table plus human validation fails where someone can see it.
- **Sources printed in the sponsor and end users reports** — rejected because those readers cannot follow them. The validation list carries them for the reviewer.

## Known gaps

| Left out | Add it when |
|---|---|
| Claude Cowork, Vibe Work and Microsoft 365 Copilot are untested with this skill | It is run on one of them |
| The setup the skill proposes depends on what the host documents, and may be out of date | A user follows the proposed setup and it does not match the host |
| No host connector to any forge has been tried with this skill | A link is used on a host other than a developer one |
| A forge on a client's internal network is out of reach of a cloud AI tool, whatever its connector | A report is needed from such a host for such a repository; the files supplied are the way round today |
| A large repository takes time to clone in full | A clone is slow enough to be noticed |
| Without git, what a spec added in the period cannot be told from what it held, and its decisions are not reported | A report without git misses a decision a sponsor needed |
| The AI notice and the `{docs_root}` rule are restated in this skill and can drift from `doc-discipline.md` | Either changes in `doc-discipline.md` |
| Support as an audience: delivered behavior with its error states, and the known limits | A team asks for support notes, or support learns about a release from users |
| A corporate or client visual identity | A report is rejected for its neutral style |
| End users never hear of a fix that no spec covers | A release carries a fix that matters to users and has no spec |
| Translation is not checked: a domain term may come out wrong | A reviewer corrects a translated term in a report |
| A spec reconciled without its Status set to `Shipped` never shows as delivered | A delivered feature is missing from a report for that reason |
| A Behavior line reworded in the period counts as new | A report lists as delivered a line that only changed its wording |
| Unanswered points are found by the word the records use, and a project documented in another language may use another word | A report misses an unanswered point written in another language |
| Nothing checks that the filter caught everything; the validation list is the only safeguard | Internal content is found in a report at review, or after it was sent |
| No rule for a section too long for one slide | A deck has a slide that overflows |
| No PDF output beyond printing from the browser | A sponsor needs a PDF and the printed slides break |
