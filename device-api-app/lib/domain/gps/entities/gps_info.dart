import 'package:geolocator/geolocator.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';
import '../../../utils/format_utils.dart';

/// GPS 정보를 담는 Entity 클래스 (로컬 센서 데이터)
class GpsInfo {
  final int sn;
  final String uuid;
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accrcy;
  final DateTime timestamp;

  GpsInfo({
    this.sn = 0,
    required this.uuid,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accrcy,
    required this.timestamp,
  });

  factory GpsInfo.fromJson(Map<String, dynamic> json) {
    return GpsInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      latitude: JsonRead.asDouble(json, ['lat', 'latitude', 'la']),
      longitude: JsonRead.asDouble(json, ['lon', 'longitude', 'lo']),
      altitude: json['altitude'] != null
          ? JsonRead.parseDouble(json['altitude'])
          : null,
      accrcy: json['accrcy'] != null
          ? JsonRead.parseDouble(json['accrcy'])
          : null,
      timestamp: JsonRead.asDateTime(json, ['timestamp', 'TIMESTAMP']) ??
          DateTime.now(),
    );
  }

  /// JSON API 본문용
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'accrcy': accrcy?.toString() ?? '0',
      'timestamp': timestamp
          .add(const Duration(hours: 9))
          .millisecondsSinceEpoch
          .toString(),
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
      sn: json['sn'] != null || json['SN'] != null
          ? JsonRead.asInt(json, ['sn', 'SN'])
          : null,
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      lat: JsonRead.asDouble(json, ['lat', 'la']),
      lon: JsonRead.asDouble(json, ['lon', 'lo']),
      accrcy: json['accrcy'] != null
          ? JsonRead.parseDouble(json['accrcy'])
          : null,
      useYn: JsonRead.asOptionalString(json, ['useYn', 'useyn', 'USEYN']),
      regDate: JsonRead.asDateTime(json, ['regDate', 'REG_DATE']),
      updDate: JsonRead.asDateTime(json, ['updDate', 'UPD_DATE']),
    );
  }

  /// JSON API 본문용
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
  String get formattedRegDate =>
      regDate != null ? FormatUtils.formatDateTime(regDate!) : 'N/A';

  /// 수정일을 문자열로 포맷
  String get formattedUpdDate =>
      updDate != null ? FormatUtils.formatDateTime(updDate!) : 'N/A';

  /// UUID를 축약해서 표시
  String get shortUuid {
    return uuid.length > 25 ? '${uuid.substring(0, 25)}...' : uuid;
  }
}
