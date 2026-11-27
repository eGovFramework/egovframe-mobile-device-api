# 1. 문법 기초 — `child` / `children`

> 위젯을 조립할 때 가장 먼저 헷갈리는 부분만 정리한다.  
> 다음: [Depth 0 껍데기](./2_depth0_shell.md)

---

## 한 줄 요약

| 상황 | 쓰는 것 | 예 |
|------|---------|----|
| 자식이 **1개** | `child: Widget(...)` | `Padding(child: Column(...))` |
| 자식이 **여러 개** | `children: [ ... ]` | `Column(children: [A, B, C])` |

- `()` → 위젯 **하나** 만들기  
- `[]` → 위젯 **목록**(배열)

---

## 맞는 예 / 틀린 예

```dart
// ✅ 스크롤은 자식 1개만 → child
//    여러 섹션은 Column으로 묶어서 그 “하나”로 넣는다
SingleChildScrollView(
  child: Column(
    children: [
      Text('A'),
      Text('B'),
    ],
  ),
)

// ❌ SingleChildScrollView에는 children이 없음
SingleChildScrollView(children: [...])

// ❌ Column에는 child가 없음
Column(child: Text('A'))
```

---

## 왜 이렇게 나뉘나?

| 위젯 종류 | 자식 개수 | 키워드 |
|-----------|-----------|--------|
| `Padding`, `Center`, `Expanded`, `SingleChildScrollView` | 항상 1 | `child` |
| `Column`, `Row`, `Stack`, `ListView`(children 모드) | 0개 이상 | `children` |

**여러 개를 스크롤하고 싶을 때 사고 순서**

1. 여러 위젯을 `Column(children: [...])`으로 **한 덩어리**로 묶는다  
2. 그 덩어리를 `SingleChildScrollView(child: ...)`에 넣는다  

---

## `const`는 언제?

```dart
const SizedBox(height: 30),
physics: const AlwaysScrollableScrollPhysics(),
padding: const EdgeInsets.all(16),
```

- 넘기는 값이 **컴파일 시점에 고정**일 때만 `const`
- `accelState.xAxis`처럼 **상태에 따라 바뀌면** `const` 불가

---

## 다음 단계

화면 **맨 바깥 껍데기**부터 고른다 → [Depth 0 껍데기](./2_depth0_shell.md)
