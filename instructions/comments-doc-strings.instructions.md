---
name: 'Comments and Doc Strings'
description: 'Use when adding or editing code comments, docstrings, or public API reference. Explain contracts and non-obvious intent without narrating the implementation.'
---

## Writing comments and doc strings

- Comment non-obvious intent, invariants, constraints, or surprising tradeoffs.
  Do not narrate self-explanatory code.
- Document public API contracts using the project's existing convention:
  meaningful inputs, outputs, errors, side effects, and examples where helpful.
  "Sparse comments" is not a reason to omit necessary API documentation.
- Keep prose brief and accurate; update it when behavior changes.

### Avoid hysteresis

- Avoid details that are too _reflective_ of the current task you're on.
    - For example, describing why and how a certain line fixes a bug is *usually not* desirable.
    - In other words, avoid the _hysteresis_ of how you arrived at your state, and consider a stateless mindset.
