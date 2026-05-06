# 04. TypeScript 기반 Pulumi 기초 사용법

## 프로젝트 생성

```bash
mkdir infra
cd infra
pulumi new typescript
```

생성되는 기본 구조:

```txt
infra/
  Pulumi.yaml
  Pulumi.dev.yaml
  index.ts
  package.json
  tsconfig.json
```

---

## OCI Provider 설치

```bash
npm install @pulumi/oci
```

---

## Stack 생성

```bash
pulumi stack init dev
```

이미 만든 stack을 선택하려면:

```bash
pulumi stack select dev
```

현재 stack 확인:

```bash
pulumi stack
```

---

## Config 설정

OCI region 설정:

```bash
pulumi config set oci:region ap-seoul-1
```

Compartment OCID 설정:

```bash
pulumi config set compartmentOcid ocid1.compartment...
```

설정 확인:

```bash
pulumi config
```

---

## 기본 코드 구조

`index.ts`

```ts
import * as pulumi from "@pulumi/pulumi";
import * as oci from "@pulumi/oci";

const config = new pulumi.Config();
const compartmentId = config.require("compartmentOcid");

const vcn = new oci.core.Vcn("app-vcn", {
  compartmentId,
  cidrBlock: "10.0.0.0/16",
  displayName: "app-vcn",
  dnsLabel: "appvcn",
});

export const vcnId = vcn.id;
```

---

## 실행 흐름

변경 예정 내용 확인:

```bash
pulumi preview
```

실제 반영:

```bash
pulumi up
```

삭제:

```bash
pulumi destroy
```

---

## Output 출력

Pulumi 리소스의 ID나 IP 같은 값은 export할 수 있습니다.

```ts
export const vcnId = vcn.id;
```

실행 후 출력값을 확인할 수 있습니다.

```bash
pulumi stack output
```

특정 output만 확인:

```bash
pulumi stack output vcnId
```

---

## 자주 헷갈리는 Output 개념

다음 코드는 일반 문자열처럼 보이지만 실제로는 `Output<string>`입니다.

```ts
const vcnId = vcn.id;
```

클라우드에 실제 리소스가 만들어진 뒤 알 수 있는 값이기 때문입니다.

필요할 때는 `apply`를 사용합니다.

```ts
vcn.id.apply((id) => {
  console.log(id);
});
```

하지만 대부분의 경우 다른 Pulumi 리소스의 입력값으로는 그냥 넘기면 됩니다.

```ts
const subnet = new oci.core.Subnet("app-subnet", {
  compartmentId,
  vcnId: vcn.id,
  cidrBlock: "10.0.1.0/24",
  displayName: "app-subnet",
  dnsLabel: "appsubnet",
});
```
