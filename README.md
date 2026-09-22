# 전자정부 표준프레임워크 모바일 Device API

[![eGovFrame](https://img.shields.io/badge/eGovFrame-5.0.0-134F8C?labelColor=white&logo=data:image/svg%2Bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxNzMuMjgyIDE3My4yODIiPjxwYXRoIGZpbGw9IiNmZmYiIGQ9Ik0xNzMuMjgyIDg2LjY1YzAgNDcuODQ0LTM4Ljc5NCA4Ni42MzItODYuNjQ2IDg2LjYzMkMzOC43OTkgMTczLjI4MiAwIDEzNC40OTQgMCA4Ni42NSAwIDM4Ljc4OCAzOC43OTkgMCA4Ni42MzYgMGM0Ny44NTIgMCA4Ni42NDYgMzguNzg4IDg2LjY0NiA4Ni42NSIvPjxwYXRoIGZpbGw9IiMwMDM3NjQiIGQ9Ik0xMjcuMzg5IDgwLjU5OGMtMTMuNzkxLTkuMzY1LTMxLjQzOS01LjU0Mi00MC43MTcgOC41MzMtNy43MiAxMS43NjctMTkuNDA1IDEzLjIzNS0yMy45MDYgMTMuMjM1LTE0Ljc1MSAwLTI0LjgyNC0xMC4zNjctMjcuODE4LTIxLjA5NWgtLjAxYy0uMDM5LS4xMDgtLjA1OS0uMi0uMDktLjMwNy0uMDI1LS4xMi0uMDU2LS4yMzMtLjA4OS0uMzY2LTEuMTc3LTQuNDY3LTEuNDY3LTYuNjA5LTEuNDY3LTExLjM2OCAwLTI1LjY1IDI2LjMyMS01NC4yMTMgNjQuMjE1LTU0LjIxMyAzOC44MjkgMCA2MS4wNSAyOS41NDUgNjYuNzggNDUuOTc5LS4xMDctLjI5NS0uMjA5LS41ODEtLjI5MS0uODc3LTExLjAxNS0zMi4xMjUtNDEuNDc0LTU1LjIxNi03Ny4zNTctNTUuMjE2LTQ1LjEzIDAtODEuNzI5IDM2LjU5LTgxLjcyOSA4MS43MzkgMCA0MC4zNTEgMjkuMTA4IDc0Ljg5MSA2OS40NzkgNzQuODkxIDMyLjE5NyAwIDUzLjg0Mi0xOC4wNTIgNjMuNzU3LTQyLjkzIDUuNDUtMTMuNjE0IDEuNTk1LTI5LjYwNS0xMC43NTctMzguMDA1Ii8%2BPHBhdGggZmlsbD0iI2U0MDMyZSIgZD0iTTE2NC43ODggNjIuNTg5Yy00Ljc3Ny0xNi4wMjYtMjcuMTUzLTQ3LjU3MS02Ny4yODItNDcuNTcxLTM3Ljg5NCAwLTY0LjIxNCAyOC41NjMtNjQuMjE0IDU0LjIxMiAwIDQuNzU5LjI5IDYuOTAxIDEuNDY2IDExLjM2OC0uNDg5LTEuOTUxLS43NC0zLjkwOC0uNzQtNS44MjMgMC0yNi43MjEgMjYuNzQxLTQ1LjIyNyA1NC4yNDgtNDUuMjI3IDM3LjIxOCAwIDY3LjM4OCAzMC4xNzQgNjcuMzg4IDY3LjM5IDAgMjkuMTczLTE2Ljc4NSA1NC40MzctNDEuMTc5IDY2LjU2NXYuMDIzYzMxLjQ1NS0xMS4zOTEgNTMuOTA4LTQxLjUxMiA1My45MDgtNzYuODg0IDAtOC4zNzgtMS4xMjctMTUuNzU5LTMuNTk1LTI0LjA1MyIvPjwvc3ZnPg%3D%3D)](https://www.egovframe.go.kr)
[![Java](https://img.shields.io/badge/Java-17-007396?logo=openjdk&logoColor=white)](https://openjdk.org/)
[![Docker](https://img.shields.io/badge/Docker-28.0.4-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Ollama](https://img.shields.io/badge/Ollama-0.16.0-000000?logo=ollama&logoColor=white)](https://ollama.com/)
[![Maven](https://img.shields.io/badge/Maven-3.9.9-C71A36?logo=apachemaven&logoColor=white)](https://maven.apache.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.6-6DB33F?logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)

표준프레임워크 기반 모바일 Device API의 WEB 서버와 Flutter 기반 App 샘플을 함께 제공하는 프로젝트입니다.

## 프로젝트 소개

이 Repository에서는 아래 2개 프로젝트로 구성됩니다. 
각 프로젝트의 실행/설정 방법은 내부 `README.md`를 참고하세요.

## 공통 환경

| 항목 | 버전 |
| :--- | :--- |
| JDK | 17 |
| Spring Boot | 3.5.6 |
| Maven | 3.9.9 |
| Ollama | 0.16.0 |
| Docker | 28.0.4 |

## 프로젝트 구성

| 프로젝트 | 역할 | 가이드 |
| :--- | :--- | :--- |
| `device-api-web` | Device API WEB 서버(Spring Boot) | [README](./device-api-app/docs/webserver.md) |
| `device-api-app` | Device API App 샘플(Flutter) | [README](./device-api-app/docs) |

## 프로젝트 시작 방법
- Device API App
	- [1.환경설정 구성 방법](./device-api-app/docs/settings.md)
	- [2.애뮬레이터 구성 방법](./device-api-app/docs/emulator.md)
	- [3.프로젝트 시작 방법](./device-api-app/docs/project_start.md)
	
- Device API Web


## 패치
### 2026/06/26 v5.0.1 배포
- gps, accelerator app에서 제공하던 '목록 삭제'를 상세 화면에서만 삭제할 수 있도록 위젯 및 레이아웃이 변경되었습니다.
- READ, UPDATE, DELETE 시 기기의 uuid를 검증하는 로직이 추가되었습니다.
	- A 디바이스에서 서버에 전송한 값을 B 디바이스에서 읽기,쓰기,삭제 불가
	- CREATE를 진행한 디바이스의 데이터만 READ, UPDATE, DELETE 가능
	- File Opener 에서 UUID 검증할 수 있도록 DB column 추가 (DDL 수정)
- UUID 생성 방식이 UUIDv4 방식으로 변경되었습니다.
	- lib/core/device_id_service.dart
	- application 삭제 전 까지 동일한 uuid를 사용할 수 있습니다. (삭제 시 uuid도 초기화)
	- docs/applications/utils.md 에서 uuid 관련 항목 참조
	
### 2026/07/01 v5.0.2 배포
- Interface APP에서 평문 비밀번호 전송 방지와 Validation 로직이 추가되었습니다.
	- 비밀번호 평문 전송 제거
	- SHA-256(userId‖password) Base64 해시값 전송·저장 (flutter_secure_storage)
	- 서버 조회 응답에서 userPw 제외, @Valid 입력 검증 추가.
- 파일 다운로드 시 uuid + fileSn 소유권 검증 추가
- 파일 업로드/다운로드 시 uuid 검증 로직이 추가되었습니다.
	- 파일 업로드 시 서버에서 uuid·fileSn 자동 등록
	- 타 기기 fileSn 임의 연결 차단
- Secure Storage 실패 시 unknown_device 폴백 제거
- print()로 출력되던 로그 및 민감정보 로그가 정리되고 Applogger를 통해 debug 모드에서만 로그가 출력됩니다.
- 미사용중인 WebSocket 샘플 모듈이 제거되었으며 차후 버전에서 고도화 될 예정입니다.

## 기타
- GPS Application 사용을 위해서는 Google MAP API Key 발급이 필요합니다
	- - [Google Map API Key 발급 방법](./device-api-app/docs/aaplications/gps.md#Google Maps API 키 설정)
	
- 로컬 환경이 아닌 환경에서 개발 및 배포하는 경우 아래 네트워크 환경에 대한 설정이 추가적으로 필요합니다.
아래 가이드를 참조하여 설정을 진행하시기 바랍니다.
[README](./device-api-app/docs/project_start.md#2) 로컬 Web서버가 아닌 다른 서버를 이용하는 경우)