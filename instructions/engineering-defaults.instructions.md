---
name: "Engineering Defaults"
description: "Apply coding and documentation defaults across projects: simple designs, focused changes, verified behavior, API contracts, architecture decisions, and project-local quality hooks."
applyTo: "**"
---

# Engineering defaults

- Read the relevant code, tests, and docs before editing. Reuse existing patterns.
- State consequential assumptions and ask about ambiguity that affects behavior
  or architecture. Keep planning proportional to the task.
- Deliver the simplest complete solution. Avoid speculative features,
  abstractions, inheritance, and configuration.
- Keep edits focused; preserve unrelated changes and remove only the unused
  pieces your change creates.
- Define observable success, add focused regression or behavior tests, and run
  relevant existing checks. Report evidence and unverified gaps honestly.
- When setting up or substantially changing a code project, establish or maintain
  project-local pre-commit lint/format checks. For Python, prefer Ruff with
  pre-commit unless the project already uses an equivalent toolchain. Follow
  [quality-hook setup](./quality-hooks.instructions.md); do not change global
  Git hooks or rewrite unrelated code to satisfy new lint rules.
- Update affected setup, usage, and public API documentation with the code.
  Record consequential architecture decisions, not routine implementation details.
- Share understanding through bounded, source-backed explanations of current
  code. Keep permanent instructions short and link to canonical documentation.
- Review the final diff for bugs, compatibility risks, and stale documentation.
  Scale human review to risk; an agent cannot replace a required human approval.

Read and follow the detailed instructions relevant to the task:

| Instructions | Description |
|--------------|-------------|
| [Writing good code](./writing-good-code.instructions.md) | Explicit assumptions, simple designs, surgical edits, and measurable verification. |
| [Comments and doc strings](./comments-doc-strings.instructions.md) | Concise intent and complete public API contracts. |
| [Writing docs](./writing-docs.instructions.md) | Accurate guides, API reference, architecture decisions, and shared context. |
| [Quality hooks](./quality-hooks.instructions.md) | Project-local pre-commit setup, Ruff for Python, and reproducible validation. |
