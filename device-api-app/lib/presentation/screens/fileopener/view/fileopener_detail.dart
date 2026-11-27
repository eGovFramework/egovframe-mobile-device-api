import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';

import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/view_model/fileopener_controller.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/file_opener_l10n.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileOpenerDetailPage extends ConsumerStatefulWidget {
  final ServerFileInfo serverFile;

  const FileOpenerDetailPage({super.key, required this.serverFile});

  @override
  ConsumerState<FileOpenerDetailPage> createState() =>
      _FileOpenerDetailPageState();
}

class _FileOpenerDetailPageState extends ConsumerState<FileOpenerDetailPage> {
  Future<void> _downloadFile() async {
    final l10n = AppLocalizations.of(context)!;

    final result = await ref
        .read(fileOpenerDetailProvider.notifier)
        .downloadServerFile(widget.serverFile);

    if (!mounted) return;

    switch (result) {
      case FileOpenerDownloadSuccess(:final message):
        await showStatusToast(
          context,

          variant: StatusVariant.success,

          title: l10n.commonSuccess,
          message: resolveAppMessage(l10n, message),
        );

        if (mounted) Navigator.pop(context, true);

      case FileOpenerDownloadFailure(:final message):
        await showStatusToast(
          context,

          variant: StatusVariant.error,

          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final detailState = ref.watch(fileOpenerDetailProvider);

    return ApiFeatureShell(
      popToApiMainCount: 2,
      feature: ApiFeature.fileOpener,

      title: l10n.fileOpenerDetailTitle,

      mainFunctionBody: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            InfoBox(text: l10n.fileOpenerDetailInfo),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: CommonTable(
                  title: l10n.fileOpenerDetailTableTitle,

                  data: [
                    {
                      'label': l10n.fileOpenerLabelFileName,

                      'value': widget.serverFile.orignlFileNm,
                    },

                    {
                      'label': l10n.fileOpenerLabelFileType,

                      'value': fileOpenerTypeLabel(
                        l10n,
                        widget.serverFile.fileType,
                      ),
                    },

                    {
                      'label': l10n.fileOpenerLabelFileSize,

                      'value': widget.serverFile.formattedFileSize,
                    },

                    {
                      'label': l10n.fileOpenerLabelUpdatedAt,

                      'value': widget.serverFile.formattedUpdateDate,
                    },

                    {
                      'label': l10n.fileOpenerLabelFileNumber,

                      'value': widget.serverFile.fileSn,
                    },

                    {
                      'label': l10n.fileOpenerLabelStoredFileName,

                      'value': widget.serverFile.streFileNm,
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
            text: detailState.isDownloading
                ? l10n.fileOpenerDownloading
                : l10n.fileOpenerDownloadButton,

            onTap: detailState.isDownloading ? null : _downloadFile,

            icon: detailState.isDownloading
                ? SizedBox(
                    width: 20,

                    height: 20,

                    child: CircularProgressIndicator(
                      strokeWidth: 2,

                      value: detailState.downloadProgress,

                      valueColor: const AlwaysStoppedAnimation<Color>(
                        EgovColor.white100,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.download,

                    color: EgovColor.white100,

                    size: 20,
                  ),
          ),
        ],
      ),
    );
  }
}
