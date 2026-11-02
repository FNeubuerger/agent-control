---
name: "Quality Hooks"
description: "Use when setting up a code project, adding pre-commit hooks, configuring linters or formatters, or maintaining Python Ruff checks."
---

# Project-local quality hooks

1. Inspect the repository's language, dependency manager, lint configuration,
   CI, `.pre-commit-config.yaml`, and Git hook configuration. Reuse an equivalent
   existing toolchain; do not introduce a second formatter or override an existing
   hook manager. Never set global `core.hooksPath`.
2. When a code project lacks local quality checks, add project-local pre-commit
   lint/format checks as part of setup or substantial code work. Do not introduce
   tools for languages absent from the project or install them for a docs-only edit.
3. For Python without an equivalent toolchain, add `pre-commit` to the project's
   development dependencies using its existing package manager. Configure
   `https://github.com/astral-sh/ruff-pre-commit` with an explicitly pinned,
   verified release and the `ruff-check` (with `--fix`) and `ruff-format` hooks.
   Verify hook IDs against that release; do not guess a revision. Respect existing
   Ruff configuration in `pyproject.toml` or `ruff.toml`, including Python targets
   and exclusions. Do not enable all rules or adopt another formatter by default.
4. Install dependencies through the project's environment, then run
   `pre-commit install` there. Check any existing hooks first; if a hook manager
   or `core.hooksPath` conflicts, explain the conflict and ask before replacing it.
   Hook installation is local to that clone, not enforced by a committed config.
5. Run `pre-commit run --all-files` and inspect the resulting diff. Hooks may
   modify files; rerun after fixing issues. Do not commit unrelated mass formatting.
   If the baseline is dirty, report it and agree on a scoped rollout rather than
   silently ignoring failures, using `--no-verify`, or weakening rules.
6. Document dependency installation, hook installation for each clone, manual
   checks, and any CI equivalent in the existing contributor guide or README.
   Reuse the same configuration in CI when CI changes are in scope. Hooks are
   bypassable and do not replace tests or required CI checks.
7. Report the exact commands, outcomes, and any network/tooling limitations.
   Never claim hooks were installed or passed without running the corresponding
   command successfully.
