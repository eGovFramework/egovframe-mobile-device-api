# DeviceAPI 연동 WebServer 기동
Spring Boot로 생성된 DeviceAPI Applicaiton과 RestAPI 통신을 하는 서버</br>

## 0. DB 연결
- Mobile용 DB 연결 필요
- 프로젝트 내 Script > DDL 확인
- 개발환경에서 DataSource Explorer 에 DB Connection 등록 시 방법2에서 테이블 자동생성 가능

## 1. 프로젝트 생성
### 방법 1) 포탈에서 다운로드
표준프레임워크 포탈 > 다운로드 > 모바일 > 디바이스 API (Server) > 모바일 디바이스 API 5.0.0 배포 파일</br>
*개발환경에서 실행

### 방법 2) 표준프레임워크 개발환경에서 생성
- 표준프레임워크 개발환경(eclipse) > eGovFrame > Start > New DeviceAPI Web Project

## 2. 설정 변경
설정은 `src/main/resources/application.properties` 하나입니다. 기본값은 로컬 실행이고, DEV/운영에서 바꿀 항목은 `[DEV/운영]` 주석으로 표시되어 있습니다.

- 호스트는 `local.host` 하나. DB, 서버 주소, RAG, MQTT가 이 값을 사용합니다.
- 허용 확장자 `ai-rag.allowedFileExtensions`, 업로드 한도(`spring.servlet.multipart.maxFileSize`와 `maxRequestSize`는 각 30MB), 서버 포트 기본값 `9700`이 이 파일에 있습니다.
- 브라우저 채팅 출처는 `app.websocket.allowed-origins`입니다. 로컬 값은 `http://localhost:9700,http://127.0.0.1:9700`이고, DEV/운영은 `https://운영도메인:9700`으로 바꿉니다.
- 채팅 동시 접속 상한은 `app.websocket.max-sessions`이며 기본값은 50입니다.

실행 방법과 앱 주소 인자는 [local과 운영 실행](/run_profiles.md)을 따릅니다.  
AI 채팅 3단 구조는 저장소 루트 [docs/3tier-architecture-guide.md](../../docs/3tier-architecture-guide.md) 를 보면 됩니다.

## 3. 서버 실행
- Boot DashBoard 실행</br>
    *상단에 Boot DashBoard 아이콘 클릭 또는 Window > Show View > Others > Boot DashBoard
- 서버 실행



## 연관 가이드

- [Flutter 설치가이드](/settings.md)
- [Android Studio Emulator 설치 및 설정](/emulator.md)
- [프로젝트 시작하기](/project_start.md)
- [local과 운영 실행](/run_profiles.md)