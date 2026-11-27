import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_message_info.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

class SocketChatMessage {
  final String text;
  final String sender;
  final DateTime receivedAt;
  final bool isMine;
  final int? savedSn;

  const SocketChatMessage({
    required this.text,
    required this.sender,
    required this.receivedAt,
    required this.isMine,
    this.savedSn,
  });

  bool get isSynced => savedSn != null;

  SocketChatMessage copyWith({int? savedSn}) {
    return SocketChatMessage(
      text: text,
      sender: sender,
      receivedAt: receivedAt,
      isMine: isMine,
      savedSn: savedSn ?? this.savedSn,
    );
  }
}

class SocketMainState {
  final bool isLoading;
  final bool isConnected;
  final ws.ConnectionState connectionState;
  final String? loadError;
  final String uuid;
  final String senderName;
  final List<SocketChatMessage> messages;
  final String inputText;

  const SocketMainState({
    required this.isLoading,
    required this.isConnected,
    required this.connectionState,
    this.loadError,
    required this.uuid,
    required this.senderName,
    required this.messages,
    required this.inputText,
  });

  factory SocketMainState.initial() {
    return SocketMainState(
      isLoading: true,
      isConnected: false,
      connectionState: const ws.Disconnected(),
      uuid: '',
      senderName: '',
      messages: const [],
      inputText: '',
    );
  }

  bool get hasMessages => messages.isNotEmpty;

  String get chatSenderName => senderName.trim();

  SocketMainState copyWith({
    bool? isLoading,
    bool? isConnected,
    ws.ConnectionState? connectionState,
    String? loadError,
    bool clearLoadError = false,
    String? uuid,
    String? senderName,
    List<SocketChatMessage>? messages,
    String? inputText,
  }) {
    return SocketMainState(
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      connectionState: connectionState ?? this.connectionState,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      uuid: uuid ?? this.uuid,
      senderName: senderName ?? this.senderName,
      messages: messages ?? this.messages,
      inputText: inputText ?? this.inputText,
    );
  }
}

class SocketListState {
  final bool isLoading;
  final List<SocketMessageInfo> messageList;
  final String errorMessage;

  const SocketListState({
    required this.isLoading,
    required this.messageList,
    required this.errorMessage,
  });

  factory SocketListState.initial() {
    return const SocketListState(
      isLoading: true,
      messageList: [],
      errorMessage: '',
    );
  }

  SocketListState copyWith({
    bool? isLoading,
    List<SocketMessageInfo>? messageList,
    String? errorMessage,
  }) {
    return SocketListState(
      isLoading: isLoading ?? this.isLoading,
      messageList: messageList ?? this.messageList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
