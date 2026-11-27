import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_heading.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/compass_message_keys.dart';

sealed class CompassHeadingResult {
  const CompassHeadingResult();
}

class CompassHeadingSuccess extends CompassHeadingResult {
  final CompassHeading heading;

  const CompassHeadingSuccess(this.heading);
}

class CompassHeadingFailure extends CompassHeadingResult {
  final String message;

  const CompassHeadingFailure(this.message);
}

sealed class CompassUploadResult {
  const CompassUploadResult();
}

class CompassUploadSuccess extends CompassUploadResult {
  const CompassUploadSuccess();
}

class CompassUploadFailure extends CompassUploadResult {
  final String message;

  const CompassUploadFailure(this.message);
}

sealed class CompassListLoadResult {
  const CompassListLoadResult();
}

class CompassListLoadSuccess extends CompassListLoadResult {
  final List<CompassInfo> items;

  const CompassListLoadSuccess(this.items);
}

class CompassListLoadEmpty extends CompassListLoadResult {
  final String message;

  const CompassListLoadEmpty([this.message = CompassMessageKeys.emptyList]);
}

class CompassListLoadFailure extends CompassListLoadResult {
  final String message;

  const CompassListLoadFailure(this.message);
}

sealed class CompassDeleteBatchResult {
  const CompassDeleteBatchResult();
}

class CompassDeleteBatchSuccess extends CompassDeleteBatchResult {
  final int deletedCount;

  const CompassDeleteBatchSuccess(this.deletedCount);
}

class CompassDeleteBatchFailure extends CompassDeleteBatchResult {
  final String message;

  const CompassDeleteBatchFailure(this.message);
}
