# 네트워크 (Network)

## 개요

네트워크 기능은 현재 네트워크 상태를 실시간으로 모니터링하고, 네트워크 정보를 서버에 저장할 수 있는 기능입니다. WiFi, 모바일 데이터, 이더넷 연결 상태를 확인하고, 네트워크 품질을 평가할 수 있습니다.

## 주요 기능

### 1. 네트워크 상태 모니터링
- 현재 디바이스의 네트워크 연결 상태를 실시간으로 확인합니다
- WiFi, 모바일 데이터, 이더넷 연결 상태 확인
- 네트워크 품질 평가
- 연결 상태 변경 실시간 감지

### 2. 네트워크 정보 수집
- 현재 연결된 네트워크의 상세 정보를 수집합니다
- 네트워크 타입 (WiFi, 4G, 5G 등)
- IP 주소
- MAC 주소
- WiFi SSID 정보

### 3. 데이터 저장
- 네트워크 정보를 서버에 저장합니다
- 서버 DB 저장 (REST API)
- 저장된 네트워크 정보 목록 조회
- 네트워크 정보 삭제 기능

## 아키텍처 구조

### Domain Layer
- **Entity**: `NetworkInfo`
  - `networkType`: 네트워크 타입
  - `networkTypeName`: 네트워크 타입 이름
  - `deviceName`: 디바이스 이름
  - `ipAddress`: IP 주소
  - `ssid`: WiFi SSID
  - `macAddress`: MAC 주소

- **Repository**: `NetworkRepository` (인터페이스)
- **UseCase**: `NetworkUseCase`

### Data Layer
- **Service**: `NetworkService`
  - 네트워크 상태 확인
  - 네트워크 정보 수집
  - 네트워크 품질 평가
  - 연결 상태 변경 감지

- **Repository Implementation**: `NetworkRepositoryImpl`

### Presentation Layer
- **Screen**: `NetworkScreen`
  - 네트워크 상태 표시
  - 네트워크 정보 표시
  - 서버 전송 기능
  - 목록 조회 기능

## 의존성

- `network_info_plus: ^5.0.1`: 네트워크 정보 조회
- `connectivity_plus: ^6.0.3`: 네트워크 연결 상태 확인
- `http: ^1.5.0`: 서버 통신

## 화면 구성 및 사용 방법

### 메인 화면
<div style="width:300px; margin-bottom:10px; display:flex; gap:10px;">
  <image src="images/network_main.png" alt="Network 메인 화면">
  <image src="images/network_off.png" alt="Network 네트워크 미연결 화면">
</div>

앱 실행 시 자동으로 네트워크 상태가 확인되며, 현재 네트워크 연결 상태와 상세 정보가 표시됩니다. 네트워크 상태가 변경되면 자동으로 업데이트됩니다.

>**사용 방법**
- 앱을 실행하면 자동으로 네트워크 상태가 확인됩니다
- 현재 네트워크의 상세 정보(네트워크 타입, 디바이스 이름, IP 주소, WiFi SSID 등)가 표시됩니다.
- 하단의 "정보 전송" 버튼을 클릭하면 현재 네트워크 정보가 서버에 저장됩니다
- 하단의 "목록" 버튼을 클릭하면 서버에 저장된 네트워크 정보 목록을 확인할 수 있습니다

### 서버 목록 조회
<div style="width:300px; margin-bottom:10px;">
  <image src="images/network_list.png" alt="Network 서버 목록 화면">
</div>

서버에 저장된 네트워크 정보 목록을 확인할 수 있습니다.

>**사용 방법**
- 하단의 "목록" 버튼을 클릭하면 서버에 저장된 네트워크 정보 목록을 확인할 수 있습니다
- 서버에 저장된 모든 네트워크 정보 목록을 조회합니다
- 각 항목의 네트워크 타입, 디바이스 이름, IP 주소, WiFi SSID, MAC 주소 등의 상세 정보를 확인할 수 있습니다
- 목록은 최신순으로 정렬되어 표시됩니다

### 네트워크 상세 정보
<div style="width:300px; margin-bottom:10px;">
  <image src="images/network_detail.png" alt="Network 상세 정보 화면">
</div>

서버에 저장된 네트워크의 상세 정보를 확인할 수 있습니다.

>**사용 방법**
- 네트워크 서버 목록에서 원하는 정보를 선택해 상세 정보를 확인할 수 있습니다.
- '삭제'버튼을 누르면 서버에서 해당 데이터를 삭제할 수 있습니다.

## 애뮬레이터를 이용한 테스트 방법
### 1. 디바이스 상단을 내려 인터넷 상태를 확인합니다
<div style="width:300px; margin-bottom:10px;">
  <image src="images/network_systemSetting.png" alt="Network 상세 정보 화면">
</div>

### 2. Internet을 클릭해 Cellular와 Wi-Fi 의 on/off 를 선택합니다
<div style="width:300px; margin-bottom:10px;">
  <image src="images/network_internet.png" alt="Network 상세 정보 화면">
</div>

### 3. Internet 연결 상태에 따라 메인 페이지의 상태가 변경됩니다.
#### Cellular 
<div style="width:300px; margin-bottom:10px; display:flex; gap:10px;">
  <image src="images/network_cellular.png" alt="Network 상세 정보 화면">
  <image src="images/network_main.png" alt="Network 상세 정보 화면">
  <image src="images/network_off.png" alt="Network 상세 정보 화면">
</div>

- 좌측부터 순서대로 cellular, wifi, internet off 상태
- '네트워크 타입'을 확인해 현 상태를 확인할 수 있습니다.
- cellular와 wifi 둘 다 연결되어있으면 wifi가 우선으로 표시됩니다.

## 주의사항

- 인터넷 연결이 필요합니다.
- WiFi 정보는 WiFi 연결 시에만 제공됩니다
- 일부 네트워크 정보는 보안상 제한될 수 있습니다
- 서버 저장 기능을 사용하려면 웹서버가 실행 중이어야 합니다

## 기술적 특징

- **실시간 모니터링**: 네트워크 상태 변경을 실시간으로 감지
  - `connectivity_plus` 패키지의 스트림을 사용하여 네트워크 상태 변경을 감지합니다
  - 상태가 변경되면 자동으로 네트워크 정보를 다시 수집합니다
- **다양한 네트워크 타입 지원**: WiFi, 모바일 데이터, 이더넷 등
  - `network_info_plus` 패키지를 사용하여 네트워크 정보를 수집합니다
  - Android와 iOS에서 제공하는 정보가 다를 수 있습니다
- **네트워크 품질 평가**: 연결 품질을 평가하여 표시
  - 네트워크 연결 상태에 따라 품질을 평가하여 표시합니다
- **네트워크 정보 수집**:
  - IP 주소: 현재 연결된 네트워크의 IP 주소를 조회합니다
  - WiFi SSID: WiFi에 연결된 경우에만 SSID 정보를 제공합니다
  - MAC 주소: 디바이스의 MAC 주소를 조회합니다 (권한 필요)
- **서버 연동**: RESTful API를 통한 네트워크 정보 저장
  - 네트워크 정보는 RESTful API를 통해 서버에 저장됩니다
  - 저장된 정보는 목록으로 조회하고 삭제할 수 있습니다
- **Pull-to-Refresh**: 화면을 아래로 당겨서 네트워크 정보를 새로고침할 수 있습니다
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
