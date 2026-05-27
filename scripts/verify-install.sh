#!/usr/bin/env sh
set -eu

usage() {
  cat <<'USAGE'
Usage:
  scripts/verify-install.sh --target global [--config /path/to/config]
  scripts/verify-install.sh --target workspace --repo /path/to/repo

Verifies expected Cline Superpowers install files exist.
USAGE
}

TARGET=""
REPO=""
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

MISSING=0

check_file() {
  if [ -f "$1" ]; then
    echo "OK: $1"
  else
    echo "MISSING: $1" >&2
    MISSING=1
  fi
}

check_file "$RULES_DEST/superpowers-bootstrap.md"
check_file "$WORKFLOWS_DEST/brainstorm.md"
check_file "$WORKFLOWS_DEST/write-plan.md"
check_file "$WORKFLOWS_DEST/execute-plan.md"
check_file "$WORKFLOWS_DEST/debug.md"
check_file "$WORKFLOWS_DEST/review.md"
check_file "$WORKFLOWS_DEST/finish-branch.md"
check_file "$WORKFLOWS_DEST/grill-me.md"
check_file "$WORKFLOWS_DEST/improve-codebase-architecture.md"
check_file "$HOOKS_DEST/TaskStart"
check_file "$SKILLS_DEST/using-superpowers/SKILL.md"
check_file "$SKILLS_DEST/brainstorming/SKILL.md"
check_file "$SKILLS_DEST/writing-plans/SKILL.md"
check_file "$SKILLS_DEST/test-driven-development/SKILL.md"
check_file "$SKILLS_DEST/systematic-debugging/SKILL.md"
check_file "$SKILLS_DEST/verification-before-completion/SKILL.md"
check_file "$SKILLS_DEST/grill-me/SKILL.md"
check_file "$SKILLS_DEST/improve-codebase-architecture/SKILL.md"
check_file "$SKILLS_DEST/improve-codebase-architecture/ADR-FORMAT.md"
check_file "$SKILLS_DEST/improve-codebase-architecture/CONTEXT-FORMAT.md"
check_file "$SKILLS_DEST/improve-codebase-architecture/DEEPENING.md"
check_file "$SKILLS_DEST/improve-codebase-architecture/HTML-REPORT.md"
check_file "$SKILLS_DEST/improve-codebase-architecture/INTERFACE-DESIGN.md"
check_file "$SKILLS_DEST/improve-codebase-architecture/LANGUAGE.md"

if [ "$MISSING" -eq 0 ]; then
  echo "Verification passed."
else
  echo "Verification failed." >&2
  exit 1
fi
