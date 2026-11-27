import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/view_model/fileopener_controller.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/state/fileopener_state.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/file_opener_l10n.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fileopener_detail.dart';

class FileOpenerListPage extends ConsumerStatefulWidget {
  const FileOpenerListPage({super.key});

  @override
  ConsumerState<FileOpenerListPage> createState() => _FileOpenerListPageState();
}

class _FileOpenerListPageState extends ConsumerState<FileOpenerListPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(fileOpenerListProvider);

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.fileOpener,

      title: l10n.fileOpenerServerListTitle,

      mainFunctionBody: _buildListTab(listState),
    );
  }

  Widget _buildListTab(FileOpenerListState listState) {
    return listState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: _buildListContent(listState),
          );
  }

  Widget _buildListContent(FileOpenerListState listState) {
    final l10n = AppLocalizations.of(context)!;
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: listState.errorMessage,
        onRetry: () => ref.read(fileOpenerListProvider.notifier).reload(),
      );
    }
    if (listState.serverFiles.isEmpty) {
      return ServerListEmptyMessage(message: l10n.fileOpenerNoServerFiles);
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(fileOpenerListProvider.notifier).reload(),
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: listState.serverFiles.length,
        itemBuilder: (context, index) {
          final serverFile = listState.serverFiles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TouchFeedbackWidget(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FileOpenerDetailPage(serverFile: serverFile),
                  ),
                );
                if (result == true && mounted) {
                  await ref.read(fileOpenerListProvider.notifier).reload();
                }
              },
              child: DeviceCardExtended(
                title: serverFile.orignlFileNm,
                subtitle: l10n.fileOpenerFileInfoLine(
                  fileOpenerTypeLabel(l10n, serverFile.fileType),
                  serverFile.formattedFileSize,
                ),
                details: [
                  {
                    'label': l10n.fileOpenerLabelFileType,
                    'value': fileOpenerTypeLabel(l10n, serverFile.fileType),
                  },
                  {
                    'label': l10n.fileOpenerLabelFileSize,
                    'value': serverFile.formattedFileSize,
                  },
                  {
                    'label': l10n.fileOpenerLabelUpdatedAt,
                    'value': serverFile.formattedUpdateDate,
                  },
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TouchFeedbackWidget extends StatefulWidget {
  final VoidCallback onTap;

  final Widget child;

  const _TouchFeedbackWidget({required this.onTap, required this.child});

  @override
  State<_TouchFeedbackWidget> createState() => _TouchFeedbackWidgetState();
}

class _TouchFeedbackWidgetState extends State<_TouchFeedbackWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),

      onTapUp: (_) => setState(() => isPressed = false),

      onTapCancel: () => setState(() => isPressed = false),

      onTap: widget.onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),

          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: EgovColor.black10,

                    blurRadius: 2,

                    offset: const Offset(0, 1),
                  ),
                ]
              : [
                  BoxShadow(
                    color: EgovColor.black25,

                    blurRadius: 4,

                    offset: const Offset(0, 2),
                  ),
                ],
        ),

        child: Transform.scale(
          scale: isPressed ? 0.95 : 1.0,

          child: widget.child,
        ),
      ),
    );
  }
}

class DeviceCardExtended extends StatelessWidget {
  final String title;

  final String? subtitle;

  final List<Map<String, String>> details;

  const DeviceCardExtended({
    super.key,

    required this.title,

    this.subtitle,

    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: ShapeDecoration(
        color: EgovColor.white100,

        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFB1B8BE)),

          borderRadius: BorderRadius.circular(12),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,

                  style: const TextStyle(
                    color: Color(0xFF1E2124),

                    fontSize: 19,

                    fontFamily: 'Pretendard GOV',

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                color: EgovColor.gray40,
                size: 16,
              ),
            ],
          ),

          if (subtitle != null) ...[const SizedBox(height: 8), Text(subtitle!)],

          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(top: 8),

              child: Row(
                children: [
                  Text(
                    '${detail['label']} :',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(width: 8),

                  Expanded(child: Text(detail['value'] ?? '')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
