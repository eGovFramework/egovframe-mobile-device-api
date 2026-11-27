import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_info.dart';

sealed class IotConnectResult {
  const IotConnectResult();
}

class IotConnectSuccess extends IotConnectResult {
  const IotConnectSuccess();
}

class IotConnectFailure extends IotConnectResult {
  final String message;
  const IotConnectFailure(this.message);
}

sealed class IotPublishResult {
  const IotPublishResult();
}

class IotPublishSuccess extends IotPublishResult {
  const IotPublishSuccess();
}

class IotPublishFailure extends IotPublishResult {
  final String message;
  const IotPublishFailure(this.message);
}

sealed class IotUploadResult {
  const IotUploadResult();
}

class IotUploadSuccess extends IotUploadResult {
  final int syncedCount;
  const IotUploadSuccess(this.syncedCount);
}

class IotUploadFailure extends IotUploadResult {
  final String message;
  const IotUploadFailure(this.message);
}

sealed class IotDeleteAllResult {
  const IotDeleteAllResult();
}

class IotDeleteAllSuccess extends IotDeleteAllResult {
  const IotDeleteAllSuccess();
}

class IotDeleteAllFailure extends IotDeleteAllResult {
  final String message;
  const IotDeleteAllFailure(this.message);
}

sealed class IotListLoadResult {
  const IotListLoadResult();
}

class IotListLoadSuccess extends IotListLoadResult {
  final List<IotMessageInfo> items;
  const IotListLoadSuccess(this.items);
}

class IotListLoadEmpty extends IotListLoadResult {
  const IotListLoadEmpty();
}

class IotListLoadFailure extends IotListLoadResult {
  final String message;
  const IotListLoadFailure(this.message);
}
