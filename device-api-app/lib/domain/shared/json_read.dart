/// Entity [fromJson]에서 키 별칭·타입 강제 파싱을 공통화한다.
///
/// 사용 예:
/// ```dart
/// JsonRead.asInt(json, ['sn', 'SN'])
/// JsonRead.asString(json, ['uuid', 'UUID'])
/// JsonRead.asOptionalString(json, ['source', 'SOURCE'])
/// JsonRead.asDouble(json, ['lat', 'la'])
/// ```
abstract final class JsonRead {
  static dynamic _first(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (_hasValue(value)) return value;
    }
    if (json.isEmpty || keys.isEmpty) return null;

    final normalized = <String, dynamic>{};
    for (final entry in json.entries) {
      if (!_hasValue(entry.value)) continue;
      normalized.putIfAbsent(_normalizeKey(entry.key), () => entry.value);
    }
    for (final key in keys) {
      final value = normalized[_normalizeKey(key)];
      if (_hasValue(value)) return value;
    }
    return null;
  }

  static bool _hasValue(dynamic value) {
    if (value == null) return false;
    if (value is String && value.trim().isEmpty) return false;
    return true;
  }

  static String _normalizeKey(String key) =>
      key.replaceAll('_', '').toLowerCase();

  /// 여러 키 중 첫 non-null 값을 [int]로 변환한다.
  static int asInt(
    Map<String, dynamic> json,
    List<String> keys, {
    int defaultValue = 0,
  }) {
    return parseInt(_first(json, keys), defaultValue: defaultValue);
  }

  /// 여러 키 중 첫 non-null 값을 [double]로 변환한다.
  static double asDouble(
    Map<String, dynamic> json,
    List<String> keys, {
    double defaultValue = 0.0,
  }) {
    return parseDouble(_first(json, keys), defaultValue: defaultValue);
  }

  /// 여러 키 중 첫 non-null 값을 [String]으로 변환한다.
  static String asString(
    Map<String, dynamic> json,
    List<String> keys, {
    String defaultValue = '',
    bool trim = false,
  }) {
    final value = _first(json, keys);
    if (value == null) return defaultValue;
    final text = '$value';
    return trim ? text.trim() : text;
  }

  /// 비어 있으면 null을 반환하는 [asString].
  static String? asOptionalString(
    Map<String, dynamic> json,
    List<String> keys, {
    bool trim = false,
  }) {
    final value = asString(json, keys, trim: trim);
    return value.isEmpty ? null : value;
  }

  /// 여러 키 중 첫 non-null 값을 [DateTime]으로 파싱한다.
  static DateTime? asDateTime(Map<String, dynamic> json, List<String> keys) {
    final value = _first(json, keys);
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse('$value');
  }

  static int parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    return int.tryParse('$value') ?? defaultValue;
  }

  static double parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse('$value') ?? defaultValue;
  }
}
