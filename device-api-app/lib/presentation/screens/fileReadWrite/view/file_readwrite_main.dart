import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/view/file_readwrite_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/view_model/file_readwrite_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/widgets/file_readwrite_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/widgets/file_readwrite_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/file_display_util.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/state/file_readwrite_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'file_readwrite_list.dart';
import 'file_readwrite_local_detail.dart';

class FileReadWriteMainPage extends ConsumerStatefulWidget {
  const FileReadWriteMainPage({super.key});

  @override
  ConsumerState<FileReadWriteMainPage> createState() =>
      _FileReadWriteMainPageState();
}

class _FileReadWriteMainPageState extends ConsumerState<FileReadWriteMainPage> {
  final _shellController = FeatureShellController();
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _fileContentController = TextEditingController();

  @override
  void dispose() {
    _fileNameController.dispose();
    _fileContentController.dispose();
    super.dispose();
  }

  FileReadWriteMain get _notifier =>
      ref.read(fileReadWriteMainProvider.notifier);

  Future<void> _showCreateFileDialog() async {
    final l10n = AppLocalizations.of(context)!;
    _fileNameController.clear();
    _fileContentController.clear();
    final mainState = ref.read(fileReadWriteMainProvider);

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.create_new_folder, color: EgovColor.primary50, size: 24),
            const SizedBox(width: 8),
            Text(l10n.fileReadWriteCreateNewFile),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fileNameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.fileReadWriteLabelFileName,
                  hintText: l10n.fileReadWriteFileNameHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.insert_drive_file),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _fileContentController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: l10n.fileReadWriteLabelContent,
                  hintText: l10n.fileReadWriteContentHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.edit_note),
                ),
              ),
            ],
          ),
        ),
        actions: [
          CustomButton(
            text: l10n.fileReadWriteCancelButton,
            onTap: () => Navigator.of(context).pop(),
            normalColor: EgovColor.gray30,
            pressedColor: EgovColor.gray50,
          ),
          const SizedBox(width: 8),
          CustomButton(
            text: l10n.fileReadWriteCreateButton,
            onTap: mainState.isLoading ? null : _createTextFile,
            isLoading: mainState.isLoading,
            normalColor: EgovColor.success50,
            pressedColor: EgovColor.success70,
          ),
        ],
      ),
    );
  }

  Future<void> _importLocalFiles() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _notifier.importLocalFiles();
    if (!mounted) return;

    switch (result) {
      case FileReadWriteImportSuccess(:final count):
        await _showMessage(l10n.fileReadWriteImportSuccess(count.toString()));
      case FileReadWriteImportCancelled():
        break;
      case FileReadWriteImportFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  Future<void> _createTextFile() async {
    final result = await _notifier.createTextFile(
      fileName: _fileNameController.text,
      content: _fileContentController.text,
    );

    if (!mounted) return;

    switch (result) {
      case FileReadWriteCreateSuccess():
        _fileNameController.clear();
        _fileContentController.clear();
        Navigator.of(context).pop();
      case FileReadWriteCreateFailure(:final message):
        await _showMessage(message);
    }
  }

  Future<void> _openLocalFileDetail(FileInfo fileInfo) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FileReadWriteLocalDetailPage(localFile: fileInfo),
      ),
    );
    if (result == true && mounted) {
      await _notifier.reloadLocalFileList();
    }
  }

  Future<void> _showMessage(String message) async {
    final l10n = AppLocalizations.of(context)!;
    await showStatusToast(
      context,
      variant: StatusVariant.success,
      title: l10n.fileReadWriteNoticeTitle,
      message: message,
    );
  }

  Future<bool> _showConfirmDialog(String title, String content) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showPromptDialog(
      context,
      title: title,
      message: content,
      confirmText: l10n.fileReadWriteConfirmButton,
      cancelText: l10n.fileReadWriteCancelButton,
    );
    return result ?? false;
  }

  Future<void> _uploadFile() async {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.read(fileReadWriteMainProvider);
    if (mainState.selectedFiles.isEmpty) {
      await _showMessage(l10n.fileReadWriteNoFilesSelectedForUpload);
      return;
    }

    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.fileReadWriteUploadTitle,
      message: l10n.fileReadWriteUploadConfirm(
        mainState.selectedFiles.length.toString(),
      ),
    );
    if (!confirmed || !mounted) return;

    final result = await _notifier.uploadSelectedFiles();
    if (!mounted) return;

    switch (result) {
      case FileReadWriteUploadSuccess(
        :final successCount,
        :final failCount,
      ):
        await _showMessage(
          resolveAppMessage(
            l10n,
            'fileReadWriteUploadSummary|$successCount|$failCount',
          ),
        );
      case FileReadWriteUploadFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  Future<void> _deleteSelectedFiles() async {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.read(fileReadWriteMainProvider);
    if (mainState.selectedFiles.isEmpty) {
      await _showMessage(l10n.fileReadWriteNoFilesToDelete);
      return;
    }

    final confirmed = await _showConfirmDialog(
      l10n.fileReadWriteDeleteTitle,
      l10n.fileReadWriteDeleteConfirm(
        mainState.selectedFiles.length.toString(),
      ),
    );
    if (!confirmed || !mounted) return;

    final result = await _notifier.deleteSelectedFiles();
    if (!mounted) return;

    if (result.isAllSuccess) {
      await _showMessage(l10n.fileReadWriteDeleteAllSuccess);
    } else {
      await _showMessage(
        l10n.fileReadWriteDeleteFailedFiles(
          result.successCount.toString(),
          result.failCount.toString(),
          result.failedFiles.length.toString(),
          result.failedFiles.join(', '),
        ),
      );
    }
  }

  Widget _buildListHeader(FileReadWriteMainState mainState) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Icon(Icons.folder_open, color: EgovColor.primary50, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            mainState.isSelectionMode
                ? l10n.fileReadWriteSelectedFiles(
                    mainState.selectedFiles.length.toString(),
                  )
                : l10n.fileReadWriteLocalFiles(
                    mainState.fileList.length.toString(),
                  ),
            style: EgovText.title.copyWith(
              fontWeight: FontWeight.bold,
              color: EgovColor.primary50,
            ),
          ),
        ),
        if (mainState.isSelectionMode) ...[
          IconButton(
            onPressed: mainState.selectedFiles.isNotEmpty
                ? _deleteSelectedFiles
                : null,
            icon: const Icon(Icons.delete),
            tooltip: l10n.fileReadWriteDeleteSelectedTooltip,
            color: mainState.selectedFiles.isNotEmpty
                ? EgovColor.danger50
                : EgovColor.gray40,
          ),
          IconButton(
            onPressed: _notifier.exitSelectionMode,
            icon: const Icon(Icons.close),
            tooltip: l10n.fileReadWriteExitSelectionTooltip,
          ),
        ] else
          IconButton(
            onPressed: mainState.isLoading
                ? null
                : () => _notifier.reloadLocalFileList(),
            icon: mainState.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
          ),
      ],
    );
  }

  Widget _buildLocalFileList(FileReadWriteMainState mainState) {
    final l10n = AppLocalizations.of(context)!;
    if (mainState.fileList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 48, color: EgovColor.gray40),
            const SizedBox(height: 16),
            Text(
              mainState.isLoading
                  ? l10n.fileReadWriteListLoading
                  : l10n.fileReadWriteNoLocalFiles,
              style: EgovText.bodyLarge.copyWith(color: EgovColor.gray60),
              textAlign: TextAlign.center,
            ),
            if (!mainState.isLoading) ...[
              const SizedBox(height: 8),
              Text(
                l10n.fileReadWriteNoLocalFilesHint,
                style: EgovText.bodyMedium.copyWith(color: EgovColor.gray50),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: mainState.fileList.length,
      itemBuilder: (context, index) {
        final fileInfo = mainState.fileList[index];
        final isSelected = mainState.selectedFiles.contains(fileInfo.fileName);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: 2,
            color: isSelected ? EgovColor.primary10 : EgovColor.white100,
            child: InkWell(
              onTap: () {
                if (mainState.isSelectionMode) {
                  _notifier.toggleFileSelection(fileInfo.fileName);
                } else {
                  _openLocalFileDetail(fileInfo);
                }
              },
              onLongPress: () {
                if (!mainState.isSelectionMode) {
                  _notifier.startSelectionMode();
                  _notifier.toggleFileSelection(fileInfo.fileName);
                }
              },
              child: ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: FileDisplayUtil.getFileIconColor(
                        fileInfo.fileName,
                      ),
                      child: Icon(
                        FileDisplayUtil.getFileIcon(fileInfo.fileName),
                        color: EgovColor.white100,
                        size: 20,
                      ),
                    ),
                    if (mainState.isSelectionMode)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? EgovColor.primary50
                                : EgovColor.white100,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? EgovColor.primary50
                                  : EgovColor.gray40,
                              width: 1,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: EgovColor.white100,
                                  size: 10,
                                )
                              : null,
                        ),
                      ),
                  ],
                ),
                title: Text(
                  fileInfo.fileName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? EgovColor.primary70 : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.fileReadWriteSize(fileInfo.formattedSize)),
                    Text(
                      l10n.fileReadWriteModifiedAt(fileInfo.formattedDate),
                      style: TextStyle(color: EgovColor.gray60, fontSize: 11),
                    ),
                  ],
                ),
                trailing: mainState.isSelectionMode
                    ? null
                    : const Icon(Icons.chevron_right, color: EgovColor.gray40),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(fileReadWriteMainProvider);

    return FeatureShell(
      controller: _shellController,
      title: l10n.fileReadWriteApiTitle,
      currentAppTargetPage: 'file_readWrite',
      guidePage: const FileReadWriteFunctionPage(),
      appBarBuilder: (ctrl) {
        return CustomAppBar(
          title: mainState.isSelectionMode
              ? l10n.fileReadWriteSelectedCount(
                  mainState.selectedFiles.length.toString(),
                )
              : l10n.fileReadWriteApiTitle,
          hideHomeButton: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
            onPressed: ctrl.handleBack,
          ),
          actions: [
            if (mainState.isSelectionMode)
              IconButton(
                icon: const Icon(Icons.close, color: EgovColor.white100),
                onPressed: _notifier.exitSelectionMode,
              ),
          ],
        );
      },
      onBeforeBack: (_) {
        if (mainState.isSelectionMode) {
          _notifier.exitSelectionMode();
          return true;
        }
        return false;
      },
      mainFunctionBody: mainState.isLoading && mainState.fileList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildListHeader(mainState),
                            const SizedBox(height: 16),
                            Expanded(child: _buildLocalFileList(mainState)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const FileReadWriteConnectionBar(),
                ],
              ),
            ),
      bottomBar: mainState.isSelectionMode && mainState.selectedFiles.isNotEmpty
          ? BottomButtonRow(
              buttons: [
                CustomButton(
                  text: l10n.commonDelete,
                  icon: const Icon(Icons.delete, size: 18),
                  normalColor: EgovColor.danger50,
                  onTap: mainState.isLoading ? null : _deleteSelectedFiles,
                ),
                ServerConnectionButtonFactory.uploadButton(
                  text: l10n.fileReadWriteUploadSelected(
                    mainState.selectedFiles.length.toString(),
                  ),
                  onServerConnected: _uploadFile,
                  resolveConnection:
                      FileReadWriteConnectionResolver.resolveConnection,
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomButtonRow(
                  buttons: [
                    CustomButton(
                      text: l10n.fileReadWriteCreateNewFile,
                      onTap: mainState.isLoading
                          ? null
                          : _showCreateFileDialog,
                      isLoading: mainState.isLoading,
                      icon: const Icon(Icons.save, size: 18),
                      normalColor: EgovColor.primary50,
                      pressedColor: EgovColor.primary70,
                      fontSize: 15,
                    ),
                    CustomButton(
                      text: l10n.fileReadWriteImportButton,
                      onTap: mainState.isLoading ? null : _importLocalFiles,
                      isLoading: mainState.isLoading,
                      icon: const Icon(Icons.file_upload_outlined, size: 18),
                      normalColor: EgovColor.secondary50,
                      pressedColor: EgovColor.secondary70,
                      fontSize: 15,
                    ),
                  ],
                ),
                BottomButtonRow(
                  height: 80,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 32,
                  ),
                  buttons: [
                    ServerConnectionButtonFactory.listButton(
                      text: l10n.fileReadWriteServerListButton,
                      onServerConnected: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FileReadWriteListPage(),
                          ),
                        );
                        await _notifier.reloadLocalFileList();
                      },
                      resolveConnection:
                          FileReadWriteConnectionResolver.resolveConnection,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
