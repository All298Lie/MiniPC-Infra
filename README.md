# 미니PC 홈 서버 (MiniPC-Infra)

개인 미니 PC 환경에서 운영 중인 다양한 서비스의 도커(Docker) 컨테이너를 관리하기 위한 인프라 전용 레포지토리

## 기술 스택
### 운영체제
<p>
  <img src="https://img.shields.io/badge/linux-FCC624?style=for-the-badge&logo=linux&logoColor=black">
  <img src="https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white">
</p>

### 서버 인프
<p>
  <img src="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white">
  <img src="https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=Docker&logoColor=white">
</p>

### 데이터베이스
<p>
  <img src="https://img.shields.io/badge/mariaDB-003545?style=for-the-badge&logo=mariaDB&logoColor=white">
</p>

### 어플리케이션
<p>
  <img src="https://img.shields.io/badge/node.js-339933?style=for-the-badge&logo=Node.js&logoColor=white">
  <img src="https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white">
</p>

---

## 아키텍처 및 디렉토리 구조

이 레포지토리는 각 서비스가 독립적인 환경에서 실행될 수 있도록 서비스별 디렉토리로 격리 처리

```text
MiniPC-Infra/
 ├── discord-bot/          # 디스코드 봇 구동 환경
 │   ├── docker-compose.yml
 │   ├── .env              (Git ignored)
 │   └── db_data/          (Git ignored, MariaDB Volume)
 │
 └── immich-app/           # 개인용 사진 백업 서버 (추후 통합 예정)
```

## 사용 중인 서비스
1. Discord-Lie-bot (디스코드 봇)
- 기능 : 주사위, 팀나누기 등의 유틸 및 출석, 강화, 랭킹 등의 경제 시스템 기반 명령어
- 환경 : Node.js 컨테이너 + MariaDB 컨테이너
- 특징 : `Dockerfile`을 통해 이미지 빌드 및 인프라 `docker-compose.yml`을 활용한 컨테이너 관리

## 엔지니어링 & 트러블슈팅 경험
1. 애플리케이션 코드와 인프라 코드 분리
   - 배경 : 초기에는 봇 소스코드 레포지토리 내부에 DB데이터와 인프라 설정이 혼재되어 있어, 관리가 어렵고 보안 위험이 존재
   - 해결 : 인프라 전용 레포지토리를 별도로 구축하고, `docker-compose.yml`의 `build context` 경로를 조정하여 소스코드 레포지토리를 참조하도록 설계
2. Docker 볼륨 마운트 권한 문제 해결
   - 배경 : 기존 봇 디렉토리에서 DB 볼륨(db_data)을 새로운 인프라 디렉토리로 이동하는 과정에서 permission Denied 에러 발생
   - 원인 : 도커 컨테이너 내부의 MariaDB가 `root` 권한으로 파일을 생성하여 디렉토리 제어 권한이 없었음
   - 해결 : `sudo` 명령어를 통해 디렉토리를 안전하게 이동시키고, 컨테이너를 재빌드하여 데이터 유실 없이 인프라 이관 완료
