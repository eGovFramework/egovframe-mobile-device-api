import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/state/face_mesh_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view/face_mesh_detailed.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/widgets/face_mesh_group_tracking_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view_model/face_mesh_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 2 : faceGroupId
class FaceMeshGroupFacesPage extends ConsumerStatefulWidget {
  final String faceGroupId;

  const FaceMeshGroupFacesPage({
    super.key,
    required this.faceGroupId,
  });

  @override
  ConsumerState<FaceMeshGroupFacesPage> createState() =>
      _FaceMeshGroupFacesPageState();
}

class _FaceMeshGroupFacesPageState
    extends ConsumerState<FaceMeshGroupFacesPage> {
  bool _listChanged = false;

  Future<void> _openDetail(FaceMeshRecord item) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FaceMeshDetailedPage(record: item),
      ),
    );

    if (result == true && mounted) {
      _listChanged = true;
      await ref.read(faceMeshListProvider.notifier).reload();
    }
  }

  void _popWithResult() {
    Navigator.pop(context, _listChanged);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(faceMeshListProvider);
    final notifier = ref.read(faceMeshListProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _popWithResult();
      },
      child: ApiFeatureShell(
        popToApiMainCount: 2,
        feature: ApiFeature.faceMesh,
        title: l10n.faceMeshGroupFacesTitle,
        mainFunctionBody: listState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: _buildListContent(l10n, listState, notifier),
              ),
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

    final items = listState.faceMeshList
        .where((item) => item.faceGroupId == widget.faceGroupId)
        .toList()
      ..sort((a, b) {
        final byIndex = (int.tryParse(a.faceIndex ?? '') ?? a.sn)
            .compareTo(int.tryParse(b.faceIndex ?? '') ?? b.sn);
        if (byIndex != 0) return byIndex;
        return a.sn.compareTo(b.sn);
      });

    if (items.isEmpty) {
      return ServerListEmptyMessage(
        message: l10n.faceMeshEmptyGroupFaces,
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: EgovColor.primary50,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length + 2,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: FaceMeshGroupTrackingPreview(records: items),
            );
          }

          if (index == 1) {
            return Text(
              '${l10n.faceMeshListItemFaceGroupId}: ${widget.faceGroupId}',
              style: EgovText.caption.copyWith(color: EgovColor.gray70),
            );
          }

          final item = items[index - 2];
          return _FaceMeshTile(
            item: item,
            sourceLabel: l10n.faceMeshListItemSource,
            timestampLabel: l10n.faceMeshDetectedAtLabel,
            onOpenDetail: () => _openDetail(item),
          );
        },
      ),
    );
  }
}

class _FaceMeshTile extends StatelessWidget {
  final FaceMeshRecord item;
  final String sourceLabel;
  final String timestampLabel;
  final VoidCallback onOpenDetail;

  const _FaceMeshTile({
    required this.item,
    required this.sourceLabel,
    required this.timestampLabel,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final faceLabel = item.faceIndex != null ? '#${item.faceIndex}' : '-';
    final source = item.source?.isNotEmpty == true ? item.source! : '-';

    return Material(
      color: EgovColor.white100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onOpenDetail,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: EgovColor.gray20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.face_retouching_natural,
                color: EgovColor.gray50,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faceLabel,
                      style: EgovText.medium.copyWith(
                        color: EgovColor.gray90,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '랜드마크: ${item.landmarkCount ?? '-'}'
                      '${(item.hasIris == 'Y') ? ' · iris' : ''}',
                      style: EgovText.caption.copyWith(
                        color: EgovColor.gray70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$sourceLabel : $source',
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
              const Icon(Icons.chevron_right, color: EgovColor.gray40),
            ],
          ),
        ),
      ),
    );
  }
}
