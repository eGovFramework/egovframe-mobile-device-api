import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/view_model/gps_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/state/gps_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gps_detail.dart';

class GpsListPage extends ConsumerStatefulWidget {
  const GpsListPage({super.key});

  @override
  ConsumerState<GpsListPage> createState() => _GpsListPageState();
}

class _GpsListPageState extends ConsumerState<GpsListPage> {
  final Set<int> _selectedSns = {};

  void _clearSelection() {
    setState(_selectedSns.clear);
  }

  void _toggleSelection(GpsInfo item) {
    if (item.sn <= 0) return;
    setState(() {
      if (_selectedSns.contains(item.sn)) {
        _selectedSns.remove(item.sn);
      } else {
        _selectedSns.add(item.sn);
      }
    });
  }

  List<GpsInfo> _selectedItems(GpsListState listState) {
    return listState.gpsInfoList
        .where((item) => _selectedSns.contains(item.sn))
        .toList();
  }

  Future<void> _openDetail(GpsInfo gpsInfo) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GpsDetailPage(gpsInfo: gpsInfo),
      ),
    );
    if (result == true && mounted) {
      await ref.read(gpsListProvider.notifier).reload();
    }
  }

  Future<void> _deleteSelected() async {
    final l10n = AppLocalizations.of(context)!;
    final selectedItems = _selectedItems(ref.read(gpsListProvider));

    if (selectedItems.isEmpty) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.gpsNoSelection,
      );
      return;
    }

    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.gpsDeleteSelectedTitle,
      message: l10n.gpsDeleteSelectedConfirm(selectedItems.length),
    );
    if (!confirmed || !mounted) return;

    final notifier = ref.read(gpsListProvider.notifier);
    final result = await notifier.deleteSelectedItems(selectedItems);
    if (!mounted) return;

    switch (result) {
      case GpsDeleteBatchSuccess():
        _clearSelection();
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.gpsDeleteSelectedSuccess,
        );
        await notifier.reload();
      case GpsDeleteBatchFailure(:final message):
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
    final listState = ref.watch(gpsListProvider);
    final hasSelection = _selectedSns.isNotEmpty;

    return PopScope(
      canPop: !hasSelection,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _clearSelection();
      },
      child: ApiFeatureShell(
        popToApiMainCount: 1,
        feature: ApiFeature.gps,
        title: hasSelection
            ? l10n.gpsSelectedCount(_selectedSns.length)
            : l10n.gpsApiTitle,
        mainFunctionBody: _buildListTab(l10n, listState),
        bottomBar: hasSelection
            ? BottomButtonRow(
                buttons: [
                  CustomButton(
                    text: l10n.commonCancel,
                    onTap: _clearSelection,
                    normalColor: EgovColor.gray70,
                    icon: const Icon(
                      Icons.close,
                      color: EgovColor.white100,
                      size: 20,
                    ),
                  ),
                  ServerConnectionButton(
                    text: l10n.gpsDeleteSelectedButton,
                    normalColor: EgovColor.point50,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: EgovColor.white100,
                      size: 20,
                    ),
                    onServerConnected: _deleteSelected,
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildListTab(AppLocalizations l10n, GpsListState listState) {
    return listState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: _buildListContent(l10n, listState),
          );
  }

  Widget _buildListContent(AppLocalizations l10n, GpsListState listState) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: () => ref.read(gpsListProvider.notifier).reload(),
      );
    }
    if (listState.gpsInfoList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.gpsEmptyList);
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(gpsListProvider.notifier).reload(),
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: listState.gpsInfoList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InfoBox(
                text: _selectedSns.isEmpty
                    ? l10n.gpsSelectionHint
                    : l10n.gpsSelectedCount(_selectedSns.length),
              ),
            );
          }

          final gpsInfo = listState.gpsInfoList[index - 1];
          final isSelected = _selectedSns.contains(gpsInfo.sn);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => _toggleSelection(gpsInfo),
                  icon: Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isSelected ? EgovColor.primary50 : EgovColor.gray50,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openDetail(gpsInfo),
                    child: DeviceCardExtended(
                      title: '${l10n.commonUuidLabel} : ${gpsInfo.uuid}',
                      isSelected: isSelected,
                      details: [
                        {
                          'label': l10n.gpsLatitudeLabel,
                          'value': gpsInfo.latitude.toStringAsFixed(6),
                        },
                        {
                          'label': l10n.gpsLongitudeLabel,
                          'value': gpsInfo.longitude.toStringAsFixed(6),
                        },
                        {
                          'label': l10n.gpsAccuracyLabel,
                          'value': gpsInfo.formattedAccuracy,
                        },
                      ],
                    ),
                  ),
                ),
              ],
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: EgovColor.gray90,
                            fontSize: 19,
                            fontFamily: 'Pretendard GOV',
                            fontWeight: FontWeight.w700,
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
                      style: const TextStyle(
                        color: EgovColor.gray70,
                        fontSize: 15,
                        fontFamily: 'Pretendard GOV',
                        fontWeight: FontWeight.w400,
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
                            style: const TextStyle(
                              color: Color(0xFF1E2124),
                              fontSize: 13,
                              fontFamily: 'Pretendard GOV',
                              fontWeight: FontWeight.w700,
                              height: 1.50,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              detail['value'] ?? '',
                              style: const TextStyle(
                                color: EgovColor.gray90,
                                fontSize: 13,
                                fontFamily: 'Pretendard GOV',
                                fontWeight: FontWeight.w400,
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
