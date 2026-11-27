import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/state/push_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/view/push_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/view_model/push_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/view_model/push_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/widgets/push_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/widgets/push_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/widgets/push_connection_resolver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'push_description.dart';

class PushPage extends ConsumerStatefulWidget {
  const PushPage({super.key});

  @override
  ConsumerState<PushPage> createState() => _PushPageState();
}

class _PushPageState extends ConsumerState<PushPage> {
  PushMain get _notifier => ref.read(pushMainProvider.notifier);

  Future<void> _handleLoadError(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'PushPage.loadError',
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
      onRetry: () => _notifier.retrySetup(),
      retryText: l10n.commonRetry,
    );
  }

  Future<void> _registerPushDevice() async {
    final l10n = AppLocalizations.of(context)!;

    if (_notifier.buildRegisterInfo() == null) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.pushNoDeviceData,
      );
      return;
    }

    final alreadyRegistered = await _notifier.isDeviceAlreadyRegistered();
    if (!mounted) return;
    if (alreadyRegistered) {
      await showInfoAlert(
        context,
        title: l10n.pushSaveTitle,
        message: l10n.pushAlreadyRegistered,
      );
      return;
    }

    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.pushSaveTitle,
      message: l10n.pushSaveConfirm,
    );
    if (!confirmed || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(l10n.pushUploading),
            ],
          ),
        );
      },
    );

    final result = await _notifier.registerPushDevice();

    if (!mounted) return;
    Navigator.of(context).pop();

    switch (result) {
      case PushUploadSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.pushSaveSuccess,
        );
      case PushUploadFailure(:final message):
        final localizedMessage = resolveAppMessage(l10n, message);
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: localizedMessage,
        );
    }
  }

  Future<void> _navigateToList() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PushListPage()),
    );
  }

  Widget _buildMainFunctionBody(PushMainState mainState) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          _notifier.reloadDeviceInfo(),
          ref.read(pushConnectionStatusProvider.notifier).refresh(),
        ]);
      },
      color: EgovColor.primary50,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: PushOverview(
          isLoading: mainState.isLoading,
          isInitialized: mainState.isInitialized,
          permissionDenied: mainState.permissionDenied,
          tokenId: mainState.tokenId,
          onOpenSettings:
              mainState.permissionDenied ? openAppSettings : null,
          footer: const PushConnectionBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(pushMainProvider);

    ref.listen<PushMainState>(pushMainProvider, (previous, next) {
      final error = next.loadError;
      if (error != null &&
          error != previous?.loadError &&
          !next.permissionDenied) {
        Future.microtask(() async {
          if (!mounted) return;
          await _handleLoadError(error);
        });
      }
    });

    return FeatureShell(
      currentAppTargetPage: 'push',
      title: l10n.pushApiTitle,
      guidePage: const PushFunctionPage(),
      mainFunctionBody: _buildMainFunctionBody(mainState),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.pushListButton,
            onServerConnected: _navigateToList,
            resolveConnection: PushConnectionResolver.resolveConnection,
          ),
          ServerConnectionButtonFactory.uploadButton(
            text: l10n.pushSaveButton,
            onServerConnected: _registerPushDevice,
            resolveConnection: PushConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }
}
