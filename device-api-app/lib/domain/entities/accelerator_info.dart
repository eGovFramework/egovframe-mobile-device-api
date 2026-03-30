class AcceleratorInfo {
  final String uuid;
  final double xAxis;
  final double yAxis;
  final double zAxis;
  final String timestamp;
  final String useYn;

  AcceleratorInfo({
    required this.uuid,
    required this.xAxis,
    required this.yAxis,
    required this.zAxis,
    required this.timestamp,
    required this.useYn,
  });

  factory AcceleratorInfo.fromJson(Map<String, dynamic> json) {
    return AcceleratorInfo(
      uuid: json['uuid'] ?? '',
      xAxis: double.tryParse(json['xaxis'] ?? '0') ?? 0.0,
      yAxis: double.tryParse(json['yaxis'] ?? '0') ?? 0.0,
      zAxis: double.tryParse(json['zaxis'] ?? '0') ?? 0.0,
      timestamp: json['timestamp'] ?? '',
      useYn: json['useYn'] ?? 'Y',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'xaxis': xAxis.toString(),
      'yaxis': yAxis.toString(),
      'zaxis': zAxis.toString(),
      'timestamp': timestamp,
      'useYn': useYn,
    };
  }
}
