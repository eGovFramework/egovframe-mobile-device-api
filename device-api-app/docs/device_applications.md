# Flutter Device API Application

Flutter를 사용한 모바일 디바이스 정보 조회 및 관리 애플리케이션입니다.
Clean Architecture 패턴을 적용하여 개발되었으며, 다양한 디바이스 기능을 통합적으로 관리할 수 있습니다.

## 주요 기능

### 1. [가속도계 (Accelerator)](applications/accelerator.md)

#### 기능

- 3D 형태의 도형을 통한 실시간 가속도 정보 시각화
- Three.js 기반 3D 애니메이션
- 디바이스의 가속도 변화에 따른 도형 회전
- 가속도 데이터 저장 및 서버 업로드
- 저장된 가속도 정보 목록 조회 및 삭제

#### 의존성

- `sensors_plus: ^4.0.2`

### 2. [파일 관리 (File Management)](/fileManagement.md)

#### 기능

- 디바이스 파일 시스템 접근
- 파일 생성, 삭제, 이동, 복사 기능
- 폴더 생성 및 관리
- 다중 파일 선택 및 일괄 작업
- 파일 정보 표시 (크기, 수정일, 항목 수)
- 텍스트 파일 읽기/쓰기
- JSON 파일 처리

#### 의존성

- `file_picker: ^8.0.0+1`
- `open_file: ^3.3.2`

### 3. [기기 정보 (Device Info)](/deiveInfo.md)

#### 기능

- 디바이스 하드웨어 및 소프트웨어 정보 조회
- OS 버전, 디바이스 모델, UUID 정보
- 네트워크 연결 상태 확인
- 앱 버전 정보
- 서버 업로드 및 목록 조회
- 상세 정보 화면 제공

#### 의존성

- `device_info_plus: ^12.2.0`
- `package_info_plus: ^8.0.0`
- `flutter_contacts: ^1.1.8+1`

### 4. [문서 뷰어 (File Opener)](/fileOpener.md)

#### 기능

- PDF, Word, Excel, PowerPoint 파일 지원
- 웹서버에서 파일 다운로드
- 다양한 문서 형식 열기
- 로컬 파일 목록 조회 및 관리
- 파일 검색 및 정렬 기능
- 외부 앱 실행을 통한 파일 열기

### 5. [파일 읽기/쓰기 (File Read/Write)](/fileReadWriter.md)

#### 기능

- 텍스트 파일 생성 및 편집
- 로컬 파일 목록 조회 및 미리보기
- 로컬 파일 삭제
- 파일 업로드 (로컬 → 서버)
- 파일 다운로드 (서버 → 로컬)
- 서버 파일 목록 조회 및 삭제

#### 의존성

- `path_provider: ^2.1.2`

### 6. [위치 서비스 (GPS)](/gps.md)

#### 기능

- **실제 GPS 센서 사용**: Mock 데이터 제거, 실제 위치 정보 수집
- Google Maps를 활용한 실시간 위치 표시
- 현재 위치 조회 및 마커 표시
- 위치 정보 저장 및 관리
- 지도 스크롤 및 줌 기능
- 위치 정확도 및 타임스탬프 표시
- **권한 관리**: 런타임 위치 권한 요청 및 상태 관리
- 저장된 위치 정보 목록 조회 및 삭제

#### 의존성

- `geolocator: ^10.1.0`
- `google_maps_flutter: ^2.13.1`
- `webview_flutter: ^4.4.2`

### 7. [인터페이스 (Interface)](/interface.md)

#### 기능

- RESTful API를 통한 서버 통신
- 정보데이터 서버로 송신
- 정보데이터 기기로 수신
- 서버의 데이터 삭제 요청
- 웹서버와의 데이터 송수신 참고 및 활용

#### 의존성

- `flutter_secure_storage: ^9.2.4`
- `crypto: ^3.0.5`

### 8. [미디어 (Media)](/media.md)

#### 기능

- 카메라를 통한 사진 촬영
- 갤러리에서 이미지 선택
- 동영상 녹화 및 재생
- 갤러리 접근 및 미디어 파일 관리
- **성능 최적화**: 이미지 캐싱 및 비디오 플레이어 메모리 관리
- **권한 관리**: 카메라 및 저장소 권한 자동 요청
- 미디어 파일 서버 업로드 및 다운로드
- 미디어 파일 삭제

#### 의존성

- `image_picker: ^1.0.7`
- `video_player: ^2.8.2`

### 9. [네트워크 (Network)](/network.md)

#### 기능

- Wi-Fi, 모바일 데이터 연결 상태 모니터링
- 네트워크 정보 조회 (IP 주소, SSID, 네트워크 타입)
- 연결 상태 실시간 확인
- 네트워크 정보 서버 저장 및 목록 조회
- 네트워크 정보 삭제

#### 의존성

- `connectivity_plus: ^6.0.3`
- `network_info_plus: ^5.0.1`

</br>

---

### 공통 의존성

- 의존성 주입 : `get_it: ^7.6.4`
- HTTP 통신 (서버 연동용) `http: ^1.5.0`
- 권한 관리 : `permission_handler: ^11.2.0`
- SVG 이미지 지원 : `flutter_svg: ^2.0.10+1`
- 설정 저장 : `shared_preferences: ^2.2.2`
- URL 실행 : `url_launcher: ^6.2.5`
- 정적 분석 규칙 세트(개발용) : `flutter_lints: ^5.0.0`
