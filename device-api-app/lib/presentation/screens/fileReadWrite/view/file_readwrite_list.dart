import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/view_model/file_readwrite_controller.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/state/file_readwrite_state.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'file_readwrite_detail.dart';

class FileReadWriteListPage extends ConsumerStatefulWidget {
  const FileReadWriteListPage({super.key});

  @override
  ConsumerState<FileReadWriteListPage> createState() =>
      _FileReadWriteListPageState();
}

class _FileReadWriteListPageState extends ConsumerState<FileReadWriteListPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final listState = ref.watch(fileReadWriteListProvider);

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.fileReadWrite,

      title: l10n.fileReadWriteServerListTitle,

      mainFunctionBody: _buildListTab(listState),
    );
  }

  Widget _buildListTab(FileReadWriteListState listState) {
    return listState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: _buildListContent(listState),
          );
  }

  Widget _buildListContent(FileReadWriteListState listState) {
    final l10n = AppLocalizations.of(context)!;
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: listState.errorMessage,
        onRetry: () => ref.read(fileReadWriteListProvider.notifier).reload(),
      );
    }
    if (listState.serverFileList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.fileReadWriteNoServerFiles);
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(fileReadWriteListProvider.notifier).reload(),
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: listState.serverFileList.length,
        itemBuilder: (context, index) {
          final serverFile = listState.serverFileList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TouchFeedbackWidget(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FileReadWriteDetailPage(serverFile: serverFile),
                  ),
                );
                if (result == true && mounted) {
                  await ref.read(fileReadWriteListProvider.notifier).reload();
                }
              },
              child: DeviceCardExtended(
                title: serverFile.fileName,
                details: [
                  {
                    'label': l10n.fileReadWriteLabelSize,
                    'value': serverFile.formattedSize,
                  },
                  {
                    'label': l10n.fileReadWriteLabelUploadedAt,
                    'value': serverFile.formattedDate,
                  },
                  {
                    'label': l10n.fileReadWriteLabelFileSn,
                    'value': serverFile.fileSn.toString(),
                  },
                  {
                    'label': l10n.fileReadWriteLabelUseYn,
                    'value': serverFile.useYn == 'Y'
                        ? l10n.fileReadWriteUseYes
                        : l10n.fileReadWriteUseNo,
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

                    height: 1.50,
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

          if (subtitle != null) ...[
            const SizedBox(height: 16),

            Text(subtitle!),
          ],

          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(top: 8),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

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
