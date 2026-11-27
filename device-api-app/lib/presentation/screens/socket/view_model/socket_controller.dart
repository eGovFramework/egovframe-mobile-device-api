import 'dart:async';

import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/usecases/socket_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/socket_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/state/socket_state.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/socket_chat_message_format.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/websocket_connection_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

part 'socket_controller.g.dart';

SocketUseCase _socketUseCase(Ref ref) => ref.read(socketUseCaseProvider);

@riverpod
class SocketMain extends _$SocketMain {
  StreamSubscription<ws.ConnectionState>? _connectionSubscription;
  StreamSubscription<String>? _messageSubscription;

  @override
  SocketMainState build() {
    ref.onDispose(_disposeSubscriptions);
    Future.microtask(_initialize);
    return SocketMainState.initial();
  }

  Future<void> _initialize() async {
    final uuid = await _socketUseCase(ref).getDeviceUuid();
    final defaultSenderName = SocketChatMessageFormat.resolveSenderId(uuid);
    state = state.copyWith(
      isLoading: false,
      uuid: uuid,
      senderName: defaultSenderName,
    );

    await _connectionSubscription?.cancel();
    await _messageSubscription?.cancel();

    _connectionSubscription =
        _socketUseCase(ref).watchConnectionState().listen((connectionState) {
      state = state.copyWith(
        connectionState: connectionState,
        isConnected: isWebSocketConnected(connectionState),
        clearLoadError: true,
      );
    });

    _messageSubscription =
        _socketUseCase(ref).watchIncomingMessages().listen((raw) {
      final parsed = SocketChatMessageFormat.parse(raw);
      if (parsed == null) {
        return;
      }

      _appendMessage(
        text: parsed.message,
        sender: parsed.sender,
        isMine: parsed.sender == state.chatSenderName,
      );
    });
  }

  void _disposeSubscriptions() {
    _connectionSubscription?.cancel();
    _messageSubscription?.cancel();
  }

  void updateInputText(String value) {
    state = state.copyWith(inputText: value);
  }

  void updateSenderName(String value) {
    state = state.copyWith(senderName: value);
  }

  Future<void> connectWebSocket() async {
    if (isWebSocketConnected(state.connectionState) ||
        isWebSocketConnecting(state.connectionState)) {
      return;
    }

    state = state.copyWith(clearLoadError: true);
    try {
      await _socketUseCase(ref).connectWebSocket();
    } catch (e) {
      state = state.copyWith(
        loadError: '${SocketMessageKeys.websocketErrorPrefix}$e',
      );
    }
  }

  Future<void> disconnectWebSocket() async {
    await _socketUseCase(ref).disconnectWebSocket();
  }

  Future<void> toggleConnection() async {
    if (isWebSocketConnected(state.connectionState) ||
        isWebSocketConnecting(state.connectionState)) {
      await disconnectWebSocket();
      return;
    }
    await connectWebSocket();
  }

  Future<void> sendMessage() async {
    final text = state.inputText.trim();
    if (text.isEmpty) {
      return;
    }

    if (!state.isConnected) {
      state = state.copyWith(loadError: SocketMessageKeys.websocketNotConnected);
      return;
    }

    if (!SocketChatMessageFormat.isValidSenderName(state.senderName)) {
      state = state.copyWith(
        loadError: state.senderName.trim().isEmpty
            ? SocketMessageKeys.nicknameRequired
            : SocketMessageKeys.nicknameInvalid,
      );
      return;
    }

    _socketUseCase(ref).sendChatMessage(
      sender: state.chatSenderName,
      message: text,
    );
    state = state.copyWith(inputText: '', clearLoadError: true);
  }

  void _appendMessage({
    required String text,
    required String sender,
    required bool isMine,
  }) {
    final message = SocketChatMessage(
      text: text,
      sender: sender,
      receivedAt: DateTime.now(),
      isMine: isMine,
    );
    state = state.copyWith(messages: [...state.messages, message]);
  }

  int get unsyncedMessageCount =>
      state.messages.where((message) => !message.isSynced).length;

  void clearSavedSn() {
    if (state.messages.every((message) => message.isSynced)) {
      return;
    }

    state = state.copyWith(
      messages: [
        for (final message in state.messages)
          SocketChatMessage(
            text: message.text,
            sender: message.sender,
            receivedAt: message.receivedAt,
            isMine: message.isMine,
          ),
      ],
    );
  }

  Future<SocketUploadResult> uploadSocketMessages() async {
    if (state.uuid.isEmpty) {
      return const SocketUploadFailure(SocketMessageKeys.noUuid);
    }
    if (state.messages.isEmpty) {
      return const SocketUploadFailure(SocketMessageKeys.noMessageData);
    }
    if (unsyncedMessageCount == 0) {
      return const SocketUploadFailure(SocketMessageKeys.noNewMessages);
    }

    final updatedMessages = List<SocketChatMessage>.from(state.messages);
    var syncedCount = 0;

    for (var i = 0; i < updatedMessages.length; i++) {
      final message = updatedMessages[i];
      if (message.isSynced) {
        continue;
      }

      final info = SocketMessageInfo(
        sn: 0,
        uuid: state.uuid,
        message: message.text,
        sender: message.sender,
        useYn: 'Y',
        timestamp: KstDateTimeUtil.format(message.receivedAt),
      );

      final savedSn = await _socketUseCase(ref).uploadSocketMessageInfo(info);
      if (savedSn == null) {
        state = state.copyWith(messages: updatedMessages);
        return syncedCount > 0
            ? const SocketUploadFailure(SocketMessageKeys.uploadFailed)
            : const SocketUploadFailure(SocketMessageKeys.uploadFailed);
      }

      updatedMessages[i] = message.copyWith(savedSn: savedSn);
      syncedCount++;
    }

    state = state.copyWith(messages: updatedMessages);
    return SocketUploadSuccess(syncedCount: syncedCount);
  }
}

@riverpod
class SocketList extends _$SocketList {
  @override
  SocketListState build() {
    Future.microtask(reload);
    return SocketListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _socketUseCase(ref).loadSocketMessageList();

    switch (result) {
      case SocketListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          messageList: items,
          errorMessage: '',
        );
      case SocketListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          messageList: [],
          errorMessage: '',
        );
      case SocketListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          messageList: [],
          errorMessage: message,
        );
    }
  }

  Future<SocketDeleteAllResult> deleteAll() async {
    return _socketUseCase(ref).deleteAllSocketMessages();
  }
}
