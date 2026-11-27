import 'package:egovframe_mobile_deviceapi_app/data/gps/datasources/gps_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/repositories/gps_repository.dart';

class GpsRemoteRepositoryImpl implements GpsRepository {
  GpsRemoteRepositoryImpl();

  @override
  Future<GpsInfo?> getCurrentLocation() async {
    final position = await GpsService.getCurrentLocation();
    if (position == null) {
      return null;
    }

    final info = GpsInfo.fromPosition(position, '');
    return GpsInfo(
      sn: info.sn,
      uuid: info.uuid,
      latitude: info.latitude,
      longitude: info.longitude,
      altitude: info.altitude,
      accrcy: info.accrcy,
      timestamp: position.timestamp.add(const Duration(hours: 9)),
    );
  }

  @override
  Future<bool> saveGpsInfo(GpsInfo gpsInfo) async {
    return GpsService.insertGpsInfo(
      uuid: gpsInfo.uuid,
      latitude: gpsInfo.latitude,
      longitude: gpsInfo.longitude,
      accuracy: gpsInfo.accrcy,
    );
  }

  @override
  Future<List<GpsInfo>> getGpsInfoList(String uuid) async {
    final rawList = await GpsService.fetchGpsInfoList(uuid);
    return rawList.map(_mapServerItemToGpsInfo).toList();
  }

  @override
  Future<bool> deleteGpsInfo(GpsInfo info, String deviceUuid) async {
    if (deviceUuid.isEmpty || info.uuid != deviceUuid || info.sn <= 0) {
      return false;
    }
    return GpsService.deleteGpsInfo(sn: info.sn, uuid: deviceUuid);
  }

  GpsInfo _mapServerItemToGpsInfo(Map<String, dynamic> item) {
    final serverInfo = GpsInfoServer.fromJson(item);
    return GpsInfo(
      sn: serverInfo.sn ?? 0,
      uuid: serverInfo.uuid,
      latitude: serverInfo.lat,
      longitude: serverInfo.lon,
      accrcy: serverInfo.accrcy,
      timestamp: serverInfo.regDate ??
          serverInfo.updDate ??
          DateTime.now(),
    );
  }
}
