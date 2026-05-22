# Cline Superpowers Design

## Goal

Create a company-internal Cline package that brings the Superpowers development methodology into the company's Cline environment. The package must support both global installation, where behavior applies to every workspace, and workspace installation, where behavior is committed to and applied only inside one repository.

The source package should avoid maintaining separate global and workspace copies. It should keep one canonical set of rules, workflows, hooks, and skills, then install those files into the correct Cline paths for the selected target.

## Upstream Baseline

The package is based on `obra/superpowers` cloned at upstream commit `f2cbfbe` (`Release v5.1.0`). The upstream repository is a multi-harness Superpowers distribution with:

- `skills/`: the core Superpowers skill library.
- `.codex-plugin/`, `.claude-plugin/`, `.cursor-plugin/`: harness metadata.
- `.opencode/plugins/superpowers.js`: an adapter that injects bootstrap context and registers the skills path.
- `CLAUDE.md` and `GEMINI.md`: harness-specific bootstrap instructions.
- `tests/`: skill triggering and adapter verification scripts.

This Cline package will reuse the skill content and adapt the packaging, installation, and bootstrap behavior for the company Cline file layout.

## Company Cline Path Model

Global installation:

```text
~/Cline/Rules/*.md
~/Cline/Workflows/*.md
~/Cline/Hooks/TaskStart
~/.agents/skills/<skill-name>/SKILL.md
```

Workspace installation:

```text
<repo>/.clinerules/*.md
<repo>/.clinerules/workflows/*.md
<repo>/.clinerules/hooks/TaskStart
<repo>/.agents/skills/<skill-name>/SKILL.md
```

Rules, workflows, hooks, and skills are therefore target-specific at install time, not source-specific in this repository.

## Repository Structure

```text
workspace/cline-superpowers/
  README.md
  LICENSE
  vendor/
    superpowers/                    # Optional upstream snapshot or submodule
  packages/
    rules/
      superpowers-bootstrap.md
    workflows/
      brainstorm.md
      write-plan.md
      execute-plan.md
      debug.md
      review.md
      finish-branch.md
    hooks/
      TaskStart
    skills/
      using-superpowers/
      brainstorming/
      writing-plans/
      test-driven-development/
      systematic-debugging/
      verification-before-completion/
      requesting-code-review/
      receiving-code-review/
      executing-plans/
      dispatching-parallel-agents/
      subagent-driven-development/
      finishing-a-development-branch/
      using-git-worktrees/
      writing-skills/
  scripts/
    sync-from-upstream.sh
    install.sh
    verify-install.sh
  docs/
    path-mapping.md
    superpowers/
      specs/
      plans/
```

`packages/` is the canonical source. Install scripts copy from `packages/` into global or workspace destinations.

## Components

### Skills

Skills are the primary integration mechanism. Each Superpowers skill remains a directory containing `SKILL.md` plus any supporting files. Skill names and YAML frontmatter are preserved unless Cline compatibility requires a narrow change.

The package should initially include all upstream general-purpose Superpowers skills. Skills that reference unavailable subagent features should remain present, but their instructions or companion notes should explain the fallback path when company Cline lacks equivalent subagent support.

### Bootstrap Rule

`packages/rules/superpowers-bootstrap.md` gives Cline always-on instructions:

- Check whether a Superpowers skill applies before starting a task.
- Load the relevant skill before asking clarifying questions, planning, debugging, implementing, reviewing, or declaring completion.
- Prefer the user's explicit instructions over Superpowers process rules.
- Use the Cline path and tool model instead of Claude, Codex, or OpenCode-specific tool names.

This rule replaces the harness-level prompt injection used by OpenCode and the native plugin metadata used by Codex/Claude.

### Workflows

Workflows are explicit slash-command entry points for common Superpowers flows:

- `brainstorm.md`: invoke the brainstorming process for feature or behavior changes.
- `write-plan.md`: create an implementation plan from an approved design.
- `execute-plan.md`: execute an existing plan with review checkpoints.
- `debug.md`: run systematic debugging before fixes.
- `review.md`: perform review before merge or after substantial changes.
- `finish-branch.md`: verify and guide merge/PR/cleanup decisions.

Workflows should be concise wrappers that tell Cline which skill to load and what evidence to gather.

### Hooks

Hooks are executable Cline scripts. The initial hook is `TaskStart`, which returns JSON with `contextModification` so Cline receives Superpowers bootstrap behavior when a new task starts.

### Scripts

`scripts/sync-from-upstream.sh` copies upstream `skills/` into `packages/skills/`, preserving supporting files. It should record the upstream commit in a metadata file so updates are auditable.

`scripts/install.sh` installs packages into either global or workspace paths:

```bash
./scripts/install.sh --target global
./scripts/install.sh --target workspace --repo /path/to/repo
```

The script should create missing destination directories, copy files idempotently, and avoid deleting unknown user files unless an explicit clean option is added later.

`scripts/verify-install.sh` checks that expected files exist at the selected target and reports missing files.

## Data Flow

1. Maintainer clones or updates upstream `obra/superpowers`.
2. Maintainer runs `sync-from-upstream.sh`.
3. The script copies upstream skills into `packages/skills/`.
4. Company-specific rules, workflows, and hooks remain in `packages/`.
5. Developer runs `install.sh` with `--target global` or `--target workspace`.
6. Cline discovers rules, workflows, hooks, and skills from the installed paths.
7. On a task, the bootstrap rule steers Cline to load relevant skills before acting.

## Error Handling

Install scripts should fail clearly when:

- `--target` is missing or not `global` or `workspace`.
- `--target workspace` is used without `--repo`.
- The workspace path does not exist.
- Source package directories are missing.
- A destination file exists but is not writable.

Warnings should be used when optional hook support cannot be verified, since hook format details may vary in the company Cline build.

## Testing

Initial verification should cover:

- `install.sh --target global --dry-run` prints the expected destination paths.
- `install.sh --target workspace --repo <tempdir> --dry-run` prints the expected destination paths.
- Real workspace install creates `.clinerules/`, `.clinerules/workflows/`, `.clinerules/hooks/`, and `.agents/skills/`.
- `verify-install.sh` reports success after install.
- Synced skills include `using-superpowers`, `brainstorming`, `writing-plans`, `test-driven-development`, `systematic-debugging`, and `verification-before-completion`.

Manual Cline acceptance test:

> "Let's make a react todo list"

A working setup should cause Cline to use the brainstorming process before writing code.

## Non-Goals

- Do not modify upstream Superpowers behavior beyond Cline compatibility notes.
- Do not build a Cline MCP server in the first version.
- Do not create separate global and workspace source trees.
- Do not delete or overwrite user-managed Cline files without explicit opt-in.

## Open Questions

- The company Cline build should be checked for any global hook path differences from the package installer mapping.
- It is not yet confirmed whether company Cline supports native skill discovery from both global and workspace `.agents/skills` paths. The installer and verifier will make the copied files explicit, and manual Cline testing will confirm runtime behavior.
