import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

class DeviceInfo {
  final int sn;
  final String uuid;
  final String os;
  final String ntwrkDeviceInfo;
  final String pgVer;
  final String deviceNm;
  final String useYn;
  final String? telno; // 연락처 개수 (서버 키: TELNO)
  final int strgeInfo; // 스토리지 용량 (서버 키: STRGE_INFO)

  DeviceInfo({
    required this.sn,
    required this.uuid,
    required this.os,
    required this.ntwrkDeviceInfo,
    required this.pgVer,
    required this.deviceNm,
    required this.useYn,
    this.telno,
    this.strgeInfo = 0,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      os: JsonRead.asString(json, ['os', 'OS'], defaultValue: 'Unknown'),
      ntwrkDeviceInfo: JsonRead.asString(
        json,
        ['ntwrkDeviceInfo', 'ntwrk_device_info', 'NTWRK_DEVICE_INFO'],
        defaultValue: 'Unknown',
      ),
      pgVer: JsonRead.asString(
        json,
        ['pgVer', 'pg_ver', 'PG_VER'],
        defaultValue: 'Unknown',
      ),
      deviceNm: JsonRead.asString(
        json,
        ['deviceNm', 'device_nm', 'DEVICE_NM'],
        defaultValue: 'Unknown',
      ),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'N',
      ),
      telno: JsonRead.asOptionalString(json, ['telno', 'TELNO']),
      strgeInfo: JsonRead.asInt(json, ['strgeInfo', 'strge_info', 'STRGE_INFO']),
    );
  }

  /// form 업로드용 필드
  Map<String, String> toUploadFields() {
    return {
      'uuid': uuid,
      'os': os,
      'ntwrkDeviceInfo': ntwrkDeviceInfo,
      'pgVer': pgVer,
      'deviceNm': deviceNm,
      'telno': telno ?? '',
      'strgeInfo': strgeInfo.toString(),
    };
  }

  /// SQLite insert/update용 행. sn 채번은 datasource에서 덮어쓸 수 있다.
  Map<String, Object?> toSqliteRow() {
    return {
      'sn': sn,
      'uuid': uuid,
      'os': os,
      'ntwrkDeviceInfo': ntwrkDeviceInfo,
      'pgVer': pgVer,
      'deviceNm': deviceNm,
      'useYn': useYn.isEmpty ? 'Y' : useYn,
      'telno': telno,
      'strgeInfo': strgeInfo,
    };
  }

  @override
  String toString() {
    return 'DeviceInfo(sn: $sn, uuid: $uuid, os: $os, ntwrkDeviceInfo: $ntwrkDeviceInfo, pgVer: $pgVer, deviceNm: $deviceNm, useYn: $useYn, telno: $telno, strgeInfo: $strgeInfo)';
  }
}
