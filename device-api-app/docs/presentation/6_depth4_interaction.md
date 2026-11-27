# 6. Depth 4 — 터치 · 입력

> **무엇을:** 사용자가 누르고 입력하는 위젯  
> 이전: [Depth 3](./5_depth3_decoration.md) · 다음: [Depth 5 내용물](./7_depth5_content.md)

---

## 이 Depth에서 쓰는 위젯 모음

### 버튼 · 탭

| 위젯 | 한 줄 |
|------|------|
| `CustomButton` | 프로젝트 표준 CTA (하단 바) |
| `ServerConnectionButton` | 연결 확인 후 실행 |
| `InkWell` + `Material` | 카드/목록 탭 + 물결 |
| `GestureDetector` | 탭만 (리플 없음) |
| `TextButton` | 다이얼로그 확인/취소 |
| `IconButton` | AppBar·플레이어 아이콘 |

### 입력 · 토글

| 위젯 | 한 줄 |
|------|------|
| `TextField` / `CustomTextFormField` | 텍스트 입력 |
| `PasswordTextFormField` | 비밀번호 |
| `Switch` | on/off (SQLite 토글 등) |
| `Checkbox` / `Slider` / `ListTile` / `TabBar` | 선택·시크·탭 (소수~미디어) |

---

## `CustomButton`

**무엇인가**  
프레스 애니메이션이 있는 표준 버튼.

**Depth**  
4 — 주로 Depth 0 `BottomButtonRow` 안

**언제**  
저장, 목록, 새로고침, 이전 화면 등 **화면 주요 행동**.

```dart
CustomButton(
  text: '저장',
  icon: const Icon(Icons.save, color: EgovColor.white100, size: 20),
  onTap: onSave,
  normalColor: EgovColor.primary50, // 삭제는 point50 등
)
```

---

## `ServerConnectionButton`

**무엇인가**  
누르기 전 **서버/SQLite 연결을 resolve**한 뒤 `onServerConnected` 실행.

**언제**  
업로드, 목록 조회, 삭제처럼 **저장소가 필요한** 액션.

```dart
ServerConnectionButton(
  text: '목록 조회',
  onServerConnected: () async => openList(),
  resolveConnection: XxxConnectionResolver.resolveConnection,
)

// 또는 팩토리
ServerConnectionButtonFactory.uploadButton(
  text: '저장',
  onServerConnected: save,
  resolveConnection: ...,
)
```

---

## `InkWell` + `Material`

**InkWell**  
탭 + Material **물결(리플)**.

**Material**  
리플이 그려질 배경. 카드 탭에 세트로 자주 씀.

```dart
Material(
  color: EgovColor.white100,
  borderRadius: BorderRadius.circular(8),
  child: InkWell(
    borderRadius: BorderRadius.circular(8), // Material과 맞출 것
    onTap: onOpenDetail,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(...),
    ),
  ),
)
```

---

## `GestureDetector`

**무엇인가**  
탭/롱프레스 등. **리플 없음**.

**언제**  
리플 없이 탭만, 또는 버튼이 자체 애니메이션을 그릴 때.

### InkWell vs GestureDetector

| | InkWell | GestureDetector |
|--|---------|-----------------|
| 리플 | 있음 | 없음 |
| 추천 | 리스트·카드 | 단순 감지·커스텀 애니 |

---

## Material 버튼 (보조)

| 위젯 | 이 프로젝트에서의 역할 |
|------|------------------------|
| `TextButton` | 다이얼로그 확인/취소 ([Depth 6](./8_depth6_overlay.md)) |
| `IconButton` | AppBar, 플레이어 |
| `ElevatedButton` / `OutlinedButton` | 소수 — 새 CTA는 `CustomButton` |

---

## 입력

```dart
CustomTextFormField(
  label: '서버 URL',
  hintText: 'https://...',
  controller: urlController,
)

PasswordTextFormField(
  label: '비밀번호',
  hintText: '입력',
  controller: pwController,
)

Switch(
  value: useSqlite,
  onChanged: (v) => ...,
)
```

---

## Depth 4 선택 규칙

| 하고 싶은 것 | 선택 |
|--------------|------|
| 하단 주요 버튼 | `CustomButton` in `BottomButtonRow` |
| 연결 필요 버튼 | `ServerConnectionButton` |
| 목록/카드 탭 + 리플 | `Material` + `InkWell` |
| 리플 없이 탭 | `GestureDetector` |
| 텍스트 입력 | `CustomTextFormField` |
| on/off | `Switch` |

---

## 다음

화면에 보이는 글·표·아이콘 → [Depth 5 내용물](./7_depth5_content.md)
