import 'package:egovframe_mobile_deviceapi_app/data/datasources/gps_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/gps_repository.dart';

class GpsRepositoryImpl implements GpsRepository {
  GpsRepositoryImpl();

  @override
  Future<GpsInfo?> getCurrentLocation() async {
    final position = await GpsService.getCurrentLocation();
    if (position != null) {
      return GpsInfo(
        uuid: '', // UUID는 호출하는 곳에서 설정해야 함
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accrcy: position.accuracy,
        timestamp: position.timestamp.add(Duration(hours: 9)),
      );
    }
    return null;
  }

  @override
  Future<bool> saveGpsInfo(GpsInfo gpsInfo) async {
    return await GpsService.saveGpsInfo(gpsInfo);
  }

  @override
  Future<List<GpsInfo>> getGpsInfoList(String uuid) async {
    return await GpsService.getGpsInfoList(uuid);
  }

  @override
  Future<bool> deleteAllGpsInfo(String uuid) async {
    return await GpsService.deleteAllGpsInfo(uuid);
  }
}
