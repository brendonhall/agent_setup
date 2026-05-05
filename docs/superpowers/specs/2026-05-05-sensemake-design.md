# Sensemake — Design

## Context

A new slash command and accompanying skill for the agent_setup repo. Implements the article-sensemaking method described in https://commoncog.com/how-to-make-sense-of-ai, generalized beyond AI to any fast-moving domain. Designed so additional sensemaking criteria can be layered in over time.

## Method (distilled)

The Commoncog framework, adapted:

- **Outcome Orientation.** Every act of attention should be tied to a desired outcome. Generic "what is this article about" summaries are not the goal — analysis grounded in the user's specific situation is.
- **Surface, but don't validate, speculation.** Opinions, predictions, and forecasts are clearly labeled and reported, never taken as evidence. Eloquence is not evidence.
- **Field reports are first-class.** Concrete observations (specific tools, dates, outcomes, screencasts) are weighted heavily because they describe what actually happened.
- **The user's profile is the anchor.** "Does this matter to me?" can only be answered against an explicit account of role, goals, anti-goals, constraints, and leverage.

## Components

### 1. `/sensemake` slash command

Path in repo: `claude/commands/sensemake.md`. Installed at `~/.claude/commands/sensemake.md`. Invoked as `/sensemake <url-or-file-path-or-pasted-text>`.

**Input handling.** The command body inspects `$ARGUMENTS` and routes:
- Looks like a URL → `WebFetch`.
- Looks like a path → `Read`.
- Otherwise → treat as pasted article text.

**Profile gate.** First action: read `~/.claude/sensemake-profile.md`. If the file does not exist, the command stops and tells the user: *"No sensemake profile found at `~/.claude/sensemake-profile.md`. Run the sensemake-profile-builder skill first (just say 'create my sensemake profile')."* It does not silently fall back to a profile-less analysis — that defeats Outcome Orientation.

**Classification.** Each piece is classified into one of:
- **OPINION** — predictions, forecasts, takes, scenario forecasts, no first-hand observation.
- **FIELD REPORT** — concrete account of usage with specifics.
- **MIXED — ~X% opinion, ~Y% field report** — the common case.

**Output structure (uniform across classifications):**
1. **Source line** — title, author, date.
2. **Classification** — bold and unambiguous, one short line of justification.
3. **Core idea(s)** — 1–3 bullets, the author's thesis stated as their claim (not as fact).
4. **Field evidence** — concrete observations only; speculation excluded even when eloquent. If none: *"No first-hand evidence in this piece."*
5. **Constraints identified or mitigated** — bottlenecks the author names, mitigations proposed; each tagged *(author claim)* vs *(demonstrated)*.
6. **Impact on your objectives** — explicit cross-reference to profile content. Honest "no impact" answers are expected and valid.
7. **Possible actions** — concrete moves the user could make; *"None warranted"* is valid.
8. **Verdict** — one line: *act now / watch the space / file and forget*.

**Encoded discipline (in the prompt body):**
- Surface speculation; never validate it.
- Section 6 (impact on objectives) is load-bearing. If the answer is "none," that is the answer — don't manufacture relevance.
- Sections may be short when the article doesn't supply enough to fill them honestly.
- Don't be persuaded by eloquence in the speculative parts. Concrete observations earn weight; predictions don't.

### 2. `sensemake-profile-builder` skill

Path in repo: `claude/skills/sensemake-profile-builder/SKILL.md`. Installed at `~/.claude/skills/sensemake-profile-builder/SKILL.md`.

**Trigger contract (in YAML description):** activates on requests to create or update `~/.claude/sensemake-profile.md`. Trigger phrases include *"create my sensemake profile"*, *"update my sensemake profile"*, *"set up sensemaking"*. Does **not** trigger on ad-hoc edits the user can make by hand.

**Hard rules:**
1. Read the existing profile at `~/.claude/sensemake-profile.md` before asking anything else.
2. One prompt at a time. Wait for each answer before moving on.
3. Never invent or pad content. If the user's answer is short, the profile reflects that.
4. Final draft requires explicit user approval before writing the file.

**Create flow** — five prompts, sequential:
1. **Identity** — role, the business you run or work for, what you ship or are responsible for.
2. **Optimization targets** — outcomes you actually want over the next 1–3 years.
3. **Anti-goals** — directions you've explicitly ruled out (so analysis won't recommend them).
4. **Constraints** — time, capital, team size, other feasibility bounds.
5. **Leverage** — skills, network, customers, unfair advantages.

After the five answers, synthesize into 3–5 prose paragraphs (lead paragraph = identity), present for review, and write to `~/.claude/sensemake-profile.md` only after the user approves.

**Update flow:**
1. Read the current profile.
2. Summarize what it says, briefly.
3. Ask: *"Update specific sections, replace certain claims, or rewrite from scratch?"*
4. For targeted updates: ask follow-ups only on the sections being changed; preserve the rest verbatim.
5. For full rewrite: run create flow.
6. Present revised draft, get approval, write the file with an updated `Last updated:` date.

**Output discipline (for the profile content itself):**
- Markdown. `Last updated: YYYY-MM-DD` line at the top, then prose paragraphs.
- **No bulleted lists in the profile.** Prose only. (Bullets push toward checkbox-thinking; the Commoncog method rewards judgment.)
- Whole profile under ~500 words. Long enough to ground analysis, short enough to re-read in a minute.

### 3. Profile file

Lives at `~/.claude/sensemake-profile.md`. Not in this repo, not symlinked, not in version control. The skill creates and updates it. The command reads it. No template ships in the repo — the skill generates content from scratch on first run.

## Repo changes

**New files:**
- `claude/commands/sensemake.md`
- `claude/skills/sensemake-profile-builder/SKILL.md`
- `docs/superpowers/specs/2026-05-05-sensemake-design.md` (this file)

**Updated files:**
- `CLAUDE.md` — document the `~/.claude/sensemake-profile.md` convention and mention the new artifacts so future sessions know about them.
- `README.md` — short user-facing section on `/sensemake` setup and use.

**Not needed:**
- No `Makefile` changes — existing install logic handles new commands and skills automatically.
- No template file in the repo.

## Extensibility

The design assumes additional sensemaking frameworks may be layered in over time. Two patterns to watch:
- **New criteria within the existing command.** Tweaking the eight output sections, or adding domain-specific weighting, happens inside `claude/commands/sensemake.md` without changing the surface.
- **Conflicting frameworks.** If a future framework genuinely conflicts with Commoncog's filter (e.g., a method that *does* take forecasts seriously for a different domain), introduce a parallel command rather than overloading `/sensemake`.

The profile is framework-agnostic by design — identity, goals, anti-goals, constraints, leverage. Future frameworks should reuse it rather than introducing parallel context files.
