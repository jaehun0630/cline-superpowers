#!/usr/bin/env sh
set -eu

usage() {
  cat <<'USAGE'
Usage:
  scripts/sync-from-upstream.sh [--upstream /path/to/superpowers]

Copies upstream Superpowers skills into packages/skills and records metadata.
USAGE
}

UPSTREAM="../superpowers"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --upstream)
      UPSTREAM="${2:-}"
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
UPSTREAM_DIR=$(CDPATH= cd -- "$UPSTREAM" && pwd)

if [ ! -d "$UPSTREAM_DIR/skills" ]; then
  echo "Upstream skills directory not found: $UPSTREAM_DIR/skills" >&2
  exit 1
fi

mkdir -p "$ROOT_DIR/packages/skills"
find "$ROOT_DIR/packages/skills" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
cp -R "$UPSTREAM_DIR/skills/." "$ROOT_DIR/packages/skills/"

UPSTREAM_COMMIT="unknown"
if git -C "$UPSTREAM_DIR" rev-parse --short HEAD >/dev/null 2>&1; then
  UPSTREAM_COMMIT=$(git -C "$UPSTREAM_DIR" rev-parse --short HEAD)
fi

cat > "$ROOT_DIR/packages/UPSTREAM.md" <<EOF
# Upstream Superpowers

- Repository: https://github.com/obra/superpowers
- Commit: $UPSTREAM_COMMIT
- Synced: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
EOF

echo "Synced skills from $UPSTREAM_DIR at $UPSTREAM_COMMIT"
