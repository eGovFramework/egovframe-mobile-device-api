import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/entities/file_mgmt_result.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileMgmt/view_model/file_mgmt_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileMgmt/widgets/file_mgmt_folder_picker.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileMgmt/widgets/file_mgmt_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileMgmt/widgets/file_mgmt_selection_bar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/bottom_sheet.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/app_shell_tab_bar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'file_mgmt_description.dart';

class FileMgmtPage extends ConsumerStatefulWidget {
  const FileMgmtPage({super.key});

  @override
  ConsumerState<FileMgmtPage> createState() => _FileMgmtPageState();
}

class _FileMgmtPageState extends ConsumerState<FileMgmtPage> {
  final _shellController = FeatureShellController();

  FileMgmtMain get _notifier => ref.read(fileMgmtMainProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startInitialize());
  }

  Future<void> _startInitialize() async {
    final result = await _notifier.initialize();
    _handleInitResult(result);
  }

  void _handleInitResult(FileMgmtInitResult result) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    switch (result) {
      case FileMgmtInitPermissionDenied():
        _showPermissionDialog();
      case FileMgmtInitFailure(:final message):
        if (message != l10n.fileMgmtAlreadyRootDirectory) {
          _showErrorDialog(message);
        }
      case FileMgmtInitSuccess():
        break;
    }
  }

  Future<void> _navigateToDirectory(String path) async {
    final result = await _notifier.navigateToDirectory(path);
    if (result is FileMgmtDirectoryFailure) {
      _showErrorDialog(result.message);
    }
  }

  void _exitSelectionMode() => _notifier.exitSelectionMode();

  void _updateItemSelection(String path, bool selected) {
    _notifier.updateItemSelection(path, selected);
  }

  Future<void> _navigateToRoot() async {
    final result = await _notifier.navigateToRoot();
    if (result is FileMgmtDirectoryFailure) {
      _showErrorDialog(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fileState = ref.watch(fileMgmtMainProvider);

    return FeatureShell(
      controller: _shellController,
      title: l10n.fileMgmtApiTitle,
      currentAppTargetPage: 'device_file_mgmt',
      guidePage: const FileFunctionPage(),
      appBarBuilder: (ctrl) {
        return CustomAppBar(
          title: fileState.isSelectionMode
              ? l10n.fileMgmtSelectedCount(fileState.selectedItems.length)
              : l10n.fileMgmtApiTitle,
          hideHomeButton: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
            onPressed: ctrl.handleBack,
          ),
          actions: [
            if (fileState.isSelectionMode)
              IconButton(
                icon: const Icon(Icons.close, color: EgovColor.white100),
                onPressed: _exitSelectionMode,
              ),
          ],
        );
      },
      onBeforeBack: (shellTab) {
        if (fileState.isSelectionMode) {
          _exitSelectionMode();
          return true;
        }
        if (shellTab == ShellTab.mainFunction &&
            fileState.pathHistory.isNotEmpty) {
          _navigateBack();
          return true;
        }
        return false;
      },
      mainFunctionBody: FileMgmtOverview(
        fileState: fileState,
        onGoRoot: _navigateToRoot,
        onToggleSelection: _updateItemSelection,
        onOpenDirectory: _navigateToDirectory,
        onLongPress: _showItemActionSheet,
        getFileInfo: _notifier.getFileInfo,
      ),
      bottomBar: fileState.isSelectionMode
          ? FileMgmtSelectionBar(
              onCancel: _exitSelectionMode,
              onCopy: fileState.selectedItems.isEmpty
                  ? null
                  : _copySelectedItems,
              onMove: fileState.selectedItems.isEmpty
                  ? null
                  : _moveSelectedItems,
              onDelete: fileState.selectedItems.isEmpty
                  ? null
                  : _deleteSelectedItems,
            )
          : BottomButtonRow(
              buttons: [
                CustomButton(
                  text: l10n.fileMgmtCreateFileAndFolder,
                  icon: const Icon(Icons.folder_open, size: 18),
                  onTap: _showFileWorkActionSheet,
                ),
              ],
            ),
    );
  }

  void _showFileWorkActionSheet() {
    showAppActionSheet(
      context,
      title: AppLocalizations.of(context)!.fileMgmtCreateFileAndFolder,
      message: AppLocalizations.of(context)!.fileMgmtActionSheetMessage,
      actions: [
        AppBottomSheetAction(
          label: AppLocalizations.of(context)!.fileMgmtNewFolder,
          icon: Icons.create_new_folder,
          onTap: _showCreateDirectoryDialog,
        ),
        AppBottomSheetAction(
          label: AppLocalizations.of(context)!.fileMgmtNewTextFile,
          icon: Icons.note_add,
          onTap: _showCreateSampleFileDialog,
        ),
      ],
    );
  }

  void _showItemActionSheet(FileSystemEntity entity) {
    final String name = entity.path.split('/').last;

    showAppActionSheet(
      context,
      title: name,
      message: AppLocalizations.of(context)!.fileMgmtItemSelectedMessage,
      actions: [
        AppBottomSheetAction(
          label: AppLocalizations.of(context)!.commonCopy,
          icon: Icons.copy,
          iconColor: EgovColor.information50,
          onTap: () => _runSingleItemAction(entity.path, _copySelectedItems),
        ),
        AppBottomSheetAction(
          label: AppLocalizations.of(context)!.commonMove,
          icon: Icons.drive_file_move,
          iconColor: EgovColor.warning40,
          onTap: () => _runSingleItemAction(entity.path, _moveSelectedItems),
        ),
        AppBottomSheetAction(
          label: AppLocalizations.of(context)!.commonRename,
          icon: Icons.edit,
          iconColor: EgovColor.primary50,
          onTap: () => _renameItem(entity.path),
        ),
        AppBottomSheetAction(
          label: AppLocalizations.of(context)!.commonDelete,
          icon: Icons.delete,
          iconColor: EgovColor.danger50,
          onTap: () => _runSingleItemAction(entity.path, _deleteSelectedItems),
        ),
        AppBottomSheetAction(
          label: AppLocalizations.of(context)!.fileMgmtSelectionMode,
          icon: Icons.checklist,
          iconColor: EgovColor.gray60,
          onTap: () => _notifier.startSelectionWithItem(entity.path),
        ),
      ],
    );
  }

  Future<void> _runSingleItemAction(
    String path,
    Future<void> Function() action,
  ) async {
    _notifier.setSelectionForSingleAction(path);
    await action();
  }

  void _showCreateDirectoryDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EgovColor.white100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          AppLocalizations.of(context)!.fileMgmtCreateFolderTitle,
          style: EgovText.title,
        ),
        content: TextField(
          controller: controller,
          style: EgovText.regular,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.fileMgmtFeatureTitle,
            labelStyle: EgovText.caption,
            hintText: AppLocalizations.of(context)!.fileMgmtNewFolder,
            hintStyle: EgovText.caption,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: EgovColor.gray20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: EgovColor.primary50, width: 2),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.commonCancel,
              style: EgovText.regular.copyWith(color: EgovColor.gray60),
            ),
          ),
          CustomButton(
            text: AppLocalizations.of(context)!.commonCreate,
            width: 80,
            height: 40,
            onTap: () async {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                await _createDirectory(controller.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createDirectory(String name) async {
    final result = await _notifier.createDirectory(name);
    if (!mounted) return;

    switch (result) {
      case FileMgmtOperationSuccess(:final message):
        showStatusToast(
          context,
          variant: StatusVariant.success,
          title: AppLocalizations.of(context)!.commonSuccess,
          message: resolveAppMessage(AppLocalizations.of(context)!, message),
        );
      case FileMgmtOperationFailure(:final message):
        _showErrorDialog(message);
    }
  }

  void _showCreateSampleFileDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.fileMgmtCreateTextFileTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.fileMgmtFeatureTitle,
                hintText: AppLocalizations.of(
                  context,
                )!.fileMgmtSampleFileNameHint,
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.commonCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final fileName = nameController.text.trim();
              if (fileName.isNotEmpty) {
                Navigator.pop(context);
                await _createSampleFile(fileName);
              }
            },
            child: Text(AppLocalizations.of(context)!.commonCreate),
          ),
        ],
      ),
    );
  }

  Future<void> _createSampleFile(String fileName) async {
    final result = await _notifier.createSampleFile(fileName);
    if (!mounted) return;

    switch (result) {
      case FileMgmtOperationSuccess(:final message):
        showStatusToast(
          context,
          variant: StatusVariant.success,
          title: AppLocalizations.of(context)!.commonSuccess,
          message: resolveAppMessage(AppLocalizations.of(context)!, message),
        );
      case FileMgmtOperationFailure(:final message):
        _showErrorDialog(message);
    }
  }

  Future<void> _navigateBack() async {
    final result = await _notifier.navigateBack();
    if (result is FileMgmtDirectoryFailure) {
      _showErrorDialog(result.message);
    }
  }

  Future<void> _deleteSelectedItems() async {
    final fileState = ref.read(fileMgmtMainProvider);
    if (fileState.selectedItems.isEmpty) return;

    final confirmed = await _showConfirmDialog(
      AppLocalizations.of(
        context,
      )!.fileMgmtDeleteSelectedConfirm(fileState.selectedItems.length),
      AppLocalizations.of(context)!.fileMgmtDeleteSelectedDescription,
    );

    if (!confirmed) return;

    final result = await _notifier.deleteSelectedItems();
    if (!mounted) return;

    switch (result) {
      case FileMgmtOperationSuccess(:final message):
        showStatusToast(
          context,
          variant: StatusVariant.success,
          title: AppLocalizations.of(context)!.commonSuccess,
          message: resolveAppMessage(AppLocalizations.of(context)!, message),
        );
      case FileMgmtOperationFailure(:final message):
        _showErrorDialog(message);
    }
  }

  Future<void> _copySelectedItems() async {
    final fileState = ref.read(fileMgmtMainProvider);
    if (fileState.selectedItems.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;

    final destinationPath = await _showFolderSelectionDialog(
      l10n.fileMgmtSelectCopyDestination,
    );

    if (!mounted) return;
    if (destinationPath == null) return;

    final result = await _notifier.copySelectedItems(destinationPath);
    if (!mounted) return;

    switch (result) {
      case FileMgmtOperationSuccess(:final message):
        showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: resolveAppMessage(l10n, message),
        );
      case FileMgmtOperationFailure(:final message):
        _showErrorDialog(message);
    }
  }

  Future<void> _moveSelectedItems() async {
    final fileState = ref.read(fileMgmtMainProvider);
    if (fileState.selectedItems.isEmpty) return;

    final destinationPath = await _showFolderSelectionDialog(
      AppLocalizations.of(context)!.fileMgmtSelectMoveDestination,
    );
    if (destinationPath == null) return;

    final result = await _notifier.moveSelectedItems(destinationPath);
    if (!mounted) return;

    switch (result) {
      case FileMgmtOperationSuccess(:final message):
        showStatusToast(
          context,
          variant: StatusVariant.success,
          title: AppLocalizations.of(context)!.commonSuccess,
          message: resolveAppMessage(AppLocalizations.of(context)!, message),
        );
      case FileMgmtOperationFailure(:final message):
        _showErrorDialog(message);
    }
  }

  Future<bool> _showConfirmDialog(String title, String content) async {
    final result = await showPromptDialog(
      context,
      title: title,
      message: content,
      confirmText: AppLocalizations.of(context)!.commonConfirm,
      cancelText: AppLocalizations.of(context)!.commonCancel,
    );
    return result ?? false;
  }

  void _showPermissionDialog() {
    showPromptDialog(
      context,
      title: AppLocalizations.of(context)!.fileMgmtPermissionTitle,
      message: AppLocalizations.of(context)!.fileMgmtPermissionMessage,
      confirmText: AppLocalizations.of(context)!.commonOpenSettings,
      cancelText: AppLocalizations.of(context)!.commonCancel,
      onConfirm: () async {
        await _notifier.openPermissionSettings();
        await Future.delayed(const Duration(seconds: 1));
        _handleInitResult(await _notifier.initialize());
      },
    );
  }

  Future<void> _renameItem(String sourcePath) async {
    final sourceName = sourcePath.split('/').last;
    final controller = TextEditingController(text: sourceName);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.commonRename),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.fileMgmtNewNameLabel,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.commonCancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty &&
                  controller.text.trim() != sourceName) {
                Navigator.pop(context, controller.text.trim());
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.commonConfirm),
          ),
        ],
      ),
    );

    if (newName != null && newName != sourceName) {
      final result = await _notifier.renameItem(sourcePath, newName);
      if (result is FileMgmtOperationFailure && mounted) {
        _showErrorDialog(result.message);
      }
    }
  }

  Future<String?> _showFolderSelectionDialog(String title) async {
    final fileState = ref.read(fileMgmtMainProvider);
    return showDialog<String>(
      context: context,
      builder: (context) => FileMgmtFolderPicker(
        title: title,
        initialPath: fileState.currentPath,
        useCase: ref.read(fileMgmtUseCaseProvider),
      ),
    );
  }

  Future<void> _showErrorDialog(String message) async {
    await showStatusToast(
      context,
      variant: StatusVariant.error,
      title: AppLocalizations.of(context)!.commonError,
      message: resolveAppMessage(AppLocalizations.of(context)!, message),
    );
  }
}
