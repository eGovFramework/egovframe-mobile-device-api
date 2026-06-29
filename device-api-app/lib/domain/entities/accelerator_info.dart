class AcceleratorInfo {
  final int? sn;
  final String uuid;
  final double xAxis;
  final double yAxis;
  final double zAxis;
  final String timestamp;
  final String useYn;

  AcceleratorInfo({
    this.sn,
    required this.uuid,
    required this.xAxis,
    required this.yAxis,
    required this.zAxis,
    required this.timestamp,
    required this.useYn,
  });

  factory AcceleratorInfo.fromJson(Map<String, dynamic> json) {
    return AcceleratorInfo(
      sn: json['sn'] is int ? json['sn'] : int.tryParse(json['sn']?.toString() ?? ''),
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
      'xaxis': xAxis.toStringAsFixed(6),
      'yaxis': yAxis.toStringAsFixed(6),
      'zaxis': zAxis.toStringAsFixed(6),
      'timestamp': timestamp,
      'useYn': useYn,
    };
  }
}
