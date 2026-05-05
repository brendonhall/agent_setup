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
