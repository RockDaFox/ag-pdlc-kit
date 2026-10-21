---
name: pdlc-report
description: Write a dated report on a project for readers who do not read its repository — a sponsor or steering committee, the end users, or the team — as Markdown, a one-page HTML document, or HTML slides ready to present. Reads the project's specs and ADRs in full, from a local repository, a link to the repository, or files the user supplies, shows a sourced list of what it will include for the user to validate, then writes the report in the language asked. Use when someone needs slides, a summary, a status update, release notes or a steering committee report on what a project delivered and decided over a period, or when the user invokes /pdlc-report.
---

# Report on a project

A project that records its decisions holds the material for every status report, and nobody outside the team reads it there. This skill turns that record into a report for one audience — what was delivered, what was decided and why, what is waiting for an answer — without inventing a line of progress the records do not hold. Its user is often not a developer: a product owner, a delivery lead, a consultant working in an AI assistant. Ask and report in plain words. Do not say commit, branch, diff or tag to a user who has not said them first.

This file is self-contained. It reads nothing from the kit's shared reference, because the AI tools it runs in may load this file without the files beside it. The rules it needs are stated here.

## What it never does

- It never sends, publishes or shares the report. A human does, after review.
- It never writes inside the project's documentation folder, and never commits anything.
- It never states a percentage, an estimate, a forecast or a date the records do not hold.
- It never names a person, commit authors included.
- It never gives a legal or regulatory reading. An open question to a data-protection or compliance function is reported as open, and nothing more.
- It never asks for a password, a token or any credential.

## 1. Five answers before anything else

Before reading any file or running any command, have all five, and ask for the missing ones in a single round:

1. **The audience**: sponsor, end users, or team. Anything else: name the three and ask again. Support is not served.
2. **The format**: Markdown, a one-page HTML document, or HTML slides. Anything else: name the three and ask again.
3. **The language** the report is written in. Never infer it from the documents: a sponsor often reads another language than the project is documented in.
4. **The period**, as dates. The end is today unless given. Where git is at hand, a tag or a commit is accepted too. There is no default start and no memory of the last report: ask.
5. **The destination**: the path of the file to write. Refuse a path inside the documentation folder, with the reason — a report there would restate the specs in a fifth document — and ask again. Where a file already exists at that path, ask before overwriting it.

When there is no repository at hand, ask in the same round for a link to the repository, or for the specs and ADRs as files.

## 2. Reach the documents

Use the first source that works.

**A repository at hand.** The documentation folder is `docs/` unless the repository's `AGENTS.md` names another, or an existing folder holds `adr/` and `specs/` under another name.

**A link to the repository.** Never name or assume a forge. On a host that runs git with the person's own credentials — a developer tool — clone the repository into a temporary directory, read from it, and delete it before you finish, including when you stop early. On any other host, read the files through the access the host already has to that forge, usually a connector.

**When the link gives no access**, say which access failed, then propose how to get it:

- on a host that runs git: git credentials for that forge, set up on the person's machine;
- on any other host: a connector to that forge, authorised on this repository.

Say who can grant it: the user, or their organisation's administrator. Give the steps of the host you run on only where that host documents them; otherwise name the setting to look for. Add that connecting a third-party tool to a client's repository is the organisation's decision. Never ask for a credential, and never suggest pasting a token into the conversation. Once access is set up, retry the link. If the user declines, or access still fails, ask for the files.

**Files the user supplies.** Read those and nothing else.

## 3. Read in full, then select

Read every spec and every ADR in full, as it stands at the end of the period. A line taken out of its document loses its meaning: a behavior needs its spec's summary, a decision needs its reason.

Stop, write nothing, and say so plainly in two cases:

- **No spec and no ADR at all.** The report would be a reworded change log. Offer `pdlc-init`, which sets the project up to record its decisions.
- **Nothing to report for this audience in the period.** Give the reason when the records show it — for example, that no feature was marked delivered in the period.

Place each document in the period by the date it carries: an ADR by its Date row, a spec by its "Revised" date. Where git history is at hand, it narrows what is new by comparing the documentation folder at the start and at the end of the period. Without history, say in the report that it was built from documents without history, because what a spec added in the period cannot be told from what it already held.

| Section | With history | Without history |
|---|---|---|
| Delivered | Each Behavior line present at the end and absent at the start, in a spec whose Status is `Shipped` at the end | The Behavior lines of each `Shipped` spec revised in the period |
| Decided | Each ADR added in the period, and each Decisions line added to a spec. A rejected alternative added in the period goes under the decision it names, or on its own line | Each ADR dated in the period, with its alternatives weighed |
| Reversed | Each ADR marked `Superseded by` an ADR that falls in the period, with the one that replaced it | Same |
| In progress | Each spec whose Status is `Draft` at the end, with its summary — never a measure of progress | Same |
| Waiting for an answer | Each point a document states as unanswered, and each Regulated data section whose Decision is unanswered, naming the function consulted and the date raised | Same |
| Deliberately not done | The Non-goals of each delivered spec, and each Known gaps row added in the period | The Non-goals and Known gaps of each delivered spec |
| Other changes | Commits in the period that no spec covers — team report only | Not reported |

## 4. What each audience gets

This table decides, not judgement item by item. The validation list is where the user corrects it for one report.

| | Sponsor | End users | Team |
|---|---|---|---|
| Waiting for an answer | first section | — | yes |
| Delivered | yes | yes, in the users' terms | yes |
| Decided | yes | — | yes |
| Reversed | yes | — | yes |
| In progress | yes | — | yes |
| Deliberately not done | yes | only the limits that affect use | yes |
| Other changes | — | — | yes |
| Sources | — | — | after each item |

Sponsor sections come in the table's order. No audience but the team sees a file path, a code symbol, or a technical term its spec does not explain.

## 5. The validation list

Before writing the report, show the list and write nothing until the user answers:

- each item, one line, under the section it will appear in, with its source named in words a non-developer recognises — the feature or the decision it comes from — and the identifier after it in brackets: a spec line, an ADR number, a commit, or "user";
- then what the audience filter left out, one line each, with the reason.

An item the user removes is absent from the report. An item the user adds goes in, sourced "user".

## 6. Write the report

Write it in the language asked, whatever language the documents are in.

**Head.** The title, the audience, the period with its dates, the date the report was written, and a visible line: "Drafted with an AI assistant — review before sending." Without history, add that the report was built from documents without history. In slides, all of this is the first slide.

**End.** The AI notice, translated with the report. Its marker line, `<!-- ai-draft -->`, is never translated.

- Markdown — one `.md` file. After a closing rule, the marker and the notice as an HTML comment:

  ```
  ---

  <!-- ai-draft -->
  <!-- Drafted with an AI assistant — review before treating as authoritative.
       Remove this notice and the ai-draft line above it as part of that
       review, before the commit. -->
  ```

- One-page HTML — one `.html` file, CSS inline, no external resource of any kind, printable from the browser. The notice is visible text set apart from the content, at the head and again at the end, with the marker as a comment just above the end notice.

- HTML slides — one `.html` file, one slide per screen, CSS and script inline, no external resource, no network call, nothing stored. The notice is visible on the first and the last slide, with the marker as a comment above the last one. Start from this skeleton:

  ```html
  <!doctype html>
  <html lang="LANG"><head><meta charset="utf-8"><title>TITLE</title>
  <style>
  html, body { margin: 0; height: 100%; font-family: system-ui, sans-serif; }
  section { display: none; box-sizing: border-box; height: 100vh; padding: 6vh 8vw; font-size: clamp(16px, 2.4vw, 28px); }
  section.on { display: block; }
  .ai { border: 2px solid #b45309; background: #fffbeb; padding: .6em 1em; }
  @media print { section { display: block; height: auto; page-break-after: always; } }
  </style></head><body>
  <section><!-- title, audience, period, date written --><p class="ai">NOTICE</p></section>
  <section><!-- one section of the report --></section>
  <!-- ai-draft -->
  <section><p class="ai">NOTICE</p></section>
  <script>
  const slides = [...document.querySelectorAll('section')];
  let i = 0;
  const show = n => { i = Math.max(0, Math.min(slides.length - 1, n)); slides.forEach((s, k) => s.classList.toggle('on', k === i)); };
  document.addEventListener('keydown', e => {
    if (['ArrowRight', 'ArrowDown', 'PageDown', ' '].includes(e.key)) show(i + 1);
    else if (['ArrowLeft', 'ArrowUp', 'PageUp'].includes(e.key)) show(i - 1);
    else if (e.key === 'f') document.fullscreenElement ? document.exitFullscreen() : document.documentElement.requestFullscreen();
  });
  show(0);
  </script></body></html>
  ```

  The script moves between slides and toggles full screen, and does nothing else. Keep it that way.

## 7. Removing the AI notice

Remove the head line, the end notice and its marker only when the user explicitly asks you to. That request is their review. Change nothing else when you do. Without that request, never remove them, including while making other changes the user asks for.

## Finishing

State the path written, how many items the report includes and how many the filter left out, and which sources the period lacked — no ADR, no spec revised. Then remind the user that the report was drafted with an AI assistant and has to be reviewed before it is sent, and that once it is, they can ask you to remove the AI notice.
