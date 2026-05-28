# Cline Superpowers

[한국어](README.kor.md)

Superpowers and selected agent skills adapted for use with Cline SR.

This repository packages `obra/superpowers` plus selected compatible skills from `mattpocock/skills` for Cline SR environments that support Rules, Workflows, Hooks, and Skills at both global and workspace scope.

## How To Use

After installation, the `TaskStart` hook and bootstrap rule ask Cline SR to choose a skill when the user request matches one of these trigger conditions. The agent can still choose a different skill when the request context is more specific.

### Superpowers Skills

| Skill | Trigger conditions | Example requests |
| --- | --- | --- |
| `using-superpowers` | Start of a task, or when Cline SR appears to skip skill selection. | "Use the using-superpowers skill before continuing." |
| `brainstorming` | New feature, behavior change, creative implementation, or unclear requirements before implementation. | "Let's make a React todo list"; "I want to add a new export feature." |
| `writing-plans` | Existing spec/design, explicit todo list request, implementation plan request, or multi-step work before edits. | "Analyze this repo and write a todo list for phase 2 and phase 3."; "Create an implementation plan." |
| `using-git-worktrees` | Feature work that should be isolated from the current workspace, especially larger changes with multiple commits. | "Set up an isolated workspace before implementing this plan." |
| `subagent-driven-development` | Written plan with independent tasks when Cline SR has usable delegation/subagent support. | "Execute this plan using subagent-driven development if available." |
| `executing-plans` | Written implementation plan executed in the current session, especially when subagent support is unavailable or not desired. | "Execute this implementation plan in this session." |
| `test-driven-development` | Feature implementation, bugfix, behavior refactor, or user-visible behavior change. | "Implement this with TDD."; "Fix this bug with a failing test first." |
| `systematic-debugging` | Failing test, bug report, flaky behavior, unexpected behavior, or performance issue that needs evidence before fixing. | "This test is failing. Find the root cause before fixing it." |
| `verification-before-completion` | Before claiming work is done or fixed, and before commit, push, merge, or PR. | "Verify the implementation before reporting completion." |
| `requesting-code-review` | After substantial or risky work, before merge, or after a complex bugfix. | "Review the current changes before I merge them." |
| `receiving-code-review` | Review feedback arrives, especially if feedback is unclear or technically questionable. | "Evaluate this review feedback before applying it." |
| `finishing-a-development-branch` | Implementation and verification are done, and you need to choose merge, push, PR, keep, or cleanup. | "Finish this development branch." |
| `dispatching-parallel-agents` | Multiple independent investigations, unrelated failures, or separate subsystems that can be explored in parallel. | "Investigate these three independent failures in parallel." |
| `writing-skills` | Creating, editing, or verifying skills before distribution. | "Help me write a new Cline SR skill for migration reviews." |

### Skills From `mattpocock/skills`

| Skill | Trigger conditions | Example requests |
| --- | --- | --- |
| `grill-me` | Explicit "grill me", pressure testing, critique, or challenging a plan/design before implementation. | "Grill me on this implementation plan."; "Challenge this architecture decision." |
| `improve-codebase-architecture` | Architecture review, refactoring opportunities, shallow modules, testability, locality, leverage, or AI navigability improvements. | "Analyze this repository and find architecture improvements."; "Find shallow modules and refactoring opportunities." |

### Manual Triggers

Automatic selection depends on Cline SR matching the request to installed skill descriptions and bootstrap guidance. For more predictable behavior, call the skill or workflow explicitly:

- Mention the skill name in the request: "Use `systematic-debugging` to find the root cause."
- Ask for the process directly: "Create an implementation plan before editing code."
- Use an installed workflow when Cline SR exposes workflows in the UI: `/brainstorm.md`, `/write-plan.md`, `/debug.md`, `/review.md`, `/finish-branch.md`, `/grill-me.md`, `/improve-codebase-architecture.md`.

## Install

Preview global install:

```bash
scripts/install.sh --target global --dry-run
```

Install globally:

```bash
scripts/install.sh --target global
```

Preview workspace install:

```bash
scripts/install.sh --target workspace --repo /path/to/repo --dry-run
```

Install into one workspace:

```bash
scripts/install.sh --target workspace --repo /path/to/repo
```

Verify an install:

```bash
scripts/verify-install.sh --target workspace --repo /path/to/repo
```

Uninstall the package files from one target:

```bash
scripts/uninstall.sh --target global --dry-run
scripts/uninstall.sh --target workspace --repo /path/to/repo
```

The uninstall script removes only the Superpowers files installed by this package. It leaves unrelated Cline SR rules, workflows, hooks, and skills intact.

## Manual Acceptance Test

After installing, start a fresh Cline session and send:

```text
Let's make a react todo list
```

Expected behavior: Cline should use the Superpowers brainstorming process before writing implementation code.

## What It Installs

Global target:

```text
~/Documents/Cline/Rules/*.md
~/Documents/Cline/Workflows/*.md
~/Documents/Cline/Hooks/TaskStart
~/.agents/skills/<skill-name>/SKILL.md
```

Workspace target:

```text
<repo>/.clinerules/*.md
<repo>/.clinerules/workflows/*.md
<repo>/.clinerules/hooks/TaskStart
<repo>/.agents/skills/<skill-name>/SKILL.md
```

The source files live once under `packages/`; install scripts copy them into the selected target.

## Global Path Configuration

Global installs read `cline-superpowers.config` by default. If a PC uses different Cline SR global paths, edit that file and rerun install, verify, or uninstall.

You can also pass a separate config file:

```bash
scripts/install.sh --target global --config /path/to/cline-superpowers.config
scripts/verify-install.sh --target global --config /path/to/cline-superpowers.config
scripts/uninstall.sh --target global --config /path/to/cline-superpowers.config
```

## Update From Upstream

Clone or update `obra/superpowers` next to this repository, then run:

```bash
scripts/sync-from-upstream.sh --upstream ../superpowers
```

The script refreshes the Superpowers skill directories in `packages/skills/` and records the upstream commit in `packages/UPSTREAM.md`. It preserves separately packaged skills such as `grill-me` and `improve-codebase-architecture`.

## Contents

- `packages/rules/superpowers-bootstrap.md`: always-on bootstrap guidance.
- `packages/workflows/*.md`: explicit workflow entry points.
- `packages/hooks/TaskStart`: executable Cline hook that injects bootstrap context when a task starts.
- `packages/skills/*`: Superpowers skills plus selected compatible skills adapted for Cline SR.
- `scripts/install.sh`: target-aware installer.
- `scripts/uninstall.sh`: target-aware remover for package-owned files.
- `scripts/verify-install.sh`: install verifier.
- `scripts/sync-from-upstream.sh`: upstream skill sync helper.

## Usage Guide

See [`docs/skill-guide.md`](docs/skill-guide.md) for each skill's role, expected trigger, and example prompts.

## Notes

`TaskStart` is a Cline SR hook script. On macOS and Linux it must stay executable and extensionless after install.

After installing hooks, enable Hooks in Cline SR so the installed `TaskStart` hook can run when a new task starts.

Additional skills from `mattpocock/skills` are available after install:

- `grill-me`: stress-test a plan or design through focused questioning.
- `improve-codebase-architecture`: find deepening opportunities that improve locality, leverage, testability, and AI navigability.

These skills can be triggered by matching user requests or invoked directly through the installed workflows.
