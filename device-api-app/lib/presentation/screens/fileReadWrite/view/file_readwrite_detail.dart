import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';

import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/view_model/file_readwrite_controller.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';

import 'package:egovframe_mobile_deviceapi_app/utils/server_connection_utils.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileReadWriteDetailPage extends ConsumerStatefulWidget {
  final FileInfo serverFile;

  const FileReadWriteDetailPage({super.key, required this.serverFile});

  @override
  ConsumerState<FileReadWriteDetailPage> createState() =>
      _FileReadWriteDetailPageState();
}

class _FileReadWriteDetailPageState
    extends ConsumerState<FileReadWriteDetailPage> {
  Future<void> _deleteServerFile() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showPromptDialog(
      context,

      title: l10n.fileReadWriteServerDeleteTitle,
      message: l10n.fileReadWriteServerDeleteConfirm(
        widget.serverFile.fileName,
      ),
      confirmText: l10n.commonDelete,
      cancelText: l10n.fileReadWriteCancelButton,
    );

    if (confirmed != true || !mounted) return;

    await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
      context: context,

      operation: () async {
        final result = await ref
            .read(fileReadWriteDetailProvider.notifier)
            .deleteServerFile(widget.serverFile);

        if (!mounted) return;

        switch (result) {
          case FileReadWriteServerDeleteSuccess(:final fileName):
            await showStatusToast(
              context,

              variant: StatusVariant.success,

              title: l10n.commonSuccess,
              message: l10n.fileReadWriteServerDeleteSuccess(fileName),
            );

            if (mounted) Navigator.pop(context, true);

          case FileReadWriteServerDeleteFailure(:final message):
            await showStatusToast(
              context,

              variant: StatusVariant.error,

              title: l10n.commonError,
              message: resolveAppMessage(l10n, message),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final detailState = ref.watch(fileReadWriteDetailProvider);

    return ApiFeatureShell(
      popToApiMainCount: 2,
      feature: ApiFeature.fileReadWrite,

      title: l10n.fileReadWriteDetailTitle,

      mainFunctionBody: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            InfoBox(text: l10n.fileReadWriteDetailInfo),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: CommonTable(
                  title: l10n.fileReadWriteDetailTableTitle,

                  data: [
                    {
                      'label': l10n.fileReadWriteLabelFileName,

                      'value': widget.serverFile.fileName,
                    },

                    {
                      'label': l10n.fileReadWriteLabelPath,

                      'value': widget.serverFile.filePath,
                    },

                    {
                      'label': l10n.fileReadWriteLabelSize,

                      'value': widget.serverFile.formattedSize,
                    },

                    {
                      'label': l10n.fileReadWriteLabelUploadedAt,

                      'value': widget.serverFile.formattedDate,
                    },

                    {
                      'label': l10n.fileReadWriteLabelFileSn,

                      'value': widget.serverFile.fileSn.toString(),
                    },

                    {
                      'label': l10n.commonUuidLabel,
                      'value': widget.serverFile.uuid,
                    },

                    {
                      'label': l10n.fileReadWriteLabelUseYn,

                      'value': widget.serverFile.useYn == 'Y'
                          ? l10n.fileReadWriteUseYes
                          : l10n.fileReadWriteUseNo,
                    },
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.commonDelete,

            onTap: detailState.isDeleting ? null : _deleteServerFile,

            icon: detailState.isDeleting
                ? const SizedBox(
                    width: 20,

                    height: 20,

                    child: CircularProgressIndicator(
                      strokeWidth: 2,

                      valueColor: AlwaysStoppedAnimation<Color>(
                        EgovColor.white100,
                      ),
                    ),
                  )
                : const Icon(Icons.delete, color: EgovColor.white100, size: 20),

            normalColor: EgovColor.danger50,
          ),
        ],
      ),
    );
  }
}
