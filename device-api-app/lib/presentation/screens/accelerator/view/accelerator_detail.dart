import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/view_model/accelerator_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcceleratorDetailPage extends ConsumerStatefulWidget {
  final AcceleratorInfo acceleratorInfo;

  const AcceleratorDetailPage({super.key, required this.acceleratorInfo});

  @override
  ConsumerState<AcceleratorDetailPage> createState() =>
      _AcceleratorDetailPageState();
}

class _AcceleratorDetailPageState extends ConsumerState<AcceleratorDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(acceleratorDetailProvider(widget.acceleratorInfo.sn).notifier)
          .initialize(widget.acceleratorInfo);
    });
  }

  Future<void> _confirmAndDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.acceleratorDeleteTitle,
      message: l10n.acceleratorDeleteConfirm,
    );
    if (!confirmed) return;

    await _deleteAccelerator();
  }

  Future<void> _deleteAccelerator() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(acceleratorDetailProvider(widget.acceleratorInfo.sn).notifier)
        .deleteAccelerator();

    if (!mounted) return;

    switch (result) {
      case AcceleratorDeleteSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.acceleratorDeleteSuccess,
        );
        if (mounted) {
          Navigator.pop(context, true);
        }
      case AcceleratorDeleteFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  List<Map<String, String>> _buildDetailTableData(
    AppLocalizations l10n,
    AcceleratorInfo info,
  ) {
    return [
      {'label': l10n.commonSn, 'value': '${info.sn}'},
      {'label': l10n.commonUuidLabel, 'value': info.uuid},
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
      {
        'label': l10n.acceleratorSavedAt,
        'value': FormatUtils.formatTimestampToDate(int.parse(info.timestamp)),
      },
      {
        'label': l10n.acceleratorUseYn,
        'value': info.useYn == 'Y' ? l10n.commonUseYnY : l10n.commonUseYnN,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detailState = ref.watch(
      acceleratorDetailProvider(widget.acceleratorInfo.sn),
    );
    final info = detailState.acceleratorInfo ?? widget.acceleratorInfo;

    return ApiFeatureShell(
      popToApiMainCount: 2,
      feature: ApiFeature.accelerator,
      title: l10n.acceleratorDetailTitle,
      mainFunctionBody: detailState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoBox(text: l10n.acceleratorDetailInfo),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: CommonTable(
                        title: l10n.acceleratorDetailTableTitle,
                        data: _buildDetailTableData(l10n, info),
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
            onTap: (detailState.isLoading || detailState.isDeleting)
                ? null
                : _confirmAndDelete,
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
