# 인터페이스 (Interface)

## 개요

인터페이스 기능은 웹서버와의 데이터 송수신을 쉽고 편하게 RESTful 방식으로 구현할 수 있도록 참고 및 활용할 수 있는 기능입니다. 로그인 및 회원가입 기능을 제공하며, 세션 관리와 보안 기능을 포함합니다.

## 주요 기능

### 1. 로그인
- 사용자 ID와 비밀번호를 입력하여 로그인합니다
- 서버와의 인증 처리
- 로그인 성공 시 세션 정보 저장
- 자동 로그인 기능 (세션 유지)

### 2. 회원가입
- 새로운 사용자 계정을 생성합니다
- 사용자 ID, 비밀번호, 이메일 입력
- 계정 중복 확인
- 회원가입 성공 시 자동 로그인

### 3. 세션 관리
- 로그인 세션 정보를 안전하게 저장합니다
- 세션 만료 시간 관리
- 자동 로그인 기능

### 4. 보안 기능
- 비밀번호 암호화 저장
- 안전한 세션 정보 저장 (flutter_secure_storage)
- 세션 만료 시 자동 로그아웃

### 5. 정보데이터 서버로 송신
- RESTful API를 통한 데이터 전송
- 서버와의 통신 처리

### 6. 정보데이터 기기로 수신
- 서버에서 데이터 수신
- RESTful API를 통한 데이터 조회

### 7. 서버의 데이터 삭제 요청
- 서버에 저장된 데이터 삭제 요청
- RESTful API를 통한 삭제 처리

## 아키텍처 구조

### Domain Layer
- **Entity**: Interface 관련 엔티티
  - 사용자 정보
  - 세션 정보

- **Repository**: `InterfaceRepository` (인터페이스)
- **UseCase**: `InterfaceUseCase`

### Data Layer
- **Service**: `InterfaceService`
  - 로그인 처리
  - 회원가입 처리
  - 세션 관리
  - 서버 통신

- **Repository Implementation**: `InterfaceRepositoryImpl`

### Presentation Layer
- **Screen**: `InterfaceScreen`
  - 로그인 폼
  - 회원가입 폼
  - 입력 검증
  - 성공 화면 (`InterfaceSuccessPage`)

## 의존성

- `http: ^1.5.0`: 서버 통신
- `flutter_secure_storage: ^9.2.4`: 안전한 데이터 저장
- `crypto: ^3.0.5`: 비밀번호 암호화

## 화면 구성 및 사용 방법

### 로그인 화면
<div style="width:300px; margin-bottom:10px;">
  <image src="images/interface_main.png" alt="interface 메인 화면">
</div>

로그인 및 회원가입을 위한 입력 폼이 표시됩니다. 사용자 ID, 비밀번호, 이메일(회원가입 시)을 입력할 수 있습니다.

>**사용 방법:**
- 사용자 ID와 비밀번호를 입력합니다
- 하단의 "로그인" 버튼을 클릭하여 로그인합니다
- 로그인 성공 시 성공 화면으로 자동 이동합니다
- 이전에 로그인한 경우 세션이 유효하면 자동으로 로그인됩니다

### 입력 폼
<div style="width:300px; margin-bottom:10px; display:flex; gap:10px;">
  <image src="images/interface_validation.png" alt="interface validation 화면">
  <image src="images/interface_userInfo.png" alt="interface 유저 정보 입력 화면">
  <image src="images/interface_pwView.png" alt="interface password view 화면">
</div>

사용자 ID, 비밀번호, 이메일 입력 필드가 표시됩니다. 각 필드에 대한 입력 검증이 수행됩니다.

>**사용 방법:**
- 사용자 ID: 필수 입력 항목입니다
- 비밀번호: 필수 입력 항목이며, 최소 6자 이상이어야 합니다.
- 비밀번호 입력 확인 : 비밀번호 입력시 '*'로 가려져 있지만 입력필드 우측의 '눈(eye)'모양 버튼을 누르면 입력한 문자를 확인할 수 있습니다.
- 이메일: 선택 입력 항목이지만, 입력 시 올바른 이메일 형식이어야 합니다
- 하단의 "회원가입" 버튼을 클릭하여 새 계정을 생성할 수 있습니다
- 회원가입 성공 시 자동으로 로그인됩니다

### 로그인 성공
<div style="width:300px; margin-bottom:10px; display:flex; gap:10px;">
  <image src="images/interface_login-success.png" alt="interface 로그인 성공 alert 화면">
  <image src="images/interface_loginSuccess.png" alt="interface 로그인 성공 결과 화면">
</div>

로그인 성공 후 표시되는 화면입니다. 사용자 정보와 세션 정보가 표시됩니다.

>**사용 방법:**
- 로그인 성공 후 자동으로 이 화면으로 이동합니다
- 세션 정보가 안전하게 저장되어 다음 앱 실행 시 자동 로그인됩니다
- 로그아웃 등으로 세션이 종료되지 않는 이상 로그인 세션이 유지됩니다.

### 로그인 실패
<div style="width:300px; margin-bottom:10px;">
  <image src="images/interface_loginError.png" alt="interface 로그인 에러 화면">
</div>

아이디 또는 비밀번호를 입력하지 않거나 서버 DB에 저장되어있지 않은 유저정보인 경우 해당 에러가 출력됩니다.

### 로그아웃
<div style="width:300px; margin-bottom:10px;">
  <image src="images/interface_logout.png" alt="interface 로그아웃 화면">
</div>

>**사용 방법**
- 로그아웃 시 로그인 입력폼이 있는 메인화면으로 돌아갑니다.
- 로그인 세션이 종료됩니다.

### 회원탈퇴
<div style="width:300px; margin-bottom:10px; display:flex; gap:10px;">
  <image src="images/interface_deleteAccount.png" alt="interface 회원탈퇴 화면">
  <image src="images/interface_deleteAccount-result.png" alt="interface 회원탈퇴 결과 화면">
</div>

>**사용 방법**
- 회원탈퇴가 진행되면 데이터가 삭제되고 되돌릴 수 없습니다.
- 회원탈퇴가 완료되면 로그인 입력폼이 있는 메인화면으로 돌아갑니다.

## 주의사항

- 서버 연결 기능을 사용하려면 웹서버가 실행 중이어야 합니다
- 비밀번호는 최소 6자 이상이어야 합니다
- 이메일은 선택 사항이지만 입력 시 올바른 형식이어야 합니다
- 세션 만료 시간은 설정에 따라 자동으로 로그아웃됩니다

## 기술적 특징

- **RESTful API**: 표준 RESTful 방식의 서버 통신
  - 로그인, 회원가입, 계정 확인 등의 API를 제공합니다
  - HTTP POST 방식을 사용하여 데이터를 전송합니다
- **보안 저장**: flutter_secure_storage를 사용한 안전한 데이터 저장
  - 사용자 ID, 비밀번호, 로그인 상태, 로그인 시간을 안전하게 저장합니다
  - iOS는 Keychain, Android는 EncryptedSharedPreferences를 사용합니다
- **세션 관리**: 자동 세션 관리 및 만료 처리
  - 세션 만료 시간은 `app_config.dart`에 설정되어 있습니다
    ```dart
      // 세션 만료 시간 설정 (기본설정시간 : 10분)
      static const Duration sessionTimeout = Duration(minutes: 10);
    ```
  - 세션이 만료되면 저장된 정보가 자동으로 삭제되고 다시 로그인해야 합니다
  - 앱 실행 시 세션 유효성을 확인하여 자동 로그인을 처리합니다
- **비밀번호 처리**
  - 비밀번호는 평문으로 저장되지만, flutter_secure_storage를 통해 암호화되어 저장됩니다
  - 서버 전송 시에는 암호화되어 전송됩니다
- **입력 검증** 폼 입력값 검증 기능
  - 사용자 ID: 필수 입력, 빈 값 불가
  - 비밀번호: 필수 입력, 최소 6자 이상
  - 이메일: 선택 입력, 입력 시 @ 기호 포함 여부 확인
- **계정 중복 확인** 회원가입 시 서버에서 계정 존재 여부를 먼저 확인합니다
- **자동 로그인** 세션 유지 시 자동 로그인 기능
  - 앱 실행 시 저장된 세션 정보를 확인하여 유효하면 자동으로 로그인합니다
- **Clean Architecture** 도메인, 데이터, 프레젠테이션 레이어 분리
