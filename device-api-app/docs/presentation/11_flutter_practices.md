# Flutter 활용 보완 가이드

> 목표: Device API 샘플을 따라 기능을 추가할 때 **Flutter답게** 작성하는 방법을 안내한다.  
> 정본 UI: **AI Chat / IoT / Face Mesh**. 서버 CRUD 템플릿은 **GPS**, 로컬 전용은 **File Management**.

이 문서는 “지금 코드가 틀린 이유”보다 **다음에 어떻게 맞출지**를 적는다.

---

## 1. 새 기능은 어느 화면을 복사하나

| 만들 기능 | 복사할 정본 | 이유 |
|-----------|-------------|------|
| 서버 또는 SQLite에 저장하는 Device API | `gps/` 또는 `aiChat/` | 3단(domain/data/presentation) + connection 바 |
| 카메라·온디바이스 ML | `faceMesh/` | permission util + overview + custom 기능설명 |
| MQTT 등 실시간 연결 | `iot/` | 상태 바와 로그 목록 분리 |
| 서버 없는 로컬 도구 | `fileMgmt/` | connection_* 없음. UseCase로 파일/디바이스 작업만 분리 |

`fileMgmt`와 `sqlite`는 서버 연결 카드가 없다. 로컬 전용 기능을 만들 때 connection_resolver를 억지로 넣지 않는다.

복사 후 목록·서버·arb에 등록하는 파일은 [새 기능 등록](../architecture/12_new_feature.md)을 본다.

---

## 2. 위젯을 나누는 기준

한 `*_main.dart`에 목록·다이얼로그·경로바를 모두 넣으면 1000줄이 넘고 따라 하기가 어렵다.

Face Mesh / AI Chat처럼 나눈다.

```
view/          # Page (셸만 조립)
widgets/       # Overview, Card, (있으면) ConnectionBar
view_model/    # Riverpod Controller
state/         # 화면 상태 copyWith
```

**규칙**

- `Page`는 `FeatureShell`/`ApiFeatureShell`과 이벤트 핸들러만 둔다.
- 목록 한 줄은 `*_card.dart`, 본문 배치는 `*_overview.dart`.
- `const` 생성자를 쓸 수 있으면 쓴다.
- `TextEditingController` / `StreamSubscription` / `Timer`는 `dispose()`에서 해제한다.

파일 관리 예: `FileMgmtPage` → `FileMgmtOverview` → `FileMgmtFileCard`.

---

## 3. 상태와 비동기

- 화면 상태는 Riverpod `Notifier` (`*_controller.dart`). 로컬 토글만 `setState`.
- `await` 뒤에 UI를 만지면 `if (!context.mounted) return;` 또는 `if (!mounted) return;`.
- UseCase는 sealed result (`Success` / `Failure`)를 반환하고, Page는 `switch` + `showStatusToast`.
- `ErrorHandler.showErrorDialog`는 유틸로 남아 있지만, 기능 화면의 기본 경로는 **result + toast + l10n** 이다.

---

## 4. 국제화

절차 전체는 [국제화 (l10n)](./12_l10n.md)를 본다. Face Mesh 기능설명처럼 **문자열은 arb**에 둔다.

```dart
final l10n = AppLocalizations.of(context)!;
_GuideIntro(title: l10n.faceMeshTitle, content: l10n.faceMeshGuideOverview);
```

하드코딩 한국어 리스트(`'바코드 스캔'`)는 새 화면에 넣지 않는다.  
`FeatureGuidePage` + `feature_data.json`은 예전 패턴이다. 신규는 `*FunctionPage` + l10n.

---

## 5. 플랫폼 코드

MethodChannel은 **Android와 iOS를 같이** 맞춘다.

| 채널 | Android | iOS |
|------|---------|-----|
| RAM 정보 | `MainActivity.kt` | `AppDelegate.swift` |
| Downloads export (`lib/sqlite`) | 있음 | 없음 → iOS는 공유 시트 등 다른 경로 |

새 채널을 추가할 때 한쪽만 구현하면 초보자가 “안 되는 기기”로 오해한다. 미지원이면 UseCase/문서에 명시한다.

`SystemChannels.platform.invokeMethod('System.gc')` 같은 호출은 Flutter에 없는 API다. 메모리 정리는 컨트롤러 `dispose`와 위젯 해제로 한다.

---

## 6. 네이밍

정본과 맞춘다.

| 역할 | 이름 |
|------|------|
| 메인 화면 | `*Page` (`FileMgmtPage`, `AiChatPage`) |
| 기능설명 | `*FunctionPage` |
| 목록/상세 | `*ListPage`, `*DetailPage` 또는 Face 계열 `*DetailedPage` |
| 클래스 `Screen` | 더 이상 쓰지 않음 |

폴더명은 기존 feature와 동일하게 둔다 (`fileMgmt`, `aiChat`, `faceMesh`).

---

## 7. 체크리스트 (새 화면 PR 전)

1. [ ] GPS/AI Chat/Face Mesh 중 하나를 템플릿으로 복사했는가
2. [ ] Domain에 UseCase·Repository가 있고, Page가 Service를 직접 호출하지 않는가
3. [ ] 서버가 없으면 connection_*를 넣지 않았는가
4. [ ] Overview/Card로 위젯을 나눴는가
5. [ ] 기능설명 문구가 l10n인가
6. [ ] `dispose` / `context.mounted`를 지켰는가
7. [ ] Android·iOS 채널이 대칭이거나, 비대칭을 문서에 적었는가
