# Android Studio Emulator 설치 및 설정

Emulator를 통한 테스트를 진행하기 위해 Emulator에 대한 기초 설정을 가이드합니다</br>
Android Studio 업데이트에 따라 설정 방법은 변경될 수도 있습니다.

## 1. 안드로이드 스튜디오 설치

### 1) 안드로이드 스튜디오 개발자 사이트 접속

[Android Stuido Developer](https://developer.android.com/studio?hl=ko)</br>

![Android Stuido Developer install](/images/androidStudio_install.png)

- 안드로이드 스튜디오 다운로드 (2026.01 기준 - Otter3)
- 다운로드 후 설치까지 진행
- macOS 유저도 Android Studio를 이용해 개발 / 테스트 가능</br> \*설치까지는 동일하나 문제가 있는 경우 [macOS 추가 설정](#macos-추가-설정) 참고

### 2) Android SDK 설치 및 설정

- (방법1) 프로그램 설치 간 Android Stuido SDK 추가</br>
  ![android studio sdk standard](/images/sdk_type1.png) - Standard : 최신 버전의 Android SDK가 다운로드 - Custom : SDK가 이미 있는 경우 SDK 경로 지정 후 사용

- (방법2) Android Studio
  - Android Studio 메인화면 > More Actions > SDK Manager </br>
    ![Welcome to Android](/images/welcomeToAndroid.png)
    \*Project가 열린 화면에서는 **File > Settings > Language & Frameworks > Android SDK**

  - Android SDK 경로 확인
    - SDK가 없는 경우 Edit을 눌러 SDK를 설치할 폴더 지정 </br> \*방법1을 진행한 경우 경로 자동 지정
    - 폴더 지정 후 SDK Platforms 탭에서 SDK 설치

### 3) macOS 추가 설정

macOS에서 Android Studio 사용 시 Android SDK에서 오류가 표시되거나 Emulator가 기동되지 않는 경우 아래 항목 점검</br>

#### Android SDK Tools 다운로드

- 메뉴바에서 Android Studio > Settings > Language & FrameWorks > Android SDK > SDK Tools 탭
  ![macos android Studio](/images/macos_anbdroid.png)
  ![macos android Tools](/images/macos_andTool.png) - Android SDK Platform-Tools가 다운로드되어있지 않은 경우 다운로드 실행 - Android Emulator의 경우도 다운로드

## 2. 안드로이드 애뮬레이터 설치

안드로이드 스튜디오에서 제공하는 가상 디바이스를 설치하여 실기기에 Build하지 않고 테스트를 진행합니다.</br>
\*macOS에서도 사용 가능

### 1) Device Manager 에서 Virtual Device 만들기

- 우측 메뉴바에서 Device Manager 선택</br>
  또는 상단 메뉴바 Tools > Device Manager
- Device Manager에서 '+' 버튼을 눌러 Create Virtual Device 선택</br>
    또는 에뮬레이터가 없는 경우 목록 화면에서 Create Virtual Device 클릭
![device manager](/images/deviceManager.png)

### 2) Virtual Device 선택

![create virtual device](/images/createVirtualDevice1.png)
- Form Factor에서 원하는 디바이스 크기 선택 (Phone 또는 Tablet)
- Google Play 사용여부, API Level, 크기 확인 후 Next</br>
    *해당 가이드에서는 'Pixel9' 사용

### 3) Virtual Device 설정 및 System Image 다운로드
※ 시스템 이미지의 경우 1-2GBytes의 대용량 파일이므로 네트워크 환경이 원활하고 메모리가 충분한 환경에서 다운로드를 진행 필요

![create virtual device2](/images/createVirtualDevice2.png)
- Name에서 디바이스의 이름 지정 (본인 확인용)
- Additional settings에서 Storage크기, Camera, 시작 시 디바이스 방향 등을 설정 가능 (필요시 선택적)
- 앞서 다운로드 한 SDK와 동일한 API 이미지 다운로드
- API의 Select Box에서 사용가능한 API Level을 선택 가능</br>
    * pixel9의 경우 API35+ 이므로 API Level이 35이상인 System Image를 다운로드 받아야함</br>
- 시스템 이미지를 다운로드 해야 Finish 또는 Next가 가능 </br>
    *목록 좌측에 다운로드 아이콘을 눌러서 다운로드 진행

### 4) Virtual Device 생성 확인
![create virtual device3](/images/createVirtualDevice3.png)
- Device Manager에서 생성한 Virtual Device가 출력되면 성공
- '▷' 버튼을 눌러 실행
- Running Device에 에뮬레이터 출력

### 5) 유의사항
- 에뮬레이터를 실행하는 PC 성능에 따라 기동시간에 큰 차이가 있을 수 있습니다.
- 에물레이터 기동에 오랜시간이 걸리는 경우 프로젝트 실행 시 곧바로 프로젝트 실행과 동시에 에뮬레이터를 실행x</br>
    **Device Manager 에서 Device만 실행 → Device 기동 완료 후 메인 화면 출력 → Flutter run** </br>
    순서로 실행하면 프로젝트 기동간 리소스 부하에 의한 강제 종료를 예방할 수 있습니다.

### 6) macOS에서 IOS Simulator를 실행하는 방법
#### 요구사항
- Xcode 필요 (구버전인 경우 Flutter Build가 되지 않을 수 있으니 최신버전으로 업데이트)
- Simulator App 필요

#### (1) 시뮬레이터 기동
`open -a Simulator`

#### (2) Finder > flutter 프로젝트 Open > Terminal
`flutter run`

#### (3) Simulator 확인
XCode를 통해 Build > Simulator에 Flutter 앱 구동 확인 

#### (4) 유의사항
IOS Simulator의 경우 보안문제로 인해 Camera, Accelerator에 대한 테스트 불가</br>
- Accelerator의 경우 application 실행 불가
- Camera의 경우 디바이스를 통한 촬영 불가 (app 자체는 실행 가능)

## 3. VSCode 에서 Android Emulator 실행
### 1) 조건
- Android Studio를 통해 Android Emulator(AVD)가 설치
- VSCode Extensions에서 Flutter가 설치

### 2) 에뮬레이터 실행 방법
- `Ctrl + Shift + P`
- 상단에서 'Emulator' 입력
- Flutter : Launch Emulator 선택
- 실행할 에뮬레이터 선택 (등록된 에뮬레이터가 없는 경우 Create Emulator)

### 3) Flutter 프로젝트 실행
- 터미널에서 `flutter run` (특정 디바이스 지정 필요시 `-d <device ID>` 사용)
- main.dart 파일에서 Run 클릭


## 연관 가이드

- [Flutter 설치가이드](/settings.md)
- [프로젝트 시작하기](/project_start.md)
- [DeviceAPI 연동 WebServer 기동](/webserver.md)