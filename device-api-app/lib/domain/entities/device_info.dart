class DeviceInfo {
  final int sn;
  final String uuid;
  final String os;
  final String ntwrkDeviceInfo;
  final String pgVer;
  final String deviceNm;
  final String useYn;
  final String? telno;       // 연락처 개수 (서버 키: TELNO)
  final int strgeInfo;   // 스토리지 용량 (서버 키: STRGE_INFO)

  DeviceInfo({
    required this.sn,
    required this.uuid,
    required this.os,
    required this.ntwrkDeviceInfo,
    required this.pgVer,
    required this.deviceNm,
    required this.useYn,
    this.telno,
    this.strgeInfo =0,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    final rawStrge = json['strgeInfo'] ?? json['STRGE_INFO'];
    return DeviceInfo(
      sn: json['sn'] ?? 0,
      uuid: json['uuid'] ?? '',
      os: json['os'] ?? 'Unknown',
      ntwrkDeviceInfo: json['ntwrkDeviceInfo'] ?? 'Unknown',
      pgVer: json['pgVer'] ?? 'Unknown',
      deviceNm: json['deviceNm'] ?? 'Unknown',
      useYn: json['useYn']?.toString() ?? json['useyn']?.toString() ?? 'N',
      telno: json['telno'] ?? json['TELNO'],
      strgeInfo: int.tryParse(rawStrge?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sn': sn,
      'uuid': uuid,
      'os': os,
      'ntwrkDeviceInfo': ntwrkDeviceInfo,
      'pgVer': pgVer,
      'deviceNm': deviceNm,
      'useYn': useYn,
      'telno': telno,
      'strgeInfo': strgeInfo,
    };
  }

  @override
  String toString() {
    return 'DeviceInfo(sn: $sn, uuid: $uuid, os: $os, ntwrkDeviceInfo: $ntwrkDeviceInfo, pgVer: $pgVer, deviceNm: $deviceNm, useYn: $useYn, telno: $telno, strgeInfo: $strgeInfo)';
  }
}
