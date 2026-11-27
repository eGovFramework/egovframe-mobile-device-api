# 9. 레시피 · 치트시트

> 초보자가 **따라 만들 수 있는** 화면 3종 + 빠른 선택표 + 체크리스트.  
> 이전: [Depth 6](./8_depth6_overlay.md) · 목차: [0_index](./0_index.md)

---

## 레시피 1 — API 메인 (accelerator형)

```
[0] ApiFeatureShell
      bottomBar: BottomButtonRow [목록, 저장]
      mainFunctionBody:
[1]   RefreshIndicator
[1]     SingleChildScrollView (AlwaysScrollable)
[3]       Padding(16)
[2]         Column
[5]           시각 위젯 (맵/큐브/오버뷰)
[3]           SizedBox
[5]           정보 위젯
[3]           SizedBox
[5]           ConnectionStatusCard
```

**해당 Depth 문서**  
[0](./2_depth0_shell.md) → [1](./3_depth1_body.md) → [2](./4_depth2_layout.md) → [3](./5_depth3_decoration.md) → [5](./7_depth5_content.md)

---

## 레시피 2 — 서버 목록

```
[0] ApiFeatureShell (popToApiMainCount: 1)
      bottomBar: [새로고침, 이전]
      mainFunctionBody:
        if loading → Center + CircularProgressIndicator
        if error   → ServerListErrorView
        if empty   → ServerListEmptyMessage
        else →
[1]       RefreshIndicator
[1]         ListView.separated
[4]           Material + InkWell 타일
[2]             Row(아이콘, Expanded(Column 텍스트), chevron)
```

---

## 레시피 3 — 상세

```
[0] ApiFeatureShell (popToApiMainCount: 2~3)
      bottomBar: [목록, 삭제]
      mainFunctionBody:
[1]   SingleChildScrollView
[3]     Padding(16)
[2]       Column
[5]         미리보기 (이미지/맵)
[3]         SizedBox(24)
[5]         CommonTable(필드들)
```

---

## X vs Y 빠른 선택표

| 고민 | 선택 | 문서 |
|------|------|------|
| API 화면 껍데기? | `ApiFeatureShell` | [Depth 0](./2_depth0_shell.md) |
| 서로 다른 섹션 세로? | `SingleChildScrollView` + `Column` | [Depth 1](./3_depth1_body.md) |
| 같은 아이템 N개? | `ListView.builder` / `separated` | [Depth 1](./3_depth1_body.md) |
| 이미지 격자? | `GridView.builder` | [Depth 1](./3_depth1_body.md) |
| 당겨 새로고침? | `RefreshIndicator` + AlwaysScrollable | [Depth 1](./3_depth1_body.md) |
| 위아래 배치? | `Column` | [Depth 2](./4_depth2_layout.md) |
| 한 줄 배치? | `Row` + `Expanded` | [Depth 2](./4_depth2_layout.md) |
| 겹침(카메라/뱃지)? | `Stack` + `Positioned` | [Depth 2](./4_depth2_layout.md) |
| 사이 간격만? | `SizedBox` | [Depth 3](./5_depth3_decoration.md) |
| 바깥 여백? | `Padding` | [Depth 3](./5_depth3_decoration.md) |
| 테두리·배경 카드? | `Container` + `BoxDecoration` | [Depth 3](./5_depth3_decoration.md) |
| 하단 주요 버튼? | `BottomButtonRow` + `CustomButton` | [0](./2_depth0_shell.md)·[4](./6_depth4_interaction.md) |
| 연결 필요 버튼? | `ServerConnectionButton` | [Depth 4](./6_depth4_interaction.md) |
| 리스트 탭 리플? | `Material` + `InkWell` | [Depth 4](./6_depth4_interaction.md) |
| 안내 문구? | `InfoBox` | [Depth 5](./7_depth5_content.md) |
| 상세 필드 표? | `CommonTable` | [Depth 5](./7_depth5_content.md) |
| 짧은 알림? | `showStatusToast` | [Depth 6](./8_depth6_overlay.md) |
| 확인창? | `showPromptDialog` / DeleteConfirm | [Depth 6](./8_depth6_overlay.md) |
| 로딩? | `Center` + `CircularProgressIndicator` | [Depth 1](./3_depth1_body.md) |

---

## 작성 직전 체크리스트

1. [ ] Depth 0: `ApiFeatureShell` 또는 `FeatureShell` + (필요 시) `bottomBar`?
   로컬 전용(fileMgmt)은 connection 바 없이 `FeatureShell`. 상세는 [Flutter 활용 보완](./11_flutter_practices.md).
2. [ ] Depth 1: 메인(섹션) vs 목록 → ScrollView vs ListView?
3. [ ] Depth 2: `Column` / `Row` / `Stack` 중 맞는 것?
4. [ ] Depth 3: 바깥 `Padding(16)`, 사이 `SizedBox`?
5. [ ] Depth 5: `EgovText`/`EgovColor`, 안내는 `InfoBox`, 상세는 `CommonTable`?
6. [ ] Depth 4/6: CTA는 `CustomButton`, 알림은 `showStatusToast`?
7. [ ] `child`(1개) / `children:[]`(여러 개) 문법 OK? → [기초](./1_basics.md)
8. [ ] `Row` 긴 텍스트에 `Expanded`?
9. [ ] 스크롤 중첩(`ScrollView` 안 `ListView`) 피함?

---

## 자주 나는 실수

| 실수 | 증상 | 해결 |
|------|------|------|
| `Column`만 길고 스크롤 없음 | BOTTOM OVERFLOWED | `SingleChildScrollView` |
| `Row`에 긴 `Text` | RIGHT OVERFLOWED | `Expanded` |
| 스크롤 안 `ListView` | Vertical viewport unbounded | `Expanded`로 높이 제한 |
| `child`/`children` 혼동 | 컴파일 에러 | [1_basics](./1_basics.md) |
| SnackBar 사용 | 프로젝트 패턴과 불일치 | `showStatusToast` |

---

## 전체 목차

[0. 시작](./0_index.md) · [1. 문법](./1_basics.md) · [2. Depth0](./2_depth0_shell.md) · [3. Depth1](./3_depth1_body.md) · [4. Depth2](./4_depth2_layout.md) · [5. Depth3](./5_depth3_decoration.md) · [6. Depth4](./6_depth4_interaction.md) · [7. Depth5](./7_depth5_content.md) · [8. Depth6](./8_depth6_overlay.md) · **9. 레시피 (현재)**
