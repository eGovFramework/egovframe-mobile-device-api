import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_heading.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';

abstract class CompassRepository {
  Stream<CompassHeading> watchHeading();

  Future<bool> uploadCompassInfo(CompassInfo info);

  Future<List<CompassInfo>> getCompassList();

  Future<bool> deleteCompassInfo(CompassInfo info, String deviceUuid);
}
