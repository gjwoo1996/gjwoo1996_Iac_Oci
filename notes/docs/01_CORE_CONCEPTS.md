# 01. Pulumi 핵심 개념

## 1. Pulumi Program

Pulumi Program은 인프라를 정의하는 코드입니다.

TypeScript 프로젝트라면 보통 다음 파일들이 있습니다.

```txt
infra/
  Pulumi.yaml
  Pulumi.dev.yaml
  package.json
  tsconfig.json
  index.ts
```

`index.ts`에 OCI 리소스를 코드로 정의합니다.

```ts
import * as oci from "@pulumi/oci";

const vcn = new oci.core.Vcn("app-vcn", {
  compartmentId: "ocid1.compartment...",
  cidrBlock: "10.0.0.0/16",
  displayName: "app-vcn",
  dnsLabel: "appvcn",
});
```

---

## 2. Provider

Provider는 Pulumi 코드와 실제 클라우드 API 사이를 연결하는 어댑터입니다.

```txt
Pulumi 코드
  ↓
OCI Provider
  ↓
OCI API
  ↓
실제 OCI 리소스 생성/수정/삭제
```

OCI를 사용하려면 TypeScript 기준으로 다음 패키지를 설치합니다.

```bash
npm install @pulumi/oci
```

---

## 3. Stack

Stack은 같은 Pulumi 코드를 환경별로 나누는 단위입니다.

예시:

```txt
dev      → 개발 환경
staging  → 테스트 환경
prod     → 운영 환경
```

명령어:

```bash
pulumi stack init dev
pulumi stack init prod
pulumi stack select dev
```

같은 `index.ts`를 사용하더라도 stack별로 다른 설정값을 사용할 수 있습니다.

예를 들어 `dev`는 작은 인스턴스, `prod`는 큰 인스턴스를 만들 수 있습니다.

---

## 4. State

State는 Pulumi가 현재 관리 중이라고 알고 있는 인프라 상태입니다.

예시:

```txt
app-vcn은 이미 생성되어 있음
app-subnet은 app-vcn 안에 있음
app-instance는 public IP를 가지고 있음
```

State가 있기 때문에 Pulumi는 다음 실행 때 변경점을 계산할 수 있습니다.

```txt
코드에서 새 subnet이 추가됨
→ subnet 생성 예정

코드에서 instance가 삭제됨
→ 실제 OCI instance 삭제 예정

코드에서 cidrBlock이 변경됨
→ 리소스 수정 또는 재생성 필요
```

---

## 5. Backend

Backend는 Pulumi state가 저장되는 위치입니다.

대표적인 backend:

```txt
- Pulumi Cloud
- Local file
- S3
- Azure Blob Storage
- Google Cloud Storage
- 기타 Object Storage
```

처음 학습할 때는 Pulumi Cloud가 가장 편합니다.

```bash
pulumi login
```

로컬에서만 실험하려면 다음도 가능합니다.

```bash
pulumi login --local
```

단, 로컬 backend는 state 파일 관리가 꼬일 수 있으므로 실전 프로젝트에서는 신중하게 사용해야 합니다.

---

## 6. Config와 Secret

Pulumi Config는 환경별 설정값을 저장합니다.

예시:

```bash
pulumi config set oci:region ap-seoul-1
pulumi config set compartmentOcid ocid1.compartment...
```

민감한 값은 secret으로 저장합니다.

```bash
pulumi config set --secret dbPassword "my-password"
```

코드에서는 이렇게 읽습니다.

```ts
import * as pulumi from "@pulumi/pulumi";

const config = new pulumi.Config();
const compartmentId = config.require("compartmentOcid");
```

---

## 7. Preview / Up / Destroy

Pulumi 기본 명령어는 세 가지가 핵심입니다.

```bash
pulumi preview
```

실제로 반영하기 전에 어떤 변경이 일어날지 미리 봅니다.

```bash
pulumi up
```

실제 클라우드에 변경사항을 반영합니다.

```bash
pulumi destroy
```

Pulumi가 관리하는 리소스를 삭제합니다.

학습할 때는 반드시 다음 흐름에 익숙해지는 것이 좋습니다.

```bash
pulumi preview
pulumi up
pulumi destroy
```

---

## 8. Input / Output 개념

Pulumi에서 리소스 생성 후에야 알 수 있는 값은 `Output<T>`로 표현됩니다.

예시:

```ts
export const vcnId = vcn.id;
```

`vcn.id`는 단순 문자열이 아니라 `Output<string>`입니다.

잘못된 예:

```ts
const id: string = vcn.id; // 타입 오류 가능
```

필요하면 `apply`를 사용합니다.

```ts
vcn.id.apply((id) => {
  console.log(`VCN ID: ${id}`);
});
```

초반에는 이렇게 기억하면 됩니다.

```txt
일반 값: 코드 실행 시점에 이미 아는 값
Output: 클라우드 리소스가 만들어진 뒤 알 수 있는 값
```
