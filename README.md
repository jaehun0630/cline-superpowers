# Cline Superpowers

Company Cline packaging for the Superpowers development methodology.

This repository adapts `obra/superpowers` for a Cline environment that supports Rules, Workflows, Hooks, and Skills at both global and workspace scope.

## What It Installs

Global target:

```text
~/Cline/Rules/*.md
~/Cline/Workflows/*.md
~/Cline/Hooks/*.md
~/.agents/skills/<skill-name>/SKILL.md
```

Workspace target:

```text
<repo>/.clinerules/*.md
<repo>/.clinerules/workflows/*.md
<repo>/.clinerules/hooks/*.md
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
- `packages/hooks/session-start.md`: lightweight session bootstrap reminder.
- `packages/skills/*`: Superpowers skills copied from upstream.
- `scripts/install.sh`: target-aware installer.
- `scripts/verify-install.sh`: install verifier.
- `scripts/sync-from-upstream.sh`: upstream skill sync helper.

## Notes

Hooks are currently markdown instructions because the exact company Cline hook runtime format has not been confirmed. If hooks require executable scripts or JSON metadata, update `packages/hooks/` and the installer path mapping without changing the rest of the package structure.
