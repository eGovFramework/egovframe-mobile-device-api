import 'dart:async';

import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:flutter/material.dart';

export 'modal.dart' show StatusVariant, simplifyStatusMessage;

enum ToastVariant { info, success, error }

typedef _ToastLook = ({
  Color background,
  Color border,
  Color text,
  String icon,
});

const Map<ToastVariant, _ToastLook> _looks = {
  ToastVariant.success: (
    background: EgovColor.success5,
    border: EgovColor.success10,
    text: EgovColor.success60,
    icon: 'assets/images/icons/system-success.png',
  ),
  ToastVariant.error: (
    background: EgovColor.danger5,
    border: EgovColor.danger10,
    text: EgovColor.danger60,
    icon: 'assets/images/icons/system-error.png',
  ),
  ToastVariant.info: (
    background: EgovColor.white100,
    border: EgovColor.gray20,
    text: EgovColor.gray90,
    icon: 'assets/images/icons/info.png',
  ),
};

const Map<ToastVariant, Duration> _durations = {
  ToastVariant.error: Duration(milliseconds: 3500),
  ToastVariant.success: Duration(milliseconds: 2500),
  ToastVariant.info: Duration(milliseconds: 2500),
};

OverlayEntry? _entry;
Timer? _timer;

class Toast extends StatelessWidget {
  final ToastVariant variant;
  final String message;

  const Toast({super.key, required this.variant, required this.message});

  @override
  Widget build(BuildContext context) {
    final _ToastLook look = _looks[variant]!;

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: look.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: look.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 32,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(look.icon, width: 24, height: 24, fit: BoxFit.contain),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: EgovText.buttonText.copyWith(
                  color: look.text,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _dismissToast() {
  _timer?.cancel();
  _entry?.remove();
  _timer = null;
  _entry = null;
}

Future<void> _showToast(
  BuildContext context, {
  required ToastVariant variant,
  required String message,
  Duration? duration,
}) async {
  if (!context.mounted) return;

  _dismissToast();

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => Positioned(
      left: 24,
      right: 24,
      bottom: MediaQuery.paddingOf(ctx).bottom + 24,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _ToastEntrance(
          child: Toast(variant: variant, message: message),
        ),
      ),
    ),
  );

  _entry = entry;
  if (!context.mounted) return;
  Overlay.of(context).insert(entry);

  final Duration wait = duration ?? _durations[variant]!;
  _timer = Timer(wait, _dismissToast);
}

class _ToastEntrance extends StatefulWidget {
  final Widget child;

  const _ToastEntrance({required this.child});

  @override
  State<_ToastEntrance> createState() => _ToastEntranceState();
}

class _ToastEntranceState extends State<_ToastEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(curve),
        child: widget.child,
      ),
    );
  }
}

String _statusToastMessage({
  required BuildContext context,
  required StatusVariant variant,
  required String title,
  required String message,
}) {
  final l10n = AppLocalizations.of(context)!;
  final String simplified = simplifyStatusMessage(message, variant, l10n);
  if (simplified != message) return simplified;
  return message.trim().isNotEmpty ? message.trim() : title.trim();
}

Future<void> showToast(
  BuildContext context, {
  required String message,
  ToastVariant variant = ToastVariant.info,
  Duration? duration,
}) {
  if (!context.mounted) return Future.value();
  return _showToast(
    context,
    variant: variant,
    message: message,
    duration: duration,
  );
}

Future<void> showStatusToast(
  BuildContext context, {
  required StatusVariant variant,
  required String title,
  required String message,
  Duration? duration,
}) {
  if (!context.mounted) return Future.value();

  final String toastMessage = _statusToastMessage(
    context: context,
    variant: variant,
    title: title,
    message: message,
  );

  return _showToast(
    context,
    variant: variant == StatusVariant.success
        ? ToastVariant.success
        : ToastVariant.error,
    message: toastMessage,
    duration: duration,
  );
}
