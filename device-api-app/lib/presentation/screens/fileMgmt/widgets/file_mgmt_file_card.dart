import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/file_display_util.dart';
import 'package:flutter/material.dart';

class FileMgmtFileCard extends StatelessWidget {
  final FileSystemEntity entity;
  final bool isSelected;
  final bool isSelectionMode;
  final void Function(String path, bool selected) onToggleSelection;
  final void Function(String path) onOpenDirectory;
  final void Function(FileSystemEntity entity) onLongPress;
  final Future<Map<String, dynamic>> Function(String path) getFileInfo;

  const FileMgmtFileCard({
    super.key,
    required this.entity,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onToggleSelection,
    required this.onOpenDirectory,
    required this.onLongPress,
    required this.getFileInfo,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDirectory = entity is Directory;
    final name = entity.path.split('/').last;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? EgovColor.primary5 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: isSelectionMode
            ? Checkbox(
                value: isSelected,
                activeColor: EgovColor.primary50,
                onChanged: (selected) {
                  onToggleSelection(entity.path, selected == true);
                },
              )
            : Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDirectory ? EgovColor.primary10 : EgovColor.gray10,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  isDirectory ? Icons.folder : FileDisplayUtil.getFileIcon(name),
                  color: isDirectory ? EgovColor.primary50 : EgovColor.gray60,
                  size: 20,
                ),
              ),
        title: Text(
          name,
          style: EgovText.medium.copyWith(
            fontWeight: isDirectory ? FontWeight.w600 : FontWeight.w500,
            color: EgovColor.gray90,
          ),
        ),
        subtitle: FutureBuilder<Map<String, dynamic>>(
          future: getFileInfo(entity.path),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final info = snapshot.data!;
            final subtitleText = isDirectory
                ? l10n.fileMgmtItemCount(info['itemCount'] ?? 0)
                : info['sizeFormatted'] ?? '';
            return Text(subtitleText, style: EgovText.caption);
          },
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: EgovColor.primary50)
            : null,
        onTap: () {
          if (isSelectionMode) {
            onToggleSelection(entity.path, !isSelected);
          } else if (isDirectory) {
            onOpenDirectory(entity.path);
          }
        },
        onLongPress: () => onLongPress(entity),
      ),
    );
  }
}
