# Working on agent-control

This repository contains reusable agent instructions and skills, not an
application. Follow the [engineering defaults](../instructions/copilot-instructions.md)
and the linked guidance relevant to the task.

- Keep reusable guidance independent of a particular language, framework, or
  personal filesystem. Put installation and harness details in the README.
- Keep baseline practices in instructions; use skills for bounded, on-demand
  workflows. Do not make every skill mandatory for every task.
- When changing a resource, update its README entry and installation guidance.
- Validate relative Markdown links, instruction frontmatter, and skill names
  against their directory names. Check `git diff --check`.
- Run `powershell -NoProfile -File .\scripts\Test-Install-Defaults.ps1` after
  installer changes. There is no application build; file validation does not
  prove that an agent followed the guidance.
