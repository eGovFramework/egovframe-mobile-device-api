import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

class CompassInfo {
  final int sn;
  final String uuid;
  final String drc;
  final String accrcy;
  final String useYn;
  final String timestamp;

  const CompassInfo({
    required this.sn,
    required this.uuid,
    required this.drc,
    required this.accrcy,
    required this.useYn,
    required this.timestamp,
  });

  factory CompassInfo.fromJson(Map<String, dynamic> json) {
    return CompassInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      drc: JsonRead.asString(json, ['drc', 'DRC']),
      accrcy: JsonRead.asString(json, ['accrcy', 'ACCRCY']),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'N',
      ),
      timestamp: JsonRead.asString(json, ['timestamp', 'TIMESTAMP']),
    );
  }

  Map<String, String> toUploadFields() {
    return {
      'uuid': uuid,
      'drc': drc,
      'accrcy': accrcy,
      'timestamp': timestamp,
      'useYn': useYn,
    };
  }

  Map<String, Object?> toSqliteRow() {
    return {
      'sn': sn,
      'uuid': uuid,
      'drc': drc,
      'accrcy': accrcy,
      'useYn': useYn,
      'timestamp': timestamp,
    };
  }
}
