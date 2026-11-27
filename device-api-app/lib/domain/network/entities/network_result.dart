import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/network_message_keys.dart';

sealed class NetworkSendResult {
  const NetworkSendResult();
}

class NetworkSendSuccess extends NetworkSendResult {
  final String message;

  const NetworkSendSuccess([this.message = NetworkMessageKeys.sendSuccess]);
}

class NetworkSendFailure extends NetworkSendResult {
  final String message;

  const NetworkSendFailure(this.message);
}

sealed class NetworkListLoadResult {
  const NetworkListLoadResult();
}

class NetworkListLoadSuccess extends NetworkListLoadResult {
  final List<NetworkInfo> items;

  const NetworkListLoadSuccess(this.items);
}

class NetworkListLoadEmpty extends NetworkListLoadResult {
  final String message;

  const NetworkListLoadEmpty([this.message = NetworkMessageKeys.emptyList]);
}

class NetworkListLoadFailure extends NetworkListLoadResult {
  final String message;

  const NetworkListLoadFailure(this.message);
}

sealed class NetworkDeleteResult {
  const NetworkDeleteResult();
}

class NetworkDeleteSuccess extends NetworkDeleteResult {
  const NetworkDeleteSuccess();
}

class NetworkDeleteFailure extends NetworkDeleteResult {
  final String message;

  const NetworkDeleteFailure(this.message);
}
