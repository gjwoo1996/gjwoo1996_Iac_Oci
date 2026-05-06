# 05. OCI 기본 예제: VCN 생성

## 목표

가장 먼저 OCI에 VCN 하나를 생성하는 예제를 작성합니다.

VCN은 OCI 네트워크의 기본 단위입니다.

---

## 사전 준비

`infra/` 디렉토리에서 다음이 완료되어 있어야 합니다.

```bash
pulumi new typescript
npm install @pulumi/oci
pulumi stack init dev
pulumi config set oci:region ap-seoul-1
pulumi config set compartmentOcid ocid1.compartment...
```

---

## index.ts

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

## preview

```bash
pulumi preview
```

이 명령은 실제로 OCI에 생성하지 않고, 어떤 리소스가 생성될지 미리 보여줍니다.

---

## up

```bash
pulumi up
```

확인 메시지가 나오면 `yes`를 입력합니다.

---

## output 확인

```bash
pulumi stack output
```

예상 출력:

```txt
Current stack outputs:
    OUTPUT  VALUE
    vcnId   ocid1.vcn.oc1.ap-seoul-1....
```

---

## destroy

학습용으로 생성한 리소스는 반드시 삭제 연습까지 하는 것이 좋습니다.

```bash
pulumi destroy
```

---

## 다음 단계

VCN 다음에는 보통 아래 순서로 확장합니다.

```txt
1. Subnet
2. Internet Gateway
3. Route Table
4. Security List 또는 NSG
5. Compute Instance
6. Public IP
7. cloud-init 또는 Ansible 연동
8. Docker 설치
9. 앱 배포
```
