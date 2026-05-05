# Sensemake Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `/sensemake` slash command and a `sensemake-profile-builder` skill that apply the Commoncog "make sense of AI" method (generalized to any domain) to articles, anchored in a personal profile at `~/.claude/sensemake-profile.md`.

**Architecture:** Two new prompt artifacts in this repo plus targeted edits to `CLAUDE.md` and `README.md`. The slash command reads the user's profile, classifies the input article, and produces an eight-section structured analysis. The skill walks the user through five sequential prompts to create or update the profile. The profile lives outside the repo at `~/.claude/sensemake-profile.md` and is not version-controlled. No Makefile changes — existing install logic handles new commands and skills.

**Tech Stack:** Markdown prompts, YAML frontmatter (skills only), bash for verification. No application code or test framework — verification is parse checks plus structural greps for required content. Spec at `docs/superpowers/specs/2026-05-05-sensemake-design.md`.

---

## File Structure

| Path | Action | Responsibility |
| --- | --- | --- |
| `claude/commands/sensemake.md` | Create | Slash command body. Reads profile, classifies article, produces structured analysis. |
| `claude/skills/sensemake-profile-builder/SKILL.md` | Create | Skill prompt. Walks user through profile creation/update. |
| `CLAUDE.md` | Modify (add paragraph in Cross-references) | Document the out-of-repo personal-context-file convention. |
| `README.md` | Modify (add two subsections) | User-facing usage notes for `/sensemake` and `sensemake-profile-builder`. |
| `~/.claude/sensemake-profile.md` | (Out of scope — created by the skill at runtime, not in this plan) | Personal context, not in version control. |

---

## Conventions used in verification steps

This repo has no test runner. "Verification" means:
- **Parse check:** the file is readable as Markdown and (for skills) the YAML frontmatter parses.
- **Content check:** required strings/structures are present (via `grep -F`).
- **Install check:** `make install` (or `make status`) shows the file symlinked to the expected `~/.claude/` location.

---

## Task 1: Create the `/sensemake` slash command

**Files:**
- Create: `claude/commands/sensemake.md`

- [ ] **Step 1: Pre-check — confirm the file does not yet exist**

Run:
```bash
test ! -e claude/commands/sensemake.md && echo "OK: not present" || echo "FAIL: already exists"
```
Expected: `OK: not present`

- [ ] **Step 2: Create the command file with full content**

Write `claude/commands/sensemake.md` with exactly this content:

```markdown
You are reading and analyzing an article using a sensemaking method derived from Commoncog's *How to Make Sense of AI* (https://commoncog.com/how-to-make-sense-of-ai), generalized to any fast-moving domain. The goal is not a generic summary — it is an analysis grounded in the user's specific outcomes and constraints.

## Step 1: Read the user's profile

Before doing anything else, read `~/.claude/sensemake-profile.md`. This file contains the user's identity, optimization targets, anti-goals, constraints, and leverage. It is the anchor for section 6 (impact on objectives) and shapes everything else you produce.

If the file does not exist, stop and reply with exactly this and nothing else:

> No sensemake profile found at `~/.claude/sensemake-profile.md`. Run the sensemake-profile-builder skill first — just say "create my sensemake profile".

Do not proceed without the profile. A profile-less analysis defeats the point of the method.

## Step 2: Acquire the article

Inspect `$ARGUMENTS` and route accordingly:

- Starts with `http://` or `https://` → use `WebFetch`.
- Starts with `/`, `~`, or `./`, or otherwise looks like a file path → use `Read`.
- Otherwise → treat the entire `$ARGUMENTS` content as the pasted article body.

If the input is ambiguous, prefer the most generous interpretation (try fetching/reading; if that fails, fall back to treating it as pasted text).

## Step 3: Classify

Decide which classification fits the piece:

- **OPINION** — predictions, forecasts, takes, scenario forecasts; no first-hand observation.
- **FIELD REPORT** — concrete account of usage with specifics: tools used, dates, what was built, what happened.
- **MIXED — ~X% opinion, ~Y% field report** — the common case. Estimate the proportions.

## Step 4: Produce the analysis

Use this exact structure regardless of classification. Sections may be short when the article does not supply enough material to fill them honestly. Do not pad.

1. **Source line** — title, author, date.
2. **Classification** — render in **bold**, with one short line of justification.
3. **Core idea(s)** — 1–3 bullets capturing the author's thesis. State each as the author's claim, not as fact.
4. **Field evidence** — concrete observations the author made or witnessed only. Speculation excluded even when eloquent. If none: "No first-hand evidence in this piece."
5. **Constraints identified or mitigated** — bottlenecks the author names, mitigations they propose. Tag each *(author claim)* or *(demonstrated)*.
6. **Impact on your objectives** — explicitly cross-reference the profile content (role, optimization targets, anti-goals, constraints, leverage). Honest "no impact" answers are valid and expected. Do not manufacture relevance.
7. **Possible actions** — concrete moves the user could make. "None warranted" is a valid answer.
8. **Verdict** — one line: *act now / watch the space / file and forget*.

## Discipline

- Surface speculation; never validate it. Eloquence is not evidence.
- Section 6 is load-bearing. If the answer is "no impact," that is the answer.
- Treat speculative bits as the mutterings of a friend high on LSD — note them, do not be persuaded by them.
- When the article does not contain enough material to fill a section honestly, leave it short rather than padding.

Article reference: $ARGUMENTS
```

- [ ] **Step 3: Verify the file parses as Markdown and contains required structural anchors**

Run:
```bash
test -f claude/commands/sensemake.md && echo "EXISTS"
grep -F 'Article reference: $ARGUMENTS' claude/commands/sensemake.md
grep -F '~/.claude/sensemake-profile.md' claude/commands/sensemake.md
grep -cE '^[0-9]+\. \*\*' claude/commands/sensemake.md
```
Expected:
- `EXISTS`
- The literal `Article reference: $ARGUMENTS` line is found.
- The profile path is referenced at least twice.
- The numbered list count is `8` (the eight output sections).

- [ ] **Step 4: Commit**

```bash
git add claude/commands/sensemake.md
git commit -m "$(cat <<'EOF'
Add /sensemake slash command

Applies the Commoncog "make sense of AI" method to articles, anchored
in the user's profile at ~/.claude/sensemake-profile.md. Produces an
eight-section structured analysis with explicit impact-on-objectives
grounding.
EOF
)"
```

---

## Task 2: Create the `sensemake-profile-builder` skill

**Files:**
- Create: `claude/skills/sensemake-profile-builder/SKILL.md` (directory + file)

- [ ] **Step 1: Pre-check — confirm the directory does not yet exist**

Run:
```bash
test ! -e claude/skills/sensemake-profile-builder && echo "OK: not present" || echo "FAIL: already exists"
```
Expected: `OK: not present`

- [ ] **Step 2: Create the skill directory and SKILL.md with full content**

Create the directory: `mkdir -p claude/skills/sensemake-profile-builder`

Write `claude/skills/sensemake-profile-builder/SKILL.md` with exactly this content:

```markdown
---
name: sensemake-profile-builder
description: Use when the user wants to create or update their sensemake profile at ~/.claude/sensemake-profile.md — the personal-context file that the /sensemake slash command reads to ground impact-on-objectives analysis. Triggers on phrases like "create my sensemake profile", "update my sensemake profile", "set up sensemaking", "rebuild my sensemake context". Do NOT use for ad-hoc edits the user can make by hand to a known section; only for guided creation or substantive revision.
---

# Sensemake Profile Builder

Walks the user through creating or updating `~/.claude/sensemake-profile.md`. Voice and prose conventions defer to `~/.claude/CLAUDE.md`.

## Hard rules

1. **Read the existing profile first.** Before asking anything, check whether `~/.claude/sensemake-profile.md` exists. If it does, read it and acknowledge what is there before going further.

2. **One prompt at a time.** Ask the questions sequentially. Wait for the user's answer before moving to the next.

3. **Never invent or pad content.** If the user's answer is short or vague, the profile reflects that. Do not fill space with assumptions about who they are or what they want.

4. **Final draft requires explicit approval.** Synthesize, present the prose, revise on request, and only write to disk after the user confirms.

## Workflow

**Create flow** (no existing profile, or user opted to rewrite):

1. Walk through these prompts, one at a time:
   - **Identity.** What is your role? What business do you run or work for? What do you ship or are you responsible for?
   - **Optimization targets.** What outcomes do you actually want over the next 1–3 years?
   - **Anti-goals.** What directions have you explicitly ruled out, so analysis will not recommend them?
   - **Constraints.** Time, capital, team size, anything else that bounds what is feasible for you?
   - **Leverage.** Skills, network, customers, unfair advantages — where do you have an edge?
2. Synthesize the answers into 3–5 prose paragraphs. Lead with an identity paragraph; let the rest flow naturally rather than mapping 1:1 to the prompt order.
3. Present the draft for review. Revise on request.
4. On approval, write to `~/.claude/sensemake-profile.md`. Top of file: a single `Last updated: YYYY-MM-DD` line (today's date), followed by a blank line, then the prose.

**Update flow** (existing profile, user wants to revise):

1. Read the current profile.
2. Briefly summarize what it currently says — one or two sentences.
3. Ask: "Update specific sections, replace certain claims, or rewrite from scratch?"
4. For targeted updates: ask follow-up questions only on the sections being changed. Preserve the rest verbatim.
5. For full rewrite: run the create flow.
6. Present the revised draft for review. Get explicit approval.
7. Write to `~/.claude/sensemake-profile.md`, refreshing the `Last updated:` date to today.

## Output discipline

- Markdown. The profile starts with a single `Last updated: YYYY-MM-DD` line, followed by a blank line, then prose paragraphs.
- **No bulleted lists in the profile itself.** Prose only. Bullets push toward checkbox-thinking; the Commoncog method rewards judgment.
- Whole profile under ~500 words. Long enough to ground analysis, short enough to re-read in a minute.
- Write the file using the `Write` tool. Never echo or cat the content into the file from the shell.
```

- [ ] **Step 3: Verify the file exists, frontmatter parses as YAML, and required content is present**

Run:
```bash
test -f claude/skills/sensemake-profile-builder/SKILL.md && echo "EXISTS"
python3 -c "
import yaml, sys
with open('claude/skills/sensemake-profile-builder/SKILL.md') as f:
    text = f.read()
parts = text.split('---', 2)
if len(parts) < 3:
    sys.exit('FAIL: no frontmatter delimiters')
fm = yaml.safe_load(parts[1])
assert fm.get('name') == 'sensemake-profile-builder', f'FAIL name: {fm.get(\"name\")}'
assert 'description' in fm and len(fm['description']) > 50, 'FAIL description missing or too short'
assert 'create my sensemake profile' in fm['description'], 'FAIL: trigger phrase missing'
assert 'Do NOT' in fm['description'] or 'do not' in fm['description'].lower(), 'FAIL: when-not-to-use clause missing'
print('YAML OK')
"
grep -F '## Hard rules' claude/skills/sensemake-profile-builder/SKILL.md
grep -F '## Workflow' claude/skills/sensemake-profile-builder/SKILL.md
grep -F '## Output discipline' claude/skills/sensemake-profile-builder/SKILL.md
```
Expected:
- `EXISTS`
- `YAML OK`
- All three section headers (`## Hard rules`, `## Workflow`, `## Output discipline`) found.

- [ ] **Step 4: Commit**

```bash
git add claude/skills/sensemake-profile-builder/SKILL.md
git commit -m "$(cat <<'EOF'
Add sensemake-profile-builder skill

Walks the user through creating or updating ~/.claude/sensemake-profile.md
via five sequential prompts (identity, optimization targets, anti-goals,
constraints, leverage). Synthesizes answers into prose under ~500 words.
Supports both create and targeted-update flows.
EOF
)"
```

---

## Task 3: Update `CLAUDE.md` to document the personal-context-file convention

**Files:**
- Modify: `CLAUDE.md` (add a paragraph at the end of the Cross-references section, around line 38)

- [ ] **Step 1: Pre-check — confirm the new content is not yet present**

Run:
```bash
grep -F 'sensemake-profile.md' CLAUDE.md && echo "FAIL: already present" || echo "OK: not present"
```
Expected: `OK: not present`

- [ ] **Step 2: Edit CLAUDE.md**

Use the `Edit` tool to replace this exact block in `CLAUDE.md`:

**Old:**
```
## Cross-references

Both existing artifacts assume `~/.claude/CLAUDE.md` exists on the host machine and carries the user's stylistic/voice preferences. Treat that file as authoritative for voice; this repo's content layers process and structure on top.
```

**New:**
```
## Cross-references

Both existing artifacts assume `~/.claude/CLAUDE.md` exists on the host machine and carries the user's stylistic/voice preferences. Treat that file as authoritative for voice; this repo's content layers process and structure on top.

Some artifacts also depend on out-of-repo personal-context files at `~/.claude/` that are intentionally not version-controlled. The first example is `~/.claude/sensemake-profile.md` — created and maintained via the `sensemake-profile-builder` skill, read by the `/sensemake` command. When adding a new artifact that relies on out-of-repo personal context, document the file path and how it gets created.
```

- [ ] **Step 3: Verify the new paragraph is in place**

Run:
```bash
grep -F 'sensemake-profile.md' CLAUDE.md
grep -F 'out-of-repo personal-context files' CLAUDE.md
```
Expected: both greps match exactly one line each.

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.md
git commit -m "$(cat <<'EOF'
Document out-of-repo personal-context file convention

Adds a paragraph to Cross-references noting that some artifacts depend
on un-versioned files at ~/.claude/, with the sensemake profile as the
first example.
EOF
)"
```

---

## Task 4: Update `README.md` with usage notes

**Files:**
- Modify: `README.md` (add `### /sensemake` subsection under "Slash commands" and `### sensemake-profile-builder` subsection under "Skills")

- [ ] **Step 1: Pre-check — confirm new content is not yet present**

Run:
```bash
grep -F '### `/sensemake`' README.md && echo "FAIL: already present" || echo "OK: command section absent"
grep -F '### `sensemake-profile-builder`' README.md && echo "FAIL: already present" || echo "OK: skill section absent"
```
Expected: both lines print the `OK:` variant.

- [ ] **Step 2: Add the `/sensemake` subsection**

Use the `Edit` tool. Insert immediately after the existing `/peer-review` block, which ends with this fenced example block:

**Old:** (lines 44–47 in current README.md)
```
```
/peer-review intro.md
/peer-review editor abstract.md
```

## Skills
```

**New:**
```
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
```

- [ ] **Step 3: Add the `sensemake-profile-builder` subsection**

Use the `Edit` tool. Append at the very end of the existing `article-writer` block, immediately before the `## Adding assets` heading.

**Old:** (the line `**Output discipline.**` paragraph through `## Adding assets`)
```
**Output discipline.** Markdown (`##` for sections, `###` for subsections), LaTeX math (`$...$` inline, `$$...$$` display), figures and tables referred to by number — never invented. When two phrasings or structures are both defensible, present both briefly and ask.

## Adding assets
```

**New:**
```
**Output discipline.** Markdown (`##` for sections, `###` for subsections), LaTeX math (`$...$` inline, `$$...$$` display), figures and tables referred to by number — never invented. When two phrasings or structures are both defensible, present both briefly and ask.

### `sensemake-profile-builder`

Walks the user through creating or updating `~/.claude/sensemake-profile.md` — the personal-context file that the `/sensemake` command reads to ground its impact-on-objectives analysis. Triggers on phrases like *"create my sensemake profile"*, *"update my sensemake profile"*, *"set up sensemaking"*. Not for ad-hoc edits the user can make by hand.

**Hard rules.** Read the existing profile first if present; ask one prompt at a time; never invent or pad content; final draft requires explicit approval before writing the file.

**Workflow.** Five sequential prompts — identity, optimization targets, anti-goals, constraints, leverage — synthesized into 3–5 prose paragraphs (lead = identity), reviewed, then written to disk with a `Last updated:` date. The update flow reads the current profile, summarizes it, and asks whether to revise specific sections or rewrite from scratch.

**Output discipline.** Profile starts with a single `Last updated: YYYY-MM-DD` line, then prose paragraphs. No bulleted lists in the profile itself — prose only. Whole profile under ~500 words.

## Adding assets
```

- [ ] **Step 4: Verify both new subsections are in place**

Run:
```bash
grep -F '### `/sensemake`' README.md
grep -F '### `sensemake-profile-builder`' README.md
grep -cF 'sensemake-profile.md' README.md
```
Expected:
- Both `### ` headings match.
- The profile path `sensemake-profile.md` appears at least 3 times in README.md.

- [ ] **Step 5: Commit**

```bash
git add README.md
git commit -m "$(cat <<'EOF'
Document /sensemake and sensemake-profile-builder in README

Adds usage subsections under Slash commands and Skills, mirroring the
structure used for /peer-review and article-writer.
EOF
)"
```

---

## Task 5: End-to-end install verification

**Files:** none (read-only verification of install state)

- [ ] **Step 1: Run `make install`**

Run:
```bash
make install
```
Expected: output reports the new command and skill being symlinked (or "already linked" if a previous run installed them). No errors, no conflicts.

- [ ] **Step 2: Verify the symlinks resolve to this repo**

Run:
```bash
readlink -f ~/.claude/commands/sensemake.md
readlink -f ~/.claude/skills/sensemake-profile-builder/SKILL.md
```
Expected:
- First line ends with `agent_setup/claude/commands/sensemake.md`.
- Second line ends with `agent_setup/claude/skills/sensemake-profile-builder/SKILL.md`.

- [ ] **Step 3: Run `make status` and confirm no conflicts**

Run:
```bash
make status
```
Expected: the new command and skill are listed as installed and resolving back into this repo. No conflicts reported for these files.

- [ ] **Step 4: Smoke-test the missing-profile gate**

Run:
```bash
test -f ~/.claude/sensemake-profile.md && echo "Profile exists — skip smoke test" || echo "Profile absent — gate path is the one to verify in the next /sensemake invocation"
```

If the profile does not exist, manually invoke `/sensemake https://example.com/anything` in a Claude Code session. Confirm the response is exactly the missing-profile message defined in Task 1, Step 2 (no analysis, no fallback). If the profile already exists, this smoke test is informational only; the gate path is exercised on a fresh machine.

- [ ] **Step 5: No commit**

This task is verification only. No file changes were made.

---

## Self-review notes

- **Spec coverage.** Each spec section maps to a task: command (Task 1), skill (Task 2), CLAUDE.md update (Task 3), README update (Task 4), end-to-end check (Task 5). The "no template file in the repo" decision is honored — no task creates one. The "no Makefile changes" decision is honored — Task 5 confirms install works untouched.
- **Placeholder scan.** Every step shows the actual content, the actual command, and the expected output. No `TBD`, no "implement later," no "similar to Task N."
- **Type consistency.** The skill name `sensemake-profile-builder` and the command name `sensemake` are used identically in every task and in both repo edits. The profile path `~/.claude/sensemake-profile.md` is used identically in every task.
- **Naming alignment with existing repo style.** The skill folder uses hyphens (`sensemake-profile-builder`) matching the convention in this repo's CLAUDE.md ("matching `~/.claude/` names"); existing `article_writer` uses an underscore but the trigger contract / hard rules / workflow / output discipline shape is preserved.
