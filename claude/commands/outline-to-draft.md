Convert a populated outline into a first draft, one section at a time, with strict discipline about what may and may not be added.

Read the outline file the user names, OUTLINE_FORMAT.md, ~/.claude/CLAUDE.md, and every source file referenced in the outline's Sources sections. Do not begin drafting until all sources have been read.

## Hard rules

1. **The outline is the contract.** Every must-establish claim must appear in the draft. No major claim may appear in the draft that wasn't in the outline. Connective and transitional prose is allowed; new arguments are not.

2. **Notes are the raw material.** Convert the user's bullet notes into prose. Do not introduce facts, examples, or framings absent from the notes and sources. If the user wrote a half-sentence note, expand it into a sentence — don't extrapolate it into a paragraph of new ideas.

3. **Sources must support claims.** Every claim with a source listed gets cited inline as `[Author Year]`. Every claim that needs a citation but lacks a source in the outline gets flagged inline as `[CITATION NEEDED: <what would be cited>]`. Do not invent citations.

4. **Length targets are real.** Each section's draft should land within ±20% of its outline length target. If a section can't be done at the target length without losing material, stop and ask whether to expand the target or cut content — don't silently overshoot.

5. **Section by section.** Draft one section, present it, wait for review. Do not draft the full manuscript in one pass.

6. **Respect the author's voice.** ~/.claude/CLAUDE.md governs prose style. The `[STYLE]` and `[IMPROVE]` flags from the article-writer skill apply at revision time, not initial drafting.

## Workflow

1. Read all referenced sources. Confirm in chat which sources you've read and flag any referenced but missing.
2. Confirm starting section (default: first section in document order, but Methods or Results often draft more easily first for research articles).
3. Draft the section. Use the outline's must-establish claims as the structural skeleton; use the notes and sources as the substance.
4. Present the draft with a brief summary noting:
   - Any `[CITATION NEEDED]` flags inserted.
   - Any places where notes were thin and prose required interpolation (mark these in chat, not in the draft).
   - Any must-establish claim that couldn't be supported from available material.
5. Update outline status to `drafting` after first section completes; to `drafted` after all sections complete.

## Output discipline

- Write directly to a draft file (default `draft.md` in the same directory as the outline). Don't paste long prose into chat.
- Keep the outline file unchanged except for the status field — the user may want to refer back to it.
- Use the outline's section headings as the draft's section headings unless the user says otherwise.

Outline file: $ARGUMENTS
