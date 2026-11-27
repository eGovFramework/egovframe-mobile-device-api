import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/view_model/network_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkDetailPage extends ConsumerStatefulWidget {
  final NetworkInfo networkInfo;

  const NetworkDetailPage({super.key, required this.networkInfo});

  @override
  ConsumerState<NetworkDetailPage> createState() => _NetworkDetailPageState();
}

class _NetworkDetailPageState extends ConsumerState<NetworkDetailPage> {
  Future<void> _handleDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPromptDialog(
      context,
      title: l10n.networkDeleteTitle,
      message: l10n.networkDeleteConfirm,
      confirmText: l10n.commonDelete,
      cancelText: l10n.commonCancel,
    );
    if (confirmed != true || !mounted) return;

    final result = await ref
        .read(networkDetailProvider(widget.networkInfo).notifier)
        .deleteNetworkInfo();
    if (!mounted) return;

    switch (result) {
      case NetworkDeleteSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.networkDeleteSuccess,
        );
        if (mounted) Navigator.pop(context, true);
      case NetworkDeleteFailure(:final message):
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
    final detailState = ref.watch(networkDetailProvider(widget.networkInfo));
    final networkInfo = detailState.networkInfo;

    return ApiFeatureShell(
      popToApiMainCount: 2,
      feature: ApiFeature.network,
      title: l10n.networkDetailTitle,
      mainFunctionBody: detailState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoBox(text: l10n.networkDetailInfo),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CommonTable(
                            title: l10n.networkDetailTableTitle,
                            data: [
                              {
                                'label': l10n.commonSn,
                                'value':
                                    networkInfo.sn?.toString() ??
                                    l10n.commonNotAvailable,
                              },
                              {
                                'label': l10n.networkDeviceIdLabel,
                                'value': networkInfo.deviceId,
                              },
                              {
                                'label': l10n.networkTypeLabel,
                                'value': networkInfo.networkTypeName,
                              },
                              {
                                'label': l10n.networkDeviceNameLabel,
                                'value': networkInfo.deviceName,
                              },
                              if (networkInfo.ipAddress != null)
                                {
                                  'label': l10n.networkIpAddressLabel,
                                  'value': networkInfo.ipAddress!,
                                },
                              if (networkInfo.macAddress != null)
                                {
                                  'label': l10n.networkMacAddressLabel,
                                  'value': networkInfo.macAddress!,
                                },
                              if (networkInfo.ssid != null)
                                {
                                  'label': l10n.networkSsidLabel,
                                  'value': networkInfo.ssid!,
                                },
                            ],
                          ),
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
            onTap: detailState.isLoading ? null : _handleDelete,
            icon: detailState.isLoading
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
