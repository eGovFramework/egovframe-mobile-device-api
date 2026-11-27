import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/accelerator_message_keys.dart';

sealed class AcceleratorSaveResult {
  const AcceleratorSaveResult();
}

class AcceleratorSaveSuccess extends AcceleratorSaveResult {
  final String message;

  const AcceleratorSaveSuccess([
    this.message = AcceleratorMessageKeys.saveSuccess,
  ]);
}

class AcceleratorSaveFailure extends AcceleratorSaveResult {
  final String message;

  const AcceleratorSaveFailure(this.message);
}

sealed class AcceleratorListLoadResult {
  const AcceleratorListLoadResult();
}

class AcceleratorListLoadSuccess extends AcceleratorListLoadResult {
  final List<AcceleratorInfo> items;

  const AcceleratorListLoadSuccess(this.items);
}

class AcceleratorListLoadEmpty extends AcceleratorListLoadResult {
  final String message;

  const AcceleratorListLoadEmpty([
    this.message = AcceleratorMessageKeys.emptyList,
  ]);
}

class AcceleratorListLoadFailure extends AcceleratorListLoadResult {
  final String message;

  const AcceleratorListLoadFailure(this.message);
}

sealed class AcceleratorDeleteResult {
  const AcceleratorDeleteResult();
}

class AcceleratorDeleteSuccess extends AcceleratorDeleteResult {
  const AcceleratorDeleteSuccess();
}

class AcceleratorDeleteFailure extends AcceleratorDeleteResult {
  final String message;

  const AcceleratorDeleteFailure(this.message);
}
