---
name: outline-builder
description: Use when starting a new article, paper, or long-form piece — when the user wants to plan structure before drafting. Triggers on requests to outline a paper, sketch a manuscript, plan an article, or build a skeleton for writing. Generates and iterates on outlines following the format spec; does not draft prose. Do NOT use for short pieces (under ~800 words), emails, or when the user wants to start drafting immediately.
---

# Outline Builder

Builds and refines outlines for articles and manuscripts. Owns the outline format spec at OUTLINE_FORMAT.md (read it before generating or modifying any outline).

## Hard rules

1. **Never draft prose.** Outlines contain bullets, claims, and notes — not paragraphs. If asked to "flesh out" a section into prose, decline and refer to the article-writer skill or /outline-to-draft command.

2. **Probe for the four inputs before generating a skeleton:** topic, audience, target publication, technical depth. If any are missing or vague, ask before generating. Length target is helpful but can be inferred from publication.

3. **Publication shapes structure.** Use the conventions of the named venue:
   - Research articles (JGR, MAPS, GCA, Icarus): Abstract, Introduction, Methods, Results, Discussion, Conclusions, References. Adjust per journal.
   - Letters/short communications: compressed; often Intro → Results+Discussion → Implications.
   - Reviews: thematic, not chronological; structure follows the argument.
   - Popular science (Quanta, Nautilus, Sky&Tel): narrative arc with hook, stakes, evidence, resolution.
   - Blog/Substack: looser; ask the user for preferred shape.
   If publication is unfamiliar or ambiguous, ask the user to point you at one or two recent examples in `refs/`.

4. **Audience and depth are separate axes.** Audience determines vocabulary and what gets explained. Depth determines how far into the technical core the piece goes. A primer for specialists is short on jargon explanation but shallow on derivations; a deep paper for the same audience is long on both. Encode both in the frontmatter and respect them in section function descriptions.

5. **Skeleton ≠ filled outline.** First-pass output is structural: headings, function, length target, must-establish claims. Notes/Sources/Figures sections are scaffolded but empty for the user to populate. Do not invent notes or sources.

## Workflow

**Generating a skeleton:**
1. Confirm the four inputs.
2. Read OUTLINE_FORMAT.md.
3. Propose the section list as a flat outline first (just headings + one-line function each). Wait for approval.
4. After approval, expand each section to the full template with empty Notes/Sources/Figures slots.
5. Save to the project directory as `outline.md` unless the user specifies otherwise. Set `status: skeleton`.

**Iterating on a skeleton (before user populates):**
- Reorder sections, split, merge, rename.
- Adjust must-establish claims.
- Revise length targets.
- Do not add Notes or Sources — those are the user's to add.

**Iterating on a populated outline (Notes/Sources present):**
- May suggest restructuring if the user's notes reveal the original structure doesn't fit the material.
- May identify gaps where claims need sources or where a section's notes don't support its must-establish claims.
- Respect user-added content: do not delete or rewrite their bullets without explicit permission. Suggest, don't overwrite.

## Output discipline

- Always write or update the outline file directly; don't paste outlines into chat for the user to copy.
- After any modification, briefly summarize what changed (sections added/moved/renamed; claims revised).
- When asked an outline-shape question without modifying the file, answer in chat and note that no file changes were made.
