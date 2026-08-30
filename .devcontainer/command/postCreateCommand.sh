SCRIPT_DIR="$(dirname "$0")"       # 현재 스크립트가 위치한 디렉토리
PARENT_DIR="$(dirname "$SCRIPT_DIR")"  # 스크립트의 상위 디렉토리

ENV_FILE="$PARENT_DIR/.env"  # 한 단계 상위 폴더에 있는 .env 파일 지정
source "$ENV_FILE"

# SSH 키 권한 설정
chmod 600 $containerWorkspaceFolder/ssh_keys/oci-main-instance.key

# JSON 변환 스크립트 실행 가능하게 변경 및 실행
chmod +x $containerWorkspaceFolder/.devcontainer/command/convert_json_to_env.sh
bash $containerWorkspaceFolder/.devcontainer/command/convert_json_to_env.sh
