# 8. Depth 6 — 오버레이 · 화면 이동

> **무엇을:** 본문 **위에** 뜨는 것, 다른 화면으로 넘어가기  
> 이전: [Depth 5](./7_depth5_content.md) · 다음: [레시피·치트시트](./9_recipes.md)

---

## 이 Depth에서 쓰는 위젯·API 모음

### 다이얼로그 · 시트 · 토스트

| API / 위젯 | 한 줄 |
|------------|------|
| `showPromptDialog` | 확인/취소 공통 |
| `showServerDeleteConfirm` | 삭제 확인 |
| `showServerRegisterConfirm` | 등록/저장 확인 |
| `showDialog` / `AlertDialog` | 시스템 다이얼로그 |
| `showAppActionSheet` / `showModalBottomSheet` | 아래에서 올라오는 선택 |
| `showToast` / `showStatusToast` | 짧은 알림 (**SnackBar 안 씀**) |

### 이동

| API | 한 줄 |
|-----|------|
| `Navigator.push` | 다음 화면 |
| `Navigator.pop` | 뒤로 (+ 결과 전달 가능) |
| `MaterialPageRoute` | 일반 페이지 전환 |

---

## 확인 다이얼로그

```dart
final confirmed = await showServerDeleteConfirm(
  context,
  title: l10n.faceMeshDeleteSelectedTitle,
  message: l10n.faceMeshDeleteSelectedGroupsConfirm(count),
);
if (!confirmed || !mounted) return;

// 삭제 실행...
```

```dart
final ok = await showPromptDialog(
  context,
  title: '저장',
  message: '저장할까요?',
  confirmText: l10n.commonConfirm,
  cancelText: l10n.commonCancel,
);
```

---

## 액션 시트 (카메라 / 갤러리 선택)

```dart
await showAppActionSheet(
  context,
  title: '이미지 선택',
  message: '출처를 고르세요',
  actions: [
    AppBottomSheetAction(
      label: '카메라',
      icon: Icons.camera_alt,
      onTap: () => pick(ImageSource.camera),
    ),
    AppBottomSheetAction(
      label: '갤러리',
      icon: Icons.photo_library,
      onTap: () => pick(ImageSource.gallery),
    ),
  ],
);
```

---

## 토스트 (성공 / 실패 알림)

이 프로젝트는 **SnackBar 대신** Overlay 토스트를 쓴다.

```dart
await showStatusToast(
  context,
  variant: StatusVariant.success,
  title: l10n.commonSuccess,
  message: '저장되었습니다',
);

await showStatusToast(
  context,
  variant: StatusVariant.error,
  title: l10n.commonError,
  message: resolveAppMessage(l10n, message),
);

await showToast(
  context,
  message: '안내 메시지',
  variant: ToastVariant.info,
);
```

---

## `Navigator` — 화면 이동

```dart
// 다음 화면으로
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const XxxListPage()),
);

// 단순 뒤로
Navigator.pop(context);

// 결과 전달 (예: 삭제 후 목록 새로고침)
Navigator.pop(context, true);

// 받을 때
final changed = await Navigator.push<bool>(...);
if (changed == true) await reload();
```

**Route 이름**  
목록으로 `popUntil`할 때 `RouteSettings(name: ...)`를 쓰는 경우가 있다  
(예: Face Mesh 목록 `routeName`).

---

## Depth 6 선택 규칙

| 하고 싶은 것 | 선택 |
|--------------|------|
| 삭제/저장 확인 | `showServerDeleteConfirm` / `showServerRegisterConfirm` |
| 여러 선택지 (카메라 등) | `showAppActionSheet` |
| 짧은 성공·실패 메시지 | `showStatusToast` |
| 다음 화면 | `Navigator.push` + `MaterialPageRoute` |
| 뒤로 + 새로고침 신호 | `Navigator.pop(context, true)` |

---

## 다음

실제로 화면 3종을 조립 → [레시피·치트시트](./9_recipes.md)
