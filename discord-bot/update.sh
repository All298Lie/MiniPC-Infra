#!/bin/bash

export $(grep -v '^#' .env | xargs)

echo "🔄 1. GitHub에서 최신 코드를 가져옵니다..."
git pull

echo "📝 패치 노트를 작성하시겠습니까? (y/n)"
read -p "선택: " DO_NOTE

if [ "$DO_NOTE" == "y" ]; then
    echo "패치 내용을 입력하세요 (엔터 치면 저장):"
    read -p "내용: " NOTE_CONTENT

    echo "💾 DB에 패치 내용을 예약합니다..."
    # 도커 내부의 MariaDB에 접속해서 SQL 실행
    docker exec discord-db mariadb -u$DB_USER -p$DB_USER_PASSWORD $DB_DATABASE -e "INSERT INTO system_settings (setting_key, setting_value) VALUES ('patch_note', '$NOTE_CONTENT') ON DUPLICATE KEY UPDATE setting_value='$NOTE_CONTENT';"
fi

echo "🐳 2. 도커 이미지를 새로 빌드하고 재시작합니다..."
docker compose up -d --build

echo "🧹 3. 사용하지 않는 구버전 이미지를 청소합니다..."
docker image prune -f

echo "✅ 업데이트 완료! 봇이 최신 버전으로 실행 중입니다."
