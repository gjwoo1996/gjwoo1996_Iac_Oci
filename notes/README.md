# Pulumi + WSL2 + DevContainer 학습 문서

이 문서는 WSL2 + DevContainer 환경에서 Pulumi를 사용해 OCI 인프라를 코드로 관리하기 위해 알아야 하는 기초 개념과 사용 흐름을 정리한 문서입니다.

## 문서 구성

| 파일 | 설명 |
|---|---|
| `docs/00_OVERVIEW.md` | Pulumi를 왜 쓰는지, 전체 그림 |
| `docs/01_CORE_CONCEPTS.md` | Pulumi 핵심 개념: Program, Provider, Stack, State, Backend |
| `docs/02_WSL2_DEVCONTAINER_SETUP.md` | WSL2 + DevContainer 개발환경 구성 |
| `docs/03_OCI_AUTH_SETUP.md` | OCI 인증 정보 준비 및 DevContainer 연결 방식 |
| `docs/04_PULUMI_TYPESCRIPT_BASICS.md` | TypeScript 기반 Pulumi 프로젝트 시작법 |
| `docs/05_OCI_BASIC_EXAMPLE.md` | OCI VCN 생성 예제 |
| `docs/06_PULUMI_ANSIBLE_CLOUDINIT.md` | Pulumi, Ansible, cloud-init 역할 구분 |
| `docs/07_RECOMMENDED_LEARNING_PATH.md` | 추천 학습 순서 |
| `docs/08_PROJECT_STRUCTURE.md` | 개인 프로젝트에 적용하기 좋은 디렉토리 구조 |
| `docs/09_COMMAND_CHEATSHEET.md` | 자주 쓰는 명령어 모음 |

## 추천 읽는 순서

1. `00_OVERVIEW.md`
2. `01_CORE_CONCEPTS.md`
3. `02_WSL2_DEVCONTAINER_SETUP.md`
4. `03_OCI_AUTH_SETUP.md`
5. `04_PULUMI_TYPESCRIPT_BASICS.md`
6. `05_OCI_BASIC_EXAMPLE.md`
7. `06_PULUMI_ANSIBLE_CLOUDINIT.md`
8. `07_RECOMMENDED_LEARNING_PATH.md`
9. `08_PROJECT_STRUCTURE.md`
10. `09_COMMAND_CHEATSHEET.md`

## 권장 조합

```txt
개발 환경: WSL2 + DevContainer + Cursor
IaC: Pulumi TypeScript
Cloud: OCI
서버 내부 설정: cloud-init 또는 Ansible
앱: Next.js + NestJS
배포 자동화: GitHub Actions
State Backend: 처음에는 Pulumi Cloud 권장
```
