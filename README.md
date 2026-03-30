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


## 기타
- GPS Application 사용을 위해서는 Google MAP API Key 발급이 필요합니다
	- - [Google Map API Key 발급 방법](./device-api-app/docs/aaplications/gps.md#Google Maps API 키 설정)
	
- 로컬 환경이 아닌 환경에서 개발 및 배포하는 경우 아래 네트워크 환경에 대한 설정이 추가적으로 필요합니다.
아래 가이드를 참조하여 설정을 진행하시기 바랍니다.
[README](./device-api-app/docs/project_start.md#2) 로컬 Web서버가 아닌 다른 서버를 이용하는 경우)