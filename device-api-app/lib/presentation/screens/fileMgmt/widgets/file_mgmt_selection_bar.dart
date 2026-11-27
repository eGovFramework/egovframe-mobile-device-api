import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class FileMgmtSelectionBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback? onCopy;
  final VoidCallback? onMove;
  final VoidCallback? onDelete;

  const FileMgmtSelectionBar({
    super.key,
    required this.onCancel,
    this.onCopy,
    this.onMove,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 48,
            child: CustomButton(
              text: AppLocalizations.of(context)!.commonCancel,
              fontSize: 15,
              horizontalPadding: 8,
              normalColor: EgovColor.gray60,
              onTap: onCancel,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SelectionIconButton(
              tooltip: AppLocalizations.of(context)!.commonCopy,
              icon: Icons.copy,
              color: EgovColor.information50,
              onTap: onCopy,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SelectionIconButton(
              tooltip: AppLocalizations.of(context)!.commonMove,
              icon: Icons.drive_file_move,
              color: EgovColor.warning40,
              onTap: onMove,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SelectionIconButton(
              tooltip: AppLocalizations.of(context)!.commonDelete,
              icon: Icons.delete,
              color: EgovColor.danger50,
              onTap: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _SelectionIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final background = isDisabled ? EgovColor.gray20 : color;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        height: 48,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(6),
          elevation: isDisabled ? 0 : 2,
          shadowColor: EgovColor.black50,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Center(
              child: Icon(
                icon,
                size: 22,
                color: isDisabled ? EgovColor.gray70 : EgovColor.white100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
