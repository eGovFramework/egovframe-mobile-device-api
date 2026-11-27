# 전자정부 표준프레임워크 모바일 Device API

[![eGovFrame](https://img.shields.io/badge/eGovFrame-5.1.0-134F8C?labelColor=white&logo=data:image/svg%2Bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxNzMuMjgyIDE3My4yODIiPjxwYXRoIGZpbGw9IiNmZmYiIGQ9Ik0xNzMuMjgyIDg2LjY1YzAgNDcuODQ0LTM4Ljc5NCA4Ni42MzItODYuNjQ2IDg2LjYzMkMzOC43OTkgMTczLjI4MiAwIDEzNC40OTQgMCA4Ni42NSAwIDM4Ljc4OCAzOC43OTkgMCA4Ni42MzYgMGM0Ny44NTIgMCA4Ni42NDYgMzguNzg4IDg2LjY0NiA4Ni42NSIvPjxwYXRoIGZpbGw9IiMwMDM3NjQiIGQ9Ik0xMjcuMzg5IDgwLjU5OGMtMTMuNzkxLTkuMzY1LTMxLjQzOS01LjU0Mi00MC43MTcgOC41MzMtNy43MiAxMS43NjctMTkuNDA1IDEzLjIzNS0yMy45MDYgMTMuMjM1LTE0Ljc1MSAwLTI0LjgyNC0xMC4zNjctMjcuODE4LTIxLjA5NWgtLjAxYy0uMDM5LS4xMDgtLjA1OS0uMi0uMDktLjMwNy0uMDI1LS4xMi0uMDU2LS4yMzMtLjA4OS0uMzY2LTEuMTc3LTQuNDY3LTEuNDY3LTYuNjA5LTEuNDY3LTExLjM2OCAwLTI1LjY1IDI2LjMyMS01NC4yMTMgNjQuMjE1LTU0LjIxMyAzOC44MjkgMCA2MS4wNSAyOS41NDUgNjYuNzggNDUuOTc5LS4xMDctLjI5NS0uMjA5LS41ODEtLjI5MS0uODc3LTExLjAxNS0zMi4xMjUtNDEuNDc0LTU1LjIxNi03Ny4zNTctNTUuMjE2LTQ1LjEzIDAtODEuNzI5IDM2LjU5LTgxLjcyOSA4MS43MzkgMCA0MC4zNTEgMjkuMTA4IDc0Ljg5MSA2OS40NzkgNzQuODkxIDMyLjE5NyAwIDUzLjg0Mi0xOC4wNTIgNjMuNzU3LTQyLjkzIDUuNDUtMTMuNjE0IDEuNTk1LTI5LjYwNS0xMC43NTctMzguMDA1Ii8%2BPHBhdGggZmlsbD0iI2U0MDMyZSIgZD0iTTE2NC43ODggNjIuNTg5Yy00Ljc3Ny0xNi4wMjYtMjcuMTUzLTQ3LjU3MS02Ny4yODItNDcuNTcxLTM3Ljg5NCAwLTY0LjIxNCAyOC41NjMtNjQuMjE0IDU0LjIxMiAwIDQuNzU5LjI5IDYuOTAxIDEuNDY2IDExLjM2OC0uNDg5LTEuOTUxLS43NC0zLjkwOC0uNzQtNS44MjMgMC0yNi43MjEgMjYuNzQxLTQ1LjIyNyA1NC4yNDgtNDUuMjI3IDM3LjIxOCAwIDY3LjM4OCAzMC4xNzQgNjcuMzg4IDY3LjM5IDAgMjkuMTczLTE2Ljc4NSA1NC40MzctNDEuMTc5IDY2LjU2NXYuMDIzYzMxLjQ1NS0xMS4zOTEgNTMuOTA4LTQxLjUxMiA1My45MDgtNzYuODg0IDAtOC4zNzgtMS4xMjctMTUuNzU5LTMuNTk1LTI0LjA1MyIvPjwvc3ZnPg%3D%3D)](https://www.egovframe.go.kr)
[![Java](https://img.shields.io/badge/Java-17-007396?logo=openjdk&logoColor=white)](https://openjdk.org/)
[![Maven](https://img.shields.io/badge/Maven-3.9.9-C71A36?logo=apachemaven&logoColor=white)](https://maven.apache.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.16-6DB33F?logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)

표준프레임워크 기반 모바일 Device API의 WEB 서버와 Flutter 기반 App 샘플을 함께 제공하는 프로젝트입니다.

## 프로젝트 소개

이 Repository에서는 아래 2개 프로젝트로 구성됩니다. 
각 프로젝트의 실행/설정 방법은 내부 `README.md`를 참고하세요.

## 공통 환경

### DeviceAPI App
| 항목 | 버전 |
| :--- | :--- |
| Flutter | SDK 3.9.2 이상 |
| Dart | 3.9.2 이상 |

### DeviceAPI Web
| 항목 | 버전 |
| :--- | :--- |
| JDK | 17 |
| Spring Boot | 3.5.16 |
| Maven | 3.9.9 |

## 프로젝트 구성

| 프로젝트 | 역할 | 
| :--- | :--- | 
| `device-api-app` | Device API App 샘플(Flutter) | 
| `device-api-web` | Device API WEB 서버(Spring Boot) | 


## 설치 및 실행

### 1. 필수 요구사항
- Flutter SDK 3.9.2 이상
- Android Studio 또는 VS Code
- iOS: Xcode (iOS 빌드 시)
- Android: Android SDK

### 2. 프로젝트 설정

압축을 풀고 IDE에서 `egovframe_mobile_deviceapi_app`을 연 뒤 맞추는 항목입니다. <br>
키 발급 절차는 [처음 설정](./docs/gettingStarted.md)에 있습니다.

#### 앱 기동에 필요한 설정

이 항목이 없으면 Android 또는 iOS 빌드가 멈추고 앱이 켜지지 않습니다.

- Flutter SDK와 Android SDK(Android) 또는 Xcode(iOS)
- 패키지 설치: `flutter pub get`
- Android `android/local.properties`. SDK가 설치되어 있으면 `flutter pub get`이 만듭니다
- `android/app/google-services.json`의 `package_name`이 `egovframework.mobile_deviceapi`일 것. 배포본의 자리표시자 파일이면 Firebase 키 없이 빌드됩니다

#### 선택 설정

없어도 앱은 켜집니다. 해당 기능만 동작하지 않습니다.

- Google Maps API 키: GPS 지도
- Firebase 앱 등록과 `google-services.json`, `ios/Runner/GoogleService-Info.plist` 교체: 푸시
- `lib/config/app_config.dart`의 `apiHost`: `flutter run`이 이 기본값으로 `device-api-web`에 연결
- `android/key.properties`: 릴리스 빌드. debug 실행에는 필요 없습니다

```bash
flutter pub get

# 코드 분석 실행 (선택사항)
flutter analyze
```

#### Message 중앙 관리
- l10n 으로 message 중앙 관리 및 국제화 처리 가능
- app_나라별 언어.arb 내부 파일 수정 
- `flutter gen-l10n` 실행 시 message 관련 파일 생성 됨 (ex - app_localizations_ko.dart)
- 파일별 기능 
  - l10n/app_*.arb : 언어별 message 원본
  - l10n/<application명>_message_keys.dart : 수동 작성 key 파일
  - l10n.yaml : gen-l10n 설정
  - l10n/app_localizations_*.dart : app_*.arb를 참고하여 자동생성되는 message 파일
  - l10n/app_localization.dart : l10n 진입점
