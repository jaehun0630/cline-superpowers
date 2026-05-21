#!/usr/bin/env sh
set -eu

usage() {
  cat <<'USAGE'
Usage:
  scripts/install.sh --target global [--dry-run]
  scripts/install.sh --target workspace --repo /path/to/repo [--dry-run]

Installs Cline Superpowers rules, workflows, hooks, and skills.
USAGE
}

TARGET=""
REPO=""
DRY_RUN=0

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
PACKAGES_DIR="$ROOT_DIR/packages"

require_dir() {
  if [ ! -d "$1" ]; then
    echo "Required directory not found: $1" >&2
    exit 1
  fi
}

copy_dir_contents() {
  src="$1"
  dest="$2"
  label="$3"

  require_dir "$src"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "Would install $label: $src -> $dest"
    return
  fi

  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
  echo "Installed $label: $dest"
}

case "$TARGET" in
  global)
    RULES_DEST="$HOME/Cline/Rules"
    WORKFLOWS_DEST="$HOME/Cline/Workflows"
    HOOKS_DEST="$HOME/Cline/Hooks"
    SKILLS_DEST="$HOME/.agents/skills"
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

copy_dir_contents "$PACKAGES_DIR/rules" "$RULES_DEST" "rules"
copy_dir_contents "$PACKAGES_DIR/workflows" "$WORKFLOWS_DEST" "workflows"
copy_dir_contents "$PACKAGES_DIR/hooks" "$HOOKS_DEST" "hooks"
copy_dir_contents "$PACKAGES_DIR/skills" "$SKILLS_DEST" "skills"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run complete."
else
  echo "Install complete."
fi
