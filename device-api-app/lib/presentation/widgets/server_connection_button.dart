import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/server_connection_utils.dart';
import 'package:flutter/material.dart';

/// 서버 연결 확인이 필요한 버튼을 위한 공통 위젯
class ServerConnectionButton extends StatefulWidget {
  final String text;
  final Widget? icon;
  final Future<void> Function() onServerConnected;
  final String errorTitle;
  final String errorMessage;
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
    this.errorTitle = '서버 연결 오류',
    this.errorMessage = '서버에 연결할 수 없습니다. 다시 시도해주세요.',
    this.normalColor,
    this.pressedColor,
    this.width,
    this.height,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<ServerConnectionButton> createState() => _ServerConnectionButtonState();
}

class _ServerConnectionButtonState extends State<ServerConnectionButton> {
  bool _isCheckingConnection = false;

  Future<void> _handleTap() async {
    if (_isCheckingConnection) return;

    setState(() => _isCheckingConnection = true);

    try {
      await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
        context: context,
        operation: widget.onServerConnected,
        errorTitle: widget.errorTitle,
        errorMessage: widget.errorMessage,
      );
    } finally {
      if (mounted) {
        setState(() => _isCheckingConnection = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: _isCheckingConnection ? '연결 확인 중...' : widget.text,
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
      normalColor: _isCheckingConnection ? EgovColor.gray40 : widget.normalColor,
      pressedColor: widget.pressedColor,
      width: widget.width,
      height: widget.height,
      animationDuration: widget.animationDuration,
    );
  }
}

/// 서버 연결 확인이 필요한 버튼을 위한 간편한 팩토리 함수들
class ServerConnectionButtonFactory {
  /// 목록 버튼 생성
  static ServerConnectionButton listButton({
    required String text,
    required Future<void> Function() onServerConnected,
    String errorTitle = '서버 연결 오류',
    String errorMessage = '서버에 연결할 수 없습니다. 목록을 다시 시도해주세요.',
    Color? normalColor,
  }) {
    return ServerConnectionButton(
      text: text,
      icon: const Icon(Icons.list, color: EgovColor.white100, size: 20),
      onServerConnected: onServerConnected,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      normalColor: normalColor,
    );
  }

  /// 업로드 버튼 생성
  static ServerConnectionButton uploadButton({
    required String text,
    required Future<void> Function() onServerConnected,
    String errorTitle = '서버 연결 오류',
    String errorMessage = '서버에 연결할 수 없습니다. 업로드를 다시 시도해주세요.',
    Color? normalColor,
  }) {
    return ServerConnectionButton(
      text: text,
      icon: const Icon(Icons.upload, color: EgovColor.white100, size: 20),
      onServerConnected: onServerConnected,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      normalColor: normalColor,
    );
  }

  /// 전송 버튼 생성
  static ServerConnectionButton sendButton({
    required String text,
    required Future<void> Function() onServerConnected,
    String errorTitle = '서버 연결 오류',
    String errorMessage = '서버에 연결할 수 없습니다. 전송을 다시 시도해주세요.',
    Color? normalColor,
  }) {
    return ServerConnectionButton(
      text: text,
      icon: const Icon(Icons.cloud_upload, color: EgovColor.white100, size: 20),
      onServerConnected: onServerConnected,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      normalColor: normalColor,
    );
  }

  /// 새로고침 버튼 생성
  static ServerConnectionButton refreshButton({
    required String text,
    required Future<void> Function() onServerConnected,
    String errorTitle = '서버 연결 오류',
    String errorMessage = '서버에 연결할 수 없습니다. 새로고침을 다시 시도해주세요.',
    Color? normalColor,
  }) {
    return ServerConnectionButton(
      text: text,
      icon: const Icon(Icons.refresh, color: EgovColor.white100, size: 20),
      onServerConnected: onServerConnected,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      normalColor: normalColor,
    );
  }
}
