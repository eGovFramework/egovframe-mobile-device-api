import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_opener_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/view_model/fileopener_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/state/fileopener_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/widgets/fileopener_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/widgets/fileopener_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/file_display_util.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/file_opener_l10n.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fileopener_description.dart';
import 'fileopener_list.dart';

class FileOpenerScreen extends ConsumerStatefulWidget {
  const FileOpenerScreen({super.key});

  @override
  ConsumerState<FileOpenerScreen> createState() => _FileOpenerScreenState();
}

class _FileOpenerScreenState extends ConsumerState<FileOpenerScreen> {
  FileOpenerMain get _notifier => ref.read(fileOpenerMainProvider.notifier);

  Future<void> _openFile(FileOpenerInfo fileInfo) async {
    final result = await _notifier.openFile(fileInfo);
    if (!mounted) return;

    switch (result) {
      case FileOpenerOpenSuccess():
        break;
      case FileOpenerOpenFailure(:final message):
        await _showErrorToast(message);
    }
  }

  Future<void> _pickFiles() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _notifier.pickFiles(allowMultiple: true);
    if (!mounted) return;

    switch (result) {
      case FileOpenerPickSuccess(:final files):
        await _showSuccessToast(
          resolveAppMessage(
            l10n,
            '${FileOpenerMessageKeys.addFilesSummaryPrefix}${files.length}',
          ),
        );
      case FileOpenerPickCancelled():
        break;
      case FileOpenerPickFailure(:final message):
        await _showErrorToast(resolveAppMessage(l10n, message));
    }
  }

  Future<void> _deleteFile(FileOpenerInfo fileInfo) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPromptDialog(
      context,
      title: l10n.fileOpenerDeleteTitle,
      message: l10n.fileOpenerDeleteConfirm(fileInfo.fileName),
      confirmText: l10n.commonDelete,
      cancelText: l10n.fileOpenerCancelButton,
    );
    if (confirmed != true || !mounted) return;

    final result = await _notifier.deleteFile(fileInfo);
    if (!mounted) return;

    switch (result) {
      case FileOpenerDeleteSuccess(:final fileName):
        await _showSuccessToast(l10n.fileOpenerDeleteSuccess(fileName));
      case FileOpenerDeleteFailure(:final message):
        await _showErrorToast(resolveAppMessage(l10n, message));
    }
  }

  Future<void> _showSuccessToast(String message) async {
    final l10n = AppLocalizations.of(context)!;
    await showStatusToast(
      context,
      variant: StatusVariant.success,
      title: l10n.commonSuccess,
      message: message,
    );
  }

  Future<void> _showErrorToast(String message) async {
    final l10n = AppLocalizations.of(context)!;
    await showStatusToast(
      context,
      variant: StatusVariant.error,
      title: l10n.commonError,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(fileOpenerMainProvider);

    return FeatureShell(
      title: l10n.fileOpenerApiTitle,
      currentAppTargetPage: 'file_opener',
      guidePage: const FileOpenerFunctionPage(),
      mainFunctionBody: _buildMainFunctionTab(mainState),
      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.fileOpenerAddFilesButton,
            onTap: mainState.isLoading ? null : _pickFiles,
            isLoading: mainState.isLoading,
            icon: const Icon(Icons.add, color: EgovColor.white100, size: 20),
          ),
          ServerConnectionButtonFactory.listButton(
            text: l10n.fileOpenerServerListButton,
            onServerConnected: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FileOpenerListPage(),
                ),
              );
              await _notifier.reload();
            },
            resolveConnection: FileOpenerConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }

  Widget _buildMainFunctionTab(FileOpenerMainState mainState) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
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
                    Row(
                      children: [
                        Icon(
                          Icons.folder_open,
                          color: EgovColor.primary50,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.fileOpenerLocalList(
                              mainState.filteredFiles.length.toString(),
                            ),
                            style: EgovText.title.copyWith(
                              fontWeight: FontWeight.bold,
                              color: EgovColor.primary50,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: mainState.isLoading
                              ? null
                              : () => _notifier.reload(),
                          icon: mainState.isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: mainState.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildLocalFileList(mainState),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const FileOpenerConnectionBar(),
        ],
      ),
    );
  }

  Widget _buildLocalFileList(FileOpenerMainState mainState) {
    final l10n = AppLocalizations.of(context)!;
    if (mainState.filteredFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 48, color: EgovColor.gray40),
            const SizedBox(height: 16),
            Text(
              mainState.selectedFileType != null
                  ? l10n.fileOpenerNoTypeFiles
                  : l10n.fileOpenerNoLocalFiles,
              style: EgovText.bodyLarge.copyWith(color: EgovColor.gray60),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.fileOpenerEmptyGuide,
              textAlign: TextAlign.center,
              style: EgovText.bodyMedium.copyWith(color: EgovColor.gray50),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: mainState.filteredFiles.length,
      itemBuilder: (context, index) {
        final file = mainState.filteredFiles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildFileItem(file),
        );
      },
    );
  }

  Widget _buildFileItem(FileOpenerInfo file) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      color: EgovColor.white100,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: FileDisplayUtil.getFileIconColor(file.fileName),
          child: Icon(
            FileDisplayUtil.getFileIcon(file.fileName),
            color: EgovColor.white100,
            size: 20,
          ),
        ),
        title: Text(
          file.fileName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.fileOpenerFileInfoLine(
                fileOpenerTypeLabel(l10n, file.fileType),
                file.formattedFileSize,
              ),
            ),
            Text(
              file.formattedLastModified,
              style: TextStyle(fontSize: 11, color: EgovColor.gray60),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _openFile(file),
              icon: const Icon(Icons.open_in_new),
              color: EgovColor.success50,
              iconSize: 20,
            ),
            IconButton(
              onPressed: () => _deleteFile(file),
              icon: const Icon(Icons.delete_outline),
              color: EgovColor.danger50,
              iconSize: 20,
            ),
          ],
        ),
        onTap: () => _openFile(file),
      ),
    );
  }
}
