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
`src/main/resources/application.properties`
- DB 설정 변경 (Globals.URL / UserName / Password 등)
- 파일 업로드 경로 변경 (Globals.fileStorePath)</br>
    *파일 업로드/다운로드 테스트 시 사용되는 경로

## 3. 서버 실행
- Boot DashBoard 실행</br>
    *상단에 Boot DashBoard 아이콘 클릭 또는 Window > Show View > Others > Boot DashBoard
- 서버 실행



## 연관 가이드

- [Flutter 설치가이드](/settings.md)
- [Android Studio Emulator 설치 및 설정](/emulator.md)
- [프로젝트 시작하기](/project_start.md)