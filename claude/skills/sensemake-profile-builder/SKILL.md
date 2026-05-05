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
