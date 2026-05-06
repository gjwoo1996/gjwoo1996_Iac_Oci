# Dev Container 설정 계획

## 목적

이 문서는 이 저장소의 Dev Container 설정만 정의한다.

이 저장소는 이후 Pulumi와 TypeScript를 사용해 Oracle Cloud Infrastructure를 IaC로 관리할 예정이지만, 이 문서에서는 Pulumi 프로젝트 구조, 스택, OCI 리소스, 인프라 코드 레이아웃을 정의하지 않는다.

이 단계의 목표는 재현 가능한 개발 환경을 먼저 준비하는 것이다.

## 범위

이 문서에 포함하는 내용:

- Dev Container 베이스 이미지
- 컨테이너 내부에 설치할 도구
- `pnpm` 기반 Node.js 패키지 관리 방식
- OCI 인증정보 마운트 전략
- Pulumi CLI 사용 가능 상태
- Codex CLI와 Claude Code CLI 설치 방식
- Codex와 Claude 로그인 정보 및 대화 이력 마운트 전략
- VS Code 확장 추천
- 로컬 인증정보 보안 규칙
- Dev Container 구현 체크리스트
- 검증 명령

이 문서에 포함하지 않는 내용:

- `Pulumi.yaml`
- Pulumi 스택 파일
- Pulumi 백엔드 설계
- OCI 리소스 아키텍처
- TypeScript 소스 레이아웃
- 환경별 IaC 구조

위 항목은 Dev Container 기준 환경을 만든 뒤 별도 문서에서 다룬다.

## 대상 개발 환경

Dev Container는 OCI용 TypeScript 기반 Pulumi 개발을 지원해야 한다.

필수 런타임:

```text
Node.js LTS
```

권장 베이스 이미지:

```text
mcr.microsoft.com/devcontainers/typescript-node:1-24-bookworm
```

선택 이유:

- Dev Container 워크플로에 맞게 유지보수되는 이미지이다.
- Node.js와 TypeScript 개발에 필요한 기본 환경을 이미 포함한다.
- Pulumi CLI, OCI CLI, Codex CLI, Claude Code CLI를 추가 설치하기 좋은 기반이다.

버전 고정 이유:

- 태그 없이 사용하면 이미지 업데이트 시 환경이 달라져 재현성이 깨진다.
- `1-24-bookworm`은 Node.js 24 Active LTS + Debian Bookworm 조합이다.
- 이미지 업데이트가 필요한 경우 태그를 명시적으로 변경한다.

## 확정된 기본 결정

처음 OCI를 IaC로 사용하는 단계이므로, 초기 설정은 단순하고 안전한 쪽을 기본값으로 한다.

```text
베이스 이미지: mcr.microsoft.com/devcontainers/typescript-node:1-24-bookworm
OCI config mount: ~/.oci -> /home/node/.oci
OCI mount mode: read-only
OCI profile: DEFAULT
Package manager: pnpm
Extra security tools: none
AI CLI tools: Codex CLI, Claude Code CLI
Codex state mount: ~/.codex -> /home/node/.codex
Claude state mount: ~/.claude -> /home/node/.claude
Claude config mount: ~/.claude.json -> /home/node/.claude.json
```

## 생성할 파일

Dev Container 설정 단계에서는 다음 파일을 생성한다.

```text
.
└── .devcontainer/
    ├── devcontainer.json
    └── Dockerfile
```

이 단계에서는 Pulumi 프로젝트 파일을 생성하지 않는다.

## 필수 도구

컨테이너에는 다음 도구가 포함되어야 한다.

- Node.js
- `pnpm`
- TypeScript 지원
- Pulumi CLI
- OCI CLI
- Codex CLI
- Claude Code CLI
- Git
- curl
- unzip
- jq
- ca-certificates

선택 편의 도구:

- bash-completion
- less
- vim 또는 nano

초기 설정에서는 Checkov, Trivy, pre-commit 같은 추가 보안/검사 도구를 넣지 않는다. Pulumi와 OCI 개발 흐름이 안정화된 뒤 별도 단계에서 추가한다.

## Dev Container 설정

### `devcontainer.json`

`devcontainer.json`은 다음을 정의해야 한다.

- 컨테이너 이름
- Dockerfile 빌드 경로
- 워크스페이스 폴더
- 컨테이너 접속 사용자 (`remoteUser`)
- OCI config 마운트
- Codex 상태 디렉터리 마운트
- Claude 상태 디렉터리 및 설정 파일 마운트
- 추천 VS Code 확장
- 안전한 환경 변수
- 컨테이너 생성 후 실행할 명령 (`postCreateCommand`)

예상 책임:

- `.devcontainer/Dockerfile`로 이미지를 빌드한다.
- 현재 저장소를 워크스페이스로 마운트한다.
- 호스트의 OCI 인증정보를 컨테이너에 읽기 전용으로 마운트한다.
- 호스트의 Codex와 Claude 로그인 정보 및 대화 이력을 컨테이너에 마운트한다.
- TypeScript, YAML, Docker, Pulumi, OCI 작업에 유용한 에디터 확장을 추천한다.
- `remoteUser: "node"`를 명시해 컨테이너 내부에서 root가 아닌 node 사용자로 접속한다.

권장 마운트:

```jsonc
"mounts": [
  "source=${localEnv:HOME}/.oci,target=/home/node/.oci,type=bind,readonly",
  "source=${localEnv:HOME}/.codex,target=/home/node/.codex,type=bind",
  "source=${localEnv:HOME}/.claude,target=/home/node/.claude,type=bind",
  "source=${localEnv:HOME}/.claude.json,target=/home/node/.claude.json,type=bind"
]
```

WSL2에서 작업하는 경우 `${localEnv:HOME}`은 보통 WSL2 사용자 홈 디렉터리인 `/home/<사용자명>`을 가리킨다. 현재 환경 기준으로는 다음 디렉터리를 재사용하는 구조가 된다.

```text
/home/gjwoo96/.oci
/home/gjwoo96/.codex
/home/gjwoo96/.claude
/home/gjwoo96/.claude.json
```

주의:

- OCI 인증정보는 컨테이너가 읽기만 하도록 `readonly`로 마운트한다.
- Codex와 Claude의 로그인 정보 및 대화 이력은 CLI가 갱신할 수 있으므로 읽기/쓰기로 마운트한다.
- `.claude.json` 파일이 없는 환경에서는 마운트 실패가 발생할 수 있으므로, 구현 전에 호스트에 파일이 있는지 확인하거나 빈 파일을 생성한다.
- `~/.codex` 디렉터리가 없는 환경도 동일하게 마운트 실패가 발생한다. Codex를 한 번도 사용하지 않은 경우 빈 디렉터리를 먼저 생성한다.

  ```bash
  mkdir -p ~/.codex
  touch ~/.claude.json
  ```

### `Dockerfile`

`Dockerfile`은 다음을 수행해야 한다.

- TypeScript Node Dev Container 이미지를 베이스로 사용한다.
- 공통 OS 패키지를 설치한다.
- `corepack`을 통해 `pnpm`을 활성화한다.
- Pulumi CLI를 설치한다.
- OCI CLI를 설치한다.
- Codex CLI를 설치한다.
- Claude Code CLI를 설치한다.
- 저장소 소스 파일을 이미지에 복사하지 않는다.

저장소 소스는 이미지에 포함하지 않고 Dev Container 런타임에서 마운트한다.

AI CLI 설치는 Dockerfile 레이어에서 수행한다. 이렇게 하면 컨테이너를 리빌드하더라도 Docker 빌드 캐시가 유지되는 한 Codex CLI와 Claude Code CLI를 매번 새로 다운로드하지 않는다.

권장 설치 방향:

```dockerfile
# Pulumi CLI
RUN curl -fsSL https://get.pulumi.com | sh
ENV PATH="/root/.pulumi/bin:${PATH}"

# OCI CLI
RUN pip3 install oci-cli

# pnpm 및 AI CLI
ENV PNPM_HOME=/usr/local/share/pnpm
ENV PATH="${PNPM_HOME}:${PATH}"

RUN corepack enable \
    && corepack prepare pnpm@latest --activate

RUN --mount=type=cache,id=pnpm-store,target=/pnpm/store \
    pnpm config set store-dir /pnpm/store \
    && pnpm add -g @openai/codex @anthropic-ai/claude-code
```

메모:

- Pulumi CLI는 공식 installer 스크립트로 설치한다. 기본 설치 경로는 `/root/.pulumi/bin`이다. `remoteUser: "node"`로 접속하는 경우에도 Dockerfile 빌드는 root로 수행되므로 이 PATH 설정이 유효하다.
- OCI CLI는 Python pip 기반이다. 베이스 이미지에 Python3와 pip3가 포함되어 있는지 빌드 시점에 확인한다. 없을 경우 `apt-get install -y python3-pip` 레이어를 앞에 추가한다.
- OpenAI Codex CLI의 공식 npm 패키지는 `@openai/codex`이다.
- Claude Code CLI의 공식 npm 패키지는 `@anthropic-ai/claude-code`이다.
- Docker 빌드 캐시를 완전히 삭제하거나 `--no-cache`로 리빌드하면 다시 다운로드된다.
- Dockerfile 레이어에서 `ENV PATH`로 설정한 경로가 `node` 사용자 접속 시에도 정상 적용되는지 빌드 후 확인한다.
- DevContainer Features(`ghcr.io/devcontainers/features/`)를 사용하면 Dockerfile 없이 일부 도구를 설치할 수 있지만, 이 설정에서는 빌드 캐시 제어와 버전 일관성을 위해 Dockerfile 방식을 선택한다.

## OCI 인증정보 마운트

OCI 인증정보는 호스트 머신에 유지한다.

예상 호스트 위치:

```text
~/.oci
```

예상 컨테이너 위치:

```text
/home/node/.oci
```

권장 마운트:

```text
source=${localEnv:HOME}/.oci,target=/home/node/.oci,type=bind,readonly
```

초기 설정에서는 읽기 전용 마운트를 사용한다. `oci setup config`처럼 `~/.oci`를 수정하는 초기화 명령은 호스트 WSL2 환경에서 실행하고, Dev Container는 이미 준비된 인증정보를 읽기만 한다.

기본 OCI CLI 프로필은 다음을 사용한다.

```text
DEFAULT
```

## Pulumi 인증

Dev Container는 Pulumi CLI를 설치하지만, Pulumi 인증정보를 저장소에 저장하지 않는다.

필요할 때 컨테이너 안에서 직접 로그인한다.

```bash
pulumi login
```

또는 호스트의 환경 변수를 컨테이너에 전달할 수 있다. `devcontainer.json`에 다음을 추가한다.

```jsonc
"remoteEnv": {
  "PULUMI_ACCESS_TOKEN": "${localEnv:PULUMI_ACCESS_TOKEN}"
}
```

이 방식은 호스트 WSL2 셸에서 `export PULUMI_ACCESS_TOKEN=...`으로 설정한 값을 컨테이너에 전달한다. 값이 비어 있으면 컨테이너 안에서도 빈 값으로 전달되므로, 호스트에서 먼저 설정했는지 확인한다.

Pulumi 백엔드는 이 문서에서 결정하지 않는다. 별도의 Pulumi 프로젝트 설계 문서에서 다룬다.

## Codex 및 Claude CLI 인증과 이력

Codex CLI와 Claude Code CLI는 Dockerfile 이미지 레이어에서 설치한다.

로그인 정보, 설정, 대화 이력은 이미지에 넣지 않고 WSL2 호스트의 홈 디렉터리를 컨테이너에 마운트해 재사용한다.

Codex:

```text
호스트: ~/.codex
컨테이너: /home/node/.codex
```

Claude:

```text
호스트: ~/.claude
컨테이너: /home/node/.claude

호스트: ~/.claude.json
컨테이너: /home/node/.claude.json
```

이 방식의 장점:

- 컨테이너를 리빌드해도 Codex와 Claude 로그인을 다시 반복하지 않아도 된다.
- 기존 대화 이력과 설정을 컨테이너 안에서 그대로 사용할 수 있다.
- 인증정보가 Docker 이미지 레이어나 Git 저장소에 포함되지 않는다.

주의:

- Codex와 Claude 상태 디렉터리에는 민감한 인증정보가 포함될 수 있다.
- 해당 디렉터리는 절대 저장소 안에 복사하지 않는다.
- 저장소 루트에 `.codex`, `.claude`, `.claude.json`이 생기는 경우 Git에서 무시해야 한다.

## 추천 VS Code 확장

`devcontainer.json`의 `customizations.vscode.extensions`에 추가할 확장 목록:

| 목적 | 확장 ID |
|------|---------|
| Pulumi | `pulumi.pulumi` |
| Docker | `ms-azuretools.vscode-docker` |
| YAML | `redhat.vscode-yaml` |
| ESLint | `dbaeumer.vscode-eslint` |
| Prettier | `esbenp.prettier-vscode` |
| TypeScript 자동 임포트 | `ms-vscode.vscode-typescript-next` |

OCI 관련 공식 VS Code 확장은 현재 안정적인 옵션이 없어 포함하지 않는다.

## 보안 규칙

Dev Container 설정은 인증정보나 비밀값을 커밋하지 않아야 한다.

저장소는 최소한 다음 패턴을 무시해야 한다.

```text
.oci/
.codex/
.claude/
.claude.json
*.pem
*.key
.env
.env.*
.pulumi/
node_modules/
```

이 단계에서는 Pulumi 프로젝트 파일을 만들지 않지만, 이후 실수 방지를 위해 `.pulumi/`와 `node_modules/`는 미리 무시한다.

## 구현 체크리스트

1. 저장소 루트에 `.gitignore` 파일을 생성하고 보안 규칙 섹션의 패턴을 추가한다.
2. `.devcontainer/devcontainer.json`을 생성한다.
3. `.devcontainer/Dockerfile`을 생성한다.
4. Dockerfile에 Pulumi CLI, OCI CLI, pnpm, AI CLI 설치 레이어를 추가한다.
5. WSL2 호스트에 `~/.oci`, `~/.codex`, `~/.claude`, `~/.claude.json`이 있는지 확인하고, 없는 항목은 미리 생성한다.
6. 저장소를 Dev Container로 다시 연다.
7. 필수 도구가 설치되었는지 확인한다.
8. `node` 사용자 컨텍스트에서 `pulumi version`, `oci --version`, `codex`, `claude` 명령이 PATH에서 찾아지는지 확인한다.
9. OCI config 디렉터리가 컨테이너 안에서 읽기 전용으로 보이는지 확인한다.
10. Pulumi CLI가 실행되는지 확인한다.

## 검증 명령

다음 명령은 Dev Container 안에서 실행한다.

```bash
node --version
pnpm --version
pulumi version
oci --version
codex --version
claude --version
git --version
jq --version
```

OCI config 확인:

```bash
ls -la ~/.oci
```

Codex 상태 디렉터리 확인:

```bash
ls -la ~/.codex
codex --version
```

> `@openai/codex` 패키지의 실제 CLI 진입점 이름이 `codex`인지 구현 시점에 공식 문서로 확인한다. 다를 경우 이 검증 명령을 수정한다.

Claude 상태 디렉터리 확인:

```bash
ls -la ~/.claude
test -f ~/.claude.json && ls -la ~/.claude.json
claude --version
```

선택 OCI CLI 읽기 전용 확인:

```bash
oci iam region list --profile DEFAULT
```

선택 Pulumi CLI 확인:

```bash
pulumi whoami
```

선택 Claude Code 상태 확인:

```bash
claude doctor
```

## 구현 전 확인할 사항

이 문서에서는 초기 기본값을 이미 정했다. 구현 전에 실제 호스트 환경만 확인하면 된다.

1. WSL2 홈 디렉터리에 `~/.oci`가 있는가?
2. WSL2 홈 디렉터리에 `~/.codex`가 있는가? 없으면 `mkdir -p ~/.codex`로 생성한다.
3. WSL2 홈 디렉터리에 `~/.claude`가 있는가?
4. WSL2 홈 디렉터리에 `~/.claude.json`이 있는가? 없으면 `touch ~/.claude.json`으로 생성한다.
5. OCI config의 기본 프로필 이름이 `DEFAULT`인가?
6. 호스트 WSL2 셸에 `PULUMI_ACCESS_TOKEN` 환경 변수가 설정되어 있는가? `remoteEnv` 방식으로 전달하려면 사전에 설정되어 있어야 한다.

위 항목 중 없는 파일이나 디렉터리는 Dev Container 구현 전에 호스트 WSL2 환경에서 먼저 준비한다.
