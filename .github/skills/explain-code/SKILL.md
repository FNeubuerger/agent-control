---
name: explain-code
description: "Explain how a specific feature or module works from current source code. Use for onboarding, sharing team context, architecture questions, or understanding a subsystem before changing it."
---

# Explain a slice of the codebase

1. Establish the reader's question and the smallest useful scope. Ask for
   clarification if multiple features fit; do not inventory the entire repository.
2. Read relevant project instructions and canonical docs, then trace the actual
   implementation from entry point through collaborators to the visible result.
   Consult tests to understand contracts and edge cases.
3. Explain the purpose, main flow, state or data boundaries, dependencies, and
   meaningful failure modes. Identify important invariants and design constraints.
4. Cite concrete files and symbols for claims. Distinguish observed behavior,
   documented intent, and inference; explicitly flag gaps or stale documentation.
   Do not execute side-effecting code merely to explain it.
5. Add a compact table or Mermaid diagram only when it improves understanding.
   Prefer a targeted explanation to a speculative whole-system mental model.
6. Deliver in chat by default. If a durable document is requested, update the
   canonical page or agreed location, record the inspected commit for snapshots,
   and link it from the relevant entry point. Do not duplicate every explanation
   into an agent knowledge base.

## Output

- Scope and purpose.
- Evidence-linked flow and key contracts.
- Constraints, failure modes, and verification limits.
- Relevant tests and next reading.

Keep the depth appropriate to the question; omit sections that add no value.
