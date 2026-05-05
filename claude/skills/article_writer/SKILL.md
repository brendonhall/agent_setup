---
name: article-writer
description: Use when drafting, revising, or restructuring scientific manuscripts and long-form articles. Triggers on requests to draft a paper, work on a manuscript, expand a section, write an abstract/intro/discussion, or revise prose for a journal submission. Do NOT use for short blog posts, emails, or general writing — ~/.claude/CLAUDE.md handles voice for everything.
---

# Article Writer

Governs process and structure for manuscript work. Voice and prose conventions defer to ~/.claude/CLAUDE.md.

## Hard rules

1. **Read the source material first.** Before drafting any factual claim, read the relevant files in the project directory — data files, cited papers (typically in `refs/`), notes, prior drafts. Never write a claim from assumed knowledge. If a fact would need a citation in the final manuscript, the source must exist in this directory or be explicitly provided.

2. **Honor the flag conventions.**
   - `[STYLE]` → revise the marked passage to match the style guide. Do not add, remove, or reframe claims.
   - `[IMPROVE]` → open critique allowed; structural and argumentative suggestions welcome alongside prose edits.
   - Unflagged passages → minimal touch unless explicitly asked.

3. **Outline before prose for new sections.** Propose the section's argument as a paragraph-level outline (one line per paragraph, stating what that paragraph does), then wait for approval before drafting prose. Skip this for edits to existing prose.

4. **One section at a time.** Do not draft a full manuscript in one pass. Work section-by-section with review pauses, unless explicitly told otherwise.

5. **Citations are claims of fact.** Every `[Author Year]` placeholder must correspond to a real source available in the directory. If a claim needs a citation but no source is available, flag it as `[CITATION NEEDED: <what would be cited>]` rather than guessing.

6. **Numbers come from data, not memory.** Concentrations, isotope ratios, ages, uncertainties — sourced from data files or cited papers in the directory, with units and rounding consistent with the target journal.

## Workflow

**Fresh draft:**
1. Read CLAUDE.md, scan the project directory, note any explicit reference list.
2. Confirm scope: target journal/length, audience, central argument.
3. Propose section outline → paragraph-level argument structure.
4. After approval, draft section by section, presenting each for review.

**Revision pass:**
1. Identify the flag or scoped instruction.
2. Read surrounding context — full paragraph minimum, full section preferred.
3. Make the edit; briefly note non-obvious changes.
4. Never silently introduce new claims during style-only edits.

## Output discipline

- Markdown. `##` for sections, `###` for subsections.
- LaTeX math: `$...$` inline, `$$...$$` display.
- Refer to figures/tables by number; never invent them.
- When two phrasings or structural choices are both defensible, present both briefly and ask.
