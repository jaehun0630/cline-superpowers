# Superpowers Bootstrap

Use Superpowers before acting.

Before starting any user request, check whether one of the installed Superpowers skills applies. If a skill applies, load and follow it before asking clarifying questions, planning, debugging, editing code, reviewing work, or claiming completion.

User instructions are higher priority than Superpowers process rules. If a project rule or direct user request conflicts with a skill, follow the user instruction and state the conflict briefly.

When a Superpowers skill mentions another agent harness, adapt the tool names to Cline:

- `Skill` or `skill` means load the matching file from `.agents/skills/<skill-name>/SKILL.md`.
- `TodoWrite` means use Cline's task or checklist mechanism if available; otherwise keep a visible markdown checklist in the response.
- `Task`, `subagent`, or parallel agent dispatch means use Cline's available delegation feature if present. If not present, use `executing-plans` as the fallback.
- `Read`, `Write`, `Edit`, and `Bash` mean Cline's normal file and terminal tools.

Important default triggers:

- New feature, behavior change, or creative implementation: use `brainstorming` before implementation.
- Approved design or multi-step work: use `writing-plans`.
- Feature or bugfix implementation: use `test-driven-development`.
- Bug, failing test, or unexpected behavior: use `systematic-debugging`.
- Before saying work is complete or fixed: use `verification-before-completion`.
- Before merge or after substantial work: use `requesting-code-review` if review support exists.

Do not treat this rule as a replacement for the skills. It only tells you to load the right skill at the right time.
