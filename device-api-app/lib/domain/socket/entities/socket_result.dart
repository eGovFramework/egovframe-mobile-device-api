import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/socket_message_keys.dart';

sealed class SocketUploadResult {
  const SocketUploadResult();
}

class SocketUploadSuccess extends SocketUploadResult {
  final int syncedCount;

  const SocketUploadSuccess({required this.syncedCount});
}

class SocketUploadFailure extends SocketUploadResult {
  final String message;

  const SocketUploadFailure(this.message);
}

sealed class SocketListLoadResult {
  const SocketListLoadResult();
}

class SocketListLoadSuccess extends SocketListLoadResult {
  final List<SocketMessageInfo> items;

  const SocketListLoadSuccess(this.items);
}

class SocketListLoadEmpty extends SocketListLoadResult {
  final String message;

  const SocketListLoadEmpty([this.message = SocketMessageKeys.emptyList]);
}

class SocketListLoadFailure extends SocketListLoadResult {
  final String message;

  const SocketListLoadFailure(this.message);
}

sealed class SocketDeleteAllResult {
  const SocketDeleteAllResult();
}

class SocketDeleteAllSuccess extends SocketDeleteAllResult {
  const SocketDeleteAllSuccess();
}

class SocketDeleteAllFailure extends SocketDeleteAllResult {
  final String message;

  const SocketDeleteAllFailure(this.message);
}
