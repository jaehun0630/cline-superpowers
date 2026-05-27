# Cline Superpowers

[한국어](README.kor.md)

Superpowers and selected agent skills adapted for use with Cline SR.

This repository packages `obra/superpowers` plus selected compatible skills from `mattpocock/skills` for Cline SR environments that support Rules, Workflows, Hooks, and Skills at both global and workspace scope.

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

## Update From Upstream

Clone or update `obra/superpowers` next to this repository, then run:

```bash
scripts/sync-from-upstream.sh --upstream ../superpowers
```

The script refreshes the Superpowers skill directories in `packages/skills/` and records the upstream commit in `packages/UPSTREAM.md`. It preserves separately packaged skills such as `grill-me` and `improve-codebase-architecture`.

## Manual Acceptance Test

After installing, start a fresh Cline session and send:

```text
Let's make a react todo list
```

Expected behavior: Cline should use the Superpowers brainstorming process before writing implementation code.

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
