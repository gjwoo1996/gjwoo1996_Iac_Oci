# 07. 추천 학습 순서

## 1단계. Pulumi CLI 설치

DevContainer 안에서 Pulumi CLI가 동작하는지 확인합니다.

```bash
pulumi version
```

---

## 2단계. TypeScript 프로젝트 생성

```bash
mkdir infra
cd infra
pulumi new typescript
```

---

## 3단계. Stack 개념 이해

```bash
pulumi stack init dev
pulumi stack ls
pulumi stack select dev
```

Stack은 `dev`, `staging`, `prod` 같은 환경 분리에 사용합니다.

---

## 4단계. Config / Secret 이해

```bash
pulumi config set oci:region ap-seoul-1
pulumi config set compartmentOcid ocid1.compartment...
pulumi config set --secret dbPassword "my-password"
```

---

## 5단계. OCI 인증 연결

DevContainer 안에서 다음을 확인합니다.

```bash
ls -al ~/.oci
cat ~/.oci/config
```

private key 권한도 확인합니다.

```bash
chmod 600 ~/.oci/oci_api_key.pem
```

---

## 6단계. VCN 하나 생성

처음에는 VCN 하나만 만듭니다.

```bash
pulumi preview
pulumi up
pulumi stack output
pulumi destroy
```

---

## 7단계. 네트워크 확장

VCN 다음에는 아래 순서로 확장합니다.

```txt
1. Subnet
2. Internet Gateway
3. Route Table
4. Security List 또는 NSG
```

---

## 8단계. Compute Instance 생성

네트워크가 준비되면 Compute Instance를 생성합니다.

이 단계에서 필요한 개념:

```txt
- Image OCID
- Shape
- Availability Domain
- SSH public key
- Subnet 연결
- Public IP 할당
```

---

## 9단계. 서버 내부 초기 설정

처음에는 cloud-init으로 간단히 Docker를 설치할 수 있습니다.

복잡해지면 Ansible로 분리합니다.

```txt
Pulumi: 인스턴스 생성
cloud-init: 최초 Docker 설치
Ansible: 반복적인 서버 내부 설정 관리
```

---

## 10단계. 앱 배포

개인 프로젝트 기준 추천 흐름:

```txt
1. Next.js / NestJS 앱 작성
2. Dockerfile 작성
3. docker-compose.yml 작성
4. OCI Instance에서 Docker Compose 실행
5. GitHub Actions로 배포 자동화
```

---

## 11단계. GitHub Actions 연동

나중에는 GitHub Actions에서 다음 작업을 자동화할 수 있습니다.

```txt
- pulumi preview
- pulumi up
- Docker image build
- Container Registry push
- 서버 배포
```

초반에는 로컬 DevContainer에서 Pulumi를 충분히 익힌 뒤 CI/CD로 옮기는 것을 추천합니다.
