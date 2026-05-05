You are reviewing a populated article outline before it goes to drafting. The user is about to spend significant effort converting this outline into prose, so your job is to catch structural problems now, when they're cheap to fix.

Read the outline file the user names. Also read OUTLINE_FORMAT.md so you understand the conventions, and CLAUDE.md for context on the author's voice and style.

Default critique level is "pre-draft check" — focused on whether this outline is ready to draft from. Adjust if user passes an argument:
- `gaps` — only check for missing material (unsourced claims, empty sections, weak evidence).
- `structure` — only check argument flow and section ordering.
- `full` (default) — both, plus scope, fit, and audience match.

## What to check

**Argument coherence**
- Does the thesis in the frontmatter match what the sections actually argue?
- Does each section's function move the argument forward, or are some redundant?
- Does the section order build the argument, or does it require the reader to hold ideas in suspension too long?
- Are there logical gaps — claims in later sections that depend on unestablished material?

**Evidence and sources**
- Every must-establish claim: is there a source listed in Notes/Sources, or is it implied to be common knowledge? Flag claims where a citation will be needed but no source is present.
- Are the cited sources actually in the project directory, or are they placeholders?
- Sections with notes but no sources — is this a section that argues from data the user has, or a gap?
- Sections with sources but thin notes — is the user planning to develop the argument at draft time, or has this section not been thought through?

**Audience and depth match**
- Given the stated audience and depth, are there sections that over-explain or under-explain? A specialist audience does not need a paragraph defining "achondrite"; a popular audience does.
- Is the technical depth consistent across sections, or does one section assume far more than another?

**Scope and length**
- Do the section length targets sum to the overall target?
- Are any sections doing too much (likely to balloon at draft time) or too little (likely to feel thin)?
- Does the publication's conventions match what's outlined? A 4000-word piece for a venue that publishes 1500-word letters is a problem to catch now.

**Open questions**
- Are there unresolved Open Questions that block drafting? Distinguish between "the author will figure this out as they draft" (fine) and "this needs a decision before prose can start" (blocker).

## Output format

1. **Readiness assessment** (one sentence): is this outline ready to draft from, or are there blockers?
2. **Blockers** (numbered): things that must be resolved before drafting. These are the items that will cause major rewrites if left unresolved.
3. **Significant gaps** (numbered): missing sources, thin sections, unresolved questions. Should address but won't block.
4. **Suggestions** (optional): structural ideas, alternative section orders, scope adjustments worth considering.

Refer to outline content by section heading. Do not rewrite the outline — diagnose only. If the user wants edits applied, they'll invoke outline-builder.

End with one sentence: recommendation (ready / minor fixes / major revision needed before drafting).

Outline file: $ARGUMENTS
