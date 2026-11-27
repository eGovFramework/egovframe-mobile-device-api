import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_group.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/state/face_mesh_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view/face_mesh_group_faces.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view_model/face_mesh_controller.dart';
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

/// 1 faceGroupId ( / )
class FaceMeshListPage extends ConsumerStatefulWidget {
  static const routeName = 'FaceMeshList';

  const FaceMeshListPage({super.key});

  @override
  ConsumerState<FaceMeshListPage> createState() =>
      _FaceMeshListPageState();
}

class _FaceMeshListPageState
    extends ConsumerState<FaceMeshListPage> {
  final Set<String> _selectedGroupIds = {};

  void _clearSelection() {
    setState(_selectedGroupIds.clear);
  }

  void _toggleSelection(FaceMeshGroupSummary group) {
    setState(() {
      if (_selectedGroupIds.contains(group.faceGroupId)) {
        _selectedGroupIds.remove(group.faceGroupId);
      } else {
        _selectedGroupIds.add(group.faceGroupId);
      }
    });
  }

  Future<void> _openGroup(FaceMeshGroupSummary group) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FaceMeshGroupFacesPage(
          faceGroupId: group.faceGroupId,
        ),
      ),
    );

    if (changed == true && mounted) {
      _selectedGroupIds.remove(group.faceGroupId);
      await ref.read(faceMeshListProvider.notifier).reload();
    }
  }

  Future<void> _deleteSelectedGroups() async {
    final l10n = AppLocalizations.of(context)!;
    final selectedIds = _selectedGroupIds.toList();

    if (selectedIds.isEmpty) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.faceMeshNoSelection,
      );
      return;
    }

    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.faceMeshDeleteSelectedTitle,
      message: l10n.faceMeshDeleteSelectedGroupsConfirm(selectedIds.length),
    );
    if (!confirmed || !mounted) return;

    final notifier = ref.read(faceMeshListProvider.notifier);
    final result = await notifier.deleteSelectedGroups(selectedIds);

    if (!mounted) return;

    switch (result) {
      case FaceMeshDeleteBatchSuccess():
        _clearSelection();
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.faceMeshDeleteSelectedGroupsSuccess,
        );
        await notifier.reload();
      case FaceMeshDeleteBatchFailure(:final message):
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
    final listState = ref.watch(faceMeshListProvider);
    final notifier = ref.read(faceMeshListProvider.notifier);
    final hasSelection = _selectedGroupIds.isNotEmpty;

    return PopScope(
      canPop: !hasSelection,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _clearSelection();
      },
      child: ApiFeatureShell(
        popToApiMainCount: 1,
        feature: ApiFeature.faceMesh,
        title: hasSelection
            ? l10n.faceMeshSelectedCount(_selectedGroupIds.length)
            : l10n.faceMeshListTitle,
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
                    text: l10n.faceMeshDeleteSelectedButton,
                    normalColor: EgovColor.point50,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: EgovColor.white100,
                      size: 20,
                    ),
                    onServerConnected: _deleteSelectedGroups,
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildListContent(
    AppLocalizations l10n,
    FaceMeshListState listState,
    FaceMeshList notifier,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: notifier.reload,
      );
    }

    final groups =
        FaceMeshGroupSummary.fromRecords(listState.faceMeshList);

    if (groups.isEmpty) {
      return ServerListEmptyMessage(message: l10n.faceMeshEmptyList);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoBox(
          text: _selectedGroupIds.isEmpty
              ? l10n.faceMeshSelectionModeHint
              : l10n.faceMeshSelectedCount(_selectedGroupIds.length),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: RefreshIndicator(
            onRefresh: notifier.reload,
            color: EgovColor.primary50,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                final isSelected =
                    _selectedGroupIds.contains(group.faceGroupId);
                return _FaceMeshGroupCard(
                  group: group,
                  isSelected: isSelected,
                  noImageLabel: l10n.faceMeshNoImage,
                  faceCountLabel:
                      l10n.faceMeshFaceCountBadge(group.faceCount),
                  onOpenGroup: () => _openGroup(group),
                  onToggleSelection: () => _toggleSelection(group),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _FaceMeshGroupCard extends StatelessWidget {
  final FaceMeshGroupSummary group;
  final bool isSelected;
  final String noImageLabel;
  final String faceCountLabel;
  final VoidCallback onOpenGroup;
  final VoidCallback onToggleSelection;

  const _FaceMeshGroupCard({
    required this.group,
    required this.isSelected,
    required this.noImageLabel,
    required this.faceCountLabel,
    required this.onOpenGroup,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? EgovColor.primary5 : EgovColor.white100,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpenGroup,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? EgovColor.primary30 : EgovColor.gray20,
              ),
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(noImageLabel),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onToggleSelection,
                          borderRadius: BorderRadius.circular(4),
                          child: Icon(
                            isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: isSelected
                                ? EgovColor.primary50
                                : EgovColor.gray50,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: EgovColor.primary50,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.face,
                              size: 14,
                              color: EgovColor.white100,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              faceCountLabel,
                              style: EgovText.caption.copyWith(
                                color: EgovColor.white100,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.timestamp?.isNotEmpty == true
                          ? group.timestamp!
                          : '-',
                      style: EgovText.caption.copyWith(
                        color: EgovColor.gray90,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      group.faceGroupId,
                      style: EgovText.caption.copyWith(
                        color: EgovColor.gray60,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String noImageLabel) {
    if (!group.hasLocalImage) {
      return Container(
        color: EgovColor.gray10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hide_image_outlined,
              size: 36,
              color: EgovColor.gray40,
            ),
            const SizedBox(height: 8),
            Text(
              noImageLabel,
              style: EgovText.caption.copyWith(color: EgovColor.gray50),
            ),
          ],
        ),
      );
    }

    return Image.file(
      File(group.imagePath!),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: EgovColor.gray10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.broken_image_outlined,
                size: 36,
                color: EgovColor.gray40,
              ),
              const SizedBox(height: 8),
              Text(
                noImageLabel,
                style: EgovText.caption.copyWith(color: EgovColor.gray50),
              ),
            ],
          ),
        );
      },
    );
  }
}
