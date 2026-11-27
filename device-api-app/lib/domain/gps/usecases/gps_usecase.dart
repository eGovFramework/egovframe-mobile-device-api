import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/repositories/gps_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/gps_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/permission_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class GpsUseCase {
  final GpsRepository repository;

  GpsUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  /// 앱 시작 시 위치 권한 확인 및 안내 메시지 반환
  Future<GpsPermissionResult> resolveLocationPermission() async {
    try {
      final status = await PermissionManager.requestLocationPermission();
      return _mapPermissionStatus(status);
    } catch (e) {
      return GpsPermissionResult(
        status: GpsPermissionStatus.unknown,
        statusMessage: '${GpsMessageKeys.initErrorPrefix}$e',
      );
    }
  }

  GpsPermissionResult _mapPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return const GpsPermissionResult(
          status: GpsPermissionStatus.granted,
          statusMessage: GpsMessageKeys.permissionGranted,
        );
      case PermissionStatus.denied:
        return const GpsPermissionResult(
          status: GpsPermissionStatus.denied,
          statusMessage: GpsMessageKeys.permissionDenied,
        );
      case PermissionStatus.permanentlyDenied:
        return const GpsPermissionResult(
          status: GpsPermissionStatus.permanentlyDenied,
          statusMessage: GpsMessageKeys.permissionPermanentlyDenied,
        );
      default:
        return const GpsPermissionResult(
          status: GpsPermissionStatus.unknown,
          statusMessage: GpsMessageKeys.permissionUnknown,
        );
    }
  }

  /// 권한 확인 후 현재 위치 조회 (Repository 경유)
  Future<GpsLocationResult> fetchCurrentLocation(String deviceUuid) async {
    final permission = await resolveLocationPermission();
    if (!permission.isGranted) {
      return GpsLocationPermissionDenied(permission);
    }

    try {
      final location = await repository.getCurrentLocation();
      if (location == null) {
        return const GpsLocationFailure(GpsMessageKeys.noLocation);
      }

      return GpsLocationSuccess(
        GpsInfo(
          uuid: deviceUuid,
          latitude: location.latitude,
          longitude: location.longitude,
          altitude: location.altitude,
          accrcy: location.accrcy,
          timestamp: location.timestamp,
        ),
      );
    } catch (e) {
      return GpsLocationFailure('${GpsMessageKeys.fetchFailedPrefix}$e');
    }
  }

  /// 현재 위치를 서버에 저장
  Future<GpsSaveResult> saveLocationToServer(GpsInfo location) async {
    if (location.uuid.isEmpty) {
      return const GpsSaveFailure(GpsMessageKeys.noUuid);
    }

    try {
      final success = await repository.saveGpsInfo(location);
      if (success) {
        return GpsSaveSuccess(savedInfo: location);
      }
      return const GpsSaveFailure(GpsMessageKeys.saveFailed);
    } catch (e) {
      return GpsSaveFailure('${GpsMessageKeys.saveErrorPrefix}$e');
    }
  }

  /// 서버 GPS 목록 조회
  Future<GpsListLoadResult> loadServerGpsList(String deviceUuid) async {
    if (deviceUuid.isEmpty) {
      return const GpsListLoadFailure(GpsMessageKeys.noUuid);
    }

    try {
      final items = await repository.getGpsInfoList(deviceUuid);
      if (items.isEmpty) {
        return const GpsListLoadEmpty();
      }
      return GpsListLoadSuccess(items);
    } catch (e) {
      return GpsListLoadFailure('${GpsMessageKeys.listLoadErrorPrefix}$e');
    }
  }

  /// 선택한 GPS 항목 삭제
  Future<GpsDeleteBatchResult> deleteGpsItems(List<GpsInfo> items) async {
    if (items.isEmpty) {
      return const GpsDeleteBatchFailure(GpsMessageKeys.noSelection);
    }

    var deletedCount = 0;
    try {
      final deviceUuid = await getDeviceUuid();
      if (deviceUuid.isEmpty) {
        return const GpsDeleteBatchFailure(GpsMessageKeys.noUuid);
      }

      for (final item in items) {
        if (item.uuid.isEmpty || item.uuid != deviceUuid || item.sn <= 0) {
          return const GpsDeleteBatchFailure(GpsMessageKeys.deleteFailed);
        }

        final success = await repository.deleteGpsInfo(item, deviceUuid);
        if (!success) {
          return const GpsDeleteBatchFailure(GpsMessageKeys.deleteFailed);
        }
        deletedCount++;
      }
      return GpsDeleteBatchSuccess(deletedCount);
    } catch (e) {
      return GpsDeleteBatchFailure('${GpsMessageKeys.genericErrorPrefix}$e');
    }
  }
}
