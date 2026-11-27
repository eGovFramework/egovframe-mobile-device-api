import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/view_model/accelerator_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/state/accelerator_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'accelerator_detail.dart';

class AcceleratorListPage extends ConsumerStatefulWidget {
  const AcceleratorListPage({super.key});

  @override
  ConsumerState<AcceleratorListPage> createState() =>
      _AcceleratorListPageState();
}

class _AcceleratorListPageState extends ConsumerState<AcceleratorListPage> {
  AcceleratorList get _notifier => ref.read(acceleratorListProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(acceleratorListProvider);

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.accelerator,
      title: l10n.acceleratorApiTitle,
      mainFunctionBody: _buildMainFunctionTab(l10n, listState),
    );
  }

  Widget _buildMainFunctionTab(
    AppLocalizations l10n,
    AcceleratorListState listState,
  ) {
    return listState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: _buildListContent(l10n, listState),
          );
  }

  Widget _buildListContent(
    AppLocalizations l10n,
    AcceleratorListState listState,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: _notifier.reload,
      );
    }
    if (listState.acceleratorInfoList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.acceleratorEmptyList);
    }
    return RefreshIndicator(
      onRefresh: _notifier.reload,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: listState.acceleratorInfoList.length,
        itemBuilder: (context, index) {
          final info = listState.acceleratorInfoList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AcceleratorDetailPage(acceleratorInfo: info),
                  ),
                );
                if (result == true) {
                  await _notifier.reload();
                }
              },
              child: DeviceCardExtended(
                title: '${l10n.commonSn} : ${info.sn}',
                subtitle: '${l10n.commonTimeLabel} : ${info.timestamp}',
                details: [
                  {
                    'label': l10n.acceleratorXAxis,
                    'value': info.xAxis.toStringAsFixed(6),
                  },
                  {
                    'label': l10n.acceleratorYAxis,
                    'value': info.yAxis.toStringAsFixed(6),
                  },
                  {
                    'label': l10n.acceleratorZAxis,
                    'value': info.zAxis.toStringAsFixed(6),
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

class DeviceCardExtended extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Map<String, String>> details;
  final VoidCallback? onTap;
  final bool showArrow;
  final bool isSelected;

  const DeviceCardExtended({
    super.key,
    required this.title,
    this.subtitle,
    required this.details,
    this.onTap,
    this.showArrow = true,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: EgovColor.white100,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: isSelected ? 3 : 1,
            color: isSelected ? EgovColor.primary50 : EgovColor.gray20,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: EgovText.title.copyWith(
                            fontSize: 19,
                            height: 1.50,
                          ),
                        ),
                      ),
                      if (showArrow) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: EgovColor.gray40,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      subtitle!,
                      style: EgovText.regular.copyWith(
                        color: EgovColor.gray70,
                        fontSize: 15,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  ...details.map(
                    (detail) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${detail['label']} :',
                            style: EgovText.captionBold.copyWith(height: 1.50),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              detail['value'] ?? '',
                              style: EgovText.caption.copyWith(
                                color: EgovColor.gray90,
                                height: 1.50,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
