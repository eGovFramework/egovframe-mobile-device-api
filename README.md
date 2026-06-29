# 전자정부 표준프레임워크 모바일 Device API

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
- UUID 생성 방식이 UUIDv4 방식으로 변경되어 16자리 수로 표현됩니다.
	- lib/core/device_id_service.dart
	- application 삭제 전 까지 동일한 uuid를 사용할 수 있습니다. (삭제 시 uuid도 초기화)
	- docs/applications/utils.md 에서 uuid 관련 항목 참조

## 기타
- GPS Application 사용을 위해서는 Google MAP API Key 발급이 필요합니다
	- - [Google Map API Key 발급 방법](./device-api-app/docs/aaplications/gps.md#Google Maps API 키 설정)
	
- 로컬 환경이 아닌 환경에서 개발 및 배포하는 경우 아래 네트워크 환경에 대한 설정이 추가적으로 필요합니다.
아래 가이드를 참조하여 설정을 진행하시기 바랍니다.
[README](./device-api-app/docs/project_start.md#2) 로컬 Web서버가 아닌 다른 서버를 이용하는 경우)