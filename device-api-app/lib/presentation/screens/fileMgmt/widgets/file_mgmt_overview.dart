import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileMgmt/state/file_mgmt_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileMgmt/widgets/file_mgmt_file_card.dart';
import 'package:flutter/material.dart';

class FileMgmtOverview extends StatelessWidget {
  final FileMgmtMainState fileState;
  final VoidCallback onGoRoot;
  final void Function(String path, bool selected) onToggleSelection;
  final void Function(String path) onOpenDirectory;
  final void Function(FileSystemEntity entity) onLongPress;
  final Future<Map<String, dynamic>> Function(String path) getFileInfo;

  const FileMgmtOverview({
    super.key,
    required this.fileState,
    required this.onGoRoot,
    required this.onToggleSelection,
    required this.onOpenDirectory,
    required this.onLongPress,
    required this.getFileInfo,
  });

  String _formatDisplayPath(String path, String rootPath) {
    if (rootPath.isNotEmpty && path.startsWith(rootPath)) {
      final relative = path.substring(rootPath.length);
      if (relative.isEmpty) return '~/Documents';
      return '~/Documents$relative';
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _PathBar(
              fileState: fileState,
              displayPath: _formatDisplayPath(
                fileState.currentPath,
                fileState.rootPath,
              ),
              onGoRoot: onGoRoot,
            ),
            const SizedBox(height: 12),
            Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: EgovColor.gray20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: fileState.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          EgovColor.primary50,
                        ),
                      ),
                    )
                  : _FileList(
                      fileState: fileState,
                      onToggleSelection: onToggleSelection,
                      onOpenDirectory: onOpenDirectory,
                      onLongPress: onLongPress,
                      getFileInfo: getFileInfo,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathBar extends StatelessWidget {
  final FileMgmtMainState fileState;
  final String displayPath;
  final VoidCallback onGoRoot;

  const _PathBar({
    required this.fileState,
    required this.displayPath,
    required this.onGoRoot,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (fileState.currentPath.isEmpty) {
      return const SizedBox.shrink();
    }

    final canGoRoot =
        fileState.rootPath.isNotEmpty &&
        fileState.currentPath != fileState.rootPath &&
        !fileState.isSelectionMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.fileMgmtFeatureTitle,
          style: EgovText.caption.copyWith(color: EgovColor.gray60),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: EgovColor.gray5,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: EgovColor.gray20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.folder_outlined, size: 18, color: EgovColor.primary50),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    displayPath,
                    maxLines: 1,
                    softWrap: false,
                    style: EgovText.regular.copyWith(
                      color: EgovColor.gray70,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 32,
                height: 32,
                child: canGoRoot
                    ? IconButton(
                        onPressed: onGoRoot,
                        icon: Icon(
                          Icons.home,
                          size: 20,
                          color: EgovColor.primary50,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        tooltip: l10n.fileMgmtGoToRoot,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FileList extends StatelessWidget {
  final FileMgmtMainState fileState;
  final void Function(String path, bool selected) onToggleSelection;
  final void Function(String path) onOpenDirectory;
  final void Function(FileSystemEntity entity) onLongPress;
  final Future<Map<String, dynamic>> Function(String path) getFileInfo;

  const _FileList({
    required this.fileState,
    required this.onToggleSelection,
    required this.onOpenDirectory,
    required this.onLongPress,
    required this.getFileInfo,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (fileState.currentContents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 48, color: EgovColor.gray40),
            const SizedBox(height: 8),
            Text(
              l10n.fileMgmtEmptyFolderTitle,
              style: EgovText.regular.copyWith(color: EgovColor.gray40),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.fileMgmtEmptyFolderDescription,
              style: EgovText.caption.copyWith(color: EgovColor.gray50),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: fileState.currentContents.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: EgovColor.gray10),
      itemBuilder: (context, index) {
        final entity = fileState.currentContents[index];
        return FileMgmtFileCard(
          entity: entity,
          isSelected: fileState.selectedItems.contains(entity.path),
          isSelectionMode: fileState.isSelectionMode,
          onToggleSelection: onToggleSelection,
          onOpenDirectory: onOpenDirectory,
          onLongPress: onLongPress,
          getFileInfo: getFileInfo,
        );
      },
    );
  }
}
