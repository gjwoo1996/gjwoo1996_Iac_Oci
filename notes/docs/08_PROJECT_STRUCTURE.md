# 08. 추천 프로젝트 구조

## 기본 구조

Next.js + NestJS + Pulumi + DevContainer를 함께 사용하는 경우 다음 구조를 추천합니다.

```txt
my-app/
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
    package.json
    src/
    Dockerfile

  frontend/
    package.json
    src/
    Dockerfile

  deploy/
    docker-compose.yml

  docs/
    architecture.md
    deployment.md
    operations.md

  README.md
```

---

## 디렉토리 역할

### `.devcontainer/`

로컬 개발 환경을 표준화합니다.

포함될 수 있는 것:

```txt
- Node.js
- Pulumi CLI
- GitHub CLI
- OCI config mount
- Docker CLI
```

---

### `infra/`

Pulumi 프로젝트입니다.

관리 대상:

```txt
- OCI VCN
- Subnet
- Internet Gateway
- Route Table
- Security List / NSG
- Compute Instance
- Object Storage
- Container Registry
```

---

### `backend/`

NestJS 백엔드 애플리케이션입니다.

---

### `frontend/`

Next.js 프론트엔드 애플리케이션입니다.

---

### `deploy/`

서버에서 실행할 Docker Compose 파일이나 배포 스크립트를 둡니다.

예시:

```txt
deploy/
  docker-compose.yml
  nginx.conf
  scripts/
    deploy.sh
```

---

### `docs/`

운영 및 개발 문서를 둡니다.

예시:

```txt
docs/
  00_PROJECT_OVERVIEW.md
  01_INFRASTRUCTURE.md
  02_DEPLOYMENT.md
  03_OPERATIONS.md
  04_TROUBLESHOOTING.md
```

---

## Pulumi 파일 예시

```txt
infra/
  Pulumi.yaml        # Pulumi 프로젝트 정의
  Pulumi.dev.yaml    # dev stack 설정
  index.ts           # 인프라 코드 진입점
  package.json       # Pulumi provider dependency
  tsconfig.json      # TypeScript 설정
```

---

## Git에 올리지 않는 것

`.gitignore` 예시:

```gitignore
node_modules/
.env
*.pem
.oci/
.DS_Store
```

Pulumi secret 관리 방식을 정하지 않았다면 `Pulumi.*.yaml`에 민감정보가 들어가지 않았는지 확인해야 합니다.

---

## 초기에는 단순하게 시작하기

처음부터 구조를 너무 복잡하게 만들기보다 다음 순서가 좋습니다.

```txt
1. infra/에서 VCN 하나 생성
2. Subnet 추가
3. Instance 추가
4. cloud-init으로 Docker 설치
5. deploy/docker-compose.yml로 앱 실행
6. GitHub Actions 추가
```
