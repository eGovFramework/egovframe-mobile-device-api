import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/state/iot_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view/iot_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view_model/iot_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/widgets/iot_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view_model/iot_connection_status_controller.dart';

class IotPage extends ConsumerStatefulWidget {
  const IotPage({super.key});

  @override
  ConsumerState<IotPage> createState() => _IotPageState();
}

class _IotPageState extends ConsumerState<IotPage> {
  IotMain get _notifier => ref.read(iotMainProvider.notifier);

  Future<void> _handlePublishResult(IotPublishResult result) async {
    final l10n = AppLocalizations.of(context)!;
    switch (result) {
      case IotPublishSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.iotPublishSuccess,
        );
      case IotPublishFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  Future<void> _handleMqttLoadError(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'IotPage.mqttConnect',
    );

    final errorType = ErrorHandler.detectErrorType(localizedMessage);
    final errorMessage = ErrorHandler.getErrorMessage(
      localizedMessage,
      errorType,
    );

    await ErrorHandler.showErrorDialog(
      context,
      errorMessage,
      title: l10n.commonError,
      onRetry: _toggleMqtt,
      retryText: l10n.commonRetry,
    );
  }

  Future<void> _toggleMqtt() async {
    final wasConnected = ref.read(iotMainProvider).isConnected;
    if (wasConnected) {
      await _notifier.disconnect();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      await showStatusToast(
        context,
        variant: StatusVariant.success,
        title: l10n.commonSuccess,
        message: l10n.iotDisconnected,
      );
      return;
    }

    await _notifier.connect();
    if (!mounted) return;
    final state = ref.read(iotMainProvider);
    if (state.isConnected && state.loadError == null) {
      final l10n = AppLocalizations.of(context)!;
      await showStatusToast(
        context,
        variant: StatusVariant.success,
        title: l10n.commonSuccess,
        message: l10n.iotConnected,
      );
    } else if (state.loadError != null) {
      await _handleMqttLoadError(state.loadError!);
    }
  }

  Future<void> _openLogList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IotListPage()),
    );
  }

  Widget _buildMainFunctionBody(IotMainState mainState) {
    if (mainState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          IotOverview(
            mainState: mainState,
            onSendCommand: () async {
              final result = await _notifier.sendPowerCommand();
              if (!mounted) return;
              await _handlePublishResult(result);
            },
            onToggleMqtt: _toggleMqtt,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(iotMainProvider);

    return ApiFeatureShell(
      feature: ApiFeature.iot,
      title: l10n.iotApiTitle,
      mainFunctionBody: RefreshIndicator(
        onRefresh: () async {
          await ref.read(iotConnectionStatusProvider.notifier).refresh();
        },
        color: EgovColor.primary50,
        child: _buildMainFunctionBody(mainState),
      ),
      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.iotLogListButton,
            onTap: _openLogList,
            icon: const Icon(Icons.list, color: EgovColor.white100, size: 20),
          ),
        ],
      ),
    );
  }
}
