# 기기 UUID

목록·저장·삭제가 기기마다 나뉘는 기준은 `DeviceIdService`가 만든 UUID v4다.  
로그인 계정이 없다. 이 값을 알면 그 기기의 행을 조회·삭제할 수 있다.

## 1. 어디서 만들고 어디서 읽나

| 파일 | 역할 |
|------|------|
| `lib/core/device_id_service.dart` | 생성·저장·조회 |
| `lib/utils/device_uuid_util.dart` | 기능 코드가 호출하는 `getDeviceUuid()` |

보안 저장소 키는 `device_install_id`다. 이미 UUID v4가 있으면 그대로 반환하고, 없거나 형식이 아니면 새로 만들어 덮어쓴다. 저장소 읽기·쓰기가 실패하면 예외가 나고, 그 요청은 서버로 가지 않는다.

앱을 지웠다가 다시 설치하면 보안 저장소가 비워지고 새 UUID가 생긴다. 이전 설치의 서버 행은 새 UUID 목록에 나오지 않는다.

## 2. 서버가 uuid를 보는 위치

`probe`는 본문을 보지 않고 HTTP 상태만 본다. 목록 API가 uuid 없이 400을 주면 연결 실패가 된다. 규칙은 [DeviceApiClient](./9_device_api_client.md) 3절이다.

| API | uuid가 없을 때 |
|-----|----------------|
| 바코드·얼굴 메시·AI 채팅·연락처·나침반·푸시·소켓·IoT의 목록·등록·삭제 | HTTP 400 `uuid is required` |
| 스트리밍 `selectStreamingMediaInfoList`·등록·삭제 | HTTP 400 `uuid is required` |
| AI 채팅 SSE 질의 | 스트림 `error`, `uuid is required` |
| 파일 읽기/쓰기·파일 오프너·미디어 다운로드, `getMediaStreaming.do` | uuid가 없으면 400. 해당 파일의 기기 행이 없으면 403 |
| 파일 읽기/쓰기 등록 | HTTP 200, `resultState=FAIL`, `기기 식별코드가 필요합니다` |
| 가속기·GPS·기기 정보 목록 | uuid 없이 200. 목록 SQL에 UUID 조건이 있으면 행은 비어 있다 |
| 스트리밍 `mediaInfoList.do`, 파일 오프너 목록 | uuid 없이 200이면 행은 비어 있다. 재생 목록과 문서 뷰어 서버 목록은 기기 uuid를 붙인다 |

연결 확인에 기기 uuid를 붙이는 기능은 바코드, 얼굴 메시, AI 채팅, 연락처, 나침반, 푸시, 소켓, IoT다. 스트리밍 연결 확인은 `POST /stm/mediaInfoList.do`, 문서 뷰어 연결 확인은 `GET /fop/selectFileOpenerList.do`이며 둘 다 uuid를 붙이지 않는다.

## 3. 앱 안의 소유권 검사

서버가 거르기 전에 앱이 한 번 더 보는 곳이 `*_uuid_guard.dart`다.

| 파일 | 함수 |
|------|------|
| `domain/barcode/entities/barcode_uuid_guard.dart` | `barcodeBelongsToDevice`, `isDeviceUuidValid` |
| `domain/faceMesh/entities/face_mesh_uuid_guard.dart` | 얼굴 메시 레코드 소유권 |
| `domain/accelerator/entities/accelerator_uuid_guard.dart` | 가속도 레코드 |
| `domain/deviceInfo/entities/device_uuid_guard.dart` | 기기 정보 |
| `domain/media/entities/media_uuid_guard.dart` | 미디어 |
| `domain/network/entities/network_uuid_guard.dart` | 네트워크 |

공통 조건은 기기 uuid가 비어 있지 않고, 행의 uuid와 같을 때다. 행 uuid가 `null`이거나 빈 문자열이면 내 기기의 행으로 보지 않는다.

## 4. 기능을 추가할 때

1. 화면과 UseCase는 `DeviceUuidUtil.getDeviceUuid()`만 호출한다. `DeviceIdService`를 기능마다 다시 만들지 않는다.
2. 목록·등록·삭제 요청에 그 문자열을 `uuid`로 넣는다.
3. 서버가 빈 uuid에 400을 주면, 연결 확인 `probe`에도 같은 쿼리를 붙인다.
4. 목록에서 다른 기기 행을 빼야 하면 `*_uuid_guard.dart`로 거른다.
