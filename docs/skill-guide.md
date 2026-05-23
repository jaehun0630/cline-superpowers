# Skill Guide

[한국어](skill-guide.kor.md)

This document explains what each packaged skill does, when Cline SR should use it, and how a user can call it directly.

## How Skills Are Selected

Cline SR discovers installed skills from the target skill directory:

- Global: `~/.agents/skills/<skill-name>/SKILL.md`
- Workspace: `<repo>/.agents/skills/<skill-name>/SKILL.md`

The installed `TaskStart` hook and `superpowers-bootstrap.md` rule tell Cline SR to check whether a skill applies before acting. That means skills are not only manual commands. They can be selected automatically when the user request matches the skill description or bootstrap trigger.

Workflows are explicit entry points. Use them when you want to force a particular process:

- Global workflows: `~/Cline/Workflows/*.md`
- Workspace workflows: `<repo>/.clinerules/workflows/*.md`

## Recommended Mental Model

Use the skills as a staged development loop:

1. Clarify and design: `brainstorming`, `grill-me`
2. Plan: `writing-plans`
3. Execute: `subagent-driven-development` or `executing-plans`
4. Implement safely: `test-driven-development`
5. Debug: `systematic-debugging`
6. Review and finish: `requesting-code-review`, `receiving-code-review`, `verification-before-completion`, `finishing-a-development-branch`

Architecture work can enter through `improve-codebase-architecture` when the task is about module depth, refactoring opportunities, testability, or AI navigability.

## Core Superpowers Skills

### `using-superpowers`

Role: Bootstrap skill selection. It teaches the agent to check whether any skill applies before responding or acting.

Use when:

- Starting a new task.
- You suspect the agent is skipping the skill system.

Example prompt:

```text
Use the using-superpowers skill before continuing.
```

### `brainstorming`

Role: Turn a rough idea into an approved design before implementation.

Use when:

- Building a new feature.
- Changing behavior.
- Starting creative implementation work.
- Requirements are still fuzzy.

Expected behavior:

- Explore the project context.
- Ask clarifying questions one at a time.
- Present approaches and trade-offs.
- Save an approved design before implementation planning.

Example prompt:

```text
Brainstorm a design for adding offline sync to this app.
```

### `writing-plans`

Role: Convert approved requirements or a design into a detailed implementation plan.

Use when:

- A spec already exists.
- The user asks for a todo list or implementation plan.
- The work is multi-step and should be broken down before editing code.

Example prompt:

```text
Create an implementation plan for phase 2 and phase 3 based on the current repository.
```

### `using-git-worktrees`

Role: Ensure feature work happens in an isolated workspace or branch.

Use when:

- Starting implementation work that should not disturb the current workspace.
- Running a larger plan with multiple commits.

Example prompt:

```text
Set up an isolated workspace before implementing this plan.
```

### `subagent-driven-development`

Role: Execute a plan by dispatching focused subagents per task, with review between tasks.

Use when:

- Cline SR has usable subagent or delegation support.
- The implementation plan has independent tasks.

Fallback:

- If Cline SR has no equivalent subagent support, use `executing-plans`.

Example prompt:

```text
Execute this implementation plan using subagent-driven development if available.
```

### `executing-plans`

Role: Execute a written implementation plan in the current session with checkpoints.

Use when:

- A written plan exists.
- Subagent support is unavailable or not desired.

Example prompt:

```text
Execute docs/superpowers/plans/2026-05-23-cache-refactor.md in this session.
```

### `test-driven-development`

Role: Enforce red-green-refactor for features, bugfixes, refactoring, and behavior changes.

Use when:

- Implementing a feature.
- Fixing a bug.
- Refactoring behavior.

Expected behavior:

- Write the failing test first.
- Verify it fails for the right reason.
- Implement the smallest fix.
- Verify it passes.

Example prompt:

```text
Implement this behavior using test-driven development.
```

### `systematic-debugging`

Role: Find root cause before fixing a bug or unexpected behavior.

Use when:

- A test fails.
- A bug appears.
- Behavior is flaky or unexpected.
- Performance appears wrong and needs evidence before optimization.

Example prompt:

```text
This test is failing. Use systematic debugging to find the root cause before fixing it.
```

### `verification-before-completion`

Role: Prevent false completion claims by requiring fresh verification evidence.

Use when:

- Before saying work is done.
- Before saying a bug is fixed.
- Before commit, push, merge, or PR.

Example prompt:

```text
Verify the implementation before reporting completion.
```

### `requesting-code-review`

Role: Review completed or risky work before it goes further.

Use when:

- A task or major feature is complete.
- Before merge.
- After a complex bugfix.

Example prompt:

```text
Review the current changes before I merge them.
```

### `receiving-code-review`

Role: Respond to review feedback with technical evaluation instead of blind agreement.

Use when:

- Review comments arrive.
- Feedback seems unclear or questionable.

Example prompt:

```text
Evaluate this review feedback before applying it.
```

### `finishing-a-development-branch`

Role: Guide the end of a development branch after verification passes.

Use when:

- Implementation is done.
- Tests pass.
- The user needs to choose merge, push, PR, keep, or cleanup.

Example prompt:

```text
Finish this development branch.
```

### `dispatching-parallel-agents`

Role: Split independent investigations or tasks across multiple agents.

Use when:

- There are multiple independent failures.
- Several unrelated subsystems can be explored at the same time.

Example prompt:

```text
Investigate these three independent failures in parallel if Cline SR supports delegation.
```

### `writing-skills`

Role: Create or revise skills using a test-driven process.

Use when:

- Writing a new skill.
- Editing existing skill behavior.
- Verifying a skill works before distributing it.

Example prompt:

```text
Help me write a new Cline SR skill for database migration reviews.
```

## Added Skills From `mattpocock/skills`

### `grill-me`

Role: Stress-test a plan or design through relentless but focused questioning.

Use when:

- The user says "grill me".
- A plan needs pressure testing.
- A design decision tree has unresolved branches.
- The user wants sharper reasoning before implementation.

Expected behavior:

- Ask one question at a time.
- Provide a recommended answer with each question.
- If the answer is discoverable in the codebase, inspect the codebase instead of asking.

Example prompts:

```text
Grill me on this implementation plan before I start coding.
```

```text
Stress-test this architecture decision and ask one question at a time.
```

Automatic trigger guidance:

- This skill should not fire for every design task.
- It is best when the user explicitly asks for pressure testing, critique, or "grill me" behavior.

### `improve-codebase-architecture`

Role: Find architectural friction and propose deepening opportunities.

Use when:

- The user wants architecture review.
- The codebase has shallow modules or pass-through wrappers.
- The user wants refactoring opportunities.
- The goal is better testability, locality, leverage, or AI navigability.

Expected behavior:

- Read `CONTEXT.md` and ADRs when present.
- Explore the codebase for friction.
- Present candidate deepening opportunities.
- Wait for the user to pick a candidate before designing interfaces.
- Use vocabulary from `LANGUAGE.md`: module, interface, implementation, depth, seam, adapter, leverage, locality.

Example prompts:

```text
Analyze this repository and find opportunities to improve codebase architecture and testability.
```

```text
Find shallow modules and propose deepening candidates.
```

Automatic trigger guidance:

- This skill is appropriate for broad architecture improvement requests.
- For small implementation tasks, prefer `brainstorming`, `writing-plans`, or `test-driven-development` depending on the request.

## Common Scenarios

### "Let's make a React todo list"

Expected skill:

- `brainstorming`

Why:

- New creative feature work needs design before implementation.

### "Analyze this repo and write a todo list for phase 2 and phase 3"

Expected skill:

- `writing-plans`

Why:

- The phase goals are already defined and the user asked for a plan/todo list.

### "This test is failing. Fix it."

Expected skill:

- `systematic-debugging`

Why:

- Root cause investigation should happen before fixes.

### "This module structure feels messy. Find refactoring opportunities."

Expected skill:

- `improve-codebase-architecture`

Why:

- The request is about architecture friction and module shape.

### "Before we implement this, challenge my plan."

Expected skill:

- `grill-me`

Why:

- The user is explicitly asking for pressure testing.

## Direct Workflow Invocation

Use workflows when automatic skill selection does not pick the process you want:

```text
/brainstorm.md
/write-plan.md
/debug.md
/review.md
/finish-branch.md
/grill-me.md
/improve-codebase-architecture.md
```

Exact invocation syntax may differ depending on the Cline SR workflow UI. The important point is that each workflow loads the named skill and tells Cline SR which process to follow.
