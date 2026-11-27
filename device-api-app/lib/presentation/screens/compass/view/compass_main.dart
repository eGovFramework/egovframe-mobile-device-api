import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/state/compass_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/view/compass_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/view_model/compass_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/view_model/compass_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/widgets/compass_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/widgets/compass_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/widgets/compass_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/widgets/compass_permission_util.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'compass_description.dart';

class CompassPage extends ConsumerStatefulWidget {
  const CompassPage({super.key});

  @override
  ConsumerState<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends ConsumerState<CompassPage>
    with WidgetsBindingObserver {
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensurePermissionAndStart();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  CompassMain get _notifier => ref.read(compassMainProvider.notifier);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _notifier.handleAppLifecyclePaused();
      case AppLifecycleState.resumed:
        if (!_permissionDenied) {
          _notifier.handleAppLifecycleResumed();
        }
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> _ensurePermissionAndStart() async {
    final l10n = AppLocalizations.of(context)!;
    final granted = await CompassPermissionUtil.ensureLocationPermission();
    if (!mounted) return;

    if (!granted) {
      _permissionDenied = true;
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.compassPermissionDenied,
      );
      return;
    }

    _permissionDenied = false;
    await _notifier.startWatching();
  }

  Future<void> _handleLoadError(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'CompassPage.loadError',
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
      onRetry: () => _ensurePermissionAndStart(),
      retryText: l10n.commonRetry,
    );
  }

  Future<void> _uploadCompassInfo() async {
    final l10n = AppLocalizations.of(context)!;

    if (_notifier.buildUploadInfo() == null) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.compassNoHeadingData,
      );
      return;
    }

    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.compassSaveTitle,
      message: l10n.compassSaveConfirm,
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
              Text(l10n.compassUploading),
            ],
          ),
        );
      },
    );

    final result = await _notifier.uploadCompassInfo();

    if (!mounted) return;
    Navigator.of(context).pop();

    switch (result) {
      case CompassUploadSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.compassSaveSuccess,
        );
      case CompassUploadFailure(:final message):
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
      MaterialPageRoute(builder: (context) => const CompassListPage()),
    );
  }

  Widget _buildMainFunctionBody(CompassMainState mainState) {
    if (mainState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          if (!_permissionDenied) _ensurePermissionAndStart(),
          ref.read(compassConnectionStatusProvider.notifier).refresh(),
        ]);
      },
      color: EgovColor.primary50,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: CompassOverview(
          heading: mainState.heading,
          isWatching: mainState.isWatching,
          footer: const CompassConnectionBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(compassMainProvider);

    ref.listen<CompassMainState>(compassMainProvider, (previous, next) {
      final error = next.loadError;
      if (error != null && error != previous?.loadError) {
        Future.microtask(() async {
          if (!mounted) return;
          await _handleLoadError(error);
        });
      }
    });

    return FeatureShell(
      currentAppTargetPage: 'compass',
      title: l10n.compassApiTitle,
      guidePage: const CompassFunctionPage(),
      mainFunctionBody: _buildMainFunctionBody(mainState),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.compassListButton,
            onServerConnected: _navigateToList,
            resolveConnection: CompassConnectionResolver.resolveConnection,
          ),
          ServerConnectionButtonFactory.uploadButton(
            text: l10n.compassSaveButton,
            onServerConnected: _uploadCompassInfo,
            resolveConnection: CompassConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }
}
