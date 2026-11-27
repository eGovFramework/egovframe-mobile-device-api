import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/device_info_message_keys.dart';

sealed class DeviceLoadResult {
  const DeviceLoadResult();
}

class DeviceLoadSuccess extends DeviceLoadResult {
  final DeviceInfo device;

  const DeviceLoadSuccess(this.device);
}

class DeviceLoadFailure extends DeviceLoadResult {
  final String message;

  const DeviceLoadFailure(this.message);
}

sealed class DeviceUploadResult {
  const DeviceUploadResult();
}

class DeviceUploadSuccess extends DeviceUploadResult {
  const DeviceUploadSuccess();
}

class DeviceUploadFailure extends DeviceUploadResult {
  final String message;

  const DeviceUploadFailure(this.message);
}

sealed class DeviceListLoadResult {
  const DeviceListLoadResult();
}

class DeviceListLoadSuccess extends DeviceListLoadResult {
  final List<DeviceInfo> items;

  const DeviceListLoadSuccess(this.items);
}

class DeviceListLoadEmpty extends DeviceListLoadResult {
  final String message;

  const DeviceListLoadEmpty([this.message = DeviceInfoMessageKeys.emptyList]);
}

class DeviceListLoadFailure extends DeviceListLoadResult {
  final String message;

  const DeviceListLoadFailure(this.message);
}

sealed class DeviceDetailLoadResult {
  const DeviceDetailLoadResult();
}

class DeviceDetailLoadSuccess extends DeviceDetailLoadResult {
  final DeviceInfo device;

  const DeviceDetailLoadSuccess(this.device);
}

class DeviceDetailLoadNotFound extends DeviceDetailLoadResult {
  final String message;

  const DeviceDetailLoadNotFound([this.message = DeviceInfoMessageKeys.cannotLoad]);
}

class DeviceDetailLoadFailure extends DeviceDetailLoadResult {
  final String message;

  const DeviceDetailLoadFailure(this.message);
}

sealed class DeviceDeleteResult {
  const DeviceDeleteResult();
}

class DeviceDeleteSuccess extends DeviceDeleteResult {
  const DeviceDeleteSuccess();
}

class DeviceDeleteFailure extends DeviceDeleteResult {
  final String message;

  const DeviceDeleteFailure(this.message);
}
