# 03. OCI 인증 정보 준비

## Pulumi가 OCI에 접근하려면 필요한 정보

Pulumi가 OCI 리소스를 생성하려면 OCI API 인증 정보가 필요합니다.

보통 필요한 값은 다음과 같습니다.

```txt
tenancy_ocid
user_ocid
fingerprint
private_key_path
region
compartment_ocid
```

---

## 일반적인 OCI 설정 파일 위치

OCI CLI를 설정하면 보통 다음 파일들이 생깁니다.

```txt
~/.oci/config
~/.oci/oci_api_key.pem
```

예시 구조:

```txt
/home/gunwoo/.oci/
  config
  oci_api_key.pem
  oci_api_key_public.pem
```

---

## ~/.oci/config 예시

```ini
[DEFAULT]
user=ocid1.user.oc1..aaaa...
fingerprint=aa:bb:cc:dd:...
tenancy=ocid1.tenancy.oc1..aaaa...
region=ap-seoul-1
key_file=/home/vscode/.oci/oci_api_key.pem
```

DevContainer 안에서 사용할 경우 `key_file` 경로는 컨테이너 내부 경로 기준이어야 합니다.

예를 들어 mount target이 `/home/vscode/.oci`라면 다음처럼 작성합니다.

```ini
key_file=/home/vscode/.oci/oci_api_key.pem
```

---

## 방식 1. WSL2의 ~/.oci를 DevContainer에 mount

`.devcontainer/devcontainer.json`

```json
{
  "mounts": [
    "source=${localEnv:HOME}/.oci,target=/home/vscode/.oci,type=bind,consistency=cached"
  ]
}
```

컨테이너 안에서 확인합니다.

```bash
ls -al ~/.oci
cat ~/.oci/config
```

private key 권한도 확인합니다.

```bash
chmod 600 ~/.oci/oci_api_key.pem
```

---

## 방식 2. 환경변수로 설정

컨테이너 안에서 다음과 같이 환경변수를 설정할 수도 있습니다.

```bash
export OCI_REGION=ap-seoul-1
export OCI_TENANCY_OCID=ocid1.tenancy...
export OCI_USER_OCID=ocid1.user...
export OCI_FINGERPRINT=aa:bb:cc:dd:...
export OCI_PRIVATE_KEY_PATH=/home/vscode/.oci/oci_api_key.pem
```

다만 민감정보가 shell history나 Git에 남지 않도록 주의해야 합니다.

---

## Pulumi config에 저장할 값

지역 설정:

```bash
pulumi config set oci:region ap-seoul-1
```

Compartment OCID:

```bash
pulumi config set compartmentOcid ocid1.compartment...
```

민감한 값은 secret으로 저장합니다.

```bash
pulumi config set --secret dbPassword "my-password"
```

---

## Git에 올리면 안 되는 파일

`.gitignore`에 다음을 추가하는 것을 권장합니다.

```gitignore
.env
*.pem
.oci/
```

Pulumi 설정 파일은 보통 Git에 올릴 수 있지만, secret 관리 방식을 정한 뒤 올리는 것이 안전합니다.

```txt
Pulumi.yaml
Pulumi.dev.yaml
```
