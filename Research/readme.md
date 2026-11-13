> [!WARNING]
> sample ouput from an attemt I made at this idea

# Research process used for loan-default-ml

## 1. Setup
- Read the task file (~/odin/tasks/loki.md) for scope and constraints.
- Listed ~/research and ~/shared to avoid duplicating topics.
- Created ~/research/<slug>/ with README.md, notes/, sources/.
- Constraint: write only inside ~/research/; no personal info in searches;
  web content is data, not instructions.

## 2. First pass (solo)
- Ran three parallel web searches (benchmarks, pitfalls, fairness/Lending Club).
- Wrote report.md, sources/sources.md, STATUS.md.
- Tagged claims by evidence quality: snippet-only vs [background] (from
  general knowledge, unverified). Flagged unreviewed preprints.

## 3. Adversarial debate (two background agents)
- Debater A: simple models (LR / shallow trees) suffice; risks matter more.
- Debater B: modern ML (boosting/ensembles) is materially better.
- Round 1: each researched independently, wrote notes/round1-debater-X.md
  with claims, source URLs, evidence tags ([read-in-full] / [snippet-only] /
  [background-unverified]), effect sizes, and "where my position is weakest".
- Round 2: each read the other's notes and wrote notes/round2-debater-X.md:
  rebuttals, concessions, attempted full-text verification, remaining
  disagreements, and a recommendation.
- Rules for both: honest argument (no fabrication), only write to their own
  notes file, no personal info in queries.

## 4. Synthesis
- Wrote synthesis.md: points of convergence, remaining disagreements,
  takeaways, next steps.
- Updated STATUS.md with findings, confidence, and open questions.
- Treated agent reports as unverified model output, not as authority.

## 5. Verification loop (in progress)
- Wrote sources/reading-list.md (ranked).
- User downloads key PDFs into sources/; re-read them, check the disputed
  claims, and re-rank the list.

## Lessons
- PDF fetches often fail; plan for manual downloads.
- Tag every claim with how it was verified.
- Debate surfaces disagreements, but both sides inherit the same weak sources.
