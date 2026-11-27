# Flutter Device API Application

이 저장소(`flutter_deviceapi_19_edit`)의 `device-api-app`은 전자정부 모바일 Device API 샘플입니다.  
Clean Architecture + feature-first 폴더 + **Riverpod** 으로 구성되어 있으며, 앱 목록(`data/app_list_data.json`)에 **19개 기능**이 있습니다.

서버 연동은 `device-api-web`(기본 `:9700`) REST를 씁니다. AI 채팅만 웹이 `egovframe-ai-rag`로 한 단 더 중계합니다. 3단 구조는 저장소 루트 [docs/3tier-architecture-guide.md](../../docs/3tier-architecture-guide.md) 를 보면 됩니다.

## 주요 기능

앱 목록 순서와 같습니다. 전용 가이드가 있는 항목은 링크로 연결합니다.

### 1. [가속도계 (Accelerator)](applications/accelerator.md)

- 3축 가속도 실시간 조회, 3D 도형 시각화
- 서버(`/acl`) 또는 SQLite 저장·목록·삭제
- 의존성: `sensors_plus: ^4.0.2`

### 2. [파일 관리 (File Management)](applications/file_management.md)

- 기기 Documents 폴더 탐색, 생성·삭제·이동·복사 (서버 연결 없음)
- 의존성: `path_provider: ^2.1.2`

### 3. [기기 정보 (Device Info)](applications/device_info.md)

- OS, 모델, UUID, 용량, 앱 버전 조회
- 서버(`/dvc`) 업로드·목록
- 의존성: `device_info_plus: ^12.2.0`, `package_info_plus: ^8.0.0`, `flutter_storage_info: ^1.0.0`

### 4. [문서 뷰어 (File Opener)](applications/file_opener.md)

- PDF/Office 등 문서 다운로드·외부 앱으로 열기
- 웹 경로 `/fop`

### 5. [파일 읽기/쓰기 (File Read/Write)](applications/file_readwrite.md)

- 텍스트 파일 로컬 CRUD, 서버(`/frw`) 업로드·다운로드
- 의존성: `path_provider: ^2.1.2`

### 6. [위치 서비스 (GPS)](applications/gps.md)

- 실제 GPS + Google Maps 마커, 서버(`/gps`) 저장
- 의존성: `geolocator: ^10.1.0`, `google_maps_flutter: ^2.13.1`

### 7. [인터페이스 (Interface)](applications/interface.md)

- 로그인·회원가입 정보를 서버(`/itf`)와 송수신하고, 세션은 `flutter_secure_storage`에 둡니다
- 의존성: `flutter_secure_storage: ^9.2.4`, `bcrypt: ^1.1.3`

### 8. [미디어 (Media)](applications/media.md)

- 카메라·갤러리 사진/동영상, 서버(`/mda`) 업로드
- 의존성: `image_picker: ^1.0.7`, `video_player: ^2.10.0`, `photo_manager: ^3.9.0`

### 9. [네트워크 (Network)](applications/network.md)

- Wi-Fi/모바일 연결·SSID·IP 조회, 서버(`/nwk`) 저장
- 의존성: `connectivity_plus: ^6.0.3`, `network_info_plus: ^5.0.1`

### 10. [바코드 스캐너 (Barcode)](applications/barcode.md)

- 카메라로 바코드/QR 스캔, 서버(`/bar`) 저장·목록·삭제
- 의존성: `flutter_zxing: 2.2.1`, `camera: ^0.11.0`

### 11. [나침반 (Compass)](applications/compass.md)

- 방위각 실시간 조회, 서버(`/cps`) 저장
- 의존성: `flutter_compass: ^0.8.1`

### 12. [연락처 (Contacts)](applications/contacts.md)

- 기기 연락처 조회, 서버(`/ctt`) 저장·목록·디바이스 저장
- 의존성: `flutter_contacts: ^1.1.9+2`

### 13. [푸시 알림 (Push)](applications/push.md)

- FCM 수신, 디바이스 등록 정보를 서버(`/pus`)에 저장
- 의존성: `firebase_core: ^3.15.2`, `firebase_messaging: ^15.2.10`, `flutter_local_notifications: ^18.0.1`

### 14. [소켓 IO (Socket)](applications/socket.md)

- WebSocket 실시간 채팅, 메시지 서버(`/ws`) 저장
- 의존성: `web_socket_client: ^0.1.0`

### 15. [스트리밍 미디어 (Streaming)](applications/streaming.md)

- 서버(`/stm`) 미디어 목록 조회·스트리밍 재생

### 16. [얼굴 메시 (Face Mesh)](applications/face_mesh.md)

- MediaPipe Face Mesh 468/478 랜드마크 시각화, 서버(`/fms`) 저장
- 의존성: `mediapipe_face_mesh: ^2.4.0`

### 17. [IoT 제어 (IoT MQTT)](applications/iot.md)

- RabbitMQ MQTT 텔레메트리 구독·제어 명령, 서버(`/iot`) 이력
- 의존성: `mqtt5_client: ^5.0.0`

### 18. [AI 채팅 (AI Chat)](applications/ai_chat.md)

- Flutter → `device-api-web` `/aic` → `egovframe-ai-rag` 3단 질의
- SSE 스트리밍, RAG/일반 채팅, 세션 목록·삭제
- 질의는 서버 필수. SQLite는 저장된 이력 CRUD만
- 의존성: `flutter_markdown: ^0.7.7+1`, `http: ^1.5.0`

### 19. [SQLite Manager](applications/sqlite.md)

- 앱 내부 SQLite DB 생성·테이블 편집·import/export
- 모듈: `lib/sqlite` (`sqlite/sqlite.dart`)

---

### 공통 의존성

- 상태·DI: `flutter_riverpod: 3.0.3`, `riverpod_annotation: 3.0.3`
- 코드 생성: `riverpod_generator: 3.0.3`, `build_runner: ^2.7.0`
- HTTP: `http: ^1.5.0`
- 권한: `permission_handler: ^11.2.0`
- SVG: `flutter_svg: ^2.0.10+1`
- 설정 저장: `shared_preferences: ^2.2.2`
- URL: `url_launcher: ^6.2.5`
- 린트: `flutter_lints: ^5.0.0`

`get_it` 은 쓰지 않습니다. 의존성 주입은 [architecture/5_dependency_injection.md](architecture/5_dependency_injection.md) 를 따릅니다.
