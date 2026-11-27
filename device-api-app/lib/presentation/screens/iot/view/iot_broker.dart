import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/state/iot_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view_model/iot_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/widgets/iot_broker_form.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IotBrokerPage extends ConsumerStatefulWidget {
  const IotBrokerPage({super.key});

  @override
  ConsumerState<IotBrokerPage> createState() => _IotBrokerPageState();
}

class _IotBrokerPageState extends ConsumerState<IotBrokerPage> {
  IotMain get _notifier => ref.read(iotMainProvider.notifier);

  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _deviceIdController = TextEditingController();
  bool _userEdited = false;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _deviceIdController.dispose();
    super.dispose();
  }

  void _syncControllers(IotMainState state) {
    if (_userEdited || state.isLoading) return;
    final config = state.config;
    if (_hostController.text == config.host &&
        _portController.text == '${config.port}' &&
        _usernameController.text == config.username &&
        _passwordController.text == config.password &&
        _deviceIdController.text == config.deviceId) {
      return;
    }
    _hostController.text = config.host;
    _portController.text = '${config.port}';
    _usernameController.text = config.username;
    _passwordController.text = config.password;
    _deviceIdController.text = config.deviceId;
  }

  void _editHost(String value) {
    _userEdited = true;
    _notifier.updateHost(value);
  }

  void _editPort(String value) {
    _userEdited = true;
    _notifier.updatePort(value);
  }

  void _editUsername(String value) {
    _userEdited = true;
    _notifier.updateUsername(value);
  }

  void _editPassword(String value) {
    _userEdited = true;
    _notifier.updatePassword(value);
  }

  void _editDeviceId(String value) {
    _userEdited = true;
    _notifier.updateDeviceId(value);
  }

  Future<void> _handleLoadError(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'IotBrokerPage.loadError',
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
      onRetry: () => _connectAndReturn(),
      retryText: l10n.commonRetry,
    );
  }

  Future<void> _connectAndReturn() async {
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
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _disconnect() async {
    await _notifier.disconnect();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    await showStatusToast(
      context,
      variant: StatusVariant.success,
      title: l10n.commonSuccess,
      message: l10n.iotDisconnected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(iotMainProvider);
    _syncControllers(mainState);

    ref.listen<IotMainState>(iotMainProvider, (previous, next) {
      final error = next.loadError;
      if (error != null && error != previous?.loadError) {
        Future.microtask(() async {
          if (!mounted) return;
          await _handleLoadError(error);
        });
      }
    });

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.iot,
      title: l10n.iotApiTitle,
      mainFunctionBody: mainState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: IotBrokerForm(
                mainState: mainState,
                hostController: _hostController,
                portController: _portController,
                usernameController: _usernameController,
                passwordController: _passwordController,
                deviceIdController: _deviceIdController,
                onHostChanged: _editHost,
                onPortChanged: _editPort,
                onUsernameChanged: _editUsername,
                onPasswordChanged: _editPassword,
                onDeviceIdChanged: _editDeviceId,
                onConnect: _connectAndReturn,
                onDisconnect: _disconnect,
              ),
            ),
    );
  }
}
