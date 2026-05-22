# Cline Superpowers Structure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fill the repository with a usable Cline Superpowers package that can sync upstream Superpowers skills and install rules, workflows, hooks, and skills into global or workspace Cline paths.

**Architecture:** Keep one canonical package tree under `packages/`. Scripts copy that tree into target-specific global or workspace locations without deleting user files. Documentation explains the path mapping and expected manual Cline acceptance test.

**Tech Stack:** POSIX shell, Markdown, Git.

---

### Task 1: Package Content

**Files:**
- Create: `packages/rules/superpowers-bootstrap.md`
- Create: `packages/workflows/brainstorm.md`
- Create: `packages/workflows/write-plan.md`
- Create: `packages/workflows/execute-plan.md`
- Create: `packages/workflows/debug.md`
- Create: `packages/workflows/review.md`
- Create: `packages/workflows/finish-branch.md`
- Create: `packages/hooks/TaskStart`
- Copy: `../superpowers/skills/*` to `packages/skills/`

- [ ] Create concise Cline-facing rule, workflow, and hook markdown files.
- [ ] Copy upstream skills preserving support files.
- [ ] Verify representative skill files exist.

### Task 2: Scripts

**Files:**
- Create: `scripts/install.sh`
- Create: `scripts/verify-install.sh`
- Create: `scripts/sync-from-upstream.sh`

- [ ] Implement `install.sh` with `--target global|workspace`, `--repo`, and `--dry-run`.
- [ ] Implement `verify-install.sh` with the same target parsing and expected file checks.
- [ ] Implement `sync-from-upstream.sh` to copy upstream skills and record metadata.
- [ ] Make scripts executable.

### Task 3: Documentation

**Files:**
- Create: `README.md`
- Create: `docs/path-mapping.md`
- Create: `LICENSE`

- [ ] Document install commands, expected paths, update flow, and manual Cline acceptance test.
- [ ] Add MIT license attribution for the packaging repo and note upstream Superpowers license.

### Task 4: Verification

**Files:**
- No new files expected.

- [ ] Run `scripts/install.sh --target workspace --repo /tmp/cline-superpowers-test --dry-run`.
- [ ] Run a real workspace install into a temp directory.
- [ ] Run `scripts/verify-install.sh --target workspace --repo /tmp/cline-superpowers-test`.
- [ ] Run `scripts/install.sh --target global --dry-run`.
- [ ] Commit the completed structure.
