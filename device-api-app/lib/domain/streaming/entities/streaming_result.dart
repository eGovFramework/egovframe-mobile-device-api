import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/streaming_message_keys.dart';

sealed class StreamingListLoadResult {
  const StreamingListLoadResult();
}

class StreamingListLoadSuccess extends StreamingListLoadResult {
  final List<StreamingMediaInfo> items;

  const StreamingListLoadSuccess(this.items);
}

class StreamingListLoadEmpty extends StreamingListLoadResult {
  final String message;

  const StreamingListLoadEmpty([this.message = StreamingMessageKeys.emptyList]);
}

class StreamingListLoadFailure extends StreamingListLoadResult {
  final String message;

  const StreamingListLoadFailure(this.message);
}

sealed class StreamingPlayCountUpdateResult {
  const StreamingPlayCountUpdateResult();
}

class StreamingPlayCountUpdateSuccess extends StreamingPlayCountUpdateResult {
  const StreamingPlayCountUpdateSuccess();
}

class StreamingPlayCountUpdateFailure extends StreamingPlayCountUpdateResult {
  final String message;

  const StreamingPlayCountUpdateFailure(this.message);
}
