---
name: "Writing Good Code"
description: "Use when planning, implementing, debugging, testing, or refactoring code. Favor explicit assumptions, simple designs, focused changes, and verified outcomes."
---

# Writing good code

## Understand before changing

- Read the relevant implementation, tests, and project documentation first. Find
  existing helpers and conventions before adding another implementation.
- State consequential assumptions. Ask when different interpretations would
  change behavior, scope, or architecture; do not silently choose for the user.
- Explain meaningful tradeoffs and suggest a simpler approach when appropriate.
  Keep the process proportionate: an obvious typo does not need a design review.

## Solve today's problem simply

- Implement the requested behavior completely, without speculative features,
  configuration, dependencies, inheritance, or extension points.
- Reuse an existing abstraction when it fits. Introduce a new one only when
  current requirements justify it, not to anticipate hypothetical growth.
- Preserve type safety and established error handling. Do not mask failures with
  broad catches, silent defaults, or success-shaped responses.

## Keep changes surgical

- Match the surrounding style and preserve unrelated user changes.
- Refactor only what the requested behavior requires. Do not reformat adjacent
  code or remove unrelated pre-existing dead code.
- Remove imports, helpers, and documentation made obsolete by this change.
- Consider all affected callers and interfaces, not just the first failing path.
  Call out intentional compatibility changes and their migration implications.

## Make success observable

- For non-trivial work, give a short plan with a concrete check for each outcome.
- For a bug fix, reproduce the failure with a focused regression test when
  feasible; for new behavior, test the contract and meaningful failure cases.
- Run the smallest relevant existing tests, type checks, lint, or build. Broaden
  validation when shared behavior or targeted failures warrant it.
- Verify the actual requirement, not merely a proxy such as compilation.
  For UI changes, inspect the affected interaction when tools are available.
- For critical invariants, consider a formal proof where its benefit justifies
  the cost. [Bend](https://github.com/bendlang/bend) is one option; ask before
  adding it or another new language or toolchain. If adopted, check the stated
  properties and their assumptions, run the project's proof checks, and report
  failures or gaps. A proof of a separate model does not by itself prove the
  production implementation. Keep relevant tests and integration checks.
- Review the final diff for unintended changes and unnecessary complexity.
  Report commands, outcomes, and remaining gaps; never imply an unrun check passed.

## Share durable context

- Update affected documentation in the same change. Record architectural
  decisions when they create meaningful constraints or tradeoffs.
- Explain unfamiliar code by tracing a bounded slice of the current
  implementation, citing evidence rather than inventing a system-wide model.
- When a review repeatedly finds the same issue, propose a focused test, lint
  rule, or short instruction at the source. Do not turn every observation into
  permanent policy or change team-wide rules without agreement.
