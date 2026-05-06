# 06. Pulumi, Ansible, cloud-init 역할 구분

## 큰 그림

Pulumi, Ansible, cloud-init은 역할이 다릅니다.

```txt
Pulumi: 클라우드 인프라 생성/수정/삭제
cloud-init: 인스턴스 최초 부팅 시 초기 설정
Ansible: 이미 생성된 서버에 접속해서 반복 가능한 설정 관리
```

---

## Pulumi가 잘하는 것

```txt
- OCI VCN 생성
- Subnet 생성
- Internet Gateway 생성
- Route Table 생성
- Security List / NSG 생성
- Compute Instance 생성
- Public IP 연결
- Load Balancer 생성
- Object Storage 생성
- Container Registry 생성
```

즉, OCI 콘솔에서 클릭해서 만들던 것들을 코드로 관리하는 데 적합합니다.

---

## Ansible이 잘하는 것

```txt
- 서버에 SSH 접속
- Docker 설치
- Nginx 설치 및 설정
- Node.js 설치
- 디렉토리 생성
- 설정 파일 배치
- systemd 서비스 등록
- 패키지 업데이트
```

즉, 서버 내부 상태를 관리하는 데 적합합니다.

---

## cloud-init이 잘하는 것

cloud-init은 인스턴스가 처음 생성될 때 한 번 실행되는 초기화 스크립트에 적합합니다.

예시:

```txt
- apt update
- Docker 설치
- 기본 사용자 설정
- SSH key 설정
- 초기 디렉토리 생성
- Docker Compose 설치
```

단, cloud-init은 복잡한 반복 운영 관리에는 Ansible보다 불편할 수 있습니다.

---

## 추천 조합

개인 프로젝트 초기에는 다음 조합이 단순합니다.

```txt
Pulumi
→ OCI 네트워크와 인스턴스 생성

cloud-init
→ 인스턴스 최초 생성 시 Docker 설치

Docker Compose
→ 앱 실행

GitHub Actions
→ 이미지 빌드 및 배포 자동화
```

조금 더 복잡해지면 다음 구조가 좋습니다.

```txt
Pulumi
→ OCI 리소스 생성

Ansible
→ 서버 내부 구성 관리

GitHub Actions
→ Pulumi preview/up 및 앱 배포 자동화
```

---

## Ansible의 한계와 보완

Ansible은 기본적으로 “선언된 작업을 실행”하는 방식입니다.

예를 들어 Ansible로 `/docs/a/test.md` 파일을 만들었다가, playbook에서 해당 작업을 삭제해도 실제 서버의 파일이 자동으로 삭제되지는 않습니다.

삭제까지 원한다면 명시적으로 다음처럼 작성해야 합니다.

```yaml
- name: Remove old file
  file:
    path: /docs/a/test.md
    state: absent
```

반면 Pulumi는 state를 기반으로 관리하기 때문에, 코드에서 리소스를 제거하면 실제 클라우드 리소스 삭제 계획이 잡힙니다.

즉:

```txt
Pulumi: state 기반 리소스 생명주기 관리에 강함
Ansible: 서버 내부 설정 작업 자동화에 강함
```

---

## 실전 기준 판단법

| 작업 | 추천 도구 |
|---|---|
| VCN 생성 | Pulumi |
| Subnet 생성 | Pulumi |
| Compute Instance 생성 | Pulumi |
| Docker 설치 | cloud-init 또는 Ansible |
| Nginx 설정 | Ansible |
| 앱 컨테이너 실행 | Docker Compose |
| 배포 자동화 | GitHub Actions |
| 서버 내부 파일 삭제/정리 | Ansible |
| 인프라 삭제 | Pulumi destroy |
