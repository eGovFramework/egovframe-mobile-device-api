import 'package:egovframe_mobile_deviceapi_app/data/compass/datasources/compass_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_heading.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/repositories/compass_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassRemoteRepositoryImpl implements CompassRepository {
  @override
  Stream<CompassHeading> watchHeading() {
    final events = CompassService.compassEvents();
    if (events == null) {
      return Stream.value(const CompassHeading.inactive());
    }

    return events.map((CompassEvent event) {
      final accuracy = event.accuracy;
      return CompassHeading(
        magneticHeading: _normalizeHeading(event.heading),
        // headingAccuracy: accuracy == null ? null : accuracy.toStringAsFixed(1),
        headingAccuracy: accuracy?.toStringAsFixed(1),
        isActive: event.heading != null,
      );
    });
  }

  /// 센서 방위각(-180~180 등)을 0~360 범위로 정규화
  static double? _normalizeHeading(double? heading) {
    if (heading == null) return null;
    var normalized = heading % 360;
    if (normalized < 0) {
      normalized += 360;
    }
    return normalized;
  }

  @override
  Future<bool> uploadCompassInfo(CompassInfo info) async {
    final response = await CompassService.postCompassInfo(info.toUploadFields());
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    if (resultState == 'OK') {
      return true;
    }

    final useYn = (response['useYn'] ?? '').toString();
    return useYn == 'OK';
  }

  @override
  Future<List<CompassInfo>> getCompassList() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    final rawList = await CompassService.fetchCompassInfoList(uuid);
    return rawList.map(CompassInfo.fromJson).toList();
  }

  @override
  Future<bool> deleteCompassInfo(CompassInfo info, String deviceUuid) async {
    if (deviceUuid.isEmpty || info.uuid != deviceUuid || info.sn <= 0) {
      return false;
    }

    final response = await CompassService.deleteCompassInfo(
      sn: info.sn,
      uuid: deviceUuid,
    );
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }
}
