import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/state/device_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/view_model/device_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/view_model/device_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/widgets/device_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/widgets/device_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/widgets/device_info_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_info_description.dart';
import 'device_info_list.dart';

class DeviceInfoPage extends ConsumerStatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  ConsumerState<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends ConsumerState<DeviceInfoPage> {
  DeviceInfoMain get _notifier => ref.read(deviceInfoMainProvider.notifier);

  Future<void> _handleLoadError(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'DeviceInfoPage.loadDeviceInfo',
    );

    final errorType = ErrorHandler.detectErrorType(localizedMessage);
    final errorMessage = ErrorHandler.getErrorMessage(
      localizedMessage,
      errorType,
    );

    await ErrorHandler.showErrorDialog(
      context,
      errorMessage,
      title: l10n.deviceInfoLoadFailedTitle,
      onRetry: () => _notifier.loadDeviceInfo(),
      retryText: l10n.commonRetry,
    );
  }

  Future<void> _uploadDeviceInfo() async {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.read(deviceInfoMainProvider);

    if (mainState.deviceInfo == null) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.deviceInfoNoUploadData,
      );
      return;
    }

    final bool confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.deviceInfoServerRegisterTitle,
      message: l10n.deviceInfoServerRegisterMessage,
    );
    if (!confirmed || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(l10n.deviceInfoUploading),
            ],
          ),
        );
      },
    );

    final result = await _notifier.uploadDeviceInfo();

    if (!mounted) return;
    Navigator.of(context).pop();

    switch (result) {
      case DeviceUploadSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.deviceInfoUploadSuccess,
        );
      case DeviceUploadFailure(:final message):
        final localizedMessage = resolveAppMessage(l10n, message);
        ErrorHandler.logError(
          localizedMessage,
          null,
          context: 'DeviceInfoPage._uploadDeviceInfo',
        );
        final errorType = ErrorHandler.detectErrorType(localizedMessage);
        final errorMessage = ErrorHandler.getErrorMessage(
          localizedMessage,
          errorType,
        );
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: errorMessage,
        );
    }
  }

  Future<void> _showErrorDialog(String message) async {
    final l10n = AppLocalizations.of(context)!;
    await showStatusToast(
      context,
      variant: StatusVariant.error,
      title: l10n.commonError,
      message: resolveAppMessage(l10n, message),
    );
  }

  Future<void> _navigateToServerList() async {
    final l10n = AppLocalizations.of(context)!;
    final deviceInfo = ref.read(deviceInfoMainProvider).deviceInfo;

    if (deviceInfo == null) {
      _showErrorDialog(l10n.deviceInfoServerListFirst);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceListPage(uuid: deviceInfo.uuid),
      ),
    );
  }

  Widget _buildMainFunctionBody(
    DeviceInfoMainState mainState,
    DeviceInfo? deviceInfo,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (mainState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          _notifier.loadDeviceInfo(),
          ref.read(deviceConnectionStatusProvider.notifier).refresh(),
        ]);
      },
      color: EgovColor.primary50,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: deviceInfo != null
            ? DeviceInfoOverview(
                deviceInfo: deviceInfo,
                footer: const DeviceConnectionBar(),
              )
            : Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    child: Center(
                      child: Text(
                        l10n.deviceInfoCannotLoad,
                        style:
                            EgovText.regular.copyWith(color: EgovColor.gray40),
                      ),
                    ),
                  ),
                  const DeviceConnectionBar(),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(deviceInfoMainProvider);
    final deviceInfo = mainState.deviceInfo;

    ref.listen<DeviceInfoMainState>(deviceInfoMainProvider, (previous, next) {
      final error = next.loadError;
      if (error != null && error != previous?.loadError) {
        Future.microtask(() async {
          if (!mounted) return;
          await _handleLoadError(error);
        });
      }
    });

    return FeatureShell(
      title: l10n.deviceInfoApiTitle,
      currentAppTargetPage: 'device_info_page',
      guidePage: const DeviceFunctionPage(),
      mainFunctionBody: _buildMainFunctionBody(mainState, deviceInfo),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.deviceInfoServerListButton,
            onServerConnected: () async => _navigateToServerList(),
            resolveConnection: DeviceConnectionResolver.resolveConnection,
          ),
          ServerConnectionButtonFactory.uploadButton(
            text: l10n.deviceInfoUploadButton,
            onServerConnected: () async => _uploadDeviceInfo(),
            resolveConnection: DeviceConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }
}
