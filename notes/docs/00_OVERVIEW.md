# 00. Pulumi 개요

## Pulumi란?

Pulumi는 클라우드 인프라를 TypeScript, Python, Go, C#, Java 같은 일반 프로그래밍 언어로 관리할 수 있게 해주는 IaC(Infrastructure as Code) 도구입니다.

Terraform이 HCL이라는 전용 문법을 사용한다면, Pulumi는 개발자가 이미 익숙한 언어를 사용합니다.

예를 들어 TypeScript로 OCI VCN을 만든다면 다음과 같은 코드가 됩니다.

```ts
import * as oci from "@pulumi/oci";

const vcn = new oci.core.Vcn("app-vcn", {
  compartmentId: "ocid1.compartment...",
  cidrBlock: "10.0.0.0/16",
  displayName: "app-vcn",
  dnsLabel: "appvcn",
});
```

이 코드는 OCI 콘솔에서 직접 클릭해서 VCN을 만드는 행위를 코드로 표현한 것입니다.

---

## Pulumi로 관리하기 좋은 영역

Pulumi는 보통 클라우드의 상위 인프라 리소스를 관리합니다.

예시:

```txt
- VCN
- Subnet
- Internet Gateway
- Route Table
- Security List / NSG
- Compute Instance
- Load Balancer
- Object Storage Bucket
- Container Registry
- Kubernetes Cluster
- IAM 관련 리소스
```

즉, OCI 콘솔에서 만들던 클라우드 리소스를 코드화하는 용도입니다.

---

## Pulumi가 덜 자연스러운 영역

Pulumi로 서버 내부 명령을 실행할 수도 있지만, 다음 작업은 보통 Ansible, cloud-init, Docker Compose, GitHub Actions 등과 나누는 편이 좋습니다.

```txt
- 인스턴스 내부에 Docker 설치
- Nginx 설정
- Node.js 설치
- systemd 서비스 등록
- 앱 파일 배포
- 로그 디렉토리 생성
- 서버 내부 패키지 업데이트
```

추천 흐름은 다음과 같습니다.

```txt
Pulumi로 OCI 인프라 생성
→ cloud-init 또는 Ansible로 서버 내부 초기 설정
→ Docker Compose로 앱 실행
→ GitHub Actions로 배포 자동화
```

---

## Terraform과의 감각적 차이

| 구분 | Terraform | Pulumi |
|---|---|---|
| 언어 | HCL | TypeScript, Python, Go 등 |
| 코드 스타일 | 선언형 설정 파일 | 일반 프로그래밍 언어 |
| 조건문/반복문 | 제한적 | 언어 기능 그대로 사용 |
| 개발자 친화성 | DevOps 친화 | 애플리케이션 개발자 친화 |
| 생태계 | 매우 큼 | 빠르게 성장 중 |

당신처럼 NestJS, Next.js, TypeScript에 익숙하다면 Pulumi TypeScript가 진입장벽이 낮습니다.
