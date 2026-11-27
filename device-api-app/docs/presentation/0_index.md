# Presentation UX/UI 가이드

> 목표: **이 문서들만 보고** `lib/presentation`의 `view` 화면을 처음부터 조립할 수 있게 한다.  
> 범위: 이 프로젝트 presentation에서 **실제로 쓰는** Flutter 위젯 + 공통 셸만.

## 읽는 순서 (추천)

1. [Depth란?](#화면-depth-한눈에) ← 이 페이지
2. [문법 기초](./1_basics.md) — `child` / `children`
3. Depth 0 → 6 순서대로
4. [레시피·치트시트](./9_recipes.md) — 따라 만들기
5. [State 가이드](./10_state.md) — Flutter state 전반 (Stateless/Stateful, setState, rebuild, Riverpod 개념)
6. [Flutter 활용 보완](./11_flutter_practices.md) — 정본 템플릿, 위젯 분해, l10n, 플랫폼 채널
7. [국제화](./12_l10n.md) — arb, 메시지 키, 얼굴 메시·AI 서버 안내 문구

## 목차

| # | 문서 | 내용 |
|---|------|------|
| 1 | [문법 기초](./1_basics.md) | `child` vs `children`, `()` vs `[]` |
| 2 | [Depth 0 껍데기](./2_depth0_shell.md) | `ApiFeatureShell`, `Scaffold`, `BottomButtonRow` |
| 3 | [Depth 1 골격](./3_depth1_body.md) | 스크롤·목록·새로고침·Expanded·로딩 |
| 4 | [Depth 2 배치](./4_depth2_layout.md) | `Column`, `Row`, `Stack`, `Wrap` |
| 5 | [Depth 3 여백·장식](./5_depth3_decoration.md) | `SizedBox`, `Padding`, `Container` |
| 6 | [Depth 4 터치·입력](./6_depth4_interaction.md) | 버튼, InkWell, TextField |
| 7 | [Depth 5 내용물](./7_depth5_content.md) | Text, Icon, InfoBox, CommonTable |
| 8 | [Depth 6 오버레이](./8_depth6_overlay.md) | 다이얼로그, 토스트, Navigator |
| 9 | [레시피·치트시트](./9_recipes.md) | 메인/목록/상세 따라하기, X vs Y |
| 10 | [State 가이드](./10_state.md) | Flutter state 초보 가이드: Widget/build, setState, ephemeral vs app state, rebuild, Riverpod 기초 |
| 11 | [Flutter 활용 보완](./11_flutter_practices.md) | 새 기능 템플릿(AI Chat/IoT/Face Mesh), 위젯 분해, l10n, 채널 |
| 12 | [국제화](./12_l10n.md) | arb·`gen-l10n`·메시지 키. 얼굴 메시 `faceMesh*`, AI 서버 미연결 문구 |

---

## 화면 Depth 한눈에

Flutter 화면은 레고처럼 **바깥 → 안쪽**으로 감싼다.

| Depth | 이름 | 하는 일 | 대표 |
|------:|------|---------|------|
| **0** | 껍데기 | AppBar, 탭, 하단 버튼 자리 | `ApiFeatureShell` |
| **1** | 골격 | 스크롤/목록/로딩 | `SingleChildScrollView`, `ListView` |
| **2** | 배치 | 위아래·좌우·겹침 | `Column`, `Row`, `Stack` |
| **3** | 여백·장식 | 간격, 테두리, 배경 | `SizedBox`, `Padding`, `Container` |
| **4** | 터치·입력 | 누르기, 입력 | `CustomButton`, `InkWell` |
| **5** | 내용물 | 글자, 아이콘, 표 | `Text`, `InfoBox`, `CommonTable` |
| **6** | 오버레이 | 확인창, 토스트, 화면 이동 | `showDialog`, `Navigator` |

### accelerator 메인 예시

```
[0] ApiFeatureShell
      └─ bottomBar: BottomButtonRow(...)
      └─ mainFunctionBody:
[1]     RefreshIndicator
[1]       └─ SingleChildScrollView
[3]           └─ Padding(16)
[2]               └─ Column
[5]                   ├─ ThreeDCube
[3]                   ├─ SizedBox(30)
[5]                   ├─ AccelerationDisplay
[3]                   ├─ SizedBox(30)
[5]                   └─ ConnectionStatusCard
```

**초보자 규칙:**  
새 화면은 **0 → 1 → 2 → 3 → 5** 순으로 뼈대를 잡고, 마지막에 **4(버튼)·6(다이얼로그)** 를 붙인다.  
값이 바뀌며 화면을 갱신하는 법 → [Flutter State 가이드](./10_state.md).

---

## 이 프로젝트에서 안 다루는 것

가이드에 나와도 presentation에서 거의 안 씀 → 새 화면에 넣지 말 것.

- `SafeArea`, `SnackBar`, `Drawer`, `FloatingActionButton`
- `CustomScrollView` / `Sliver*`
- `PageView`, `Hero`

---

## 관련 문서

- [Clean Architecture](../architecture/0_index.md)
- [Device Applications](../device_applications.md)
