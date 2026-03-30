import 'package:egovframe_mobile_deviceapi_app/domain/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/gps_repository.dart';

class GpsUseCase {
  final GpsRepository repository;

  GpsUseCase(this.repository);

  /// 현재 GPS 위치 정보 조회
  Future<GpsInfo?> getCurrentLocation() async {
    return await repository.getCurrentLocation();
  }

  /// GPS 정보 목록 조회
  Future<List<GpsInfo>> getGpsInfoList(String uuid) async {
    return await repository.getGpsInfoList(uuid);
  }

  /// GPS 정보 저장
  Future<bool> saveGpsInfo(GpsInfo gpsInfo) async {
    return await repository.saveGpsInfo(gpsInfo);
  }
}
