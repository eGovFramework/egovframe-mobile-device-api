/// 네트워크 정보 모델 클래스
/// eGovFrame Network API 가이드를 참고하여 구현
class NetworkInfo {
  final String? sn;
  final String networkType;
  final String networkTypeName;
  final String deviceId;
  final String deviceName;
  final String useYn;
  final DateTime registDate;
  final String? ipAddress;
  final String? macAddress;
  final String? ssid;

  NetworkInfo({
    this.sn,
    required this.networkType,
    required this.networkTypeName,
    required this.deviceId,
    required this.deviceName,
    required this.useYn,
    required this.registDate,
    this.ipAddress,
    this.macAddress,
    this.ssid,
  });

  /// JSON에서 NetworkInfo 객체 생성
  factory NetworkInfo.fromJson(Map<String, dynamic> json) {
    return NetworkInfo(
      sn: json['sn']?.toString(),
      networkType: json['networkType'] ?? '',
      networkTypeName: json['networkTypeName'] ?? '',
      deviceId: json['deviceId'] ?? '',
      deviceName: json['deviceName'] ?? '',
      useYn: json['useYn'] ?? 'Y',
      registDate: json['registDate'] != null
          ? DateTime.tryParse(json['registDate']) ?? DateTime.now()
          : DateTime.now(),
      ipAddress: json['ipAddress'],
      macAddress: json['macAddress'],
      ssid: json['ssid'],
    );
  }

  /// NetworkInfo 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      if (sn != null) 'sn': sn,
      'networkType': networkType,
      'networkTypeName': networkTypeName,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'useYn': useYn,
      'registDate': registDate.toIso8601String(),
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (macAddress != null) 'macAddress': macAddress,
      if (ssid != null) 'ssid': ssid,
    };
  }

  /// 네트워크 타입 코드에 따른 네트워크 이름 반환
  static String getNetworkTypeName(String networkType) {
    switch (networkType) {
      case 'UNKNOWN':
        return 'Unknown connection';
      case 'ETHERNET':
        return 'Ethernet connection';
      case 'WIFI':
        return 'WiFi connection';
      case 'CELL_2G':
        return 'Cell 2G connection';
      case 'CELL_3G':
        return 'Cell 3G connection';
      case 'CELL_4G':
        return 'Cell 4G connection';
      case 'CELL_5G':
        return 'Cell 5G connection';
      case 'NONE':
        return 'No network connection';
      default:
        return 'Unknown connection';
    }
  }

  /// 네트워크 상태에 따른 아이콘 반환
  static String getNetworkIcon(String networkType) {
    switch (networkType) {
      case 'WIFI':
        return '📶';
      case 'CELL_2G':
      case 'CELL_3G':
      case 'CELL_4G':
      case 'CELL_5G':
        return '📱';
      case 'ETHERNET':
        return '🌐';
      case 'NONE':
        return '❌';
      default:
        return '❓';
    }
  }

  @override
  String toString() {
    return 'NetworkInfo{sn: $sn, networkType: $networkType, networkTypeName: $networkTypeName, deviceId: $deviceId, deviceName: $deviceName, registDate: $registDate}';
  }
}
