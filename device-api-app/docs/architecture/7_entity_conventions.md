# Entity·State 작성 규칙 (freezed 미사용)

> freezed 없이 **수동 클래스 + 공용 유틸**로 일관성을 유지한다.

## 1. Entity 직렬화 메서드 이름

| 메서드 | 용도 | 반환 타입 가이드 |
|--------|------|------------------|
| `fromJson` | API·SQLite row·맵에서 객체 생성 | `factory` |
| `toJson` | **JSON API 본문** 왕복 (중첩 JSON 등) | `Map<String, dynamic>` |
| `toUploadFields` | **multipart/form 또는 form 필드** 업로드 | `Map<String, String>` |
| `toSqliteRow` | 로컬 SQLite insert/update용 | `Map<String, Object?>` |

규칙:

- form 업로드만 하면 `toUploadFields`를 쓰고, JSON body면 `toJson`을 쓴다. 둘을 섞지 않는다.
- SQLite에 저장하는 feature는 `toSqliteRow`를 entity에 두고, datasource에서 맵을 손으로 조립하지 않는다.
- sn을 DB에서 채번하는 경우: `{...info.toSqliteRow(), 'sn': generatedSn}`처럼 **나중에 덮어쓴다**.

JSON 키 별칭·타입 변환은 entity마다 `_readString`을 두지 말고
[`JsonRead`](../../lib/domain/shared/json_read.dart)를 사용한다.

```dart
factory Foo.fromJson(Map<String, dynamic> json) {
  return Foo(
    sn: JsonRead.asInt(json, ['sn', 'SN']),
    uuid: JsonRead.asString(json, ['uuid', 'UUID']),
    useYn: JsonRead.asString(json, ['useYn', 'useyn', 'USEYN'], defaultValue: 'N'),
  );
}
```

## 2. Presentation State (`*_state.dart`)

- `const` 생성자 + `factory XxxState.initial()`
- 불변 필드 + 수동 `copyWith`
- 일반 필드는 `value ?? this.value`
- **nullable을 명시적으로 null로 비울 때**만 `clearXxx = false` 플래그를 추가한다  
  (예: `clearPosition`, `clearNetworkInfo`)
- `==` / `hashCode`는 테스트에서 값 비교가 필요할 때만 선택적으로 추가한다

## 3. Domain Result

- Dart 3 `sealed class` + Success / Failure / Empty 변형을 유지한다.
- feature마다 네이밍만 맞춘다 (`XxxLoadSuccess`, `XxxLoadFailure` 등).
