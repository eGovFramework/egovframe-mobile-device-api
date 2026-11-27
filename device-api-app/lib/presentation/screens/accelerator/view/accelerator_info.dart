import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/view_model/accelerator_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/view_model/accelerator_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/view/accelerator_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/state/accelerator_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/widgets/accelerator_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/widgets/accelerator_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/widgets/accelerator_widget.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/widgets/three_d_cube.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcceleratorInfoPage extends ConsumerStatefulWidget {
  const AcceleratorInfoPage({super.key});

  @override
  ConsumerState<AcceleratorInfoPage> createState() =>
      _AcceleratorInfoPageState();
}

class _AcceleratorInfoPageState extends ConsumerState<AcceleratorInfoPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AcceleratorMain get _notifier => ref.read(acceleratorMainProvider.notifier);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _notifier.handleAppLifecyclePaused();
      case AppLifecycleState.resumed:
        _notifier.handleAppLifecycleResumed();
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.acceleratorRegisterTitle,
      message: l10n.acceleratorRegisterMessage,
    );
    if (!confirmed || !mounted) return;

    final result = await _notifier.saveCurrentReading();
    if (!mounted) return;

    switch (result) {
      case AcceleratorSaveSuccess(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: resolveAppMessage(l10n, message),
        );
      case AcceleratorSaveFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  void _navigateToList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AcceleratorListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accelState = ref.watch(acceleratorMainProvider);

    return ApiFeatureShell(
      feature: ApiFeature.accelerator,
      title: l10n.acceleratorApiTitle,
      mainFunctionBody: _buildMainFunctionTab(accelState),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.acceleratorListButton,
            onServerConnected: () async => _navigateToList(),
            resolveConnection: AcceleratorConnectionResolver.resolveConnection,
          ),
          ServerConnectionButtonFactory.uploadButton(
            text: l10n.acceleratorSaveButton,
            onServerConnected: () async => _handleSave(),
            resolveConnection: AcceleratorConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }

  Widget _buildMainFunctionTab(AcceleratorMainState accelState) {
    return accelState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(acceleratorConnectionStatusProvider.notifier)
                  .refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ThreeDCube(
                      xAxis: accelState.xAxis,
                      yAxis: accelState.yAxis,
                      zAxis: accelState.zAxis,
                    ),
                    const SizedBox(height: 30),
                    AccelerationDisplay(
                      xAxis: accelState.xAxis,
                      yAxis: accelState.yAxis,
                      zAxis: accelState.zAxis,
                      timestamp: accelState.timestamp,
                    ),
                    const SizedBox(height: 30),
                    const AcceleratorConnectionBar(),
                  ],
                ),
              ),
            ),
          );
  }
}
