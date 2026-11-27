import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/server_connection_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ConnectionResolver = Future<bool> Function({
  required BuildContext context,
  required WidgetRef ref,
});

/// 서버 연결 확인이 필요한 버튼을 위한 공통 위젯
class ServerConnectionButton extends ConsumerStatefulWidget {
  final String text;
  final Widget? icon;
  final Future<void> Function() onServerConnected;
  final ConnectionResolver? resolveConnection;
  final Color? normalColor;
  final Color? pressedColor;
  final double? width;
  final double? height;
  final Duration animationDuration;

  const ServerConnectionButton({
    super.key,
    required this.text,
    this.icon,
    required this.onServerConnected,
    this.resolveConnection,
    this.normalColor,
    this.pressedColor,
    this.width,
    this.height,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  ConsumerState<ServerConnectionButton> createState() =>
      _ServerConnectionButtonState();
}

class _ServerConnectionButtonState extends ConsumerState<ServerConnectionButton> {
  bool _isCheckingConnection = false;

  Future<void> _handleTap() async {
    if (_isCheckingConnection) return;

    setState(() => _isCheckingConnection = true);

    try {
      final bool connected;
      if (widget.resolveConnection != null) {
        connected = await widget.resolveConnection!(
          context: context,
          ref: ref,
        );
      } else {
        connected = await ServerConnectionUtils.checkConnectionAndShowToast(
          context: context,
        );
      }
      if (!connected || !mounted) return;

      await widget.onServerConnected();
    } finally {
      if (mounted) {
        setState(() => _isCheckingConnection = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomButton(
      text: _isCheckingConnection ? l10n.serverConnectionChecking : widget.text,
      icon: _isCheckingConnection
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(EgovColor.white100),
              ),
            )
          : widget.icon,
      onTap: _isCheckingConnection ? null : _handleTap,
      normalColor:
          _isCheckingConnection ? EgovColor.gray40 : widget.normalColor,
      pressedColor: widget.pressedColor,
      width: widget.width,
      height: widget.height,
      animationDuration: widget.animationDuration,
    );
  }
}

/// 서버 연결 확인이 필요한 버튼을 위한 간편한 팩토리 함수들
class ServerConnectionButtonFactory {
  static ServerConnectionButton listButton({
    required String text,
    required Future<void> Function() onServerConnected,
    ConnectionResolver? resolveConnection,
    Color? normalColor,
  }) {
    return ServerConnectionButton(
      text: text,
      icon: const Icon(Icons.list, color: EgovColor.white100, size: 20),
      onServerConnected: onServerConnected,
      resolveConnection: resolveConnection,
      normalColor: normalColor,
    );
  }

  static ServerConnectionButton uploadButton({
    required String text,
    required Future<void> Function() onServerConnected,
    ConnectionResolver? resolveConnection,
    Color? normalColor,
  }) {
    return ServerConnectionButton(
      text: text,
      icon: const Icon(Icons.upload, color: EgovColor.white100, size: 20),
      onServerConnected: onServerConnected,
      resolveConnection: resolveConnection,
      normalColor: normalColor,
    );
  }

  static ServerConnectionButton sendButton({
    required String text,
    required Future<void> Function() onServerConnected,
    ConnectionResolver? resolveConnection,
    Color? normalColor,
  }) {
    return ServerConnectionButton(
      text: text,
      icon: const Icon(Icons.cloud_upload, color: EgovColor.white100, size: 20),
      onServerConnected: onServerConnected,
      resolveConnection: resolveConnection,
      normalColor: normalColor,
    );
  }

  static ServerConnectionButton refreshButton({
    required String text,
    required Future<void> Function() onServerConnected,
    ConnectionResolver? resolveConnection,
    Color? normalColor,
  }) {
    return ServerConnectionButton(
      text: text,
      icon: const Icon(Icons.refresh, color: EgovColor.white100, size: 20),
      onServerConnected: onServerConnected,
      resolveConnection: resolveConnection,
      normalColor: normalColor,
    );
  }
}
