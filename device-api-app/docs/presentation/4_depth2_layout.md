# 4. Depth 2 — 배치 (Column · Row · Stack)

> **무엇을:** 스크롤/목록 **안쪽**에서 위젯을 위아래·좌우·겹침으로 배치  
> 이전: [Depth 1](./3_depth1_body.md) · 다음: [Depth 3 여백·장식](./5_depth3_decoration.md)

---

## 이 Depth에서 쓰는 위젯 모음

| 위젯 | 방향/방식 |
|------|-----------|
| `Column` | 위 → 아래 (가장 많이 씀) |
| `Row` | 왼쪽 → 오른쪽 |
| `Wrap` | 가로로 놓다 자리 없으면 다음 줄 |
| `Stack` + `Positioned` | 겹침 (카메라·뱃지·박스) |

---

## `Column`

**무엇인가**  
자식을 **위에서 아래로** 순서대로 배치.  
**선언 순서 = 화면에서 보이는 위→아래 순서.**

**Depth**  
2

**언제**  
메인 섹션 스택, 카드 안 여러 줄 텍스트, 상세 본문.

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch, // 가로로 꽉
  children: [
    TitleWidget(),
    BodyWidget(),
  ],
)
```

| `crossAxisAlignment` | 의미 |
|----------------------|------|
| `start` | 왼쪽 정렬 (목록 텍스트) |
| `stretch` | 자식이 가로 전체 (버튼·카드) |
| `center` | 가운데 |

---

## `Row`

**무엇인가**  
자식을 **왼쪽에서 오른쪽**.

**언제**  
아이콘 + 제목 + 화살표 한 줄, 라벨|값.

```dart
Row(
  children: [
    const Icon(Icons.face),
    const SizedBox(width: 12),
    Expanded(                    // 긴 글자 overflow 방지
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Text(subtitle),
        ],
      ),
    ),
    const Icon(Icons.chevron_right),
  ],
)
```

**초보자 필수**  
`Row` 안 긴 `Text`는 반드시 `Expanded` 또는 `Flexible`로 감싼다.  
안 그러면 **RIGHT OVERFLOWED** 노란/검정 줄이 난다.

---

## `Wrap`

**무엇인가**  
`Row`처럼 가로로 놓다가 **자리 없으면 다음 줄**로 넘어감.

**언제**  
연결 상태 칩/태그처럼 개수가 들쭉날쭉할 때.

---

## `Stack` + `Positioned`

**무엇인가**  
자식을 **겹쳐서** 그림. **나중에 쓴 위젯이 위에** 그려진다.

**Depth**  
2 (특수 — 일반 폼에는 쓰지 말 것)

**언제 (이 프로젝트)**  
- 카메라 미리보기 + Tracking Box  
- 이미지 위 얼굴 수 뱃지 / 체크박스  
- 플레이어 컨트롤 오버레이  

```dart
Stack(
  fit: StackFit.expand,
  children: [
    Image.file(...),                 // 아래 레이어
    CustomPaint(painter: ...),       // 박스
    Positioned(                      // 모서리에 고정
      top: 8,
      right: 8,
      child: FaceCountBadge(),
    ),
  ],
)
```

**보더가 이미지에 가려질 때**  
`foregroundDecoration`을 쓰거나, `Stack` **맨 위**에 보더용 위젯을 올린다.

---

## Depth 2 선택 규칙

| 하고 싶은 것 | 선택 |
|--------------|------|
| 세로로 섹션 쌓기 | `Column` |
| 한 줄 (아이콘+글+화살표) | `Row` + `Expanded` |
| 칩이 줄바꿈 | `Wrap` |
| 이미지 위 뱃지/박스 | `Stack` + `Positioned` |

---

## 다음

간격과 카드 테두리 → [Depth 3 여백·장식](./5_depth3_decoration.md)
