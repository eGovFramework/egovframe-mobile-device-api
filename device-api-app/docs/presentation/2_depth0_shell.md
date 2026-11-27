# 2. Depth 0 — 화면 껍데기 (Page Root)

> **무엇을:** AppBar, 하단 탭, 하단 버튼이 놓일 **화면 전체 틀**  
> **언제:** `build()`의 **가장 바깥**  
> 이전: [문법 기초](./1_basics.md) · 다음: [Depth 1 골격](./3_depth1_body.md)

---

## 이 Depth에서 쓰는 위젯 모음

| 그룹 | 위젯 |
|------|------|
| 프로젝트 표준 셸 | `ApiFeatureShell`, `FeatureShell` |
| 하단 CTA 자리 | `BottomButtonRow` |
| Flutter 기본 틀 (특수 화면) | `Scaffold`, `CustomAppBar` / `AppBar` |
| 뒤로가기 제어 | `PopScope` |

---

## `ApiFeatureShell`

**무엇인가**  
Device API 화면(메인·목록·상세)의 **표준 껍데기**.  
안에서 `FeatureShell` → `Scaffold`를 만든다.

**Depth**  
0 (최외곽)

**언제 쓰나**  
GPS, 가속도, 얼굴인식 등 **기능 화면**의 `build()` 최상단.

**언제 안 쓰나**  
홈 앱 목록, 바코드 스캔 풀스크린, 비디오 플레이어 같은 **특수 풀스크린**.

```dart
return ApiFeatureShell(
  feature: ApiFeature.accelerator,
  title: l10n.acceleratorApiTitle,
  mainFunctionBody: /* → Depth 1부터 채움 */,
  bottomBar: BottomButtonRow(
    buttons: [
      CustomButton(text: '목록', onTap: openList),
      CustomButton(text: '저장', onTap: save),
    ],
  ),
  popToApiMainCount: 1, // 목록=1, 상세=2~3
);
```

| 파라미터 | 의미 |
|----------|------|
| `feature` | 어떤 API인지 (기능설명 탭 연결) |
| `title` | 위 AppBar 제목 |
| `mainFunctionBody` | **주요기능** 탭 본문 (Depth 1~5) |
| `bottomBar` | 하단 고정 버튼 줄 |
| `popToApiMainCount` | 홈/뒤로 시 몇 단계 pop |

---

## `FeatureShell`

**무엇인가**  
`ApiFeatureShell`보다 한 단계 낮은 공통 셸.  
4탭: 주요기능 · 기능설명 · 라이선스 · 더보기.

**언제**  
AI Chat, Face Mesh, File Management처럼 메인이 `FeatureShell`을 직접 쓰는 경우.  
`ApiFeatureShell`은 `ApiFeature` enum이 있는 서버 연동 기능을 짧게 감싸는 wrapper다.  
로컬 전용(fileMgmt, sqlite)은 connection 바가 없으므로 `FeatureShell`만 쓴다.

---

## `BottomButtonRow`

**무엇인가**  
셸 **하단**에 버튼을 가로로 균등 배치.

**Depth**  
0의 `bottomBar` 자리 (본문 스크롤과 **분리**)

**왜 본문에 안 넣나**  
스크롤해도 저장/목록 버튼이 **항상 보이게** 하려는 UX.

```dart
bottomBar: BottomButtonRow(
  buttons: [
    CustomButton(text: '새로고침', onTap: reload),
    CustomButton(text: '이전 화면', onTap: () => Navigator.pop(context)),
  ],
)
```

버튼 위젯 자체 설명 → [Depth 4](./6_depth4_interaction.md)

---

## `Scaffold` (직접 사용은 예외)

**무엇인가**  
Material 화면 기본 틀 (AppBar + body).

**이 프로젝트**  
보통 셸이 만든다. **직접 쓰는 경우만** 기억:

- 홈 (`ApplicationListMain`)
- 바코드 스캔 / 얼굴 카메라
- 미디어·스트리밍 플레이어

```dart
return Scaffold(
  appBar: CustomAppBar(title: '스캔'),
  body: /* Depth 1 */,
);
```

---

## `CustomAppBar` / `AppBar`

**무엇인가**  
상단 바 (제목, 뒤로, 홈, ⓘ).

**권장**  
프로젝트에서는 `CustomAppBar` (홈 버튼 자동 처리).

---

## `PopScope`

**무엇인가**  
시스템 뒤로가기를 가로챔.

**예**  
체크박스로 여러 개 선택 중이면, 뒤로가기 = 화면 종료가 아니라 **선택 해제**.

---

## Depth 0 선택 규칙

| 화면 종류 | 선택 |
|-----------|------|
| API 메인·목록·상세 | `ApiFeatureShell` |
| 홈 / 스캔 / 플레이어 | `Scaffold` + `CustomAppBar` |
| 하단 주요 행동 | 반드시 `bottomBar: BottomButtonRow` |

---

## 다음

본문을 **스크롤할지·목록할지** 정한다 → [Depth 1 골격](./3_depth1_body.md)
