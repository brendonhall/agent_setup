# Outline Format Specification

## File header (YAML frontmatter)

```yaml
---
title: working title (revisable)
publication: target journal/venue
audience: one-line description (e.g., "planetary geochemists familiar with NanoSIMS")
technical_depth: assumed background (e.g., "expert: assumes XRD, IR spectroscopy")
target_length: word count (or "1-page letter", "8-page article")
thesis: one-sentence central argument
status: skeleton | populated | critiqued | drafting | drafted
---
```

## Section structure

Each section uses this template:

```markdown
## [Section heading]

**Function:** What this section does for the overall argument. One sentence.
**Length:** Word target.
**Must establish:**
- Claim 1
- Claim 2

**Notes:**
(User-supplied bullets, prose fragments, observations.)

**Sources:**
- path/to/paper.pdf — what it supports
- [Author Year] — what it supports
- data/file.csv — what it shows

**Figures/data:**
- Fig 1: description, source file
- Table 1: description

**Open questions:**
- Things to resolve before drafting.
```

## Conventions

- Sections in document order match draft order.
- "Must establish" claims are the contract: the draft must support each, and must not introduce major claims absent from this list.
- "Notes" are raw material — bullets, half-sentences, links. Not prose.
- Empty sections are allowed during skeleton phase; flag them at critique.
- A claim with no source listed will be flagged at draft time as `[CITATION NEEDED]`.
