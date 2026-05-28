# Cline Superpowers

[English](README.md)

Cline SR에서 사용할 수 있도록 Superpowers와 일부 agent skill을 조정한 패키지입니다.

이 저장소는 `obra/superpowers`와 `mattpocock/skills`의 일부 호환 skill을 Cline SR 환경에 맞게 패키징합니다. Cline SR의 Rules, Workflows, Hooks, Skills를 global 또는 workspace 범위로 설치할 수 있습니다.

## 설치되는 위치

Global 대상:

```text
~/Documents/Cline/Rules/*.md
~/Documents/Cline/Workflows/*.md
~/Documents/Cline/Hooks/TaskStart
~/.agents/skills/<skill-name>/SKILL.md
```

Workspace 대상:

```text
<repo>/.clinerules/*.md
<repo>/.clinerules/workflows/*.md
<repo>/.clinerules/hooks/TaskStart
<repo>/.agents/skills/<skill-name>/SKILL.md
```

원본 파일은 `packages/` 아래에 한 벌만 유지됩니다. 설치 스크립트가 선택한 대상 경로로 복사합니다.

## Global 경로 설정

Global 설치는 기본적으로 `cline-superpowers.config`를 읽습니다. PC마다 Cline SR global 경로가 다르면 스크립트를 수정하지 말고 이 파일의 경로 값을 수정한 뒤 install, verify, uninstall을 다시 실행하세요.

별도 config 파일을 지정할 수도 있습니다.

```bash
scripts/install.sh --target global --config /path/to/cline-superpowers.config
scripts/verify-install.sh --target global --config /path/to/cline-superpowers.config
scripts/uninstall.sh --target global --config /path/to/cline-superpowers.config
```

## 설치

Global 설치 미리보기:

```bash
scripts/install.sh --target global --dry-run
```

Global 설치:

```bash
scripts/install.sh --target global
```

Workspace 설치 미리보기:

```bash
scripts/install.sh --target workspace --repo /path/to/repo --dry-run
```

특정 workspace에 설치:

```bash
scripts/install.sh --target workspace --repo /path/to/repo
```

설치 확인:

```bash
scripts/verify-install.sh --target workspace --repo /path/to/repo
```

설치 제거:

```bash
scripts/uninstall.sh --target global --dry-run
scripts/uninstall.sh --target workspace --repo /path/to/repo
```

`uninstall.sh`는 이 패키지가 설치한 Superpowers 관련 파일만 제거합니다. 다른 Cline SR rules, workflows, hooks, skills는 건드리지 않습니다.

## Upstream 업데이트

`obra/superpowers`를 이 저장소 옆에 clone 또는 update 한 뒤 실행합니다.

```bash
scripts/sync-from-upstream.sh --upstream ../superpowers
```

이 스크립트는 `packages/skills/` 안의 Superpowers skill 디렉터리만 갱신하고 upstream commit을 `packages/UPSTREAM.md`에 기록합니다. 별도로 패키징된 `grill-me`, `improve-codebase-architecture`는 유지됩니다.

## 수동 동작 확인

설치 후 Cline SR에서 새 task를 시작하고 다음 메시지를 보냅니다.

```text
Let's make a react todo list
```

기대 동작: Cline SR이 바로 구현 코드를 작성하지 않고 Superpowers의 `brainstorming` 흐름을 먼저 사용해야 합니다.

## Skill 발동 조건 요약

`TaskStart` hook과 bootstrap rule은 사용자 요청이 아래 조건에 맞을 때 Cline SR이 적절한 skill을 선택하도록 안내합니다. 특정 절차를 강제로 사용하고 싶으면 workflow를 직접 호출하세요.

| Skill | 발동 조건 |
| --- | --- |
| `using-superpowers` | 새 task 시작 시, 또는 Cline SR이 skill 선택을 건너뛰는 것처럼 보일 때 |
| `brainstorming` | 새 기능, 동작 변경, 창의적인 구현, 요구사항이 불명확한 구현 전 단계 |
| `writing-plans` | 이미 spec/design이 있을 때, todo list 요청, implementation plan 요청, 코드 수정 전 여러 단계로 나눠야 하는 작업 |
| `using-git-worktrees` | 현재 workspace와 분리된 feature 작업을 시작할 때, 특히 여러 commit이 필요한 큰 변경 |
| `subagent-driven-development` | 작성된 plan에 독립적인 task가 있고 Cline SR에서 delegation/subagent 기능을 사용할 수 있을 때 |
| `executing-plans` | 작성된 implementation plan을 현재 세션에서 실행할 때, 특히 subagent 기능이 없거나 원하지 않을 때 |
| `test-driven-development` | feature 구현, bug 수정, behavior refactoring, 사용자에게 보이는 동작 변경 |
| `systematic-debugging` | 실패하는 test, bug report, flaky behavior, 예상과 다른 동작, 근거 수집이 필요한 성능 문제 |
| `verification-before-completion` | 완료 또는 수정 완료를 말하기 전, commit, push, merge, PR 전 |
| `requesting-code-review` | 큰 변경이나 위험한 작업 후, merge 전, 복잡한 bugfix 후 |
| `receiving-code-review` | review feedback을 받았을 때, 특히 feedback이 불명확하거나 기술적으로 의심스러울 때 |
| `finishing-a-development-branch` | 구현과 검증이 끝난 뒤 merge, push, PR, branch 유지, cleanup 중 선택해야 할 때 |
| `dispatching-parallel-agents` | 독립적인 조사 여러 개, 관련 없는 failure 여러 개, 병렬로 탐색 가능한 별도 subsystem이 있을 때 |
| `writing-skills` | 새 skill 작성, 기존 skill 수정, 배포 전 skill 검증 |
| `grill-me` | 명시적인 "grill me", pressure testing, critique, 구현 전 계획/설계 도전 요청 |
| `improve-codebase-architecture` | architecture review, refactoring opportunity, shallow module, testability, locality, leverage, AI navigability 개선 |

## 구성

- `packages/rules/superpowers-bootstrap.md`: 항상 적용되는 bootstrap 규칙입니다.
- `packages/workflows/*.md`: 명시적으로 실행할 수 있는 workflow 진입점입니다.
- `packages/hooks/TaskStart`: 새 task 시작 시 bootstrap context를 주입하는 실행 가능한 Cline hook입니다.
- `packages/skills/*`: Superpowers skill과 Cline SR에 맞게 조정된 호환 skill입니다.
- `scripts/install.sh`: 대상별 설치 스크립트입니다.
- `scripts/uninstall.sh`: 이 패키지가 설치한 파일만 제거하는 스크립트입니다.
- `scripts/verify-install.sh`: 설치 확인 스크립트입니다.
- `scripts/sync-from-upstream.sh`: upstream Superpowers skill 동기화 도우미입니다.

## 사용 가이드

각 skill의 역할, 자동 발동 기준, 예시 prompt는 [docs/skill-guide.kor.md](docs/skill-guide.kor.md)를 참고하세요.

## 참고

`TaskStart`는 Cline SR hook script입니다. macOS와 Linux에서는 설치 후에도 실행 권한이 있어야 하고, 확장자가 없는 파일명이어야 합니다.

Hook을 설치한 뒤에는 Cline SR에서 Hooks를 활성화해야 새 task 시작 시 설치된 `TaskStart` hook이 실행됩니다.

설치 후 사용할 수 있는 `mattpocock/skills` 기반 추가 skill:

- `grill-me`: 계획이나 설계를 집중 질문으로 압박 검증합니다.
- `improve-codebase-architecture`: locality, leverage, testability, AI navigability를 개선할 수 있는 architecture deepening 기회를 찾습니다.

이 skill들은 사용자 요청과 trigger가 맞으면 자동으로 선택될 수 있고, 설치된 workflow를 통해 직접 호출할 수도 있습니다.
