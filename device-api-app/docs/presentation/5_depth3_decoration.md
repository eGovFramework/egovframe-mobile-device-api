# 5. Depth 3 — 여백 · 장식

> **무엇을:** 배치된 블록 사이 간격, 바깥 여백, 테두리·배경  
> 이전: [Depth 2](./4_depth2_layout.md) · 다음: [Depth 4 터치·입력](./6_depth4_interaction.md)

---

## 이 Depth에서 쓰는 위젯 모음

### 간격

| 위젯 | 한 줄 |
|------|------|
| `SizedBox` | 형제 **사이** 고정 간격 (가장 흔함) |
| `Padding` | 자식 **바깥(안쪽 여백)** 사방 |

### 박스 · 클립

| 위젯 | 한 줄 |
|------|------|
| `Container` | 색·테두리·둥근 모서리·패딩을 한곳에 |
| `ClipRRect` | 둥근 모서리로 **자르기** (이미지) |
| `AspectRatio` | 가로:세로 비율 고정 |
| `Divider` | 얇은 선 (목록 간격은 SizedBox가 더 흔함) |
| `Card` | Material 카드 (이 프로젝트는 소수 — 새 UI는 Container 권장) |

### 기타 (알아만 두기)

| 위젯 | 한 줄 |
|------|------|
| `DecoratedBox` | 장식만 (Container 단순판) |
| `ConstrainedBox` | 최대/최소 크기 (`CustomButton` 내부 등) |
| `AnimatedContainer` | 크기·색 애니메이션 |
| `Transform` / `Transform.scale` | 확대·축소 (버튼 프레스) |

---

## `SizedBox`

**무엇인가**  
고정 가로/세로 **빈 칸**.

**Depth**  
3 — `Column`/`Row`의 **형제 사이**

```dart
const SizedBox(height: 30), // 세로 간격
const SizedBox(width: 12),  // 가로 간격
```

---

## `Padding`

**무엇인가**  
자식 전체에 **안쪽 여백**.

**Depth**  
3

**이 프로젝트 표준**  
본문 바깥 `EdgeInsets.all(16)`.

```dart
Padding(
  padding: const EdgeInsets.all(16),
  child: Column(...),
)
```

**Padding vs SizedBox**

| | Padding | SizedBox |
|--|---------|----------|
| 역할 | 한 덩어리 **바깥** 여백 | A와 B **사이** 간격 |
| 예 | 화면 가장자리와 본문 | 큐브와 숫자 표시 사이 |

**팁**  
`Padding`은 스크롤 **안쪽**에 두는 편이 자연스럽다.

---

## `Container`

**무엇인가**  
색, 테두리, radius, 패딩, 크기를 줄 수 있는 박스.

**언제**  
카드 외곽선, 뱃지 배경. 이 프로젝트는 `Card`보다 **Container + BoxDecoration**이 주류.

```dart
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: EgovColor.white100,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: EgovColor.gray20),
  ),
  child: ...,
)
```

**초보자 규칙**  
- 여백만 → `Padding`  
- 색/테두리/radius → `Container`

---

## `ClipRRect` / `AspectRatio`

**ClipRRect**  
이미지를 둥근 사각형으로 잘라 모서리가 안 삐져나오게.

**AspectRatio**  
사진 비율 유지 (`aspectRatio: width / height`) → 찌그러짐 방지.

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: AspectRatio(
    aspectRatio: imageSize.width / imageSize.height,
    child: Image.file(...),
  ),
)
```

---

## 색 · 글꼴 (장식과 함께)

이 프로젝트 토큰:

```dart
// 색
EgovColor.primary50  // 강조
EgovColor.gray90     // 본문 글자
EgovColor.gray20     // 보더
EgovColor.point50    // 삭제 등 위험

// 글꼴
EgovText.medium.copyWith(fontWeight: FontWeight.w700, color: EgovColor.gray90)
EgovText.caption.copyWith(color: EgovColor.gray70)
```

경로: `lib/presentation/resources/color_style.dart`, `text_style.dart`

---

## Depth 3 선택 규칙

| 하고 싶은 것 | 선택 |
|--------------|------|
| 섹션 사이 간격 | `SizedBox(height: …)` |
| 화면 가장자리 여백 | `Padding(all: 16)` |
| 카드 테두리·배경 | `Container` + `BoxDecoration` |
| 이미지 둥글게 | `ClipRRect` |
| 이미지 비율 유지 | `AspectRatio` |

---

## 다음

누르는 버튼·입력 → [Depth 4 터치·입력](./6_depth4_interaction.md)
