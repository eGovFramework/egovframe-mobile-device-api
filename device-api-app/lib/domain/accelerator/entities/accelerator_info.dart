import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

class AcceleratorInfo {
  final int sn;
  final String uuid;
  final double xAxis;
  final double yAxis;
  final double zAxis;
  final String timestamp;
  final String useYn;

  AcceleratorInfo({
    required this.sn,
    required this.uuid,
    required this.xAxis,
    required this.yAxis,
    required this.zAxis,
    required this.timestamp,
    required this.useYn,
  });

  factory AcceleratorInfo.fromJson(Map<String, dynamic> json) {
    return AcceleratorInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      xAxis: JsonRead.asDouble(json, ['xaxis', 'xAxis', 'XAXIS']),
      yAxis: JsonRead.asDouble(json, ['yaxis', 'yAxis', 'YAXIS']),
      zAxis: JsonRead.asDouble(json, ['zaxis', 'zAxis', 'ZAXIS']),
      timestamp: JsonRead.asString(json, ['timestamp', 'TIMESTAMP']),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'Y',
      ),
    );
  }

  /// form/multipart 업로드용 필드
  ///
  /// 서버 ACCELERATOR.XAXIS/YAXIS/ZAXIS 컬럼이 VARCHAR(20)이라
  /// [double.toString] 전체 자릿수를 쓰면 insert가 실패할 수 있다.
  Map<String, String> toUploadFields() {
    return {
      'uuid': uuid,
      'xaxis': _formatAxis(xAxis),
      'yaxis': _formatAxis(yAxis),
      'zaxis': _formatAxis(zAxis),
      'timestamp': timestamp,
      'useYn': useYn,
    };
  }

  /// SQLite insert/update용 행. sn 채번은 datasource에서 덮어쓴다.
  Map<String, Object?> toSqliteRow() {
    return {
      'sn': sn,
      'uuid': uuid,
      'xaxis': _formatAxis(xAxis),
      'yaxis': _formatAxis(yAxis),
      'zaxis': _formatAxis(zAxis),
      'useYn': useYn,
      'timestamp': timestamp,
    };
  }

  static String _formatAxis(double value) => value.toStringAsFixed(6);
}
