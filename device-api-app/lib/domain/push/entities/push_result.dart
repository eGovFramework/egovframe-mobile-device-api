import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/push_message_keys.dart';

sealed class PushUploadResult {
  const PushUploadResult();
}

class PushUploadSuccess extends PushUploadResult {
  const PushUploadSuccess();
}

class PushUploadFailure extends PushUploadResult {
  final String message;

  const PushUploadFailure(this.message);
}

sealed class PushListLoadResult {
  const PushListLoadResult();
}

class PushListLoadSuccess extends PushListLoadResult {
  final List<PushMessageInfo> items;

  const PushListLoadSuccess(this.items);
}

class PushListLoadEmpty extends PushListLoadResult {
  final String message;

  const PushListLoadEmpty([this.message = PushMessageKeys.emptyMessageList]);
}

class PushListLoadFailure extends PushListLoadResult {
  final String message;

  const PushListLoadFailure(this.message);
}

sealed class PushDeleteAllResult {
  const PushDeleteAllResult();
}

class PushDeleteAllSuccess extends PushDeleteAllResult {
  const PushDeleteAllSuccess();
}

class PushDeleteAllFailure extends PushDeleteAllResult {
  final String message;

  const PushDeleteAllFailure(this.message);
}

sealed class PushInitResult {
  const PushInitResult();
}

class PushInitSuccess extends PushInitResult {
  const PushInitSuccess();
}

class PushInitFailure extends PushInitResult {
  final String message;

  const PushInitFailure(this.message);
}

sealed class PushNotificationResult {
  const PushNotificationResult();
}

class PushNotificationSuccess extends PushNotificationResult {
  const PushNotificationSuccess();
}

class PushNotificationFailure extends PushNotificationResult {
  final String message;

  const PushNotificationFailure(this.message);
}
