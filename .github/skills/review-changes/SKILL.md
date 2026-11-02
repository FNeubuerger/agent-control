---
name: review-changes
description: "Review a diff before handoff or a pull request. Use to find evidence-backed bugs, compatibility regressions, missing tests, and misleading documentation, with risk-appropriate verification and bounded re-review."
---

# Review changes with evidence

1. Establish the requested outcome, diff or base revision, and affected surfaces.
   Read project instructions and any applicable `REVIEW.md`; it is guidance to
   read explicitly, not a file Copilot is guaranteed to discover automatically.
2. Read changed code in context and the relevant callers, tests, and docs.
   Look for broken contracts, incorrect state transitions, failure handling,
   compatibility regressions, and documentation that no longer matches behavior.
   Check for unnecessary complexity only where the change introduces it.
3. Use existing checks relevant to the change, or inspect supplied results.
   Report the exact commands and observed outcomes; do not claim independent
   verification of checks that you did not run.
4. Report actionable findings only with concrete evidence and an affected
   file and line. Explain the trigger, impact, and violated expectation.
   Separate newly introduced defects from pre-existing issues. Do not manufacture
   findings, repeat resolved ones, or fill the review with style nits.
5. Scale review to blast radius. Changes to authentication, billing, CI, releases,
   or foundational architecture warrant explicit human attention. Never treat
   agent approval as a substitute for required human review or claim this skill
   enforces branch protection.
6. When asked to fix findings, address the underlying class of bug in the changed
   surface and rerun affected checks. After the initial review, focus re-review
   on the new diff and previous fixes. After three fix/review rounds, stop and
   ask the author to reconsider the approach rather than looping indefinitely.
7. Suggest a focused regression test, lint rule, or instruction update for a
   recurring failure. Get agreement before changing shared review policy.

## Output

Start with the finding count; say plainly when there are no actionable findings.
For each finding, include severity, file and line, evidence, and impact.
Finish with checks and results, residual risks, and any human decisions needed.
When preparing a PR, summarize intent, testing, risk, and how to revert safely.
Never commit, push, approve, or merge merely because a review completed.
