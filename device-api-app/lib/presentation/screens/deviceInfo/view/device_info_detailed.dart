import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/view_model/device_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceDetailedPage extends ConsumerStatefulWidget {
  final DeviceInfo device;

  const DeviceDetailedPage({super.key, required this.device});

  @override
  ConsumerState<DeviceDetailedPage> createState() => _DeviceDetailedPageState();
}

class _DeviceDetailedPageState extends ConsumerState<DeviceDetailedPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(deviceDetailProvider(widget.device.sn).notifier)
          .initialize(widget.device);
    });
  }

  Future<void> _confirmAndDeleteDevice() async {
    final l10n = AppLocalizations.of(context)!;
    final bool confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.deviceInfoDeleteTitle,
      message: l10n.deviceInfoDeleteConfirm,
    );
    if (!confirmed) return;

    await _deleteDevice();
  }

  Future<void> _deleteDevice() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(deviceDetailProvider(widget.device.sn).notifier)
        .deleteDevice();

    if (!mounted) return;

    switch (result) {
      case DeviceDeleteSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.deviceInfoDeleteSuccess,
        );
        if (mounted) {
          Navigator.pop(context, true);
        }
      case DeviceDeleteFailure(:final message):
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
    DeviceInfo deviceInfo,
  ) {
    return [
      {'label': l10n.deviceInfoSerialNumber, 'value': '${deviceInfo.sn}'},
      {'label': l10n.deviceInfoUuid, 'value': deviceInfo.uuid},
      {'label': l10n.deviceInfoOperatingSystem, 'value': deviceInfo.os},
      {
        'label': l10n.deviceInfoNetworkInfo,
        'value': deviceInfo.ntwrkDeviceInfo,
      },
      {'label': l10n.deviceInfoProgramVersion, 'value': deviceInfo.pgVer},
      {'label': l10n.deviceInfoDeviceName, 'value': deviceInfo.deviceNm},
      {
        'label': l10n.deviceInfoUseStatus,
        'value': deviceInfo.useYn == 'Y'
            ? l10n.deviceInfoInUse
            : l10n.deviceInfoNotInUse,
      },
      if (deviceInfo.telno != null)
        {'label': l10n.deviceInfoContactCount, 'value': deviceInfo.telno!},
      if (deviceInfo.strgeInfo != 0)
        {
          'label': l10n.deviceInfoStorageInfo,
          'value': FormatUtils.formatFileSize(deviceInfo.strgeInfo),
        },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detailState = ref.watch(deviceDetailProvider(widget.device.sn));
    final detailNotifier = ref.read(
      deviceDetailProvider(widget.device.sn).notifier,
    );
    final deviceInfo = detailState.deviceInfo;

    return ApiFeatureShell(
      popToApiMainCount: 2,
      feature: ApiFeature.deviceInfo,
      title: l10n.deviceInfoDetailTitle,
      mainFunctionBody: detailState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : detailState.errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      size: 64,
                      color: EgovColor.danger50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      resolveAppMessage(l10n, detailState.errorMessage!),
                      style: EgovText.regular.copyWith(
                        color: EgovColor.danger50,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: detailNotifier.loadDetail,
                      child: Text(l10n.commonRetry),
                    ),
                  ],
                ),
              ),
            )
          : deviceInfo == null
          ? Center(
              child: Text(
                l10n.deviceInfoCannotLoad,
                style: EgovText.regular.copyWith(color: EgovColor.gray40),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: CommonTable(
                title: l10n.deviceInfoDeviceDetailTitle,
                data: _buildDetailTableData(l10n, deviceInfo),
              ),
            ),
      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.commonDelete,
            onTap: (detailState.isLoading || detailState.isDeleting)
                ? null
                : _confirmAndDeleteDevice,
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
          ),
        ],
      ),
    );
  }
}
