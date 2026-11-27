/// 온습도 텔레메트리 페이로드
class IotTelemetry {
  final double? temperature;
  final double? humidity;
  final String? rawPayload;
  final String topic;
  final DateTime receivedAt;

  const IotTelemetry({
    this.temperature,
    this.humidity,
    this.rawPayload,
    required this.topic,
    required this.receivedAt,
  });

  bool get hasNumericValues => temperature != null || humidity != null;

  String get temperatureText =>
      temperature == null ? '-' : temperature!.toStringAsFixed(1);

  String get humidityText =>
      humidity == null ? '-' : humidity!.toStringAsFixed(1);

  /// 온·습도 표시값(소수 1자리) 기준 변경 여부
  bool valuesDifferFrom(IotTelemetry? other) {
    if (other == null) return hasNumericValues;
    return temperatureText != other.temperatureText ||
        humidityText != other.humidityText;
  }
}
