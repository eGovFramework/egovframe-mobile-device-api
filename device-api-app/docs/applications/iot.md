# IoT 제어 (IoT MQTT)

## 개요

IoT 기능은 `mqtt5_client`로 RabbitMQ MQTT plugin에 연결하여 `iot/{deviceId}/telemetry`를 구독하고 `iot/{deviceId}/command`로 제어 명령을 발행하는 샘플입니다. 서버(`/iot`) 또는 SQLite에 메시지 이력을 남길 수 있습니다.

## 주요 기능

### 1. MQTT 연결
- 기본 포트 1883, 사용자/비밀번호 인증을 지원합니다
- Host/Port/계정/Device ID는 `application.properties`의 `mqtt.host`, `mqtt.port`, `mqtt.username`, `mqtt.password`, `mqtt.device-id`입니다
- `mqtt.enabled=false`이거나 호스트가 비어 있으면 접속하지 않습니다. 연결 버튼을 눌렀을 때만 브로커에 붙고, IoT 화면을 벗어나면 끊습니다

### 2. 텔레메트리 구독
- `iot/{deviceId}/telemetry` 토픽으로 온습도 JSON을 수신·표시합니다

### 3. 제어 명령 발행
- `iot/{deviceId}/command`로 전원 제어 JSON을 publish 합니다 (`action: power`, `value: on/off`)

### 4. 자동 저장
- 데이터 저장소(서버/SQLite)가 연결되어 있으면, 온·습도가 이전 값과 다를 때와 명령 발송 시 DB에 자동 저장합니다

### 5. 로컬 테스트
- 실제 IoT 기기 없이도 MQTT Explorer로 동일 토픽에 publish/subscribe 하여 검증할 수 있습니다

## 아키텍처 구조

### Domain Layer
- **Entity**: `IotMessageInfo`
  - `sn`, `uuid`, `topic`, `payload`, `direction`, `messageType`, `timestamp`, `useYn`
- **Entity**: `IotBrokerConfig`
  - `host`, `port`, `username`, `password`, `deviceId`, `clientId`
- **Repository**: `IotRepository` (인터페이스)
- **UseCase**: `IotUseCase`

### Data Layer
- **Service**: `IotMqttService`
  - MQTT 연결·구독·publish
- **Service**: `IotRemoteService`
  - 서버 REST(`/iot`) 이력
- **Repository Implementation**: `IotRepositoryImpl`

### Presentation Layer
- **Screen**: `IotPage`
  - 온습도·명령 오버뷰 (`IotOverview`)
  - 브로커 설정 (`IotBrokerPage`)
  - 실시간 로그·저장 이력 (`IotListPage`, `IotSavedListPage`)

## 의존성

- `mqtt5_client: ^5.0.0`: MQTT 5 클라이언트
- `http: ^1.5.0`: 이력 REST 저장

## 화면 구성 및 사용 방법

### 메인 화면

앱 목록에서 **IoT 제어**로 진입합니다.

>**사용 방법**
- MQTT 바의 연결 버튼으로 브로커에 접속합니다. 주소는 서버 properties의 `mqtt.host`입니다. 공기계는 PC의 사설 IP, 에뮬레이터는 `10.0.2.2`로 바꿉니다
- 메인에서 데이터 저장소(서버 또는 SQLite)를 연결한 뒤 온습도·명령을 사용합니다
- 온·습도 값이 바뀌거나 명령을 발송하면 저장소에 자동 저장됩니다
- 메시지 로그의 목록에서 저장 이력을 확인합니다
- MQTT Explorer로 `iot/device01/telemetry`에 publish 하면 앱에 값이 표시됩니다

### 브로커 설정
서버에서 받은 Host, Port(1883), Username/Password, Device ID를 화면에서 바꿀 수 있습니다. 기본 Device ID는 `device01`입니다.

## 주의사항

- RabbitMQ MQTT plugin이 떠 있어야 연결됩니다
- 실기기에서는 브로커 Host가 PC/서버 LAN IP여야 합니다 (앱 `localhost`는 기기 자신)
- 데이터 저장소가 연결되어 있어야 온·습도 변경과 명령이 DB에 남습니다
- HTTP `/iot`와 MQTT 1883은 역할이 다릅니다. 앱은 둘 다 쓸 수 있습니다
- `/iot` 목록·등록·삭제는 기기 uuid가 있어야 합니다. 연결 확인도 같은 uuid를 붙입니다

## 기술적 특징

- **토픽**: telemetry `iot/{deviceId}/telemetry`, command `iot/{deviceId}/command`
- **웹 경로**: 이력 REST `/iot` (`IOT_MESSAGE`)
- **연결 모드**: MQTT와 별도로 서버/SQLite 이력 저장소를 고름
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
