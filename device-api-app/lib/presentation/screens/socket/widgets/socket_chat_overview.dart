import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/state/socket_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/websocket_connection_util.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

class SocketChatOverview extends StatelessWidget {
  final SocketMainState mainState;
  final TextEditingController nicknameController;
  final ValueChanged<String> onSenderNameChanged;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final VoidCallback onOpenChat;
  final Widget? footer;

  const SocketChatOverview({
    super.key,
    required this.mainState,
    required this.nicknameController,
    required this.onSenderNameChanged,
    required this.onConnect,
    required this.onDisconnect,
    required this.onOpenChat,
    this.footer,
  });

  String _connectionStatusText(AppLocalizations l10n) {
    final state = mainState.connectionState;
    if (state is ws.Connected || state is ws.Reconnected) {
      return l10n.socketWebsocketConnected;
    }
    if (state is ws.Connecting) {
      return l10n.socketWebsocketConnecting;
    }
    if (state is ws.Reconnecting) {
      return l10n.socketWebsocketReconnecting;
    }
    return l10n.socketWebsocketDisconnected;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isConnected = isWebSocketConnected(mainState.connectionState);
    final isConnecting = isWebSocketConnecting(mainState.connectionState);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoBox(text: _connectionStatusText(l10n)),
        const SizedBox(height: 8),
        Text(
          l10n.socketWebsocketUrl(AppConfig.websocketUrl),
          style: EgovText.caption.copyWith(color: EgovColor.gray60),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.socketChatNicknameLabel,
          style: EgovText.medium.copyWith(
            color: EgovColor.gray90,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: nicknameController,
          onChanged: onSenderNameChanged,
          enabled: !isConnected && !isConnecting,
          decoration: InputDecoration(
            hintText: l10n.socketChatNicknameHint,
            filled: true,
            fillColor: EgovColor.white100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: EgovColor.gray20),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: EgovColor.gray20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (isConnected)
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: l10n.socketWebsocketDisconnectButton,
                  onTap: onDisconnect,
                  icon: const Icon(
                    Icons.link_off,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: l10n.socketChatOpenButton,
                  onTap: onOpenChat,
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
              ),
            ],
          )
        else
          CustomButton(
            text: l10n.socketWebsocketConnectButton,
            onTap: isConnecting ? null : onConnect,
            isLoading: isConnecting,
            icon: const Icon(
              Icons.link,
              color: EgovColor.white100,
              size: 20,
            ),
          ),
        if (footer != null) ...[
          const SizedBox(height: 16),
          footer!,
        ],
      ],
    );
  }
}
