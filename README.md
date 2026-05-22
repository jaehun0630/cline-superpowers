# Cline Superpowers

Superpowers adapted for use with Cline SR.

This repository packages `obra/superpowers` for Cline SR environments that support Rules, Workflows, Hooks, and Skills at both global and workspace scope.

## What It Installs

Global target:

```text
~/Cline/Rules/*.md
~/Cline/Workflows/*.md
~/Document/Cline/Hooks/TaskStart
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

The script copies upstream `skills/` into `packages/skills/` and records the upstream commit in `packages/UPSTREAM.md`.

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
- `packages/skills/*`: Superpowers skills copied from upstream.
- `scripts/install.sh`: target-aware installer.
- `scripts/uninstall.sh`: target-aware remover for package-owned files.
- `scripts/verify-install.sh`: install verifier.
- `scripts/sync-from-upstream.sh`: upstream skill sync helper.

## Notes

`TaskStart` is a Cline SR hook script. On macOS and Linux it must stay executable and extensionless after install.
