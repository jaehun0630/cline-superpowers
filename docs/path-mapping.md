# Path Mapping

`packages/` is the canonical source tree. Global and workspace installs use the same source files.

## Global Target

| Source | Destination |
| --- | --- |
| `packages/rules/*` | `~/Cline/Rules/*` |
| `packages/workflows/*` | `~/Cline/Workflows/*` |
| `packages/hooks/TaskStart` | `~/Document/Cline/Hooks/TaskStart` |
| `packages/skills/*` | `~/.agents/skills/*` |

## Workspace Target

| Source | Destination |
| --- | --- |
| `packages/rules/*` | `<repo>/.clinerules/*` |
| `packages/workflows/*` | `<repo>/.clinerules/workflows/*` |
| `packages/hooks/TaskStart` | `<repo>/.clinerules/hooks/TaskStart` |
| `packages/skills/*` | `<repo>/.agents/skills/*` |

## Install Behavior

The installer creates destination directories when needed and copies package files over existing files with the same names. It does not delete unrelated files in Cline SR directories.

The uninstall script removes package-owned files only. It does not remove destination directories or unrelated Cline SR files.

Use `--dry-run` before installing to inspect destination paths:

```bash
scripts/install.sh --target global --dry-run
scripts/install.sh --target workspace --repo /path/to/repo --dry-run
scripts/uninstall.sh --target workspace --repo /path/to/repo --dry-run
```
