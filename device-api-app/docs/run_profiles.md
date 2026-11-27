# local과 운영 실행

서버와 앱을 로컬 개발과 운영으로 나눠 실행하는 방법입니다.  
서버 설정은 `application.properties` 하나이고, 기본값은 로컬 실행입니다. 앱 주소와 계정은 실행 인자로 바꿉니다.

| 구분 | 서버 | 앱 |
| --- | --- | --- |
| local | `application.properties` 기본값 | `APP_ENV` 기본값 `local`. HTTP |
| 운영 | 같은 파일에서 `[DEV/운영]` 주석 항목을 수정 | `APP_ENV=dev`. HTTPS와 Basic 인증 |

웹 DB 기본값은 HSQL 파일입니다.

## 1. local 서버

개발 PC에서 서버를 켤 때 사용합니다. 인증은 꺼지고 Swagger 실행은 켜집니다. DB, 파일 경로, FCM, RAG 주소는 `device-api-web/src/main/resources/application.properties`에 있습니다.

DB는 별도 설치 없이 HSQL 파일로 열립니다. `device-api-web`에서 실행하면 `data/hsql/hyb`에 저장되고, 스키마는 `script/hsql`을 기동 시 적용합니다. MySQL, Oracle, Altibase, Tibero, Cubrid 스크립트는 `script` 아래에 샘플로 남아 있습니다.

`device-api-web` 디렉터리에서 실행합니다.

```ps1
mvn spring-boot:run
```

서버 포트 기본값은 `9700`입니다.

## 2. local 앱

앱이 요청을 보내는 주소는 `lib/config/app_config.dart`입니다.  
`flutter run`만 하면 `apiHost`의 `defaultValue`와 `apiPort`(기본 `9700`)를 사용합니다. `APP_ENV`를 생략하면 `local`이고 스킴은 `http`입니다.

`defaultValue`가 `127.0.0.1`이면 그 주소는 앱이 실행 중인 기기 자신입니다. 서버를 개발 PC에서 켜고 공기계에서 `127.0.0.1`로 실행하면, 유선으로 연결되어 있어도 PC의 9700 포트에 연결되지 않습니다. 공기계는 `apiHost`를 개발 PC의 사설 IP로 바꿉니다.

파일을 바꾸지 않고 그 실행만 다른 호스트를 쓰려면 `--dart-define=API_HOST`로 `defaultValue`를 덮어씁니다. `APP_ENV=local`은 기본값이라 생략할 수 있습니다.

```ps1
# 앱과 서버를 같은 PC에서 실행
flutter run --dart-define=API_HOST=127.0.0.1

# Android 에뮬레이터. 10.0.2.2는 에뮬레이터에서 호스트 PC를 가리킵니다.
flutter run --dart-define=API_HOST=10.0.2.2

# 공기계. 개발 PC의 사설 IP를 넣습니다.
flutter run -d <DeviceID> --dart-define=API_HOST=x.x.x.x
```

이 값은 그 실행으로 설치되는 앱에 들어갑니다. IP가 바뀌면 다시 `flutter run` 합니다.  
Android Studio 상단 실행은 Additional run args에 같은 `--dart-define`을 저장해 두면 매번 입력하지 않아도 됩니다.

공기계만 USB로 `127.0.0.1:9700`을 PC 서버에 연결하려면, 연결 전에 포트 전달을 실행합니다.

```ps1
adb reverse tcp:9700 tcp:9700
flutter run --dart-define=API_HOST=127.0.0.1
```

`adb reverse`를 실행하지 않으면 케이블 연결만으로 `127.0.0.1`이 PC를 가리키지 않습니다.

### HTTP를 허용하는 범위

debug 빌드는 `android/app/src/debug/res/xml/network_security_config.xml`에 있는 호스트만 HTTP를 허용합니다.

- `localhost`
- `127.0.0.1`
- `10.0.2.2`

공기계에서 PC 사설 IP로 HTTP 접속하려면 이 파일의 `domain-config`에 그 IP를 추가합니다.  
릴리스 빌드는 `android/app/src/main/res/xml/network_security_config.xml`을 사용하며 HTTP를 허용하지 않습니다.

iOS는 `ios/Runner/Info.plist`에서 `localhost`와 `127.0.0.1`만 HTTP 예외입니다. 그 외 주소는 HTTPS를 사용합니다.

AI 채팅은 앱이 9700만 호출합니다. RAG 주소(`Globals.AiRag.Url`)는 `application.properties`에만 둡니다.

## 3. 운영 서버

`application.properties`에서 `[DEV/운영]` 주석이 붙은 항목을 바꿉니다. 인증을 켜고 Swagger try-it-out은 끕니다.  
주소, 파일 경로, FCM, RAG, WebSocket 출처, MQTT 사용 여부가 해당합니다. DB를 그대로 두면 HSQL 파일 DB를 사용합니다.

JAR로 실행할 때는 수정한 설정이 들어간 뒤 다음을 실행합니다.

```ps1
java -jar device-api-web.jar
```

MySQL 등 다른 DB 스키마 스크립트는 `device-api-web/script/{db}`에 샘플로 있습니다. MySQL 드라이버는 프로젝트에 포함하지 않습니다.

## 4. 운영 앱

local 실행은 debug 빌드입니다. `flutter run`은 개발 PC에 있는 디버그 서명을 사용합니다.

운영 서버는 HTTPS와 Basic 인증을 요구합니다. 앱은 릴리스 빌드로 실행합니다. 릴리스 서명은 `device-api-app/android/key.properties`와 키스토어 파일이 있을 때만 진행됩니다. 두 파일은 빌드하는 PC에만 두고 저장소에는 올리지 않습니다. 파일이 없으면 `flutter run --release`와 `flutter build apk --release`는 실패합니다.

키스토어는 다음으로 만듭니다. 경로와 별칭은 빌드 PC에 맞게 바꿉니다.

```ps1
keytool -genkeypair -v -keystore C:/keys/device-api-upload.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

`android/key.properties` 예시는 다음과 같습니다. `storeFile`은 키스토어의 절대 경로이거나, `android` 폴더 기준 상대 경로입니다.

```properties
storePassword=스토어비밀번호
keyPassword=키비밀번호
keyAlias=upload
storeFile=C:/keys/device-api-upload.jks
```

서명이 다른 앱이 이미 기기에 있으면 덮어쓰지 못합니다. 기기에서 앱을 지운 뒤 설치합니다.

```ps1
flutter run --release --dart-define=APP_ENV=dev --dart-define=API_BASE_URL=https://운영도메인:9700 --dart-define=API_USERNAME=deviceapi --dart-define=API_PASSWORD=운영비밀번호
```

`API_BASE_URL`을 주면 그 주소만 사용합니다. 사용자와 비밀번호는 요청 헤더와 WebSocket 연결에 붙습니다.  
local처럼 인증 값을 비우면 운영 서버는 요청을 거절합니다.

iOS 기기 서명은 [실기기 빌드](/device_build.md)의 Xcode Signing을 사용합니다.

## 5. MQTT

MQTT 접속 값은 실행 인자가 아니라 `application.properties`에 있습니다.

| 키 | local | DEV/운영 |
| --- | --- | --- |
| `mqtt.enabled` | `true` | `false`. 쓸 때 `true`로 바꿉니다 |
| `mqtt.host` | `${local.host}` | 비움. 브로커 주소로 채웁니다 |
| `mqtt.port` | `1883` | `1883` |
| `mqtt.username`, `mqtt.password` | 비움 | 계정이 있으면 이 파일에 적습니다 |
| `mqtt.device-id` | `device01` | `device01` |

서버는 기동할 때 브로커에 접속하지 않습니다. 앱은 IoT 화면에 들어올 때 `/iot/mqttConfig.do`로 값을 읽고, 연결 버튼을 눌렀을 때만 접속합니다. 화면을 벗어나면 연결을 끊습니다.  
`mqtt.enabled`가 `false`이거나 `mqtt.host`가 비어 있으면 앱은 브로커에 접속하지 않습니다.

공기계에서 `127.0.0.1`은 휴대폰 자신입니다. DB, 서버 주소, RAG, MQTT를 개발 PC의 사설 IP로 맞출 때는 `application.properties`의 `local.host`만 바꿉니다.

## 6. 실행 인자

| 인자 | 기본값 | 설명 |
| --- | --- | --- |
| `APP_ENV` | `local` | `local`이면 `http`, 그 외에는 `https` |
| `API_HOST` | `app_config.dart`의 `apiHost` `defaultValue` | `API_BASE_URL`이 없을 때의 호스트. 생략하면 파일의 기본값 |
| `API_PORT` | `9700` | `API_BASE_URL`이 없을 때의 포트 |
| `API_BASE_URL` | 없음 | 스킴과 호스트를 한 번에 지정. 운영에서 사용 |
| `API_USERNAME`, `API_PASSWORD` | 없음 | 운영 Basic 인증. 비어 있으면 헤더를 보내지 않음 |
| `GOOGLE_MAPS_API_KEY` | 자리표시자 | 지도 키 |

API 경로(`/acl`, `/gps` 등)와 SQLite 테이블명은 환경과 상관없이 `app_config.dart`에 있습니다.

## 연관 가이드

- [프로젝트 시작하기](/project_start.md)
- [DeviceAPI 연동 WebServer 기동](/webserver.md)
