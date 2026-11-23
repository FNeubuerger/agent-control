
# agent-control

Resources to make your agent less stupid.

Although I try in some places to guide on usage with Claude, I'm building this with
VSCode's default GitHub Copilot.

## Included practices

The [engineering defaults](./instructions/engineering-defaults.instructions.md) cover explicit
assumptions, simple designs, focused changes, and observable verification.
Detailed resources:

| Resource                                                                       | Purpose                                                                                                   |
| ------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| [Writing good code](./instructions/writing-good-code.instructions.md)           | Plan proportionately, avoid speculative abstractions, and verify behavior.                                |
| [Writing docs](./instructions/writing-docs.instructions.md)                     | Maintain setup, usage, API contracts, architecture explanations, and consequential decision records.      |
| [Comments and doc strings](./instructions/comments-doc-strings.instructions.md) | Explain non-obvious intent and public contracts without narrating code.                                   |
| [Quality hooks](./instructions/quality-hooks.instructions.md)                   | Set up project-local pre-commit checks, including Ruff for Python, without replacing existing toolchains. |
| [Explain code](./.github/skills/explain-code/SKILL.md)                          | Build shared understanding of a specific feature from current source evidence.                            |
| [Review changes](./.github/skills/review-changes/SKILL.md)                      | Find actionable regressions, report verification evidence, and keep review rounds bounded.                |

The coding practices are informed by
[multica-ai&#39;s Karpathy-inspired guidelines](https://github.com/multica-ai/andrej-karpathy-skills).
The explanation and review workflows also draw on
[Anthropic&#39;s code review and shared-context practices](https://claude.dev/blog/solving-code-review-at-anthropic/#sharing-context-across-the-team).
These are adapted workflows, not an installation of a Claude plugin.

For suitable critical invariants, the testing guidance also considers
[Bend](https://github.com/bendlang/bend) as an optional formal proof tool.
Proofs complement tests; introducing a new language or toolchain requires agreement.

## Make these your Copilot defaults

### This repository

[Repository instructions](./.github/copilot-instructions.md) apply when working on
this repository. The two skills are discoverable from `.github/skills/`.
The templates under `instructions/` alone are not automatically installed in
other repositories.

### All your VS Code workspaces: install once, edit in one place

Keep a local checkout of this fork at a stable path. On Windows, run from its root:

```powershell
git clone git@github.com:FNeubuerger/agent-control.git
Set-Location .\agent-control
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Install-Defaults.ps1
```

`-ExecutionPolicy Bypass` applies to this process only; it does not change your
machine policy. Organization policy can still prohibit script execution.
The [installer](./scripts/Install-Defaults.ps1) uses directory junctions, which
normally require neither administrator privileges nor Developer Mode.
It does not copy policies into projects or change VS Code settings or Git hooks.

| Installed location                                | Live source / purpose                                                                              |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| `~/.copilot/instructions/agent-control/`        | Junction to this checkout's `instructions/`.                                                     |
| `<VS Code user profile>/prompts/agent-control/` | Junction to the same instructions for the Local harness.                                           |
| `~/.copilot/skills/<skill>/`                    | Junction to each skill in this checkout's `.github/skills/`.                                     |
| `~/.agents/skills/<skill>/`                     | Junction to the same skills for Local sessions.                                                    |
| `~/.copilot/copilot-instructions.md`            | Small managed block linking the canonical baseline; unrelated personal instructions remain intact. |

The single policy source is
[`instructions/engineering-defaults.instructions.md`](./instructions/engineering-defaults.instructions.md)
and its linked modular files. Its `applyTo: "**"` deliberately makes the short
baseline apply across file types. Skill workflows live only in `.github/skills/`.
The other entry points link to these sources rather than duplicate their rules.

**Updates:** edit this checkout, or pull changes from your fork, then start a
fresh chat (reload VS Code if discovery is cached). Existing linked policies and
skills update without copying or reinstalling. Run the installer again after
adding a new skill; new files inside the linked instructions directory appear
automatically. Changes made only on GitHub are not local until you pull them.
Keep this trusted checkout available: moving or deleting it breaks the links.

The default VS Code profile is `%APPDATA%\Code\User`. For a named profile or
VS Code Insiders, find the active user-data directory via the Customizations
editor and install once for that profile:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Install-Defaults.ps1 -VSCodeUserDirectory 'C:\path\to\Code\User\profiles\<profile-id>'
```

This is **user scope**, so no per-workspace installation is needed for local
workspaces under that profile. Remote SSH, WSL, dev containers, other machines,
and other OSes have separate homes/profiles: this Windows installer does not
configure those environments. Install equivalent links in supported harness
locations there. Do not rely on Settings Sync to reproduce filesystem junctions;
clone and install on each Windows machine instead.

The installer is safe to rerun: expected junctions are retained, and only its
marked block in personal instructions is updated. Conflicting files, directories,
or links cause an explicit error. If migrating an earlier copy-based install,
back up and move aside those copies first, including any old always-on baseline,
to avoid duplicate or stale rules. Never delete unrelated personal customizations.

**Verify:** start a fresh chat, open **Chat: Open Customizations**, confirm the
instructions and skills are discovered for the intended harness, and inspect
instruction references for a coding task. Invoke `/explain-code` or
`/review-changes` to test skill discovery. These files guide model behavior;
they are not deterministic enforcement. To test installer behavior without
changing your real profile:

```powershell
powershell -NoProfile -File .\scripts\Test-Install-Defaults.ps1
```

**Remove:** remove only the installed junction entries (not their target
contents), then remove the `agent-control:start` / `agent-control:end` block
from personal Copilot instructions. Do not recursively delete through a junction.
Your checkout and unrelated customizations should remain untouched.

### Pre-commit and Ruff defaults

The baseline tells the agent to establish project-local lint/format hooks during
code-project setup or substantial changes, reusing an existing toolchain first.
For Python, the [quality-hook workflow](./instructions/quality-hooks.instructions.md)
prefers `pre-commit` with a pinned Ruff hook release, `ruff-check --fix` followed
by `ruff-format`, installation in the project's environment, and verification
with `pre-commit run --all-files`. It also requires documenting setup per clone.

This is not a global Git hook: each project owns its dependency versions and
configuration, and each clone needs hook installation. Existing projects are
not silently modified merely by installing these agent defaults. This resource
repository has no Python code, so it does not need Ruff itself.

### GitHub.com and other repositories

Local VS Code files do not configure GitHub.com's personal Copilot Chat.
In [GitHub Copilot Chat](https://github.com/copilot), open your profile menu,
choose **Personal instructions**, paste the engineering-default bullets, and save.
These personal instructions apply to GitHub.com chat, not as a global policy
for every repository's cloud coding agent or code review.

For remote Copilot use in another repository, merge the baseline into its
`.github/copilot-instructions.md` and copy any referenced modular files and skill
directories. Repository customizations must be committed and pushed before remote
Copilot experiences can read them. Supported instructions and skills differ by
experience; see the [GitHub documentation](https://docs.github.com/en/copilot/concepts/prompting-and-context/custom-instructions).
This repository does not enable AI review services, CI, branch protection, or
automatic merging.

### Forcing Load

If you would like any of the instructions provided here to be loaded on any agent operation,
set `applyTo: **` within the frontmatter of them.

From what I understand, this is not literally on every request, but would be pulled in when
it wants to edit a file.

For global always-on instructions, see "Always-on Instructions" below.

Use the live-link installer above for personal defaults instead of copying
the entry point into each project.

## Adding Instructions

In VSCode, run **Chat: Open Customizations** from the Command Palette to check whether your instructions or skills are discovered.
To test use, start a fresh chat with a matching task and check the response's **References** for instructions, or invoke a skill from the `/` menu.

### Locations

These locations hold modular instructions for GitHub's Copilot or Claude.

A Workspace scope applies to the project you're working on, and is thus relative to the project's root.

Use the User scope to apply controls to all your projects using that harness.

| Session and scope | Default file location        |
| ----------------- | ---------------------------- |
| Copilot workspace | `.github/instructions/`    |
| Claude workspace  | `.claude/rules/`           |
| Copilot user      | `~/.copilot/instructions/` |
| Claude user       | `~/.claude/rules/`         |

#### Always-on Instructions

Use these files for guidance that applies throughout a session, rather than
instructions selected by file patterns or task relevance.

See the [VS Code custom instructions documentation](https://code.visualstudio.com/docs/agent-customization/custom-instructions)
and [Claude Code instructions documentation](https://code.claude.com/docs/en/memory).

| Description                                                     | File location                          |
| --------------------------------------------------------------- | -------------------------------------- |
| Copilot user-level instructions that apply across repositories. | `~/.copilot/copilot-instructions.md` |
| Copilot repository-wide instructions.                           | `.github/copilot-instructions.md`    |
| Claude user-level instructions that apply across repositories.  | `~/.claude/CLAUDE.md`                |
| Claude repository-wide instructions.                            | `CLAUDE.md` or `.claude/CLAUDE.md` |

### Filenaming

Name Copilot's modular files `*.instructions.md`. Claude rules can use ordinary
`*.md` filenames.

### Frontmatter

For Copilot, you can optionally supply frontmatter:

```yaml
---
name: ...
description: ...
applyTo: "**/*.py"
---
```

`applyTo` automatically attaches instructions when matching files are changed.
`description` helps the agent discover instructions relevant to a task. If you
omit both, attach the file manually.

For Claude rules, use `paths` instead of `applyTo`:

```yaml
---
paths:
  - "**/*.py"
---
```

## Creating Skills

Skills describe task-specific workflows that the agent can load when relevant.
Unlike instructions, a skill can also include scripts, examples, and other
supporting files.

### Locations

As with instructions, workspace skills belong to a project, while user skills
are available across projects.

| Session and scope | Default file location                       |
| ----------------- | ------------------------------------------- |
| Copilot workspace | `.github/skills/<skill-name>/SKILL.md`    |
| Claude workspace  | `.claude/skills/<skill-name>/SKILL.md`    |
| Copilot user      | `~/.copilot/skills/<skill-name>/SKILL.md` |
| Claude user       | `~/.claude/skills/<skill-name>/SKILL.md`  |

VS Code's Local sessions also search `.claude/skills/` and `.agents/skills/`
in the workspace, and `~/.claude/skills/` and `~/.agents/skills/` for user
skills. Supported locations can differ between harnesses.

### Filenaming

Give each skill its own directory containing a file named `SKILL.md`. For
example, `.github/skills/test-changes/SKILL.md`:

```markdown
---
name: test-changes
description: Run relevant project tests when validating a code change and report the results.
---

# Test changes

1. Find the tests relevant to the change.
2. Run them using the project's documented test commands.
3. Report what passed, failed, or could not be run.
```

In VS Code, `name` and `description` are required. The name must match the
directory name and use only lowercase letters, numbers, and hyphens. The
description should say both what the skill does and when to use it.

### Using skills

By default, Copilot may select a discovered skill based on its description, or
you can invoke it directly in chat, for example with `/test-changes`. Discovery
does not guarantee automatic selection. Start a fresh chat to test both direct
invocation and whether the skill is selected for a relevant request.

Claude Code can use the directory name when `name` is omitted, but include it
for VS Code compatibility. Claude Code also supports older command files in
`.claude/commands/`; new skills should use the skill directories above.

See the [VS Code agent skills documentation](https://code.visualstudio.com/docs/agent-customization/agent-skills)
and [Claude Code skills documentation](https://code.claude.com/docs/en/skills).
