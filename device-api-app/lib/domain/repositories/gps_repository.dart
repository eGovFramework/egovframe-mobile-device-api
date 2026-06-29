import 'package:egovframe_mobile_deviceapi_app/domain/entities/gps_info.dart';

abstract class GpsRepository {
  Future<GpsInfo?> getCurrentLocation();
  Future<bool> saveGpsInfo(GpsInfo gpsInfo);
  Future<List<GpsInfo>> getGpsInfoList(String uuid);
}
