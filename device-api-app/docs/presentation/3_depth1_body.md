# 3. Depth 1 — body 골격 (스크롤 · 목록 · 로딩)

> **무엇을:** `mainFunctionBody` / `Scaffold.body` 바로 아래 — “본문이 어떻게 늘어나나”  
> 이전: [Depth 0](./2_depth0_shell.md) · 다음: [Depth 2 배치](./4_depth2_layout.md)

---

## 이 Depth에서 쓰는 위젯 모음

### 스크롤 계열 (비슷해서 같이 외우기)

| 위젯 | 한 줄 |
|------|------|
| `SingleChildScrollView` | 서로 다른 섹션 몇 개를 스크롤 |
| `ListView` / `builder` / `separated` | 같은 아이템 N개 목록 |
| `GridView.builder` | 같은 카드 격자 (2열 등) |
| `RefreshIndicator` | 당겨서 새로고침 (스크롤 **바깥**에서 감쌈) |
| `AlwaysScrollableScrollPhysics` | 내용이 짧아도 스크롤 제스처 받기 |

### 공간 나누기 · 상태

| 위젯 | 한 줄 |
|------|------|
| `Expanded` | Column/Row에서 남은 공간 전부 |
| `Flexible` / `Spacer` | 일부만 / 빈 공간 |
| `Center` | 가운데 (로딩에 가장 많이) |
| `ServerListEmptyMessage` / `ServerListErrorView` | 빈 목록 / 오류+재시도 |

---

## `SingleChildScrollView`

**무엇인가**  
자식 **하나**를 세로(또는 가로)로 스크롤.

**Depth**  
1

**언제 쓰나 (이 프로젝트)**  
- 메인/오버뷰: 큐브 + 숫자 + 연결카드처럼 **서로 다른 섹션 몇 개**  
- 상세에서 표가 길 때  
- 가이드/설명 텍스트가 길 때  

**언제 안 쓰나**  
- 같은 카드가 **수십 개** → `ListView`  
- 이미 `ListView`가 있는데 또 바깥에 스크롤 → **중첩 충돌**

```dart
SingleChildScrollView(
  physics: const AlwaysScrollableScrollPhysics(),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        SectionA(),
        SectionB(),
      ],
    ),
  ),
)
```

---

## `AlwaysScrollableScrollPhysics`

**무엇인가**  
내용이 화면보다 짧아도 **스크롤 제스처를 받음**.

**언제**  
`RefreshIndicator`와 함께 쓸 때 거의 필수.  
짧은 화면에서도 “당겨서 새로고침”이 되게.

---

## `ListView` / `ListView.builder` / `ListView.separated`

**무엇인가**  
**같은 형태 아이템 N개** 스크롤 목록.

**Depth**  
1

**언제**  
서버 목록, 연락처, 파일 목록 등.

| 종류 | 차이 |
|------|------|
| `builder` | 화면에 보이는 것만 생성 (성능) |
| `separated` | 아이템 사이 간격/구분선 콜백 |

```dart
ListView.separated(
  physics: const AlwaysScrollableScrollPhysics(),
  itemCount: items.length,
  separatorBuilder: (_, __) => const SizedBox(height: 8),
  itemBuilder: (context, index) => ItemTile(item: items[index]),
)
```

---

## `GridView.builder`

**무엇인가**  
격자 (예: 2열 이미지 카드).

**언제**  
미디어 썸네일, Face Mesh 그룹 이미지 목록.

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 0.78,
  ),
  itemCount: groups.length,
  itemBuilder: (context, index) => GroupCard(...),
)
```

---

## `RefreshIndicator`

**무엇인가**  
아래로 당겨 새로고침.

**Depth**  
1 — 스크롤 위젯을 **바깥에서** 감싼다.

```dart
RefreshIndicator(
  onRefresh: () async => notifier.reload(),
  color: EgovColor.primary50,
  child: ListView.builder(...), // 또는 SingleChildScrollView
)
```

---

## 스크롤 계열 한눈에

| 위젯 | 쓰는 순간 |
|------|-----------|
| `SingleChildScrollView` | 서로 다른 섹션 몇 개 |
| `ListView*` | 같은 아이템 N개 |
| `GridView*` | 같은 카드 격자 |
| `RefreshIndicator` | 당겨서 새로고침 |

### 초보자 금기

```dart
// ❌ 스크롤 안에 또 무한 높이 ListView
SingleChildScrollView(child: ListView(...))

// ✅ 위 헤더 + 아래 목록
Column(
  children: [
    Header(),
    Expanded(child: ListView(...)),
  ],
)
```

---

## `Expanded` / `Flexible` / `Spacer`

**Expanded**  
`Column`/`Row` 안에서 **남은 공간을 전부** 차지.

```dart
Column(
  children: [
    InfoBox(text: '...'),
    Expanded(child: ListView(...)), // 아래가 목록으로 꽉 참
  ],
)
```

**주의**  
`SingleChildScrollView` → `Column` 안에서 `Expanded`는 보통 **에러**.  
(스크롤 방향 높이가 무한에 가깝기 때문)  
`Expanded`는 **높이가 정해진** Flex 부모 안에서만.

**Flexible**  
남은 공간 중 일부. `Row` 안 긴 텍스트 줄임 등.

**Spacer**  
`Expanded`의 빈 공간 버전. 좌우 양끝 배치.

---

## `Center` + 로딩

```dart
if (isLoading) {
  return const Center(child: CircularProgressIndicator());
}
```

---

## 목록 빈 상태 / 에러

```dart
if (error.isNotEmpty) {
  return ServerListErrorView(
    errorMessage: error,
    onRetry: reload,
  );
}
if (items.isEmpty) {
  return ServerListEmptyMessage(message: '저장된 데이터가 없습니다.');
}
```

---

## Depth 1 선택 규칙

| 본문 성격 | 선택 |
|-----------|------|
| 섹션 몇 개 (메인) | `RefreshIndicator` → `SingleChildScrollView` → `Column` |
| 같은 행 N개 (목록) | `RefreshIndicator` → `ListView` |
| 이미지 격자 | `GridView` (+ 필요 시 위 `Column`+`Expanded`) |
| 로딩만 | `Center` + `CircularProgressIndicator` |

---

## 다음

스크롤/목록 **안쪽**에서 위젯을 늘어놓기 → [Depth 2 배치](./4_depth2_layout.md)
