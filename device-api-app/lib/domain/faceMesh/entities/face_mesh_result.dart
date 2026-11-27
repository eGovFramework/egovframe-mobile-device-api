import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/face_mesh_message_keys.dart';

sealed class FaceMeshPickResult {
  const FaceMeshPickResult();
}

class FaceMeshPickSuccess extends FaceMeshPickResult {
  final FaceMeshSession session;

  const FaceMeshPickSuccess(this.session);
}

class FaceMeshPickCancelled extends FaceMeshPickResult {
  const FaceMeshPickCancelled();
}

class FaceMeshPickPermissionDenied extends FaceMeshPickResult {
  final String message;

  const FaceMeshPickPermissionDenied([
    this.message = FaceMeshMessageKeys.permissionDenied,
  ]);
}

class FaceMeshPickFailure extends FaceMeshPickResult {
  final String message;

  const FaceMeshPickFailure(this.message);
}

sealed class FaceMeshProcessResult {
  const FaceMeshProcessResult();
}

class FaceMeshProcessSuccess extends FaceMeshProcessResult {
  final FaceMeshSession session;

  const FaceMeshProcessSuccess(this.session);
}

class FaceMeshProcessEmpty extends FaceMeshProcessResult {
  final FaceMeshSession session;

  const FaceMeshProcessEmpty(this.session);
}

class FaceMeshProcessFailure extends FaceMeshProcessResult {
  final String message;

  const FaceMeshProcessFailure(this.message);
}

sealed class FaceMeshUploadResult {
  const FaceMeshUploadResult();
}

class FaceMeshUploadSuccess extends FaceMeshUploadResult {
  const FaceMeshUploadSuccess();
}

class FaceMeshUploadFailure extends FaceMeshUploadResult {
  final String message;

  const FaceMeshUploadFailure(this.message);
}

sealed class FaceMeshListLoadResult {
  const FaceMeshListLoadResult();
}

class FaceMeshListLoadSuccess extends FaceMeshListLoadResult {
  final List<FaceMeshRecord> items;

  const FaceMeshListLoadSuccess(this.items);
}

class FaceMeshListLoadEmpty extends FaceMeshListLoadResult {
  final String message;

  const FaceMeshListLoadEmpty([
    this.message = FaceMeshMessageKeys.emptyList,
  ]);
}

class FaceMeshListLoadFailure extends FaceMeshListLoadResult {
  final String message;

  const FaceMeshListLoadFailure(this.message);
}

sealed class FaceMeshDeleteBatchResult {
  const FaceMeshDeleteBatchResult();
}

class FaceMeshDeleteBatchSuccess extends FaceMeshDeleteBatchResult {
  final int deletedCount;

  const FaceMeshDeleteBatchSuccess(this.deletedCount);
}

class FaceMeshDeleteBatchFailure extends FaceMeshDeleteBatchResult {
  final String message;

  const FaceMeshDeleteBatchFailure(this.message);
}
