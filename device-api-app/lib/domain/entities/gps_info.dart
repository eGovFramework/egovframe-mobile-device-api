import 'package:geolocator/geolocator.dart';
import '../../utils/format_utils.dart';

/// GPS 정보를 담는 Entity 클래스 (로컬 센서 데이터)
class GpsInfo {
  final int? sn;
  final String uuid;
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accrcy;
  final DateTime timestamp;

  GpsInfo({
    this.sn,
    required this.uuid,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accrcy,
    required this.timestamp,
  });

  factory GpsInfo.fromJson(Map<String, dynamic> json) {
    return GpsInfo(
      sn: json['sn'] is int ? json['sn'] : int.tryParse(json['sn']?.toString() ?? ''),
      uuid: json['uuid'],
      latitude: json['lat'].toDouble(),
      longitude: json['lon'].toDouble(),
      accrcy: json['accrcy']?.toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'accrcy': accrcy?.toString() ?? '0',
      'timestamp': timestamp.add(Duration(hours: 9)).millisecondsSinceEpoch.toString(),
    };
  }

  /// 정확도를 포맷된 문자열로 반환
  String get formattedAccuracy => FormatUtils.formatAccuracy(accrcy);

  /// Position에서 GpsInfo를 생성
  factory GpsInfo.fromPosition(Position position, String uuid) {
    return GpsInfo(
      uuid: uuid,
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      accrcy: position.accuracy,
      timestamp: position.timestamp,
    );
  }
}

/// 서버에서 받아오는 GPS 정보 호출
class GpsInfoServer {
  final int? sn;
  final String uuid;
  final double lat;
  final double lon;
  final double? accrcy;
  final String? useYn;
  final DateTime? regDate;
  final DateTime? updDate;

  GpsInfoServer({
    this.sn,
    required this.uuid,
    required this.lat,
    required this.lon,
    this.accrcy,
    this.useYn,
    this.regDate,
    this.updDate,
  });

  /// JSON으로부터 GpsInfoServer를 생성
  factory GpsInfoServer.fromJson(Map<String, dynamic> json) {
    return GpsInfoServer(
      sn: json['sn'] is int ? json['sn'] : (json['sn'] is String ? int.tryParse(json['sn']) : null),
      uuid: json['uuid'] ?? '',
      lat: _parseDouble(json['lat'] ?? json['la']),
      lon: _parseDouble(json['lon'] ?? json['lo']),
      accrcy: _parseDouble(json['accrcy']),
      useYn: json['useYn'] ?? json['useyn'],
      regDate: json['regDate'] != null ? DateTime.parse(json['regDate']) : null,
      updDate: json['updDate'] != null ? DateTime.parse(json['updDate']) : null,
    );
  }

  /// double 변환
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'sn': sn,
      'uuid': uuid,
      'lat': lat,
      'lon': lon,
      'accrcy': accrcy,
      'useYn': useYn,
      'regDate': regDate?.toIso8601String(),
      'updDate': updDate?.toIso8601String(),
    };
  }

  /// 위도, 경도를 문자열로 포맷
  String get formattedLocation {
    return '위도: ${lat.toStringAsFixed(6)}, 경도: ${lon.toStringAsFixed(6)}';
  }

  /// 정확도를 문자열로 포맷
  String get formattedAccuracy => FormatUtils.formatAccuracyWithNA(accrcy);

  /// 등록일을 문자열로 포맷
  String get formattedRegDate => regDate != null ? FormatUtils.formatDateTime(regDate!) : 'N/A';

  /// 수정일을 문자열로 포맷
  String get formattedUpdDate => updDate != null ? FormatUtils.formatDateTime(updDate!) : 'N/A';

  /// UUID를 축약해서 표시
  String get shortUuid {
    return uuid.length > 25 ? '${uuid.substring(0, 25)}...' : uuid;
  }
}
