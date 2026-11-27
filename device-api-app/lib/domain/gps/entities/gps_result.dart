import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/gps_message_keys.dart';

/// 위치 권한 상태 (Domain 표현)
enum GpsPermissionStatus { granted, denied, permanentlyDenied, unknown }

class GpsPermissionResult {
  final GpsPermissionStatus status;
  final String statusMessage;

  const GpsPermissionResult({
    required this.status,
    required this.statusMessage,
  });

  bool get isGranted => status == GpsPermissionStatus.granted;
}

sealed class GpsLocationResult {
  const GpsLocationResult();
}

class GpsLocationSuccess extends GpsLocationResult {
  final GpsInfo location;

  const GpsLocationSuccess(this.location);
}

class GpsLocationPermissionDenied extends GpsLocationResult {
  final GpsPermissionResult permission;

  const GpsLocationPermissionDenied(this.permission);
}

class GpsLocationFailure extends GpsLocationResult {
  final String message;

  const GpsLocationFailure(this.message);
}

sealed class GpsSaveResult {
  const GpsSaveResult();
}

class GpsSaveSuccess extends GpsSaveResult {
  final GpsInfo savedInfo;
  final String message;

  const GpsSaveSuccess({
    required this.savedInfo,
    this.message = GpsMessageKeys.saveSuccess,
  });
}

class GpsSaveFailure extends GpsSaveResult {
  final String message;

  const GpsSaveFailure(this.message);
}

sealed class GpsListLoadResult {
  const GpsListLoadResult();
}

class GpsListLoadSuccess extends GpsListLoadResult {
  final List<GpsInfo> items;

  const GpsListLoadSuccess(this.items);
}

class GpsListLoadEmpty extends GpsListLoadResult {
  final String message;

  const GpsListLoadEmpty([this.message = GpsMessageKeys.emptyList]);
}

class GpsListLoadFailure extends GpsListLoadResult {
  final String message;

  const GpsListLoadFailure(this.message);
}

sealed class GpsDeleteBatchResult {
  const GpsDeleteBatchResult();
}

class GpsDeleteBatchSuccess extends GpsDeleteBatchResult {
  final int deletedCount;

  const GpsDeleteBatchSuccess(this.deletedCount);
}

class GpsDeleteBatchFailure extends GpsDeleteBatchResult {
  final String message;

  const GpsDeleteBatchFailure(this.message);
}
