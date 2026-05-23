# Cline Superpowers

[English](README.md)

Cline SR에서 사용할 수 있도록 Superpowers와 일부 agent skill을 조정한 패키지입니다.

이 저장소는 `obra/superpowers`와 `mattpocock/skills`의 일부 호환 skill을 Cline SR 환경에 맞게 패키징합니다. Cline SR의 Rules, Workflows, Hooks, Skills를 global 또는 workspace 범위로 설치할 수 있습니다.

## 설치되는 위치

Global 대상:

```text
~/Cline/Rules/*.md
~/Cline/Workflows/*.md
~/Document/Cline/Hooks/TaskStart
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
