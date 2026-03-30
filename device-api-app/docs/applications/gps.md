# 위치 서비스 (GPS)

## 개요

GPS 기능은 디바이스의 현재 위치 정보를 실시간으로 조회하고, Google Maps를 통해 시각적으로 확인할 수 있는 기능입니다. 위치 정보를 로컬과 서버에 동시에 저장할 수 있으며, 저장된 위치 이력을 관리할 수 있습니다.

## 주요 기능

### 1. 위치 정보 조회
- 현재 디바이스의 GPS 위치 정보를 실시간으로 가져옵니다
- 위도, 경도, 정확도, 고도 정보를 제공합니다
- 위치 권한을 자동으로 요청하고 확인합니다

### 2. 지도 표시
- Google Maps를 통해 현재 위치를 시각적으로 확인할 수 있습니다
- 실시간 위치 마커 표시
- 자동 카메라 이동 및 줌 레벨 조정 기능

### 3. 데이터 저장
- GPS 정보를 로컬과 서버에 동시에 저장합니다
- 로컬 JSON 파일 저장
- 서버 DB 저장 (REST API)
- 저장 이력 관리 기능

### 4. 저장된 위치 목록 조회
- 서버에 저장된 위치 정보 목록을 조회할 수 있습니다
- 위치 데이터의 상세 정보 확인 가능

### 5. 위치 데이터 삭제
- 저장된 위치 정보를 개별 또는 일괄 삭제할 수 있습니다
- 서버 동기화 기능 제공

## 아키텍처 구조

### Domain Layer
- **Entity**: `GpsInfo`
  - `uuid`: 디바이스 고유 식별자
  - `latitude`: 위도
  - `longitude`: 경도
  - `altitude`: 고도
  - `accrcy`: 정확도
  - `timestamp`: 타임스탬프

- **Repository**: `GpsRepository` (인터페이스)
- **UseCase**: `GpsUseCase`

### Data Layer
- **Service**: `GpsService`
  - GPS 위치 정보 수집
  - 로컬 파일 저장
  - 서버 전송 로직

- **Repository Implementation**: `GpsRepositoryImpl`

### Presentation Layer
- **Screen**: `GpsMainPage`
  - Google Maps 지도 표시 (`MinimalMapWidget`)
  - 현재 위치 정보 표시 (`GpsLocationDisplay`)
  - 저장된 위치 목록 표시
  - 저장 및 목록 조회 기능

## 의존성

- `geolocator: ^10.1.0`: GPS 위치 정보 조회
- `permission_handler: ^11.2.0`: 위치 권한 관리
- `google_maps_flutter: ^2.13.1`: Google Maps 지도 표시

## Google Maps API 키 설정

Google Maps를 사용하기 위해서는 Google Maps API 키가 필요합니다. Google Cloud Console에서 API 키를 발급받은 후 아래와 같이 설정해야 합니다.

### 1. Google Cloud Console에서 API 키 발급

1. [Google Cloud Console](https://console.cloud.google.com/)에 접속합니다
2. 프로젝트를 생성하거나 기존 프로젝트를 선택합니다
3. "API 및 서비스" > "사용자 인증 정보"로 이동합니다
4. "사용자 인증 정보 만들기" > "API 키"를 선택합니다
5. 발급받은 API 키를 복사합니다
6. "API 및 서비스" > "라이브러리"에서 "Maps SDK for Android"와 "Maps SDK for iOS"를 활성화합니다

### 2. Android 설정

`android/app/src/main/AndroidManifest.xml` 파일을 열고 `<application>` 태그 내부에 다음을 추가합니다:

```xml
<!-- Google Maps API 키 -->
<meta-data android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

**설정 위치:**
```
android/app/src/main/AndroidManifest.xml
```

**예시:**
```xml
<application
    android:label="egovframe_mobile_deviceapi_app"
    ...>
    <!-- Google Maps API 키 -->
    <meta-data android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_API_KEY_HERE"/>
    
    <!-- Google Play Services 버전 -->
    <meta-data android:name="com.google.android.gms.version"
        android:value="@integer/google_play_services_version" />
    <meta-data android:name="com.google.android.gms.maps.USE_GOOGLE_PLAY_SERVICES" 
        android:value="true" />
</application>
```

### 3. iOS 설정

`ios/Runner/Info.plist` 파일을 열고 다음을 추가합니다:

```xml
<!-- Google Maps API 키 -->
<key>GMSApiKey</key>
<string>YOUR_API_KEY_HERE</string>
```

**설정 위치:**
```
ios/Runner/Info.plist
```

**예시:**
```xml
<dict>
    <!-- 기존 설정들... -->
    
    <!-- Google Maps API 키 -->
    <key>GMSApiKey</key>
    <string>GOOGLE_MAP_IOS_KEY</string>
</dict>
```

`ios/Runner/AppDelegate.swift` 파일에서는 `Info.plist`에서 API 키를 자동으로 읽어와 설정합니다:

```swift
// Google Maps API 키 설정 (Info.plist에서 읽어옴)
if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
   let plist = NSDictionary(contentsOfFile: path),
   let apiKey = plist["GMSApiKey"] as? String {
  GMSServices.provideAPIKey(apiKey)
}
```

### 4. 설정 완료 후

API 키를 설정한 후에는 다음 명령어를 실행하여 변경사항을 적용합니다:

```bash
flutter clean
flutter pub get
```

### 5. API 키 보안 주의사항

- **프로덕션 환경**: API 키에 대한 제한을 설정하는 것을 권장합니다
  - 애플리케이션 제한: Android 패키지 이름 및 iOS 번들 ID로 제한
  - API 제한: Maps SDK for Android, Maps SDK for iOS만 허용
- **개발 환경**: 개발용 API 키와 프로덕션용 API 키를 분리하여 사용하는 것을 권장합니다

## 화면 구성 및 사용 방법

### 메인 화면
<div style="width:300px; margin-bottom:10px;">
  <image src="images/gps_main.png" alt="gps 메인 화면">
</div>

Google Maps 지도와 현재 위치 정보가 표시됩니다. 화면 우측 상단의 위치 버튼을 클릭하면 현재 위치를 가져올 수 있습니다.

>**사용 방법:**
- 화면 우측 상단의 위치 버튼을 클릭합니다
- 위치 권한이 필요하면 자동으로 요청됩니다
- 위도, 경도, 정확도, 고도 정보가 표시됩니다
- 현재 위치가 지도에 표시되고 정보가 화면에 나타납니다
- 하단의 "저장" 버튼을 클릭하면 현재 위치 정보가 로컬과 서버에 저장됩니다
- 하단의 "서버 목록" 버튼을 클릭하면 서버에 저장된 위치 정보 목록을 확인할 수 있습니다

### 현재 위치 확인
<div style="width:300px; margin-bottom:10px;">
  <image src="images/gps_myRotate.png" alt="gps 현재 위치 확인 기능">
</div>

>**사용 방법**
- 우측 위에 현재위치 버튼을 눌러 현재 위치로 이동할 수 있습니다.
- [애뮬레이터에서 현재 위치 변경 후 테스트하는 방법](#emulator에서-위치-테스트를-하는-방법)을 확인해서 에뮬레이터에서 테스트를 진행할 수 있습니다.
- 현재 위치가 표시되면 하단의 위도/경도/정확도도 변경됩니다.
- 현재 위치가 표시된 마커가 고정된 상태에서 화면을 드래그해 지도를 이동할 수 있습니다.
- 지도 우측하단의 '+'/'-' 버튼을 통해 지도를 확대/축소할 수 있습니다.

### 서버 목록 조회
<div style="width:300px; margin-bottom:10px;">
  <image src="images/gps_list.png" alt="gps 서버 목록 조회 화면">
</div>

'서버 목록' 버튼을 눌러 서버에 저장된 위치 정보 목록을 확인할 수 있습니다.

>**사용 방법:**
- 하단의 "서버 목록" 버튼을 클릭하면 서버에 저장된 위치 정보 목록을 확인할 수 있습니다
- 서버에 저장된 모든 위치 정보 목록을 조회합니다
- 각 항목의 UUID, 위도, 경도, 정확도, 고도, 타임스탬프 정보를 확인할 수 있습니다
- 목록은 최신순으로 정렬되어 표시됩니다

### 서버 목록 삭제
<div style="width:300px; margin-bottom:10px; display:flex; gap:10px;">
  <image src="images/gps_delete.png" alt="gps 서버 목록 삭제">
  <image src="images/gps_delete-result.png" alt="gps 서버 목록 삭제 결과">
</div>

서버에 저장된 위치 정보를 삭제할 수 있습니다.

>**사용 방법:**
- 개별 삭제: 각 항목의 삭제 버튼을 클릭하여 개별 항목을 삭제할 수 있습니다
- 일괄 삭제: "전체 삭제" 버튼을 클릭하여 모든 위치 정보를 한 번에 삭제할 수 있습니다
- 삭제된 데이터는 서버에서 영구적으로 제거되며 복구할 수 없습니다

## 주의사항

- 위치 권한이 필요하며, 설정에서 권한을 허용해야 합니다
- 인터넷 연결이 필요합니다 (Google Maps 표시 및 서버 저장용)
- 정확한 위치를 위해 실외에서 사용하시기 바랍니다
- 배터리 사용량이 증가할 수 있습니다
- Google Maps API 키가 필요하며, 위의 "Google Maps API 키 설정" 섹션을 참고하여 설정해야 합니다
- API 키가 설정되지 않으면 지도가 표시되지 않습니다

## Emulator에서 위치 테스트를 하는 방법
1. emulator 우측에 '...' 버튼을 눌러 Extended Controls 창을 확인합니다.
<div style="width:300px; margin-bottom:10px;">
  <image src="images/gps_test1.png" alt="gps 테스트 화면">
</div>

2. 좌측 메뉴에 Location 버튼을 클릭합니다.
<div style="width:500px; margin-bottom:10px;">
  <image src="images/gps_test2.png" alt="gps 테스트 화면">
</div>

- 지도 표시가 나오면 상단의 검색창에 원하는 위치를 검색합니다.
- 예시) '서울 시청'

3. 위치가 나오면 SAVE POINT를 눌러 저장합니다.
<div style="width:500px; margin-bottom:10px;">
  <image src="images/gps_test3.png" alt="gps 테스트 화면">
</div>

4. 저장할 위치의 위도,경도, 주소를 확인하고 Name에 저장할 이름을 지정합니다.
<div style="width:500px; margin-bottom:10px;">
  <image src="images/gps_test4.png" alt="gps 테스트 화면">
</div>

5. 우측에 저장한 이름으로 저장되었는지 확인 후 SET LOCATION을 누르면 현재 위치가 변경됩니다.
<div style="width:500px; margin-bottom:10px;">
  <image src="images/gps_test5.png" alt="gps 테스트 화면">
</div>


## 기술적 특징

- **실시간 위치 추적**: `geolocator` 패키지를 사용한 정확한 위치 정보 수집
  - 위치 정확도는 `LocationAccuracy.high`로 설정되어 최대한 정확한 위치를 제공합니다
  - 위치 가져오기 시간 제한은 15초로 설정되어 있습니다
- **지도 시각화**: Google Maps를 통한 직관적인 위치 표시
  - 초기 줌 레벨은 15.0으로 설정되어 있습니다
  - 현재 위치가 변경되면 지도가 자동으로 해당 위치로 이동합니다
- **이중 저장**: 로컬과 서버에 동시 저장으로 데이터 안정성 확보
  - 로컬 저장은 JSON 파일 형식으로 저장되며, 앱의 문서 디렉토리에 저장됩니다
  - 서버 저장은 RESTful API를 통해 데이터베이스에 저장됩니다
- **타임스탬프 처리**: 위치 정보의 타임스탬프는 UTC 시간을 사용하며, 표시 시 로컬 시간으로 변환됩니다
- **권한 관리**: 자동 권한 요청 및 처리
  - 위치 권한이 거부된 경우 설정 화면으로 이동할 수 있는 안내를 제공합니다
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
