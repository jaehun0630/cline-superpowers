# Skill Guide

[English](skill-guide.md)

이 문서는 패키지에 포함된 각 skill의 역할, Cline SR이 언제 사용해야 하는지, 사용자가 직접 어떻게 호출할 수 있는지를 설명합니다.

## Skill 선택 방식

Cline SR은 설치된 skill을 다음 경로에서 발견합니다.

- Global: `~/.agents/skills/<skill-name>/SKILL.md`
- Workspace: `<repo>/.agents/skills/<skill-name>/SKILL.md`

설치된 `TaskStart` hook과 `superpowers-bootstrap.md` rule은 Cline SR에게 작업을 시작하기 전에 적용 가능한 skill이 있는지 확인하라고 지시합니다. 그래서 skill은 수동 명령 전용이 아닙니다. 사용자 요청이 skill description 또는 bootstrap trigger와 맞으면 자동으로 선택될 수 있습니다.

Workflow는 명시적인 진입점입니다. 특정 프로세스를 강제로 사용하고 싶을 때 사용합니다.

- Global workflows: `~/Documents/Cline/Workflows/*.md`
- Workspace workflows: `<repo>/.clinerules/workflows/*.md`

## 추천 흐름

Skill은 단계형 개발 루프로 이해하면 편합니다.

1. 명확화와 설계: `brainstorming`, `grill-me`
2. 계획 작성: `writing-plans`
3. 실행: `subagent-driven-development` 또는 `executing-plans`
4. 안전한 구현: `test-driven-development`
5. 디버깅: `systematic-debugging`
6. 리뷰와 마무리: `requesting-code-review`, `receiving-code-review`, `verification-before-completion`, `finishing-a-development-branch`

Architecture 작업은 module depth, refactoring opportunity, testability, AI navigability를 다룰 때 `improve-codebase-architecture`로 진입할 수 있습니다.

## Core Superpowers Skills

### `using-superpowers`

역할: skill 선택을 bootstrap합니다. agent가 응답하거나 행동하기 전에 적용 가능한 skill이 있는지 확인하도록 만듭니다.

사용 시점:

- 새 task를 시작할 때
- agent가 skill system을 건너뛰고 있다고 느껴질 때

예시 prompt:

```text
Use the using-superpowers skill before continuing.
```

### `brainstorming`

역할: 거친 아이디어를 구현 전 승인된 설계로 다듬습니다.

사용 시점:

- 새 기능을 만들 때
- 동작을 변경할 때
- 창의적인 구현 작업을 시작할 때
- 요구사항이 아직 흐릿할 때

기대 동작:

- 프로젝트 context를 탐색합니다.
- 질문을 한 번에 하나씩 합니다.
- 접근안과 trade-off를 제시합니다.
- 구현 계획 전에 승인된 design 문서를 저장합니다.

예시 prompt:

```text
Brainstorm a design for adding offline sync to this app.
```

### `writing-plans`

역할: 승인된 요구사항이나 설계를 상세 구현 계획으로 바꿉니다.

사용 시점:

- 이미 spec이 있을 때
- 사용자가 todo list 또는 implementation plan을 요청할 때
- 작업이 여러 단계이고 코드 수정 전 분해가 필요할 때

예시 prompt:

```text
Create an implementation plan for phase 2 and phase 3 based on the current repository.
```

### `using-git-worktrees`

역할: feature 작업이 격리된 workspace 또는 branch에서 진행되도록 합니다.

사용 시점:

- 현재 workspace를 건드리지 않고 구현 작업을 시작해야 할 때
- 여러 commit이 필요한 큰 계획을 실행할 때

예시 prompt:

```text
Set up an isolated workspace before implementing this plan.
```

### `subagent-driven-development`

역할: 계획의 각 task를 focused subagent로 실행하고 task 사이에 review합니다.

사용 시점:

- Cline SR에서 subagent 또는 delegation 기능을 사용할 수 있을 때
- 구현 계획의 task들이 독립적으로 나뉘어 있을 때

Fallback:

- Cline SR에 대응되는 subagent 기능이 없으면 `executing-plans`를 사용합니다.

예시 prompt:

```text
Execute this implementation plan using subagent-driven development if available.
```

### `executing-plans`

역할: 작성된 구현 계획을 현재 세션에서 checkpoint와 함께 실행합니다.

사용 시점:

- 작성된 plan이 있을 때
- subagent 기능을 사용할 수 없거나 원하지 않을 때

예시 prompt:

```text
Execute docs/superpowers/plans/2026-05-23-cache-refactor.md in this session.
```

### `test-driven-development`

역할: feature, bugfix, refactoring, behavior change에 대해 red-green-refactor 흐름을 강제합니다.

사용 시점:

- feature를 구현할 때
- bug를 수정할 때
- behavior를 refactoring할 때

기대 동작:

- 실패하는 test를 먼저 작성합니다.
- 올바른 이유로 실패하는지 확인합니다.
- 가장 작은 수정으로 통과시킵니다.
- test가 통과하는지 확인합니다.

예시 prompt:

```text
Implement this behavior using test-driven development.
```

### `systematic-debugging`

역할: bug나 예상치 못한 동작을 수정하기 전에 root cause를 찾습니다.

사용 시점:

- test가 실패할 때
- bug가 발생했을 때
- 동작이 flaky하거나 예상과 다를 때
- 성능 문제가 있어 최적화 전 근거 수집이 필요할 때

예시 prompt:

```text
This test is failing. Use systematic debugging to find the root cause before fixing it.
```

### `verification-before-completion`

역할: fresh verification 없이 완료를 주장하지 않도록 막습니다.

사용 시점:

- 작업이 끝났다고 말하기 전
- bug가 고쳐졌다고 말하기 전
- commit, push, merge, PR 전

예시 prompt:

```text
Verify the implementation before reporting completion.
```

### `requesting-code-review`

역할: 완료된 작업이나 위험한 변경을 다음 단계로 넘기기 전에 review합니다.

사용 시점:

- task 또는 주요 feature가 끝났을 때
- merge 전
- 복잡한 bugfix 후

예시 prompt:

```text
Review the current changes before I merge them.
```

### `receiving-code-review`

역할: review feedback에 무조건 동의하지 않고 기술적으로 평가합니다.

사용 시점:

- review comment를 받았을 때
- feedback이 불명확하거나 기술적으로 의심스러울 때

예시 prompt:

```text
Evaluate this review feedback before applying it.
```

### `finishing-a-development-branch`

역할: verification이 통과한 뒤 development branch를 마무리하는 결정을 돕습니다.

사용 시점:

- 구현이 끝났을 때
- test가 통과했을 때
- merge, push, PR, branch 유지, cleanup 중 선택이 필요할 때

예시 prompt:

```text
Finish this development branch.
```

### `dispatching-parallel-agents`

역할: 독립적인 조사나 task를 여러 agent로 나눕니다.

사용 시점:

- 독립적인 failure가 여러 개 있을 때
- 서로 다른 subsystem을 동시에 조사할 수 있을 때

예시 prompt:

```text
Investigate these three independent failures in parallel if Cline SR supports delegation.
```

### `writing-skills`

역할: test-driven 방식으로 새 skill을 만들거나 기존 skill을 수정합니다.

사용 시점:

- 새 skill을 작성할 때
- 기존 skill 동작을 수정할 때
- 배포 전 skill이 제대로 동작하는지 검증할 때

예시 prompt:

```text
Help me write a new Cline SR skill for database migration reviews.
```

## `mattpocock/skills`에서 추가한 Skill

### `grill-me`

역할: 계획이나 설계를 집요하지만 집중된 질문으로 압박 검증합니다.

사용 시점:

- 사용자가 "grill me"라고 말할 때
- 계획에 pressure testing이 필요할 때
- 설계 결정 트리에 아직 해결되지 않은 가지가 있을 때
- 구현 전에 더 날카로운 reasoning을 원할 때

기대 동작:

- 질문을 한 번에 하나씩 합니다.
- 각 질문마다 추천 답변도 함께 제공합니다.
- 코드베이스에서 답을 찾을 수 있으면 질문하지 않고 직접 조사합니다.

예시 prompt:

```text
Grill me on this implementation plan before I start coding.
```

```text
Stress-test this architecture decision and ask one question at a time.
```

자동 발동 기준:

- 모든 설계 작업마다 발동하는 skill은 아닙니다.
- 사용자가 pressure testing, critique, "grill me" 동작을 명시적으로 원할 때 가장 적합합니다.

### `improve-codebase-architecture`

역할: architecture friction을 찾고 deepening opportunity를 제안합니다.

사용 시점:

- 사용자가 architecture review를 원할 때
- codebase에 shallow module이나 pass-through wrapper가 있을 때
- refactoring opportunity를 찾고 싶을 때
- testability, locality, leverage, AI navigability 개선이 목표일 때

기대 동작:

- `CONTEXT.md`와 ADR이 있으면 먼저 읽습니다.
- codebase에서 friction을 탐색합니다.
- deepening candidate를 제시합니다.
- 사용자가 candidate를 선택하기 전에는 interface 설계를 제안하지 않습니다.
- `LANGUAGE.md`의 용어를 사용합니다: module, interface, implementation, depth, seam, adapter, leverage, locality.

예시 prompt:

```text
Analyze this repository and find opportunities to improve codebase architecture and testability.
```

```text
Find shallow modules and propose deepening candidates.
```

자동 발동 기준:

- 넓은 architecture improvement 요청에 적합합니다.
- 작은 구현 task는 요청 내용에 따라 `brainstorming`, `writing-plans`, `test-driven-development`가 더 적합할 수 있습니다.

## 흔한 시나리오

### "Let's make a React todo list"

기대 skill:

- `brainstorming`

이유:

- 새 창의적 feature 작업은 구현 전에 설계가 필요합니다.

### "Analyze this repo and write a todo list for phase 2 and phase 3"

기대 skill:

- `writing-plans`

이유:

- phase 목표가 이미 정의되어 있고 사용자가 plan/todo list를 요청했습니다.

### "This test is failing. Fix it."

기대 skill:

- `systematic-debugging`

이유:

- 수정 전에 root cause 조사가 필요합니다.

### "This module structure feels messy. Find refactoring opportunities."

기대 skill:

- `improve-codebase-architecture`

이유:

- architecture friction과 module shape에 대한 요청입니다.

### "Before we implement this, challenge my plan."

기대 skill:

- `grill-me`

이유:

- 사용자가 명시적으로 pressure testing을 요청했습니다.

## Workflow 직접 호출

자동 skill 선택이 원하는 프로세스를 고르지 않을 때 workflow를 사용하세요.

```text
/brainstorm.md
/write-plan.md
/debug.md
/review.md
/finish-branch.md
/grill-me.md
/improve-codebase-architecture.md
```

정확한 호출 방식은 Cline SR workflow UI에 따라 다를 수 있습니다. 중요한 점은 각 workflow가 이름에 해당하는 skill을 load하고 Cline SR에게 어떤 process를 따라야 하는지 알려준다는 것입니다.
