#!/usr/bin/env sh
set -eu

usage() {
  cat <<'USAGE'
Usage:
  scripts/uninstall.sh --target global [--config /path/to/config] [--dry-run]
  scripts/uninstall.sh --target workspace --repo /path/to/repo [--dry-run]

Removes files installed by Cline Superpowers without deleting unrelated Cline files.
USAGE
}

TARGET=""
REPO=""
DRY_RUN=0
CONFIG_FILE=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --repo)
      REPO="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --config)
      CONFIG_FILE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

load_config() {
  if [ -z "$CONFIG_FILE" ]; then
    CONFIG_FILE="$ROOT_DIR/cline-superpowers.config"
  fi

  if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
  fi

  : "${CLINE_RULES_DIR:=$HOME/Documents/Cline/Rules}"
  : "${CLINE_WORKFLOWS_DIR:=$HOME/Documents/Cline/Workflows}"
  : "${CLINE_HOOKS_DIR:=$HOME/Documents/Cline/Hooks}"
  : "${CLINE_SKILLS_DIR:=$HOME/.agents/skills}"
}

case "$TARGET" in
  global)
    load_config
    RULES_DEST="$CLINE_RULES_DIR"
    WORKFLOWS_DEST="$CLINE_WORKFLOWS_DIR"
    HOOKS_DEST="$CLINE_HOOKS_DIR"
    SKILLS_DEST="$CLINE_SKILLS_DIR"
    ;;
  workspace)
    if [ -z "$REPO" ]; then
      echo "--repo is required for --target workspace" >&2
      usage >&2
      exit 2
    fi
    if [ "$DRY_RUN" -eq 0 ] && [ ! -d "$REPO" ]; then
      echo "Workspace repo does not exist: $REPO" >&2
      exit 1
    fi
    RULES_DEST="$REPO/.clinerules"
    WORKFLOWS_DEST="$REPO/.clinerules/workflows"
    HOOKS_DEST="$REPO/.clinerules/hooks"
    SKILLS_DEST="$REPO/.agents/skills"
    ;;
  *)
    echo "--target must be global or workspace" >&2
    usage >&2
    exit 2
    ;;
esac

remove_path() {
  path="$1"
  label="$2"

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "Would remove $label: $path"
    return
  fi

  if [ -e "$path" ]; then
    rm -rf "$path"
    echo "Removed $label: $path"
  else
    echo "Already absent $label: $path"
  fi
}

remove_path "$RULES_DEST/superpowers-bootstrap.md" "rule"
remove_path "$WORKFLOWS_DEST/brainstorm.md" "workflow"
remove_path "$WORKFLOWS_DEST/write-plan.md" "workflow"
remove_path "$WORKFLOWS_DEST/execute-plan.md" "workflow"
remove_path "$WORKFLOWS_DEST/debug.md" "workflow"
remove_path "$WORKFLOWS_DEST/review.md" "workflow"
remove_path "$WORKFLOWS_DEST/finish-branch.md" "workflow"
remove_path "$WORKFLOWS_DEST/grill-me.md" "workflow"
remove_path "$WORKFLOWS_DEST/improve-codebase-architecture.md" "workflow"
remove_path "$WORKFLOWS_DEST/handoff.md" "workflow"
remove_path "$HOOKS_DEST/TaskStart" "hook"

for skill in \
  brainstorming \
  dispatching-parallel-agents \
  executing-plans \
  finishing-a-development-branch \
  receiving-code-review \
  requesting-code-review \
  subagent-driven-development \
  systematic-debugging \
  test-driven-development \
  using-git-worktrees \
  using-superpowers \
  verification-before-completion \
  writing-plans \
  writing-skills \
  grill-me \
  improve-codebase-architecture \
  handoff
do
  remove_path "$SKILLS_DEST/$skill" "skill"
done

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run complete."
else
  echo "Uninstall complete."
fi
