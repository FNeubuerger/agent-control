---
name: "Writing Docs"
description: "Use when writing or updating documentation, API contracts, setup guides, architecture explanations, or decision records. Keep documentation accurate, discoverable, and grounded in current code."
applyTo: "**/*.md,**/*.mdx,**/*.rst"
---

# Writing documentation

## Start with the reader and the source of truth

- Read the relevant code and existing docs before writing. State the audience
  and task; distinguish tutorials, task-oriented guides, reference, and explanation.
- Update the existing canonical page rather than creating a parallel version.
  Keep entry points and agent instructions short and link to details.
- Use the repository's established locations. Human documentation normally
  belongs in `docs/`; reuse `.agent/docs/` or `docs/agent/` only if already used.
  Do not create a second documentation tree or an agent copy of every human page.
- Update directly affected docs without a separate approval round. Ask before
  introducing a new documentation hierarchy or substantial unrelated material.

## Document the contract, not the obvious implementation

- Keep setup and usage accurate: prerequisites, supported versions, commands,
  configuration, expected results, and common failures.
- For public APIs, document inputs, outputs, defaults, errors, side effects,
  compatibility guarantees, and a minimal usable example. Use the existing
  API reference or docstring convention; avoid duplicating generated reference.
- For architecture changes, explain responsibilities, boundaries, data flow,
  dependencies, and important failure modes at the affected scope.
- Record consequential architectural decisions using the existing ADR convention,
  or a concise decision record in `docs/decisions/` if none exists. Include
  context, options, the decision, tradeoffs, consequences, and status. Routine
  implementation details do not need an ADR.
- Explain non-obvious intent and constraints rather than narrating each line.
  Describe current behavior; mark proposals and uncertainty explicitly.

## Make shared understanding cheap

- When asked how a feature works, trace that specific feature in today's code:
  entry point, main collaborators, state transitions, and externally visible result.
- Cite files and symbols, distinguish observed facts from inference, and mention
  verification limits. Include the commit when saving a time-sensitive explainer.
- Use a small Mermaid diagram or table if it clarifies the flow. Do not generate
  a whole-codebase overview, HTML artifact, or persistent explainer unless needed
  for the request.
- Capture lasting constraints in canonical docs or a decision record, not in
  chat transcripts, task logs, or a redundant agent-only knowledge base.

## Check the result

- Verify commands, examples, links, paths, and stated defaults against the source.
  Use the existing documentation build or link checker when available.
- Do not execute destructive commands just to validate an example; state what
  was checked statically and what was run.
- Update navigation and remove statements made stale by the change.
- Keep prose concise, scannable, and consistent with project terminology.
  Never publish secrets or unredacted personal data in examples.
