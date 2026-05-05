# agent_setup

Portable, version-controlled home for Claude Code agent configuration — skills, slash commands, and (over time) hooks, settings, agent definitions, output styles, and status line scripts. `make install` symlinks the contents of `claude/` into `~/.claude/` so the same setup follows you across machines.

## Install

```sh
make install     # symlink everything under claude/ into ~/.claude/
make status      # show install state and any conflicts
make uninstall   # remove only symlinks that point back into this repo
make help
```

Top-level files in `claude/` (e.g. a future `settings.json`) are linked directly. Top-level directories (`commands/`, `skills/`, …) are descended one level so each child is linked individually — `~/.claude/skills` can mix repo skills with skills installed by other tools without either side clobbering the other.

`install` never overwrites. If a destination already exists as a real file or a symlink pointing elsewhere, it is reported as a conflict and skipped; resolve by hand before re-running. Override the destination with `CLAUDE_DIR=/path/to/dest` for testing.

## Layout

```
claude/
  commands/<name>.md              → ~/.claude/commands/<name>.md       invoked as /<name>
  skills/<skill-name>/SKILL.md    → ~/.claude/skills/<skill-name>/...  loaded by description
```

When adding a new asset type, mirror the directory name Claude Code expects under `~/.claude/` (e.g. `hooks/`, `agents/`, `output-styles/`). No Makefile changes needed.

## Slash commands

Plain Markdown prompts with no frontmatter. The file name becomes the command: `claude/commands/foo.md` → `/foo`. Whatever the user types after the command is substituted for `$ARGUMENTS` at the end of the prompt. Commands address Claude in second person ("You are…"), define defaults plus optional argument modes, and assume `~/.claude/CLAUDE.md` provides voice.

### `/peer-review`

Constructive but rigorous peer review of a scientific manuscript or section. Reads the named file plus surrounding context (full section minimum) and `~/.claude/CLAUDE.md` for authorial intent — but reviews for substance, not style adherence.

Argument selects review level:

- `friendly` — collegial first read; flag big issues, skip nitpicks.
- `r2` *(default)* — skeptical "fair Reviewer 2"; the work must defend itself.
- `editor` — scope, fit, and significance; methods and prose left to other reviewers.

Checks claims-vs-evidence (including whether each `[Author Year]` actually supports its sentence), methods and reproducibility, argument structure, and scope/framing. Output is a fixed shape: 2–3 sentence summary, numbered major issues, numbered minor issues, optional suggestions, and one closing line with overall recommendation (accept / minor / major / reject) plus the single most important thing to address. Diagnoses; does not rewrite prose unless asked.

```
/peer-review intro.md
/peer-review editor abstract.md
```

### `/sensemake`

Structured analysis of an article using the method from [How to Make Sense of AI](https://commoncog.com/how-to-make-sense-of-ai), generalized to any fast-moving domain. Reads the user's profile at `~/.claude/sensemake-profile.md`, classifies the input as OPINION / FIELD REPORT / MIXED, and produces an eight-section response: source line, classification, core ideas, field evidence, constraints identified or mitigated, impact on your objectives, possible actions, and a one-line verdict.

Argument is the article: a URL (fetched), a file path (read), or pasted text. If the profile file is missing, the command refuses and points to the `sensemake-profile-builder` skill.

```
/sensemake https://example.com/some-article
/sensemake ~/Downloads/article.md
/sensemake <pasted article body>
```

## Skills

Skills are directories under `claude/skills/` so they can carry supporting files alongside `SKILL.md`. Each `SKILL.md` requires YAML frontmatter with `name` and `description` — the description is the trigger contract Claude reads when deciding whether to invoke the skill, so it must state both *when to use* and (where relevant) *when not to*. Skills should defer voice and prose conventions to `~/.claude/CLAUDE.md` rather than redefining them; their job is process and structure.

### `article-writer`

Governs process and structure for scientific manuscripts and long-form articles. Triggers on requests to draft a paper, work on a manuscript, expand a section, write an abstract/intro/discussion, or revise prose for a journal submission. Explicitly *not* for short blog posts, emails, or general writing.

**Hard rules.**

1. Read source material first — data files, cited papers (typically `refs/`), notes, prior drafts. Never write a claim from assumed knowledge.
2. Honor flag conventions: `[STYLE]` revises prose without changing claims; `[IMPROVE]` allows open structural critique; unflagged passages get minimal touch.
3. Outline before prose for new sections — paragraph-level argument structure first, draft after approval.
4. One section at a time, with review pauses, unless told otherwise.
5. Every `[Author Year]` is a claim of fact backed by a real source in the directory; missing sources surface as `[CITATION NEEDED: …]`, never invented.
6. Numbers come from data files or cited papers, with units and rounding consistent with the target journal.

**Workflow.** Fresh drafts: read `CLAUDE.md`, scan the directory, confirm scope (journal/length/audience/argument), propose an outline, draft section-by-section. Revisions: identify the flag, read the surrounding paragraph or section, edit, briefly note non-obvious changes; never silently introduce new claims during a style-only edit.

**Output discipline.** Markdown (`##` for sections, `###` for subsections), LaTeX math (`$...$` inline, `$$...$$` display), figures and tables referred to by number — never invented. When two phrasings or structures are both defensible, present both briefly and ask.

### `sensemake-profile-builder`

Walks the user through creating or updating `~/.claude/sensemake-profile.md` — the personal-context file that the `/sensemake` command reads to ground its impact-on-objectives analysis. Triggers on phrases like *"create my sensemake profile"*, *"update my sensemake profile"*, *"set up sensemaking"*. Not for ad-hoc edits the user can make by hand.

**Hard rules.** Read the existing profile first if present; ask one prompt at a time; never invent or pad content; final draft requires explicit approval before writing the file.

**Workflow.** Five sequential prompts — identity, optimization targets, anti-goals, constraints, leverage — synthesized into 3–5 prose paragraphs (lead = identity), reviewed, then written to disk with a `Last updated:` date. The update flow reads the current profile, summarizes it, and asks whether to revise specific sections or rewrite from scratch.

**Output discipline.** Profile starts with a single `Last updated: YYYY-MM-DD` line, then prose paragraphs. No bulleted lists in the profile itself — prose only. Whole profile under ~500 words.

## Adding assets

Authoring conventions live in `CLAUDE.md`. Briefly: skills need `name` + `description` frontmatter and follow the imperative-rules / Workflow / Output-discipline pattern; slash commands are second-person Markdown prompts ending in `$ARGUMENTS`. The only validation is that files parse as Markdown (and, for skills, that the YAML frontmatter is valid).
