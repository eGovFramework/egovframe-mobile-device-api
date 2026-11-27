import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

class PushDeviceInfo {
  final int sn;
  final String uuid;
  final String ntwrkDeviceInfo;
  final String osVer;
  final String deviceNm;
  final String useYn;
  final String osType;
  final String tokenId;

  const PushDeviceInfo({
    required this.sn,
    required this.uuid,
    required this.ntwrkDeviceInfo,
    required this.osVer,
    required this.deviceNm,
    required this.useYn,
    required this.osType,
    required this.tokenId,
  });

  factory PushDeviceInfo.fromJson(Map<String, dynamic> json) {
    return PushDeviceInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      ntwrkDeviceInfo: JsonRead.asString(json, [
        'ntwrkDeviceInfo',
        'NTWRK_DEVICE_INFO',
      ]),
      osVer: JsonRead.asString(json, ['osVer', 'OS_VER']),
      deviceNm: JsonRead.asString(json, ['deviceNm', 'DEVICE_NM']),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'N',
      ),
      osType: JsonRead.asString(json, ['osType', 'OS_TYPE']),
      tokenId: JsonRead.asString(json, ['tokenId', 'TOKEN_ID']),
    );
  }

  Map<String, String> toUploadFields() {
    return {
      'uuid': uuid,
      'ntwrkDeviceInfo': ntwrkDeviceInfo,
      'osVer': osVer,
      'deviceNm': deviceNm,
      'useYn': useYn,
      'osType': osType,
      'tokenId': tokenId,
    };
  }

  Map<String, Object?> toSqliteRow() {
    return {
      'sn': sn,
      'uuid': uuid,
      'ntwrkDeviceInfo': ntwrkDeviceInfo,
      'osVer': osVer,
      'deviceNm': deviceNm,
      'useYn': useYn,
      'osType': osType,
      'tokenId': tokenId,
    };
  }
}
