# AI 채팅 (AI Chat)

## 개요

AI 채팅은 질문을 device-api-web(`/aic`)으로 보내 egovframe-ai-rag가 답을 만들고, 질문-답을 MySQL `AI_CHAT_INFO`에 저장·조회·삭제하는 샘플입니다. 앱은 AI 엔진(Ollama, PostgreSQL)을 직접 부르지 않습니다. 3단 구조는 저장소 루트 [docs/3tier-architecture-guide.md](../../../docs/3tier-architecture-guide.md)를 보면 됩니다.

## 주요 기능

### 1. AI 질의
- RAG(문서 검색) 또는 일반 채팅 모드를 고릅니다
- `POST /aic/askAiChatInfoStream.do`로 SSE 토큰을 받아 말풍선에 이어 붙입니다

### 2. 웹 DB 저장
- 생성이 끝나면 웹이 `AI_CHAT_INFO`에 INSERT 합니다
- 답은 마크다운으로 표시합니다. `<think>` 구간은 화면에 남기지 않습니다

### 3. 채팅 목록
- 같은 `sessionId`를 한 세션 타일로 묶습니다
- 세션을 누르면 해당 대화 전체를 볼 수 있습니다

### 4. 채팅 삭제
- 목록에서 세션을 고르거나 상세에서 해당 세션 기록을 논리 삭제합니다 (`USEYN='N'`)

### 5. SQLite 연동
- MySQL과 동일 컬럼으로 로컬 이력 CRUD를 지원합니다
- **질의 자체는 웹 서버가 필수**입니다

## 아키텍처 구조

### Domain Layer
- **Entity**: `AiChatInfo`
  - `sn`: 일련번호
  - `uuid`: 디바이스 고유 식별자
  - `question` / `answer`: 질문·답
  - `chatMode`: `rag` 또는 `simple`
  - `modelNm`: LLM 모델명 (앱은 비우고 웹이 채움)
  - `sessionId`: ai-rag 대화 세션
  - `useYn`: 사용 여부
  - `questionTimestamp` / `answerTimestamp`: 질문·답 시각
- **Entity**: `AiChatSession`: `sessionId`로 묶은 메시지 목록
- **Repository**: `AiChatRepository` (인터페이스)
- **UseCase**: `AiChatUseCase`

### Data Layer
- **Service**: `AiChatService`
  - SSE 질의, 목록, 삭제, 직접 등록
- **Repository Implementation**: `AiChatRepositoryImpl`
  - 질의는 항상 원격, 목록/삭제는 서버 또는 SQLite

### Presentation Layer
- **Screen**: `AiChatPage`
  - 모드 칩·입력 (`AiChatOverview`)
  - 말풍선·마크다운 (`AiChatTranscript`)
  - 세션 목록 (`AiChatListPage`)
  - 세션 상세 (`AiChatDetailPage`)

## 웹서버

device-api-web(기본 포트 **9700**)이 AI 채팅의 중계·업무 서버입니다. 앱은 8080(ai-rag)을 모릅니다. Swagger 태그는 `18. AI Chat Guide Program Service`입니다.

웹은 LLM을 돌리지 않습니다. `EgovAiRagClient`로 egovframe-ai-rag에 물어보고, 답을 다듬은 뒤 MySQL `hyb.AI_CHAT_INFO`에 저장합니다.

### 1. 역할

- `/aic/**` REST와 SSE 입구 (`EgovAiChatAPIController`)
- 세션 ID가 없으면 ai-rag `/api/chat/sessions` 생성 (실패 시 UUID)
- 앱이 `modelNm`을 안 내면 `/api/ollama/models`의 `defaultModel`, 그것도 없으면 `Globals.AiRag.Model`
- SSE 토큰을 앱에 바로 넘기되, 추론 모델은 `ThinkStreamGate`로 think 구간을 숨김
- 생성이 끝나면 `stripThink`·영어 혼잣말 제거 후 INSERT
- `questionTimestamp`가 비면 웹이 KST 시각을 넣고, `answerTimestamp`는 저장 시각

하지 않는 일: 문서 임베딩, Ollama 직접 호출, 프롬프트 본문 작성(그건 ai-rag). RAG 문서 파일은 웹이 `ai-rag.fileStorePath`에 저장하고 재인덱싱만 요청한다.

### 2. API

필수 파라미터는 `uuid`입니다. 질의 시 `question`도 필수입니다. `chatMode`는 `rag`(기본) 또는 `simple`입니다.

| Method | Path | 설명 |
|--------|------|------|
| GET | `/aic/selectAiChatInfoList.do` | uuid 기준 목록 (`USEYN='Y'`). 앱의 device-api-web 연결 확인도 이 URL에 기기 uuid를 붙여 호출하고, 목록 본문은 버립니다 |
| GET | `/aic/selectAiRagConnection.do` | 웹이 ai-rag(`/api/ollama/models`)에 닿는지. 응답은 항상 200이고 `connected`로 구분 |
| POST | `/aic/askAiChatInfoStream.do` | **앱이 쓰는 SSE 질의**. 토큰 중계 후 DB 저장 |
| POST | `/aic/askAiChatInfo.do` | 답이 전부 나온 뒤 JSON 한 건 (호환용) |
| POST | `/aic/insertAiChatInfo.do` | 질문-답 직접 등록 (질의 없음) |
| DELETE | `/aic/deleteAiChatInfo.do` | `USEYN='N'` 논리 삭제 |
| POST | `/aic/uploadAiRagDocument.do` | 공통 RAG 문서를 `ai-rag.fileStorePath`에 저장 후 재인덱싱. **앱 미사용** |
| POST | `/aic/reindexAiRagDocument.do` | 저장 폴더 재인덱싱. **앱 미사용** |
| GET | `/aic/selectAiRagDocumentStatus.do` | 저장 파일 목록·인덱싱 상태. **앱 미사용** |

선택: `sessionId`(이어 묻기), `modelNm`, `questionTimestamp`.

SSE 이벤트 (`type`은 중계 서버가 붙입니다):

| type | 의미 |
|------|------|
| `token` | 생성 중인 글자 |
| `done` | 저장 완료. `aiChatInfo` 포함 |
| `error` | 실패 (`uuid`/`question` 누락, ai-rag HTTP 오류 등) |

### 3. ai-rag 중계

| 모드 | 스트림 | 일괄 JSON |
|------|--------|-----------|
| RAG | `GET /ai/rag/stream` | `GET /ai/rag` |
| 일반 | `GET /ai/simple/stream` | `GET /ai/simple` |

쿼리: `message`, `sessionId`, (선택) `model`.

### 4. 테이블

`AI_CHAT_INFO`: `sn`, `uuid`, `question`, `answer`, `chatMode`, `modelNm`, `sessionId`, `useYn`, `questionTimestamp`, `answerTimestamp`.  
스키마 정본은 `device-api-web/script/mysql/ddl/deviceapi_all_create_mysql.sql`입니다. `THINK` 컬럼은 쓰지 않습니다.

### 5. 설정

포트, 허용 확장자, 비동기 타임아웃, RAG 주소, 문서 경로는 `device-api-web/src/main/resources/application.properties`에 있습니다.  
DEV/운영은 `Globals.AiRag.Url`과 `ai-rag.fileStorePath`를 그 파일의 `[DEV/운영]` 주석대로 바꿉니다. 실행 방법은 [local과 운영 실행](/run_profiles.md)을 따릅니다.

```properties
server.port=9700
ai-rag.allowedFileExtensions=.md,.pdf,.docx,.hwp,.hwpx
spring.mvc.async.request-timeout=600000
```

| 파일 | 역할 |
|------|------|
| `.../aic/web/EgovAiChatAPIController.java` | URL 입구, SSE `SseEmitter`(타임아웃 10분) |
| `.../aic/service/impl/EgovAiChatAPIServiceImpl.java` | 질의·저장 트랜잭션 |
| `.../aic/client/EgovAiRagClient.java` | 8080 클라이언트, think 필터, 모델명 해석, 재인덱싱/상태 |
| `.../aic/service/EgovAiRagDocumentStore.java` | RAG 문서를 `ai-rag.fileStorePath`에 저장 |
| `.../mapper/mbl/aic/EgovAiChatAPIGuide_SQL_mysql.xml` | MySQL SQL |

웹과 ai-rag가 같은 PC면 `Globals.AiRag.Url`은 `http://127.0.0.1:8080`이면 됩니다. 앱만 휴대폰 기준으로 LAN IP:9700을 맞춥니다.

## ai-rag 서버

egovframe-ai-rag의 `langchain4j-ai-rag-postgre`(기본 포트 **8080**)가 실제 AI를 돌리는 서버입니다. 앱은 이 주소를 모릅니다. 호출하는 쪽은 device-api-web의 `EgovAiRagClient`뿐입니다.

이 서버는 문서에서 근거를 찾고(RAG), LangChain4j로 프롬프트를 만든 뒤 Ollama로 토큰을 생성합니다. 모바일 기기 UUID 이력은 저장하지 않습니다. 문서 파일 입구는 device-api-web(`/aic/uploadAiRagDocument.do`)이며, ai-rag 브라우저 UI는 쓰지 않습니다.

### 1. 역할

- 업로드 문서 청크·ONNX 임베딩 → PostgreSQL PGVector (`document_embeddings`)
- 질문과 비슷한 문단 검색 (벡터 + `pg_trgm` 키워드 하이브리드, RRF)
- RAG 챗봇 또는 RAG 없는 일반 챗봇으로 Ollama 호출
- `sessionId` 기준 대화 메모리 (`chat_sessions`, `chat_memory`, 최대 20메시지)
- 자체 think 태그 분리 (`EgovThinkTagStripper`). 앱 화면에 안 보이게 하는 최종 필터는 웹 `ThinkStreamGate`

하지 않는 일: 기기 UUID 목록/삭제, MySQL `AI_CHAT_INFO` 저장, Device API `/aic` 계약. 문서 파일 입구(업로드 화면)는 device-api-web이다.

### 2. 웹이 쓰는 API

쿼리: `message`, `sessionId`, (선택) `model`. 스트림은 Spring WebFlux `Flux` SSE입니다. 한 토큰은 `{"token":"..."}`이고 `type` 필드는 없습니다.

| Method | Path | 설명 |
|--------|------|------|
| GET | `/ai/rag/stream` | RAG SSE. 앱 질의의 기본 경로 |
| GET | `/ai/simple/stream` | 일반 채팅 SSE |
| GET | `/ai/rag` | RAG JSON `{ "answer", "think" }` |
| GET | `/ai/simple` | 일반 채팅 JSON |
| POST | `/api/chat/sessions` | 세션 생성. 웹이 `sessionId`가 없을 때 호출 |
| GET | `/api/ollama/models` | 설치 모델과 `defaultModel` |
| GET | `/api/documents/status` | 인덱싱 상태. 웹 `/aic/selectAiRagDocumentStatus.do`가 중계 |
| POST | `/api/documents/reindex` | 재인덱싱. 웹 `/aic/reindexAiRagDocument.do`가 중계 |

`defaultModel`은 `langchain4j.ollama.chat-model.model-name`입니다. 웹은 이 값을 `AI_CHAT_INFO.modelNm`에 넣습니다.

### 3. 문서 넣기 (앱은 호출하지 않음)

공통 RAG 문서는 Flutter가 아니라 **device-api-web Swagger**로 넣는다.

| Method | Path | 설명 |
|--------|------|------|
| POST | `/aic/uploadAiRagDocument.do` | `ai-rag.fileStorePath`에 저장 후 재인덱싱 |
| POST | `/aic/reindexAiRagDocument.do` | 폴더만 다시 인덱싱 |
| GET | `/aic/selectAiRagDocumentStatus.do` | 파일 목록·인덱싱 진행 |

허용 확장자는 `ai-rag.allowedFileExtensions`(.md,.pdf,.docx,.hwp,.hwpx). 경로는 ai-rag `document.path`와 같아야 한다.

문서가 없거나 질문과 다르면 RAG는 관련 청크를 못 찾아 “모른다”에 가깝게 답할 수 있습니다. 그때는 앱에서 **일반 채팅**을 씁니다.

### 4. 테이블 (PostgreSQL `ragdb`)

| 테이블 | 내용 |
|--------|------|
| `document_embeddings` | 문서 조각 + 768차원 벡터 (코사인) |
| `chat_sessions` | LLM 대화 세션 |
| `chat_memory` | 세션별 메시지 히스토리 |

앱 목록의 출처가 아닙니다. 이력 정본은 MySQL `hyb.AI_CHAT_INFO`입니다. PostgreSQL이 없어도 일반 채팅은 LLM만으로 가능하고, RAG 검색만 실패합니다.

### 5. 설정

`egovframe-ai-rag/langchain4j-ai-rag-postgre/src/main/resources/application.yml`

```yaml
spring.datasource.url: jdbc:postgresql://localhost:5432/ragdb
langchain4j.ollama.base-url: http://localhost:11434
langchain4j.ollama.chat-model.model-name: qwen2.5:7b-instruct
langchain4j.ollama.chat-model.timeout: 600s
document.path: file:C:/workspace-test/upload/data/**/*.md
document.pdf-path: file:C:/workspace-test/upload/data/**/*.pdf
document.docx-path: file:C:/workspace-test/upload/data/**/*.docx
document.hwp-path: file:C:/workspace-test/upload/data/**/*.hwp
document.hwpx-path: file:C:/workspace-test/upload/data/**/*.hwpx
```

포트는 Spring Boot 기본 **8080**입니다. Ollama와 PostgreSQL이 먼저 떠 있어야 합니다.

| 파일 | 역할 |
|------|------|
| `.../controller/EgovChatController.java` | `/ai/rag`, `/ai/simple` 스트림·JSON |
| `.../controller/EgovChatSessionController.java` | `/api/chat/sessions` |
| `.../controller/EgovOllamaModelController.java` | `/api/ollama/models` |
| `.../controller/EgovDocumentController.java` | 재인덱싱·상태 (웹이 중계) |

실행 순서는 Ollama → ai-rag → device-api-web입니다. 웹만 켜면 device-api-web 연결은 되지만, 채팅 화면과 저장된 목록 위에 AI 서버 미연결 안내가 나옵니다. 그 상태에서는 저장된 대화는 볼 수 있고 새 질문은 보낼 수 없습니다.

## 의존성

- `http: ^1.5.0`: REST·SSE
- `flutter_markdown: ^0.7.7+1`: 답 렌더링
- `lib/sqlite`: 로컬 이력 스키마

## 화면 구성 및 사용 방법

### 메인 화면

앱 목록에서 **AI 채팅**으로 진입합니다. 제목은 AI 채팅 API입니다.

>**사용 방법**
- **문서 검색 (RAG)** 또는 **일반 채팅**을 고릅니다
- AI 서버(ai-rag)가 연결되지 않으면 모드 선택 위에 미연결 안내가 나옵니다. 저장된 대화는 볼 수 있고 새 질문은 보낼 수 없습니다
- 질문을 입력하고 전송합니다. 질의 전에 device-api-web 연결을 확인합니다
- 질문 말풍선이 바로 붙고, 답이 글자 단위로 쌓입니다 (`<think>`는 보이지 않습니다)
- 같은 화면에서 이어 물으면 `sessionId`가 유지되어 한 대화로 묶입니다
- 앱바 목록 아이콘으로 세션 목록을 열고, 세션을 누르면 상세 대화를 봅니다
- egovframe-ai-rag(기본 `http://127.0.0.1:8080`)와 device-api-web이 실행 중이어야 합니다

### 세션 목록
첫 질문, 모드, 메시지 수, 마지막 시각이 타일로 보입니다. 여러 세션을 골라 삭제할 수 있습니다.

### 세션 상세
해당 세션의 질문-답 전체를 말풍선으로 보고, 세션 단위로 삭제할 수 있습니다.

## 주의사항

- 질의는 SQLite 모드여도 **항상 9700 서버**가 필요합니다
- 앱 `baseUrl`은 `http://PC의LAN_IP:9700`이어야 합니다. `127.0.0.1`은 실기기에서 실패합니다
- 앱에 8080(ai-rag) 주소를 넣지 않습니다
- 문서가 없거나 질문과 다르면 RAG는 “모른다”에 가깝게 답할 수 있습니다. 그때는 일반 채팅을 씁니다
- Ollama가 CPU로 생성하면 답이 느린 것이 정상입니다. SSE 타임아웃은 10분입니다

## 기술적 특징

- **3단 호출**: Flutter → device-api-web `/aic` → egovframe-ai-rag → Ollama
- **SSE**: `type=token|done|error`. think는 웹 `ThinkStreamGate`와 앱 `AiChatThinkStripper`가 숨김
- **모델명**: 앱은 빈 `modelNm`. 웹이 `/api/ollama/models` 또는 `Globals.AiRag.Model`
- **연결**: 질의 `resolveAskConnection`(서버만), 목록 `resolveConnection`(서버/SQLite). device-api-web 확인은 목록 API에 기기 uuid를 붙입니다. AI 서버 확인은 `/aic/selectAiRagConnection.do`이고, 끊기면 `AiChatAiServerBanner`를 채팅 화면과 목록 화면에 표시합니다. HTTP 공통 규칙은 [DeviceApiClient](../architecture/9_device_api_client.md)를 본다
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
