import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/media_message_keys.dart';
import 'package:image_picker/image_picker.dart';

enum MediaPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  unknown,
}

class MediaPermissionResult {
  final MediaPermissionStatus status;
  final String message;
  final String permissionLabel;

  const MediaPermissionResult({
    required this.status,
    required this.message,
    required this.permissionLabel,
  });

  bool get isGranted => status == MediaPermissionStatus.granted;
  bool get isPermanentlyDenied =>
      status == MediaPermissionStatus.permanentlyDenied;
}

sealed class MediaLocalListResult {
  const MediaLocalListResult();
}

class MediaLocalListSuccess extends MediaLocalListResult {
  final List<MediaFileInfo> items;

  const MediaLocalListSuccess(this.items);
}

class MediaLocalListFailure extends MediaLocalListResult {
  final String message;

  const MediaLocalListFailure(this.message);
}

sealed class MediaPickResult {
  const MediaPickResult();
}

class MediaPickSuccess extends MediaPickResult {
  final XFile file;

  const MediaPickSuccess(this.file);
}

class MediaPickCancelled extends MediaPickResult {
  const MediaPickCancelled();
}

class MediaPickPermissionDenied extends MediaPickResult {
  final MediaPermissionResult permission;

  const MediaPickPermissionDenied(this.permission);
}

class MediaPickFailure extends MediaPickResult {
  final String message;

  const MediaPickFailure(this.message);
}

sealed class MediaSaveResult {
  const MediaSaveResult();
}

class MediaSaveSuccess extends MediaSaveResult {
  final String savedPath;
  final String message;

  const MediaSaveSuccess({
    required this.savedPath,
    this.message = MediaMessageKeys.saveSuccess,
  });
}

class MediaSaveFailure extends MediaSaveResult {
  final String message;

  const MediaSaveFailure(this.message);
}

sealed class MediaUploadResult {
  const MediaUploadResult();
}

class MediaUploadSuccess extends MediaUploadResult {
  final int successCount;
  final int failCount;
  final String message;

  const MediaUploadSuccess({
    required this.successCount,
    required this.failCount,
    required this.message,
  });
}

class MediaUploadFailure extends MediaUploadResult {
  final String message;

  const MediaUploadFailure(this.message);
}

sealed class MediaDeleteBatchResult {
  const MediaDeleteBatchResult();
}

class MediaDeleteBatchSuccess extends MediaDeleteBatchResult {
  final int successCount;
  final int failCount;
  final String message;

  const MediaDeleteBatchSuccess({
    required this.successCount,
    required this.failCount,
    required this.message,
  });
}

class MediaDeleteBatchFailure extends MediaDeleteBatchResult {
  final String message;

  const MediaDeleteBatchFailure(this.message);
}

sealed class MediaServerListResult {
  const MediaServerListResult();
}

class MediaServerListSuccess extends MediaServerListResult {
  final List<MediaFileInfo> items;

  const MediaServerListSuccess(this.items);
}

class MediaServerListEmpty extends MediaServerListResult {
  final String message;

  const MediaServerListEmpty([this.message = MediaMessageKeys.serverListEmpty]);
}

class MediaServerListFailure extends MediaServerListResult {
  final String message;

  const MediaServerListFailure(this.message);
}

sealed class MediaDownloadResult {
  const MediaDownloadResult();
}

class MediaDownloadSuccess extends MediaDownloadResult {
  const MediaDownloadSuccess();
}

class MediaDownloadFailure extends MediaDownloadResult {
  final String message;

  const MediaDownloadFailure(this.message);
}

sealed class MediaServerDeleteResult {
  const MediaServerDeleteResult();
}

class MediaServerDeleteSuccess extends MediaServerDeleteResult {
  final String message;

  const MediaServerDeleteSuccess([this.message = MediaMessageKeys.serverDeleted]);
}

class MediaServerDeleteFailure extends MediaServerDeleteResult {
  final String message;

  const MediaServerDeleteFailure(this.message);
}

sealed class MediaDownloadUrlResult {
  const MediaDownloadUrlResult();
}

class MediaDownloadUrlSuccess extends MediaDownloadUrlResult {
  final String url;

  const MediaDownloadUrlSuccess(this.url);
}

class MediaDownloadUrlFailure extends MediaDownloadUrlResult {
  final String message;

  const MediaDownloadUrlFailure(this.message);
}
