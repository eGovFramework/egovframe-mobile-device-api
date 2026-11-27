# 처음 설정

압축을 풀고 IDE에서 `egovframe_mobile_deviceapi_app` 폴더를 연 뒤에 맞추는 항목입니다.

앱을 켜는 데 필요한 설정과, 특정 기능만 막는 설정을 나눕니다. 서버를 켜는 절차는 [local과 운영 실행](./run_profiles.md), IDE에서 실행하는 절차는 [프로젝트 시작](./project_start.md)을 봅니다.

## 1. 앱 기동에 필요한 설정

여기가 비어 있거나 값이 틀리면 빌드가 멈추고 앱이 설치되지 않습니다.

### Flutter와 플랫폼 SDK

- Flutter SDK 3.9.2 이상
- Android: Android SDK
- iOS: Xcode

설치 확인은 [Flutter 설치 가이드](./settings.md)를 봅니다.

### 패키지 설치

`egovframe_mobile_deviceapi_app` 디렉터리에서 실행합니다.

```powershell
flutter pub get
```

이 명령을 하지 않으면 의존성을 찾지 못해 빌드되지 않습니다. `pubspec.lock`과 `lib/l10n/app_localizations*.dart`는 이 명령이 arb와 `pubspec.yaml`로 다시 만듭니다. `*.g.dart`는 `flutter pub get`이 만들지 않으므로 압축에 들어 있습니다.

### Android SDK 경로

`android/local.properties`는 저장소에 없습니다. Flutter SDK와 Android SDK가 설치되어 있으면 `flutter pub get` 또는 `flutter run`이 이 파일을 만듭니다.

파일이 없거나 `sdk.dir`, `flutter.sdk` 경로가 틀리면 Gradle이 실패합니다. 직접 만들 때는 이 PC의 경로를 넣습니다.

```properties
sdk.dir=<Android SDK 경로>
flutter.sdk=<Flutter SDK 경로>
```

### google-services.json 패키지명

Android 빌드는 `android/app/google-services.json`이 있고, 그 안의 `package_name`이 앱 ID `egovframework.mobile_deviceapi`와 같아야 합니다.

배포본에는 이 패키지명의 자리표시자 파일이 들어 있습니다. Firebase 키를 발급하지 않아도 그 파일로 앱은 빌드되고 켜집니다. 파일을 지우거나 다른 패키지명의 json으로 바꾸면 Android 빌드가 멈춥니다.

푸시가 필요하면 아래 선택 설정에서 본인 Firebase 프로젝트의 파일로 바꿉니다.

## 2. 선택 설정

없어도 앱 목록까지 켜집니다. 그 기능 화면만 동작하지 않거나, 서버와 연결되지 않습니다.

### device-api-web 연결

서버를 켜지 않아도 앱은 기동합니다. 서버 저장·조회를 쓸 때만 주소를 맞춥니다.

`flutter run`만 하면 `lib/config/app_config.dart`의 `apiHost` `defaultValue`와 `apiPort`(기본 `9700`)로 접속합니다. `--dart-define`을 주지 않아도 그 값이 사용됩니다. 개발 PC 주소가 다르면 이 `defaultValue`를 고친 뒤 다시 `flutter run` 합니다.

```dart
static const String apiHost = String.fromEnvironment(
  'API_HOST',
  defaultValue: '개발 PC 주소',
);
```

한 번만 다른 주소로 실행할 때는 파일을 고치지 않고 기본값을 덮어씁니다. Android 에뮬레이터에서 개발 PC는 `10.0.2.2`입니다.

```powershell
flutter run --dart-define=API_HOST=10.0.2.2
```

debug 빌드가 HTTP로 허용하는 호스트와 릴리스의 HTTPS는 [local과 운영 실행](./run_profiles.md)을 봅니다.

### Google Maps API 키 (GPS 지도)

키가 `GOOGLE_MAP_API_KEY` 또는 `GOOGLE_MAP_IOS_KEY`이면 GPS 화면의 지도만 나오지 않습니다. 위치 권한과 다른 기능, 앱 기동에는 영향이 없습니다.

1. [Google Cloud Console](https://console.cloud.google.com/)에서 프로젝트를 만들거나 선택합니다.
2. API 및 서비스 > 라이브러리에서 Maps SDK for Android, Maps SDK for iOS를 사용 설정합니다.
3. API 및 서비스 > 사용자 인증 정보 > 사용자 인증 정보 만들기 > API 키로 키를 만듭니다.
4. 키 제한에 Android 패키지 `egovframework.mobile_deviceapi`, iOS 번들 `egovframework.mobile-deviceapi`를 넣습니다.

키를 세 곳에 같은 값으로 넣습니다.

`android/app/src/main/AndroidManifest.xml`

```xml
<meta-data android:name="com.google.android.geo.API_KEY"
    android:value="발급받은_키"/>
```

`ios/Runner/Info.plist`

```xml
<key>GMSApiKey</key>
<string>발급받은_키</string>
```

앱 안 지도 표시 여부는 실행 인자로 판단합니다.

```powershell
flutter run --dart-define=GOOGLE_MAPS_API_KEY=발급받은_키
```

파일에 이미 있는 메타데이터 위치와 iOS에서 키를 읽는 코드는 [GPS](./applications/gps.md)를 봅니다.

### Firebase (푸시)

`lib/firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`가 자리표시자이면 Firebase 초기화가 실패하고 푸시 토큰만 발급되지 않습니다. `main`에서 이 실패를 잡으므로 앱은 계속 켜집니다.

푸시를 쓸 때 [Firebase 콘솔](https://console.firebase.google.com/)에서 프로젝트를 만든 뒤 앱을 등록합니다.

1. Android 앱 패키지 이름에 `egovframework.mobile_deviceapi`를 넣고 `google-services.json`을 받습니다.
2. 받은 파일을 `android/app/google-services.json`에 덮어씁니다. `package_name`이 앱 ID와 다르면 Android 빌드가 멈춥니다.
3. iOS 앱 번들 ID에 `egovframework.mobile-deviceapi`를 넣습니다. Firebase는 번들 ID의 `_`를 받지 않습니다. 받은 `GoogleService-Info.plist`를 `ios/Runner/GoogleService-Info.plist`에 덮어쓰고, `lib/firebase_options.dart`의 iOS `apiKey`, `appId`, `messagingSenderId`, `projectId`, `iosBundleId`를 그 파일 값으로 바꿉니다.
4. Android 에뮬레이터는 Google Play가 포함된 시스템 이미지를 사용합니다.

발송 화면은 앱이 아니라 서버 `/fcm`입니다. 서버의 Firebase Admin 설정은 [푸시](./applications/push.md)를 봅니다.

### 릴리스 서명

`flutter run` debug 실행에는 서명 파일이 필요 없습니다. `flutter run --release`와 `flutter build apk --release`는 `android/key.properties`와 키스토어가 없으면 실패합니다.

만드는 방법과 파일 예시는 [local과 운영 실행](./run_profiles.md)의 운영 앱을 봅니다. 두 파일은 빌드하는 PC에만 둡니다.
