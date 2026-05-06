# 02. WSL2 + DevContainer 개발환경 구성

## 권장 작업 위치

WSL2에서 개발할 때는 Windows 파일 시스템이 아니라 WSL 내부 파일 시스템에서 작업하는 것이 좋습니다.

좋은 예:

```bash
/home/gunwoo/projects/my-project
```

피하는 것이 좋은 예:

```bash
/mnt/c/Users/gunwoo/projects/my-project
```

`/mnt/c` 아래에서 작업하면 파일 IO가 느리거나 DevContainer 권한 문제가 생기기 쉽습니다.

---

## 추천 프로젝트 구조

```txt
my-project/
  .devcontainer/
    devcontainer.json
    Dockerfile
  infra/
    Pulumi.yaml
    Pulumi.dev.yaml
    package.json
    tsconfig.json
    index.ts
  backend/
  frontend/
  docs/
```

여기서 `infra/`가 Pulumi 프로젝트입니다.

---

## DevContainer Dockerfile 예시

`.devcontainer/Dockerfile`

```Dockerfile
FROM mcr.microsoft.com/devcontainers/base:noble

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
```

Node.js는 Dockerfile에서 직접 설치해도 되지만, DevContainer feature를 쓰는 편이 관리하기 편합니다.

---

## devcontainer.json 예시

`.devcontainer/devcontainer.json`

```json
{
  "name": "pulumi-oci-dev",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "remoteUser": "vscode",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "20"
    },
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "mounts": [
    "source=${localEnv:HOME}/.oci,target=/home/vscode/.oci,type=bind,consistency=cached"
  ],
  "postCreateCommand": "curl -fsSL https://get.pulumi.com | sh && echo 'export PATH=$PATH:$HOME/.pulumi/bin' >> ~/.bashrc"
}
```

---

## 컨테이너 생성 후 확인

DevContainer가 열린 뒤 터미널에서 확인합니다.

```bash
source ~/.bashrc
pulumi version
node -v
npm -v
git --version
```

---

## Pulumi CLI 설치 위치 주의

`remoteUser`가 `vscode`인 경우 Pulumi CLI는 `/home/vscode/.pulumi/bin`에 설치되는 것이 자연스럽습니다.

따라서 PATH에 다음 경로가 포함되어야 합니다.

```bash
export PATH=$PATH:$HOME/.pulumi/bin
```

---

## DevContainer에서 OCI 인증 파일 mount 주의

아래 mount는 WSL2 환경에서 DevContainer를 열었을 때 WSL의 `$HOME/.oci`를 컨테이너로 연결하기 위한 예시입니다.

```json
"mounts": [
  "source=${localEnv:HOME}/.oci,target=/home/vscode/.oci,type=bind,consistency=cached"
]
```

환경에 따라 `${localEnv:HOME}`이 Windows HOME을 가리킬 수도 있으므로, 실제로 컨테이너 안에서 다음 명령으로 확인해야 합니다.

```bash
ls -al ~/.oci
```
