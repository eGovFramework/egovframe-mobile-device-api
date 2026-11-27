import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/state/compass_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/view_model/compass_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompassListPage extends ConsumerStatefulWidget {
  const CompassListPage({super.key});

  @override
  ConsumerState<CompassListPage> createState() => _CompassListPageState();
}

class _CompassListPageState extends ConsumerState<CompassListPage> {
  final Set<int> _selectedSns = {};

  void _clearSelection() {
    setState(_selectedSns.clear);
  }

  void _toggleSelection(CompassInfo item) {
    setState(() {
      if (_selectedSns.contains(item.sn)) {
        _selectedSns.remove(item.sn);
      } else {
        _selectedSns.add(item.sn);
      }
    });
  }

  List<CompassInfo> _selectedItems(CompassListState listState) {
    return listState.compassList
        .where((item) => _selectedSns.contains(item.sn))
        .toList();
  }

  Future<void> _deleteSelected() async {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.read(compassListProvider);
    final selectedItems = _selectedItems(listState);

    if (selectedItems.isEmpty) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.compassNoSelection,
      );
      return;
    }

    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.compassDeleteSelectedTitle,
      message: l10n.compassDeleteSelectedConfirm(selectedItems.length),
    );
    if (!confirmed || !mounted) return;

    final notifier = ref.read(compassListProvider.notifier);
    final result = await notifier.deleteSelectedItems(selectedItems);

    if (!mounted) return;

    switch (result) {
      case CompassDeleteBatchSuccess():
        _clearSelection();
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.compassDeleteSelectedSuccess,
        );
        await notifier.reload();
      case CompassDeleteBatchFailure(:final message):
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
    final listState = ref.watch(compassListProvider);
    final notifier = ref.read(compassListProvider.notifier);
    final hasSelection = _selectedSns.isNotEmpty;

    return PopScope(
      canPop: !hasSelection,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _clearSelection();
      },
      child: ApiFeatureShell(
        popToApiMainCount: 1,
        feature: ApiFeature.compass,
        title: hasSelection
            ? l10n.compassSelectedCount(_selectedSns.length)
            : l10n.compassApiTitle,
        mainFunctionBody: listState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: _buildListContent(l10n, listState, notifier),
              ),
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
                    text: l10n.compassDeleteSelectedButton,
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

  Widget _buildListContent(
    AppLocalizations l10n,
    CompassListState listState,
    CompassList notifier,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: notifier.reload,
      );
    }

    if (listState.compassList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.compassEmptyList);
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: EgovColor.primary50,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listState.compassList.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InfoBox(
                text: _selectedSns.isEmpty
                    ? l10n.compassSelectionModeHint
                    : l10n.compassSelectedCount(_selectedSns.length),
              ),
            );
          }

          final item = listState.compassList[index - 1];
          final isSelected = _selectedSns.contains(item.sn);

          return _SelectableCompassTile(
            item: item,
            isSelected: isSelected,
            drcLabel: l10n.compassListItemDrc,
            timestampLabel: l10n.compassTimestampLabel,
            onTap: () => _toggleSelection(item),
          );
        },
      ),
    );
  }
}

class _SelectableCompassTile extends StatelessWidget {
  final CompassInfo item;
  final bool isSelected;
  final String drcLabel;
  final String timestampLabel;
  final VoidCallback onTap;

  const _SelectableCompassTile({
    required this.item,
    required this.isSelected,
    required this.drcLabel,
    required this.timestampLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final uuidText = item.uuid.length > 25
        ? '${item.uuid.substring(0, 25)}...'
        : item.uuid;

    return Material(
      color: isSelected ? EgovColor.primary5 : EgovColor.white100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? EgovColor.primary30 : EgovColor.gray20,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  isSelected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: isSelected ? EgovColor.primary50 : EgovColor.gray50,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.explore,
                color: isSelected ? EgovColor.primary50 : EgovColor.gray50,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      uuidText,
                      style: EgovText.medium.copyWith(
                        color: EgovColor.gray90,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$drcLabel : ${item.drc}',
                      style: EgovText.caption.copyWith(
                        color: EgovColor.gray70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$timestampLabel : ${item.timestamp}',
                      style: EgovText.caption.copyWith(
                        color: EgovColor.gray70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
