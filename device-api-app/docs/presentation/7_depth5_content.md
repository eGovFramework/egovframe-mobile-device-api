# 7. Depth 5 — 내용물 (Text · 표 · 이미지)

> **무엇을:** 실제로 **보이는 정보**  
> 이전: [Depth 4](./6_depth4_interaction.md) · 다음: [Depth 6 오버레이](./8_depth6_overlay.md)

---

## 이 Depth에서 쓰는 위젯 모음

### Flutter 기본

| 위젯 | 한 줄 |
|------|------|
| `Text` | 글자 |
| `Icon` | 아이콘 |
| `Image` (`file` / `network` / `asset`) | 이미지 |
| `CircularProgressIndicator` | 로딩 (보통 Depth 1 `Center`와 함께) |
| `CustomPaint` | 직접 그림 (나침반, Tracking Box, 3D 큐브) |
| `SelectableText` | 선택 가능한 글 (소수) |

### 프로젝트 공통

| 위젯 | 한 줄 |
|------|------|
| `InfoBox` | 안내/힌트 박스 |
| `CommonTable` | 상세 화면 라벨·값 표 |
| `LabelValueGroup` / `LabelValueRow` | 카드 안 라벨·값 |
| `ServerMediaThumbnail` | 미디어 썸네일 |

---

## `Text` / `Icon`

```dart
Text(
  '제목',
  style: EgovText.medium.copyWith(
    fontWeight: FontWeight.w700,
    color: EgovColor.gray90,
  ),
)

const Icon(Icons.face_retouching_natural, color: EgovColor.gray50)
```

**권장**  
하드코딩 색·폰트 대신 `EgovColor` / `EgovText`.

---

## `Image`

```dart
Image.file(File(path), fit: BoxFit.cover)
Image.network(url, fit: BoxFit.cover)
Image.asset('assets/...', fit: BoxFit.contain)
```

미리보기는 보통 [Depth 3](./5_depth3_decoration.md)의 `ClipRRect` + `AspectRatio`로 감싼다.

---

## `CircularProgressIndicator`

```dart
const Center(child: CircularProgressIndicator())
```

---

## `CustomPaint`

**무엇인가**  
`CustomPainter`로 박스·바늘·큐브 등을 그림.

**언제**  
얼굴 Tracking Box, 바코드 스캔 마스크, 나침반 다이얼, 3D 큐브.  
보통 [Depth 2 `Stack`](./4_depth2_layout.md) 안에 둔다.

```dart
CustomPaint(
  painter: FaceBoundingBoxPainter(
    faces: faces,
    imageSize: imageSize,
    labels: ['#0', '#1'],
  ),
)
```

---

## `InfoBox`

**무엇인가**  
안내 아이콘 + 텍스트.

**언제**  
선택 방법 힌트, 권한/주의, “이미지 없음” 안내 등.

```dart
InfoBox(text: l10n.faceMeshSelectionModeHint)
```

---

## `CommonTable`

**무엇인가**  
제목 + `label` / `value` 행 표.

**언제**  
**상세 화면**에서 sn, uuid, 좌표 등 필드를 나열할 때.  
(`DataTable`은 GPS 등 예외 — 새 상세는 `CommonTable`)

```dart
CommonTable(
  title: '상세정보',
  data: [
    {'label': '일련번호', 'value': '$sn'},
    {'label': '그룹 ID', 'value': faceGroupId},
  ],
)
```

---

## `LabelValueGroup` / `LabelValueRow`

카드·오버뷰 안에서 라벨 너비를 맞춰 여러 줄 표시할 때.

```dart
LabelValueGroup(entries: [
  LabelValueEntry(label: '형식', value: 'QR'),
  LabelValueEntry(label: '값', value: raw),
])
```

---

## Depth 5 선택 규칙

| 하고 싶은 것 | 선택 |
|--------------|------|
| 제목/본문 글 | `Text` + `EgovText` |
| 목록 왼쪽 아이콘 | `Icon` |
| 안내 문구 | `InfoBox` |
| 상세 필드 표 | `CommonTable` |
| 사진 | `Image` (+ ClipRRect / AspectRatio) |
| 센서·감지 오버레이 그림 | `CustomPaint` |
| 로딩 | `CircularProgressIndicator` |

---

## 다음

확인창·토스트·화면 이동 → [Depth 6 오버레이](./8_depth6_overlay.md)
