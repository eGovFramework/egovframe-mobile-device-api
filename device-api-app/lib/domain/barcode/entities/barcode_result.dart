import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/barcode_message_keys.dart';

sealed class BarcodeUploadResult {
  const BarcodeUploadResult();
}

class BarcodeUploadSuccess extends BarcodeUploadResult {
  const BarcodeUploadSuccess();
}

class BarcodeUploadFailure extends BarcodeUploadResult {
  final String message;

  const BarcodeUploadFailure(this.message);
}

sealed class BarcodeListLoadResult {
  const BarcodeListLoadResult();
}

class BarcodeListLoadSuccess extends BarcodeListLoadResult {
  final List<BarcodeInfo> items;

  const BarcodeListLoadSuccess(this.items);
}

class BarcodeListLoadEmpty extends BarcodeListLoadResult {
  final String message;

  const BarcodeListLoadEmpty([this.message = BarcodeMessageKeys.emptyList]);
}

class BarcodeListLoadFailure extends BarcodeListLoadResult {
  final String message;

  const BarcodeListLoadFailure(this.message);
}

sealed class BarcodeDeleteBatchResult {
  const BarcodeDeleteBatchResult();
}

class BarcodeDeleteBatchSuccess extends BarcodeDeleteBatchResult {
  final int deletedCount;

  const BarcodeDeleteBatchSuccess(this.deletedCount);
}

class BarcodeDeleteBatchFailure extends BarcodeDeleteBatchResult {
  final String message;

  const BarcodeDeleteBatchFailure(this.message);
}
