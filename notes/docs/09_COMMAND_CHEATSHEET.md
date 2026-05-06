# 09. Pulumi 명령어 치트시트

## Pulumi 로그인

```bash
pulumi login
```

로컬 backend 사용:

```bash
pulumi login --local
```

---

## 프로젝트 생성

```bash
mkdir infra
cd infra
pulumi new typescript
```

---

## Provider 설치

OCI Provider:

```bash
npm install @pulumi/oci
```

---

## Stack 관리

Stack 생성:

```bash
pulumi stack init dev
```

Stack 목록:

```bash
pulumi stack ls
```

Stack 선택:

```bash
pulumi stack select dev
```

현재 stack 확인:

```bash
pulumi stack
```

---

## Config 관리

Config 설정:

```bash
pulumi config set oci:region ap-seoul-1
pulumi config set compartmentOcid ocid1.compartment...
```

Secret 설정:

```bash
pulumi config set --secret dbPassword "my-password"
```

Config 확인:

```bash
pulumi config
```

특정 config 확인:

```bash
pulumi config get compartmentOcid
```

---

## Preview / Up / Destroy

변경 예정 확인:

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

## Output 확인

전체 output 확인:

```bash
pulumi stack output
```

특정 output 확인:

```bash
pulumi stack output vcnId
```

---

## State 동기화

실제 클라우드 상태와 Pulumi state를 다시 맞추고 싶을 때:

```bash
pulumi refresh
```

---

## DevContainer 안에서 확인할 것

Pulumi CLI:

```bash
pulumi version
```

Node.js:

```bash
node -v
npm -v
```

OCI 설정 파일:

```bash
ls -al ~/.oci
cat ~/.oci/config
```

Private key 권한:

```bash
chmod 600 ~/.oci/oci_api_key.pem
```

---

## 자주 쓰는 전체 흐름

```bash
cd infra
pulumi stack select dev
pulumi config
pulumi preview
pulumi up
pulumi stack output
```

학습용 삭제:

```bash
pulumi destroy
```
