# lib 파일 목록

device-api-app의 `lib` 디렉터리 하위 파일(총 611개)과 각 파일의 역할입니다.

> `.g.dart` 파일은 `build_runner`로 자동 생성되는 Riverpod 코드입니다.
>
> `domain/`·`data/`는 `presentation/screens`와 같이 **feature-first**로 구성합니다.
> 공유 타입은 `domain/shared/`에 둡니다.

lib
  firebase_options.dart - FlutterFire CLI가 생성한 Firebase 플랫폼별 설정(Android/iOS 등).
  main.dart - Flutter 앱 진입점. Firebase 초기화, SQLite 설정, 화면 방향 고정, Riverpod ProviderScope 및 MaterialApp 구성.
  config
    accelerator_sqlite_schema.dart - accelerator 기능용 SQLite DB 스키마 정의.
    ai_chat_sqlite_schema.dart - AI 채팅 SQLite 스키마 (MySQL AI_CHAT_INFO 동일 컬럼).
    app_config.dart - 앱 공통 설정. 실행 인자로 정하는 서버 주소(`API_HOST`, `API_BASE_URL`), API 엔드포인트(`/aic` 포함), 타임아웃, DB 테이블명, Google Maps API 키 등.
    barcode_sqlite_schema.dart - 바코드 기능용 SQLite DB 스키마(테이블·컬럼 정의) 및 마이그레이션 정보.
    compass_sqlite_schema.dart - 나침반 기능용 SQLite DB 스키마 정의.
    contacts_sqlite_schema.dart - 연락처 기능용 SQLite DB 스키마 정의.
    device_sqlite_schema.dart - device 기능용 SQLite DB 스키마 정의.
    file_readwrite_sqlite_schema.dart - file_readwrite 기능용 SQLite DB 스키마 정의.
    fileopener_sqlite_schema.dart - fileopener 기능용 SQLite DB 스키마 정의.
    face_mesh_sqlite_schema.dart - 얼굴 메시 SQLite 스키마.
    gps_sqlite_schema.dart - gps 기능용 SQLite DB 스키마 정의.
    interface_sqlite_schema.dart - interface 기능용 SQLite DB 스키마 정의.
    iot_sqlite_schema.dart - IoT MQTT 이력 SQLite 스키마.
    media_gallery_options.dart - 미디어 갤러리 접근 시 사용하는 옵션(허용 타입, 품질 등) 설정.
    media_sqlite_schema.dart - media 기능용 SQLite DB 스키마 정의.
    network_sqlite_schema.dart - network 기능용 SQLite DB 스키마 정의.
    push_sqlite_schema.dart - 푸시 알림 기능용 SQLite DB 스키마 정의.
    socket_sqlite_schema.dart - 소켓(WebSocket) 메시지용 SQLite DB 스키마 정의.
    streaming_sqlite_schema.dart - 스트리밍 미디어용 SQLite DB 스키마 정의.
  core
    device_id_service.dart - 기기 고유 식별자 조회·관리 서비스.
    device_api_client.dart - device-api-web HTTP 호출과 기능별 연결 확인(probe). 200이면 연결됨, 500이면 DB 오류, 그 외는 연결 안 됨.
  data
    accelerator
      datasources
        accelerator_sqlite_service.dart - accelerator 데이터의 로컬 SQLite CRUD 및 DB 연동.
        accelerator_server_connection_service.dart - 가속도계 기능의 서버 REST API 연결·동기화 서비스.
        accelerometer_service.dart - 가속도계 센서 데이터 수집 및 서버 전송.
      repositories
        accelerator_remote_repository_impl.dart - 가속도계 Repository의 서버(원격) 데이터 소스 구현체.
        accelerator_repository_impl.dart - 가속도계 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        accelerator_sqlite_repository_impl.dart - 가속도계 Repository의 로컬 SQLite 데이터 소스 구현체.
    aiChat
      datasources
        ai_chat_service.dart - device-api-web `/aic` REST·SSE 통신.
        ai_chat_sqlite_service.dart - AI 채팅 로컬 SQLite CRUD.
        ai_chat_server_connection_service.dart - AI 채팅 서버 연결 확인.
      repositories
        ai_chat_remote_repository_impl.dart - AI 채팅 원격 Repository (질의·목록·삭제).
        ai_chat_repository_impl.dart - 서버/SQLite 모드에 따라 저장소 선택.
        ai_chat_sqlite_repository_impl.dart - AI 채팅 로컬 SQLite Repository.
    barcode
      datasources
        barcode_service.dart - 바코드/QR 스캔 및 서버·로컬 저장 처리.
        barcode_sqlite_service.dart - 바코드 데이터의 로컬 SQLite CRUD 및 DB 연동.
        barcode_server_connection_service.dart - 바코드 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        barcode_remote_repository_impl.dart - 바코드 Repository의 서버(원격) 데이터 소스 구현체.
        barcode_repository_impl.dart - 바코드 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        barcode_sqlite_repository_impl.dart - 바코드 Repository의 로컬 SQLite 데이터 소스 구현체.
    compass
      datasources
        compass_service.dart - 나침반(방위각) 센서 데이터 수집 및 저장.
        compass_sqlite_service.dart - 나침반 데이터의 로컬 SQLite CRUD 및 DB 연동.
        compass_server_connection_service.dart - 나침반 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        compass_remote_repository_impl.dart - 나침반 Repository의 서버(원격) 데이터 소스 구현체.
        compass_repository_impl.dart - 나침반 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        compass_sqlite_repository_impl.dart - 나침반 Repository의 로컬 SQLite 데이터 소스 구현체.
    contacts
      datasources
        contacts_service.dart - 기기 연락처 읽기 및 서버 동기화.
        contacts_sqlite_service.dart - 연락처 데이터의 로컬 SQLite CRUD 및 DB 연동.
        contacts_server_connection_service.dart - 연락처 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        contacts_remote_repository_impl.dart - 연락처 Repository의 서버(원격) 데이터 소스 구현체.
        contacts_repository_impl.dart - 연락처 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        contacts_sqlite_repository_impl.dart - 연락처 Repository의 로컬 SQLite 데이터 소스 구현체.
    deviceInfo
      datasources
        device_service.dart - 기기 하드웨어/소프트웨어 정보 수집 및 서버 전송.
        device_sqlite_service.dart - 기기 정보 데이터의 로컬 SQLite CRUD 및 DB 연동.
        device_server_connection_service.dart - 기기 정보 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        device_remote_repository_impl.dart - 기기 정보 Repository의 서버(원격) 데이터 소스 구현체.
        device_repository_impl.dart - 기기 정보 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        device_sqlite_repository_impl.dart - 기기 정보 Repository의 로컬 SQLite 데이터 소스 구현체.
    faceMesh
      datasources
        face_mesh_service.dart - MediaPipe Face Mesh 검출 서비스.
        face_mesh_sqlite_service.dart - 얼굴 메시 로컬 SQLite CRUD.
        face_mesh_server_connection_service.dart - 얼굴 메시 서버 연결 확인.
      repositories
        face_mesh_remote_repository_impl.dart - 얼굴 메시 원격 Repository.
        face_mesh_repository_impl.dart - 서버/SQLite 모드 조합.
        face_mesh_sqlite_repository_impl.dart - 얼굴 메시 로컬 SQLite Repository.
    fileMgmt
      datasources
        file_management_service.dart - 파일 시스템 탐색·관리(목록, 삭제 등).
      repositories
        file_mgmt_repository_impl.dart - FileMgmtRepository 구현. FileManagementService 위임.
    fileopener
      datasources
        file_opener_service.dart - 다양한 형식의 파일 열기(외부 앱 연동).
        file_opener_sqlite_service.dart - fileopener 데이터의 로컬 SQLite CRUD 및 DB 연동.
        file_opener_server_connection_service.dart - 파일 열기 기능의 서버 REST API 연결·동기화 서비스.
      models
        downloaded_file_data.dart - 서버에서 다운로드한 파일의 메타데이터(경로, 이름, 크기 등) 모델.
      repositories
        file_opener_remote_repository_impl.dart - fileopener Repository의 서버(원격) 데이터 소스 구현체.
        file_opener_repository_impl.dart - 파일 열기 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        file_opener_sqlite_repository_impl.dart - fileopener Repository의 로컬 SQLite 데이터 소스 구현체.
    fileReadWrite
      datasources
        file_readwrite_service.dart - 텍스트/JSON 파일 읽기·쓰기 및 서버 업로드/다운로드.
        file_readwrite_sqlite_service.dart - file_readwrite 데이터의 로컬 SQLite CRUD 및 DB 연동.
        file_readwrite_server_connection_service.dart - 파일 읽기/쓰기 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        file_readwrite_repository_impl.dart - 파일 읽기/쓰기 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        file_remote_repository_impl.dart - 파일 읽기/쓰기 Repository의 서버(원격) 데이터 소스 구현체.
        file_sqlite_repository_impl.dart - 파일 읽기/쓰기 Repository의 로컬 SQLite 데이터 소스 구현체.
    gps
      datasources
        gps_service.dart - GPS 위치 정보 수집 및 서버 전송.
        gps_sqlite_service.dart - gps 데이터의 로컬 SQLite CRUD 및 DB 연동.
        gps_server_connection_service.dart - GPS 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        gps_remote_repository_impl.dart - gps Repository의 서버(원격) 데이터 소스 구현체.
        gps_repository_impl.dart - GPS Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        gps_sqlite_repository_impl.dart - gps Repository의 로컬 SQLite 데이터 소스 구현체.
    interface
      datasources
        interface_service.dart - UI 인터페이스(화면 전환 등) API 연동.
        interface_sqlite_service.dart - interface 데이터의 로컬 SQLite CRUD 및 DB 연동.
        interface_server_connection_service.dart - 인터페이스 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        interface_remote_repository_impl.dart - interface Repository의 서버(원격) 데이터 소스 구현체.
        interface_repository_impl.dart - 인터페이스 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        interface_sqlite_repository_impl.dart - interface Repository의 로컬 SQLite 데이터 소스 구현체.
    iot
      datasources
        iot_mqtt_service.dart - RabbitMQ MQTT 텔레메트리 구독·명령 전송.
        iot_remote_service.dart - IoT 이력 서버 REST.
        iot_sqlite_service.dart - IoT 로컬 SQLite CRUD.
        iot_server_connection_service.dart - IoT 서버 연결 확인.
      repositories
        iot_remote_repository_impl.dart - IoT 원격 Repository.
        iot_repository_impl.dart - MQTT/서버/SQLite 조합.
        iot_sqlite_repository_impl.dart - IoT 로컬 SQLite Repository.
    media
      datasources
        media_service.dart - 이미지/동영상 촬영·선택 및 서버 업로드.
        media_sqlite_service.dart - media 데이터의 로컬 SQLite CRUD 및 DB 연동.
        media_server_connection_service.dart - 미디어 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        media_remote_repository_impl.dart - media Repository의 서버(원격) 데이터 소스 구현체.
        media_repository_impl.dart - 미디어 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        media_sqlite_repository_impl.dart - media Repository의 로컬 SQLite 데이터 소스 구현체.
    network
      datasources
        network_service.dart - 네트워크 연결 상태·인터페이스 정보 조회.
        network_sqlite_service.dart - network 데이터의 로컬 SQLite CRUD 및 DB 연동.
        network_server_connection_service.dart - 네트워크 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        network_remote_repository_impl.dart - network Repository의 서버(원격) 데이터 소스 구현체.
        network_repository_impl.dart - 네트워크 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        network_sqlite_repository_impl.dart - network Repository의 로컬 SQLite 데이터 소스 구현체.
    push
      datasources
        firebase_messaging_service.dart - Firebase Cloud Messaging 초기화 및 푸시 수신 처리.
        push_service.dart - 푸시 디바이스 등록 및 메시지 관리.
        push_sqlite_service.dart - 푸시 데이터의 로컬 SQLite CRUD 및 DB 연동.
        push_server_connection_service.dart - 푸시 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        push_remote_repository_impl.dart - 푸시 Repository의 서버(원격) 데이터 소스 구현체.
        push_repository_impl.dart - 푸시 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        push_sqlite_repository_impl.dart - 푸시 Repository의 로컬 SQLite 데이터 소스 구현체.
    socket
      datasources
        socket_service.dart - WebSocket 실시간 채팅 메시지 송수신.
        socket_sqlite_service.dart - 소켓(WebSocket) 데이터의 로컬 SQLite CRUD 및 DB 연동.
        socket_server_connection_service.dart - 소켓(WebSocket) 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        socket_remote_repository_impl.dart - 소켓(WebSocket) Repository의 서버(원격) 데이터 소스 구현체.
        socket_repository_impl.dart - 소켓(WebSocket) Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        socket_sqlite_repository_impl.dart - 소켓(WebSocket) Repository의 로컬 SQLite 데이터 소스 구현체.
    streaming
      datasources
        streaming_service.dart - 스트리밍 미디어 업로드·재생 연동.
        streaming_sqlite_service.dart - 스트리밍 데이터의 로컬 SQLite CRUD 및 DB 연동.
        streaming_server_connection_service.dart - 스트리밍 기능의 서버 REST API 연결·동기화 서비스.
      repositories
        streaming_remote_repository_impl.dart - 스트리밍 Repository의 서버(원격) 데이터 소스 구현체.
        streaming_repository_impl.dart - 스트리밍 Repository 구현체. 로컬·서버 데이터 소스 조합 및 도메인 변환.
        streaming_sqlite_repository_impl.dart - 스트리밍 Repository의 로컬 SQLite 데이터 소스 구현체.
  di
    accelerator_connection_provider.dart - accelerator 기능의 연결 모드(로컬/서버) 상태 Provider.
    accelerator_connection_provider.g.dart - accelerator_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    ai_chat_connection_provider.dart - AI 채팅 연결 모드(서버/SQLite) Provider.
    ai_chat_connection_provider.g.dart - ai_chat_connection_provider.dart의 Riverpod 코드 생성 파일.
    barcode_connection_provider.dart - 바코드 기능의 연결 모드(로컬/서버) 상태 Provider.
    barcode_connection_provider.g.dart - barcode_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    compass_connection_provider.dart - 나침반 기능의 연결 모드(로컬/서버) 상태 Provider.
    compass_connection_provider.g.dart - compass_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    contacts_connection_provider.dart - 연락처 기능의 연결 모드(로컬/서버) 상태 Provider.
    contacts_connection_provider.g.dart - contacts_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    device_connection_provider.dart - device 기능의 연결 모드(로컬/서버) 상태 Provider.
    device_connection_provider.g.dart - device_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    face_mesh_connection_provider.dart - 얼굴 메시 연결 모드 Provider.
    face_mesh_connection_provider.g.dart - face_mesh_connection_provider.dart의 Riverpod 코드 생성 파일.
    file_readwrite_connection_provider.dart - file_readwrite 기능의 연결 모드(로컬/서버) 상태 Provider.
    file_readwrite_connection_provider.g.dart - file_readwrite_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    fileopener_connection_provider.dart - fileopener 기능의 연결 모드(로컬/서버) 상태 Provider.
    fileopener_connection_provider.g.dart - fileopener_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    gps_connection_provider.dart - gps 기능의 연결 모드(로컬/서버) 상태 Provider.
    gps_connection_provider.g.dart - gps_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    interface_connection_provider.dart - interface 기능의 연결 모드(로컬/서버) 상태 Provider.
    interface_connection_provider.g.dart - interface_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    iot_connection_provider.dart - IoT 연결 모드 Provider.
    iot_connection_provider.g.dart - iot_connection_provider.dart의 Riverpod 코드 생성 파일.
    media_connection_provider.dart - media 기능의 연결 모드(로컬/서버) 상태 Provider.
    media_connection_provider.g.dart - media_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    network_connection_provider.dart - network 기능의 연결 모드(로컬/서버) 상태 Provider.
    network_connection_provider.g.dart - network_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    providers.dart - Riverpod 기반 전역 의존성 주입. Service·Repository·UseCase Provider 등록.
    providers.g.dart - providers.dart의 Riverpod 코드 생성 파일.
    push_connection_provider.dart - 푸시 기능의 연결 모드(로컬/서버) 상태 Provider.
    push_connection_provider.g.dart - push_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    socket_connection_provider.dart - 소켓(WebSocket) 기능의 연결 모드(로컬/서버) 상태 Provider.
    socket_connection_provider.g.dart - socket_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    streaming_connection_provider.dart - 스트리밍 기능의 연결 모드(로컬/서버) 상태 Provider.
    streaming_connection_provider.g.dart - streaming_connection_provider.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
    sqlite_manager_provider.dart - SQLite Manager Provider.
    sqlite_manager_provider.g.dart - sqlite_manager_provider.dart의 Riverpod 코드 생성 파일.
  domain
    accelerator
      entities
        accelerator_connection_mode.dart - accelerator 연결 모드(로컬/서버) 열거형.
        accelerator_data_source_status.dart - accelerator 데이터 소스 연결 상태 모델.
        accelerator_info.dart - 가속도계 핵심 정보 엔티티.
        accelerator_uuid_guard.dart - 가속도계 레코드의 디바이스 UUID 소유권 검증.
        accelerator_result.dart - 가속도계 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        accelerator_repository.dart - 가속도계 Repository 인터페이스.
      usecases
        accelerator_usecase.dart - accelerator 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    aiChat
      entities
        ai_chat_connection_mode.dart - AI 채팅 연결 모드(서버/SQLite).
        ai_chat_data_source_status.dart - AI 채팅 데이터 소스 연결 상태.
        ai_chat_info.dart - 질문-답변 행 엔티티 (AI_CHAT_INFO).
        ai_chat_result.dart - 질의·목록·삭제 UseCase 결과.
        ai_chat_session.dart - sessionId로 묶은 대화 세션.
      repositories
        ai_chat_repository.dart - AI 채팅 Repository 인터페이스.
      usecases
        ai_chat_usecase.dart - 질의(SSE)·목록·삭제 비즈니스 로직.
    barcode
      entities
        barcode_connection_mode.dart - 바코드 연결 모드(로컬/서버/하이브리드 등) 열거형.
        barcode_data_source_status.dart - 바코드 데이터 소스(로컬·서버) 연결 상태 모델.
        barcode_info.dart - 바코드 핵심 정보 엔티티.
        barcode_result.dart - 바코드 API/UseCase 실행 결과(성공·실패·메시지) 모델.
        barcode_scan.dart - 바코드 스캔 1회 결과(값, 형식, 시각).
        barcode_scan_session_result.dart - 바코드 스캔 세션 전체 결과 집계.
        barcode_uuid_guard.dart - 바코드 기능에서 디바이스 UUID 일치 여부 검증.
      repositories
        barcode_repository.dart - barcode_repository 관련 코드.
      usecases
        barcode_usecase.dart - barcode 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    compass
      entities
        compass_connection_mode.dart - 나침반 연결 모드(로컬/서버/하이브리드 등) 열거형.
        compass_data_source_status.dart - 나침반 데이터 소스(로컬·서버) 연결 상태 모델.
        compass_heading.dart - 나침반 방위각(heading) 측정값.
        compass_info.dart - 나침반 핵심 정보 엔티티.
        compass_result.dart - 나침반 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        compass_repository.dart - compass_repository 관련 코드.
      usecases
        compass_usecase.dart - compass 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    contacts
      entities
        contact_preview.dart - 연락처 미리보기용 요약 정보.
        contacts_connection_mode.dart - 연락처 연결 모드(로컬/서버/하이브리드 등) 열거형.
        contacts_data_source_status.dart - 연락처 데이터 소스(로컬·서버) 연결 상태 모델.
        contacts_device_guard.dart - contacts device guard 관련 파일.
        contacts_info.dart - 연락처 핵심 정보 엔티티.
        contacts_result.dart - 연락처 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        contacts_repository.dart - contacts_repository 관련 코드.
      usecases
        contacts_usecase.dart - contacts 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    deviceInfo
      entities
        device_connection_mode.dart - device 연결 모드(로컬/서버) 열거형.
        device_data_source_status.dart - device 데이터 소스 연결 상태 모델.
        device_info.dart - 기기 정보 핵심 정보 엔티티.
        device_uuid_guard.dart - 기기 정보 레코드의 디바이스 UUID 소유권 검증.
        device_result.dart - 기기 정보 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        device_repository.dart - device_repository 관련 코드.
      usecases
        device_usecase.dart - device 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    faceMesh
      entities
        face_mesh_connection_mode.dart - 얼굴 메시 연결 모드.
        face_mesh_data_source_status.dart - 얼굴 메시 데이터 소스 상태.
        face_mesh_geometry.dart - 랜드마크 기하.
        face_mesh_group.dart - 저장 그룹.
        face_mesh_info.dart - 얼굴 메시 세션 정보.
        face_mesh_record.dart - 저장 행.
        face_mesh_result.dart - UseCase 결과.
        face_mesh_uuid_guard.dart - UUID 검증.
      repositories
        face_mesh_repository.dart - 얼굴 메시 Repository 인터페이스.
      usecases
        face_mesh_usecase.dart - 얼굴 메시 검출·저장 UseCase.
    fileMgmt
      entities
        file_mgmt_result.dart - 파일 관리 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        file_mgmt_repository.dart - 로컬 파일 시스템 Repository 인터페이스.
      usecases
        file_mgmt_usecase.dart - 폴더/파일 생성·복사·이동·삭제 비즈니스 로직.
    fileopener
      entities
        file_opener_info.dart - 파일 열기 핵심 정보 엔티티.
        fileopener_connection_mode.dart - fileopener 연결 모드(로컬/서버) 열거형.
        fileopener_data_source_status.dart - fileopener 데이터 소스 연결 상태 모델.
        fileopener_result.dart - 파일 열기 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        fileopener_repository.dart - fileopener_repository 관련 코드.
      usecases
        fileopener_server_usecase.dart - fileopener 서버 연동 비즈니스 로직(UseCase).
    fileReadWrite
      entities
        file_readwrite_connection_mode.dart - file_readwrite 연결 모드(로컬/서버) 열거형.
        file_readwrite_data_source_status.dart - file_readwrite 데이터 소스 연결 상태 모델.
        file_readwrite_info.dart - 파일 읽기/쓰기 핵심 정보 엔티티.
        file_readwrite_result.dart - 파일 읽기/쓰기 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        file_readwrite_repository.dart - file_readwrite_repository 관련 코드.
      usecases
        file_readwrite_usecase.dart - file_readwrite 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    gps
      entities
        gps_connection_mode.dart - gps 연결 모드(로컬/서버) 열거형.
        gps_data_source_status.dart - gps 데이터 소스 연결 상태 모델.
        gps_info.dart - GPS 핵심 정보 엔티티.
        gps_result.dart - GPS API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        gps_repository.dart - gps_repository 관련 코드.
      usecases
        gps_usecase.dart - gps 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    interface
      entities
        interface_connection_mode.dart - interface 연결 모드(로컬/서버) 열거형.
        interface_data_source_status.dart - interface 데이터 소스 연결 상태 모델.
        interface_info.dart - 인터페이스 핵심 정보 엔티티.
        interface_result.dart - 인터페이스 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        interface_repository.dart - interface_repository 관련 코드.
      usecases
        interface_usecase.dart - interface 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    iot
      entities
        iot_broker_config.dart - MQTT 브로커 설정.
        iot_connection_mode.dart - IoT 연결 모드.
        iot_data_source_status.dart - IoT 데이터 소스 상태.
        iot_message_info.dart - IoT 메시지 엔티티.
        iot_message_log.dart - IoT 로그.
        iot_result.dart - UseCase 결과.
        iot_telemetry.dart - 텔레메트리.
      repositories
        iot_repository.dart - IoT Repository 인터페이스.
      usecases
        iot_usecase.dart - MQTT 구독·명령·이력 UseCase.
    media
      entities
        media_connection_mode.dart - media 연결 모드(로컬/서버) 열거형.
        media_data_source_status.dart - media 데이터 소스 연결 상태 모델.
        media_info.dart - 미디어 핵심 정보 엔티티.
        media_uuid_guard.dart - 미디어 레코드의 디바이스 UUID 소유권 검증.
        media_result.dart - 미디어 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        media_repository.dart - media_repository 관련 코드.
      usecases
        media_usecase.dart - media 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    network
      entities
        network_connection_mode.dart - network 연결 모드(로컬/서버) 열거형.
        network_data_source_status.dart - network 데이터 소스 연결 상태 모델.
        network_info.dart - 네트워크 핵심 정보 엔티티.
        network_uuid_guard.dart - 네트워크 레코드의 디바이스 UUID 소유권 검증.
        network_result.dart - 네트워크 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        network_repository.dart - network_repository 관련 코드.
      usecases
        network_usecase.dart - network 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    push
      entities
        push_connection_mode.dart - 푸시 연결 모드(로컬/서버/하이브리드 등) 열거형.
        push_data_source_status.dart - 푸시 데이터 소스(로컬·서버) 연결 상태 모델.
        push_device_info.dart - 푸시 등록 디바이스 정보(FCM 토큰 등).
        push_message_info.dart - 수신·발송 푸시 메시지 정보.
        push_result.dart - 푸시 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        push_repository.dart - push_repository 관련 코드.
      usecases
        push_usecase.dart - push 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    shared
      entities
        app_item.dart - 앱 목록에 표시되는 기능 모듈 항목(이름, 아이콘, 라우트).
        server_connection_result.dart - 서버 연결 시도 결과 모델.
      json_read.dart - entity fromJson 공용 파서.
    socket
      entities
        socket_connection_mode.dart - 소켓(WebSocket) 연결 모드(로컬/서버/하이브리드 등) 열거형.
        socket_data_source_status.dart - 소켓(WebSocket) 데이터 소스(로컬·서버) 연결 상태 모델.
        socket_message_info.dart - WebSocket 채팅 메시지 엔티티.
        socket_result.dart - 소켓(WebSocket) API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        socket_repository.dart - socket_repository 관련 코드.
      usecases
        socket_usecase.dart - socket 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
    streaming
      entities
        streaming_connection_mode.dart - 스트리밍 연결 모드(로컬/서버/하이브리드 등) 열거형.
        streaming_data_source_status.dart - 스트리밍 데이터 소스(로컬·서버) 연결 상태 모델.
        streaming_media_info.dart - 스트리밍 미디어 메타데이터.
        streaming_result.dart - 스트리밍 API/UseCase 실행 결과(성공·실패·메시지) 모델.
      repositories
        streaming_repository.dart - streaming_repository 관련 코드.
      usecases
        streaming_usecase.dart - streaming 비즈니스 로직(UseCase). Repository를 통해 데이터 조작.
  l10n
    message_keys
      accelerator_message_keys.dart - accelerator 기능의 서버/도메인 메시지 키 상수 정의.
      ai_chat_message_keys.dart - AI 채팅 도메인 메시지 키.
      barcode_message_keys.dart - barcode 기능의 서버/도메인 메시지 키 상수 정의.
      compass_message_keys.dart - compass 기능의 서버/도메인 메시지 키 상수 정의.
      contacts_message_keys.dart - contacts 기능의 서버/도메인 메시지 키 상수 정의.
      device_info_message_keys.dart - device info 기능의 서버/도메인 메시지 키 상수 정의.
      face_mesh_message_keys.dart - 얼굴 메시 메시지 키.
      file_mgmt_message_keys.dart - file mgmt 기능의 서버/도메인 메시지 키 상수 정의.
      file_opener_message_keys.dart - file opener 기능의 서버/도메인 메시지 키 상수 정의.
      file_readwrite_message_keys.dart - file readwrite 기능의 서버/도메인 메시지 키 상수 정의.
      gps_message_keys.dart - gps 기능의 서버/도메인 메시지 키 상수 정의.
      interface_message_keys.dart - interface 기능의 서버/도메인 메시지 키 상수 정의.
      iot_message_keys.dart - IoT 메시지 키.
      media_message_keys.dart - media 기능의 서버/도메인 메시지 키 상수 정의.
      network_message_keys.dart - network 기능의 서버/도메인 메시지 키 상수 정의.
      push_message_keys.dart - push 기능의 서버/도메인 메시지 키 상수 정의.
      socket_message_keys.dart - socket 기능의 서버/도메인 메시지 키 상수 정의.
      streaming_message_keys.dart - streaming 기능의 서버/도메인 메시지 키 상수 정의.
    app_en.arb - 영문 UI 문자열 리소스(ARB 형식).
    app_ko.arb - 한국어 UI 문자열 리소스(ARB 형식).
    app_localizations.dart - 다국어 지원 추상 클래스 및 delegate 정의.
    app_localizations_en.dart - 영문 AppLocalizations 구현체.
    app_localizations_ko.dart - 한국어 AppLocalizations 구현체.
    app_message_resolver.dart - 서버/도메인 메시지 키를 로컬라이즈된 문자열로 변환하는 리졸버.
  presentation
    resources
      color_style.dart - 앱 전역 색상 팔레트(EgovColor) 정의.
      text_service.dart - 텍스트 관련 공통 서비스(스타일 적용 등).
      text_style.dart - 앱 전역 텍스트 스타일 정의.
    screens
      accelerator
        state
          accelerator_state.dart - 가속도계 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          accelerator_description.dart - 기능 설명(가이드) 화면.
          accelerator_detail.dart - 상세 정보 표시 화면.
          accelerator_info.dart - accelerator_info 화면 위젯.
          accelerator_list.dart - 목록 조회 화면.
        view_model
          accelerator_connection_status_controller.dart - accelerator_connection_status 화면 상태/동작 컨트롤러.
          accelerator_connection_status_controller.g.dart - Riverpod 코드 생성 파일(build_runner 자동 생성).
          accelerator_controller.dart - 가속도계 화면 상태·이벤트 처리 Riverpod Controller.
          accelerator_controller.g.dart - accelerator_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          accelerator_connection_resolver.dart - accelerator connection resolver 관련 파일.
          accelerator_connection_status_card.dart - accelerator connection status card 관련 파일.
          accelerator_widget.dart - 가속도 3축 값 실시간 표시 위젯.
          three_d_cube.dart - 가속도 변화를 3D 큐브로 시각화.
      aiChat
        state
          ai_chat_state.dart - 메인 채팅·세션 목록 UI 상태.
        view
          ai_chat_description.dart - 기능 설명 탭.
          ai_chat_detail.dart - 세션 상세 대화.
          ai_chat_list.dart - 세션 목록·다중 삭제.
          ai_chat_main.dart - 채팅 메인 (`AiChatPage`).
        view_model
          ai_chat_connection_status_controller.dart - 서버/SQLite 연결 상태.
          ai_chat_connection_status_controller.g.dart - Riverpod 코드 생성 파일.
          ai_chat_controller.dart - 질의 SSE·목록·삭제 컨트롤러.
          ai_chat_controller.g.dart - Riverpod 코드 생성 파일.
        widgets
          ai_chat_connection_bar.dart - 메인 화면 연결 바.
          ai_chat_ai_server_banner.dart - AI 서버(ai-rag) 미연결 안내. 채팅 화면과 저장 목록에 표시.
          ai_chat_connection_resolver.dart - 질의는 서버 필수, 목록은 서버/SQLite.
          ai_chat_connection_status_card.dart - 연결 상태 카드.
          ai_chat_overview.dart - RAG/일반 칩·입력창.
          ai_chat_transcript.dart - 말풍선·마크다운·think 숨김.
      barcode
        state
          barcode_state.dart - 바코드 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          barcode_description.dart - 기능 설명(가이드) 화면.
          barcode_list.dart - 목록 조회 화면.
          barcode_main.dart - 기능 메인(탭/셸) 화면.
          barcode_scan_page.dart - 바코드 스캔 카메라 화면.
        view_model
          barcode_connection_status_controller.dart - 바코드 서버/로컬 연결 상태 관리 Riverpod Controller.
          barcode_connection_status_controller.g.dart - barcode_connection_status_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
          barcode_controller.dart - 바코드 화면 상태·이벤트 처리 Riverpod Controller.
          barcode_controller.g.dart - barcode_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          barcode_card.dart - 목록 항목 카드 UI.
          barcode_connection_resolver.dart - 로컬/서버 데이터 소스 선택 및 연결 해석 위젯.
          barcode_connection_status_card.dart - 서버·로컬 연결 상태를 표시하는 카드 위젯.
          barcode_overview.dart - 기능 요약(최근 데이터·상태) 오버레이/패널.
          barcode_permission_util.dart - 해당 기능에 필요한 권한 요청 유틸리티.
      compass
        state
          compass_state.dart - 나침반 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          compass_description.dart - 기능 설명(가이드) 화면.
          compass_list.dart - 목록 조회 화면.
          compass_main.dart - 기능 메인(탭/셸) 화면.
        view_model
          compass_connection_status_controller.dart - 나침반 서버/로컬 연결 상태 관리 Riverpod Controller.
          compass_connection_status_controller.g.dart - compass_connection_status_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
          compass_controller.dart - 나침반 화면 상태·이벤트 처리 Riverpod Controller.
          compass_controller.g.dart - compass_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          compass_connection_resolver.dart - 로컬/서버 데이터 소스 선택 및 연결 해석 위젯.
          compass_connection_status_card.dart - 서버·로컬 연결 상태를 표시하는 카드 위젯.
          compass_dial.dart - 원형 다이얼(나침반/푸시 등) 시각화 위젯.
          compass_overview.dart - 기능 요약(최근 데이터·상태) 오버레이/패널.
          compass_permission_util.dart - 해당 기능에 필요한 권한 요청 유틸리티.
      contacts
        state
          contacts_state.dart - 연락처 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          contacts_description.dart - 기능 설명(가이드) 화면.
          contacts_device_list.dart - 목록 조회 화면.
          contacts_list.dart - 목록 조회 화면.
          contacts_main.dart - 기능 메인(탭/셸) 화면.
        view_model
          contacts_connection_status_controller.dart - 연락처 서버/로컬 연결 상태 관리 Riverpod Controller.
          contacts_connection_status_controller.g.dart - contacts_connection_status_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
          contacts_controller.dart - 연락처 화면 상태·이벤트 처리 Riverpod Controller.
          contacts_controller.g.dart - contacts_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          contacts_card.dart - 목록 항목 카드 UI.
          contacts_connection_resolver.dart - 로컬/서버 데이터 소스 선택 및 연결 해석 위젯.
          contacts_connection_status_card.dart - 서버·로컬 연결 상태를 표시하는 카드 위젯.
          contacts_overview.dart - 기능 요약(최근 데이터·상태) 오버레이/패널.
          contacts_permission_util.dart - 해당 기능에 필요한 권한 요청 유틸리티.
      deviceInfo
        state
          device_state.dart - 기기 정보 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          device_info_description.dart - 기능 설명(가이드) 화면.
          device_info_detailed.dart - 상세 정보 표시 화면.
          device_info_list.dart - 목록 조회 화면.
          device_info_main.dart - 기능 메인(탭/셸) 화면.
        view_model
          device_connection_status_controller.dart - device_connection_status 화면 상태/동작 컨트롤러.
          device_connection_status_controller.g.dart - Riverpod 코드 생성 파일(build_runner 자동 생성).
          device_controller.dart - 기기 정보 화면 상태·이벤트 처리 Riverpod Controller.
          device_controller.g.dart - device_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          device_card.dart - 목록 항목 카드 UI.
          device_connection_resolver.dart - device connection resolver 관련 파일.
          device_connection_status_card.dart - device connection status card 관련 파일.
          device_info_overview.dart - 기능 요약(최근 데이터·상태) 오버레이/패널.
      faceMesh
        state
          face_mesh_state.dart - 얼굴 메시 화면 상태.
        view
          face_mesh_camera_page.dart - 실시간 카메라.
          face_mesh_description.dart - 기능 설명.
          face_mesh_detailed.dart - 상세.
          face_mesh_group_faces.dart - 그룹 얼굴 목록.
          face_mesh_list.dart - 목록.
          face_mesh_main.dart - 메인.
        view_model
          face_mesh_connection_status_controller.dart - 연결 상태 컨트롤러.
          face_mesh_connection_status_controller.g.dart - Riverpod 코드 생성 파일.
          face_mesh_controller.dart - 얼굴 메시 화면 컨트롤러.
          face_mesh_controller.g.dart - Riverpod 코드 생성 파일.
        widgets
          face_coordinates_translator.dart - 좌표 변환.
          face_mesh_connection_resolver.dart - 연결 해석.
          face_mesh_connection_status_card.dart - 연결 상태 카드.
          face_mesh_group_tracking_preview.dart - 그룹 트래킹 미리보기.
          face_mesh_overview.dart - 오버뷰.
          face_mesh_permission_util.dart - 권한.
          face_mesh_tracking_preview.dart - 트래킹 미리보기.
          face_painter.dart - 메시 오버레이 페인터.
      fileMgmt
        state
          file_mgmt_state.dart - 파일 관리 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          file_mgmt_description.dart - 기능 설명(가이드) 화면. Face Mesh와 같은 FunctionPage + l10n.
          file_mgmt_main.dart - FileMgmtPage. FeatureShell(서버 연결 없음).
        view_model
          file_mgmt_controller.dart - 경로 히스토리·선택 모드 Riverpod Controller. 파일 작업은 UseCase.
          file_mgmt_controller.g.dart - file_mgmt_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          file_mgmt_overview.dart - 경로 바 + 파일 목록.
          file_mgmt_file_card.dart - 파일/폴더 한 줄 카드.
          file_mgmt_selection_bar.dart - 선택 모드 하단 바.
          file_mgmt_folder_picker.dart - 복사/이동 대상 폴더 선택.
      fileopener
        state
          fileopener_state.dart - 파일 열기 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          fileopener_description.dart - 기능 설명(가이드) 화면.
          fileopener_detail.dart - 상세 정보 표시 화면.
          fileopener_list.dart - 목록 조회 화면.
          fileopener_main.dart - 기능 메인(탭/셸) 화면.
        view_model
          fileopener_connection_status_controller.dart - fileopener_connection_status 화면 상태/동작 컨트롤러.
          fileopener_connection_status_controller.g.dart - Riverpod 코드 생성 파일(build_runner 자동 생성).
          fileopener_controller.dart - 파일 열기 화면 상태·이벤트 처리 Riverpod Controller.
          fileopener_controller.g.dart - fileopener_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          fileopener_connection_resolver.dart - fileopener connection resolver 관련 파일.
          fileopener_connection_status_card.dart - fileopener connection status card 관련 파일.
      fileReadWrite
        state
          file_readwrite_state.dart - 파일 읽기/쓰기 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          file_readwrite_description.dart - 기능 설명(가이드) 화면.
          file_readwrite_detail.dart - 상세 정보 표시 화면.
          file_readwrite_list.dart - 목록 조회 화면.
          file_readwrite_local_detail.dart - 상세 정보 표시 화면.
          file_readwrite_main.dart - 기능 메인(탭/셸) 화면.
        view_model
          file_readwrite_connection_status_controller.dart - file_readwrite_connection_status 화면 상태/동작 컨트롤러.
          file_readwrite_connection_status_controller.g.dart - Riverpod 코드 생성 파일(build_runner 자동 생성).
          file_readwrite_controller.dart - 파일 읽기/쓰기 화면 상태·이벤트 처리 Riverpod Controller.
          file_readwrite_controller.g.dart - file_readwrite_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          file_readwrite_connection_resolver.dart - file readwrite connection resolver 관련 파일.
          file_readwrite_connection_status_card.dart - file readwrite connection status card 관련 파일.
      gps
        state
          gps_state.dart - GPS 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          gps_description.dart - 기능 설명(가이드) 화면.
          gps_detail.dart - 상세 정보 표시 화면.
          gps_list.dart - 목록 조회 화면.
          gps_main.dart - 기능 메인(탭/셸) 화면.
        view_model
          gps_connection_status_controller.dart - gps_connection_status 화면 상태/동작 컨트롤러.
          gps_connection_status_controller.g.dart - Riverpod 코드 생성 파일(build_runner 자동 생성).
          gps_controller.dart - GPS 화면 상태·이벤트 처리 Riverpod Controller.
          gps_controller.g.dart - gps_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          gps_connection_resolver.dart - gps connection resolver 관련 파일.
          gps_connection_status_card.dart - gps connection status card 관련 파일.
          gps_location_display.dart - GPS 좌표·주소 텍스트 표시.
          gps_map_fallback.dart - 지도 로드 실패 시 대체 UI.
          minimal_map_widget.dart - Google Maps 최소 지도 위젯.
      interface
        state
          interface_state.dart - 인터페이스 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          interface_description.dart - 기능 설명(가이드) 화면.
          interface_main.dart - 기능 메인(탭/셸) 화면.
          interface_success.dart - 작업 성공 결과 화면.
        view_model
          interface_connection_status_controller.dart - interface_connection_status 화면 상태/동작 컨트롤러.
          interface_connection_status_controller.g.dart - Riverpod 코드 생성 파일(build_runner 자동 생성).
          interface_controller.dart - 인터페이스 화면 상태·이벤트 처리 Riverpod Controller.
          interface_controller.g.dart - interface_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          interface_connection_resolver.dart - interface connection resolver 관련 파일.
          interface_connection_status_card.dart - interface connection status card 관련 파일.
      iot
        state
          iot_state.dart - IoT 화면 상태.
        view
          iot_broker.dart - MQTT 브로커 설정.
          iot_description.dart - 기능 설명.
          iot_list.dart - 실시간 로그 목록.
          iot_main.dart - 메인.
          iot_saved_list.dart - 저장된 이력.
        view_model
          iot_connection_status_controller.dart - 연결 상태 컨트롤러.
          iot_connection_status_controller.g.dart - Riverpod 코드 생성 파일.
          iot_controller.dart - IoT 화면 컨트롤러.
          iot_controller.g.dart - Riverpod 코드 생성 파일.
        widgets
          iot_broker_form.dart - 브로커 입력 폼.
          iot_connection_resolver.dart - 연결 해석.
          iot_connection_status_card.dart - 연결 상태 카드.
          iot_log_card.dart - 실시간 로그 카드.
          iot_overview.dart - 오버뷰.
          iot_saved_log_card.dart - 저장 로그 카드.
      media
        state
          media_state.dart - 미디어 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          media_description.dart - 기능 설명(가이드) 화면.
          media_detail.dart - 상세 정보 표시 화면.
          media_list.dart - 목록 조회 화면.
          media_main.dart - 기능 메인(탭/셸) 화면.
          video_player_screen.dart - 동영상 재생 전용 화면.
        view_model
          media_connection_status_controller.dart - media_connection_status 화면 상태/동작 컨트롤러.
          media_connection_status_controller.g.dart - Riverpod 코드 생성 파일(build_runner 자동 생성).
          media_controller.dart - 미디어 화면 상태·이벤트 처리 Riverpod Controller.
          media_controller.g.dart - media_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          media_connection_resolver.dart - media connection resolver 관련 파일.
          media_connection_status_card.dart - media connection status card 관련 파일.
      network
        state
          network_state.dart - 네트워크 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          network_description.dart - 기능 설명(가이드) 화면.
          network_detail.dart - 상세 정보 표시 화면.
          network_list.dart - 목록 조회 화면.
          network_main.dart - 기능 메인(탭/셸) 화면.
        view_model
          network_connection_status_controller.dart - network_connection_status 화면 상태/동작 컨트롤러.
          network_connection_status_controller.g.dart - Riverpod 코드 생성 파일(build_runner 자동 생성).
          network_controller.dart - 네트워크 화면 상태·이벤트 처리 Riverpod Controller.
          network_controller.g.dart - network_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          network_connection_resolver.dart - network connection resolver 관련 파일.
          network_connection_status_card.dart - network connection status card 관련 파일.
      push
        state
          push_state.dart - 푸시 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          push_description.dart - 기능 설명(가이드) 화면.
          push_list.dart - 목록 조회 화면.
          push_main.dart - 기능 메인(탭/셸) 화면.
        view_model
          push_connection_status_controller.dart - 푸시 서버/로컬 연결 상태 관리 Riverpod Controller.
          push_connection_status_controller.g.dart - push_connection_status_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
          push_controller.dart - 푸시 화면 상태·이벤트 처리 Riverpod Controller.
          push_controller.g.dart - push_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          push_card.dart - 목록 항목 카드 UI.
          push_connection_resolver.dart - 로컬/서버 데이터 소스 선택 및 연결 해석 위젯.
          push_connection_status_card.dart - 서버·로컬 연결 상태를 표시하는 카드 위젯.
          push_dial.dart - 원형 다이얼(나침반/푸시 등) 시각화 위젯.
          push_overview.dart - 기능 요약(최근 데이터·상태) 오버레이/패널.
          push_permission_util.dart - 해당 기능에 필요한 권한 요청 유틸리티.
      socket
        state
          socket_state.dart - 소켓(WebSocket) 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          socket_chat.dart - socket chat 관련 파일.
          socket_description.dart - 기능 설명(가이드) 화면.
          socket_list.dart - 목록 조회 화면.
          socket_main.dart - 기능 메인(탭/셸) 화면.
        view_model
          socket_connection_status_controller.dart - 소켓(WebSocket) 서버/로컬 연결 상태 관리 Riverpod Controller.
          socket_connection_status_controller.g.dart - socket_connection_status_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
          socket_controller.dart - 소켓(WebSocket) 화면 상태·이벤트 처리 Riverpod Controller.
          socket_controller.g.dart - socket_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          socket_card.dart - 목록 항목 카드 UI.
          socket_chat_overview.dart - 기능 요약(최근 데이터·상태) 오버레이/패널.
          socket_connection_resolver.dart - 로컬/서버 데이터 소스 선택 및 연결 해석 위젯.
          socket_connection_status_card.dart - 서버·로컬 연결 상태를 표시하는 카드 위젯.
      streaming
        state
          streaming_state.dart - 스트리밍 화면 UI 상태(로딩, 데이터, 에러 등) 모델.
        view
          streaming_description.dart - 기능 설명(가이드) 화면.
          streaming_list.dart - 목록 조회 화면.
          streaming_main.dart - 기능 메인(탭/셸) 화면.
          streaming_video_player_page.dart - 스트리밍 동영상 재생 화면.
        view_model
          streaming_connection_status_controller.dart - 스트리밍 서버/로컬 연결 상태 관리 Riverpod Controller.
          streaming_connection_status_controller.g.dart - streaming_connection_status_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
          streaming_controller.dart - 스트리밍 화면 상태·이벤트 처리 Riverpod Controller.
          streaming_controller.g.dart - streaming_controller.dart의 Riverpod 코드 생성 파일(build_runner 자동 생성).
        widgets
          streaming_card.dart - 목록 항목 카드 UI.
          streaming_connection_resolver.dart - 로컬/서버 데이터 소스 선택 및 연결 해석 위젯.
          streaming_connection_status_card.dart - 서버·로컬 연결 상태를 표시하는 카드 위젯.
          streaming_overview.dart - 기능 요약(최근 데이터·상태) 오버레이/패널.
      sqlite
        state
          sqlite_state.dart - SQLite Manager 화면 상태.
        view
          sqlite_create_table.dart - 테이블 생성.
          sqlite_database_detail.dart - DB 상세.
          sqlite_description.dart - 기능 설명.
          sqlite_main.dart - 메인.
          sqlite_table_data.dart - 테이블 데이터.
          sqlite_table_schema.dart - 스키마.
        view_model
          sqlite_controller.dart - SQLite Manager 컨트롤러.
          sqlite_controller.g.dart - Riverpod 코드 생성 파일.
      application_list_main.dart - 앱 목록(홈) 화면. 각 Device API 기능 모듈로 이동하는 진입점.
      loading_page.dart - 앱 시작 시 표시되는 로딩 화면. 초기화 후 홈으로 전환.
    widgets
      api_feature_shell.dart - 서버 연동 기능(바코드·소켓 등) 공통 셸 UI.
      api_feature_shell_config.dart - ApiFeatureShell 탭·라우트 구성 설정.
      app_list.dart - 홈 화면 기능 모듈 목록 그리드/리스트.
      app_navigation.dart - 앱 내부 화면 간 내비게이션 헬퍼.
      app_navigation_hub.dart - 더보기 탭 등 공통 내비게이션 허브.
      app_shell_tab_bar.dart - 기능 셸 하단 탭 바 위젯.
      appbar.dart - 앱 공통 커스텀 AppBar.
      barcode_scan_overlay.dart - 바코드 스캔 카메라 오버레이 UI.
      bottom_sheet.dart - 공통 바텀시트 컴포넌트.
      button.dart - 공통 버튼 스타일 위젯.
      feature_guide_page.dart - 기능 설명 가이드 페이지 템플릿.
      feature_connection_bar.dart - 기능 화면 공통 연결 바.
      feature_shell.dart - 기능별 4탭 셸(주요기능·설명·라이선스·더보기).
      file_display_util.dart - 파일 내용·아이콘 표시 유틸리티.
      file_mgmt_sample_content.dart - 파일 관리 샘플 콘텐츠 UI.
      file_opener_l10n.dart - 파일 열기 기능 다국어 헬퍼.
      infobox.dart - 정보 안내 박스 위젯.
      label_value.dart - 라벨-값 쌍 표시 위젯.
      license.dart - 오픈소스 라이선스 표시 화면/위젯.
      media_thumbnail.dart - 이미지/동영상 썸네일 위젯.
      modal.dart - 공통 모달 다이얼로그.
      server_connection_button.dart - 서버 연결/동기화 버튼.
      server_list_state_view.dart - 서버 데이터 목록의 로딩·빈·에러 상태 뷰.
      table.dart - 데이터 테이블 표시 위젯.
      text_form.dart - 공통 텍스트 입력 폼 필드.
      toast.dart - 토스트(스낵바) 메시지 표시.
  utils
    ai_chat_think_stripper.dart - 스트리밍 중 `<think>`/`<thinking>` 을 화면에서 숨김.
    app_logger.dart - 디버그 모드용 통합 로깅 유틸리티.
    device_uuid_util.dart - 디바이스 UUID 생성·조회·검증 유틸리티.
    error_handler.dart - 앱 전역 예외·에러 처리 및 사용자 메시지 변환.
    file_validation_util.dart - 파일 확장자·크기 등 유효성 검사 유틸리티.
    format_utils.dart - 날짜, 숫자, 파일 크기 등 포맷 변환 유틸리티.
    kst_datetime_util.dart - 한국 표준시(KST) 기준 날짜·시간 변환 유틸리티.
    media_gallery_link_store.dart - 미디어 갤러리 링크(URI) 로컬 저장·조회.
    media_gallery_service.dart - 기기 갤러리에서 이미지/동영상 선택·접근 서비스.
    media_preview_util.dart - 이미지·동영상 미리보기 표시 유틸리티.
    password_encryption.dart - SQLite 인터페이스 비밀번호 BCrypt 해시·검증.
    permission_manager.dart - 카메라, 위치, 연락처 등 런타임 권한 요청·확인.
    push_permission_util.dart - 해당 기능에 필요한 권한 요청 유틸리티.
    server_connection_utils.dart - 서버 연결 상태 확인, URL 구성 등 공통 유틸리티.
    socket_chat_message_format.dart - WebSocket 채팅 메시지 인코딩/디코딩(`msg:발신자:내용` 프로토콜).
    sqlite_file_validator.dart - SQLite DB 파일 형식·무결성 검증.
    sqlite_import_error_mapper.dart - SQLite 가져오기 오류를 사용자 메시지로 매핑.
    websocket_connection_util.dart - WebSocket 연결 URL 구성 및 연결 헬퍼.
