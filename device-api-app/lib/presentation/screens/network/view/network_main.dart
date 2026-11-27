import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/view_model/network_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/view_model/network_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/view/network_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/state/network_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/widgets/network_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/widgets/network_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkScreen extends ConsumerStatefulWidget {
  const NetworkScreen({super.key});

  @override
  ConsumerState<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends ConsumerState<NetworkScreen> {
  NetworkMain get _notifier => ref.read(networkMainProvider.notifier);

  Future<void> _handleSendNetworkInfo() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.networkRegisterTitle,
      message: l10n.networkRegisterMessage,
    );
    if (!confirmed || !mounted) return;

    final result = await _notifier.sendNetworkInfoToServer();
    if (!mounted) return;

    switch (result) {
      case NetworkSendSuccess(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: resolveAppMessage(l10n, message),
        );
      case NetworkSendFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  void _navigateToNetworkList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NetworkListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final networkState = ref.watch(networkMainProvider);

    return ApiFeatureShell(
      feature: ApiFeature.network,
      title: l10n.networkApiTitle,
      mainFunctionBody: _buildMainFunctionTab(l10n, networkState),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.networkListButton,
            onServerConnected: () async => _navigateToNetworkList(),
            resolveConnection: NetworkConnectionResolver.resolveConnection,
          ),
          ServerConnectionButtonFactory.sendButton(
            text: l10n.networkSendButton,
            onServerConnected: () async => _handleSendNetworkInfo(),
            resolveConnection: NetworkConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }

  Widget _buildMainFunctionTab(
    AppLocalizations l10n,
    NetworkMainState networkState,
  ) {
    return networkState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                _notifier.initialize(),
                ref.read(networkConnectionStatusProvider.notifier).refresh(),
              ]);
            },
            color: EgovColor.primary50,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCurrentNetworkStatus(l10n, networkState),
                  const SizedBox(height: 16),
                  const NetworkConnectionBar(),
                ],
              ),
            ),
          );
  }

  Widget _buildCurrentNetworkStatus(
    AppLocalizations l10n,
    NetworkMainState networkState,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: networkState.isConnected
            ? EgovColor.success5
            : EgovColor.danger5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: networkState.isConnected
              ? EgovColor.success50
              : EgovColor.danger50,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: networkState.isConnected
                      ? EgovColor.success50
                      : EgovColor.danger50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  networkState.isConnected ? Icons.wifi : Icons.wifi_off,
                  color: EgovColor.white100,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.networkCurrentStatus,
                      style: EgovText.captionBold,
                    ),
                    Text(
                      networkState.isConnected
                          ? l10n.networkConnected
                          : l10n.networkDisconnected,
                      style: EgovText.title.copyWith(
                        color: networkState.isConnected
                            ? EgovColor.success60
                            : EgovColor.danger60,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: EgovColor.white100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: EgovColor.gray20),
                ),
                child: Text(
                  resolveAppMessage(l10n, networkState.networkQuality),
                  style: EgovText.caption.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (networkState.currentNetworkInfo != null) ...[
            const SizedBox(height: 16),
            const Divider(color: EgovColor.gray20),
            const SizedBox(height: 16),
            _buildNetworkInfoRow(
              l10n.networkTypeLabel,
              '${NetworkInfo.getNetworkIcon(networkState.currentNetworkInfo!.networkType)} ${networkState.currentNetworkInfo!.networkTypeName}',
            ),
            _buildNetworkInfoRow(
              l10n.networkDeviceLabel,
              networkState.currentNetworkInfo!.deviceName,
            ),
            if (networkState.currentNetworkInfo!.ipAddress != null)
              _buildNetworkInfoRow(
                l10n.networkIpAddressLabel,
                networkState.currentNetworkInfo!.ipAddress!,
              ),
            if (networkState.currentNetworkInfo!.ssid != null)
              _buildNetworkInfoRow(
                l10n.networkWifiSsidLabel,
                networkState.currentNetworkInfo!.ssid!,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildNetworkInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: EgovText.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: EgovText.caption)),
        ],
      ),
    );
  }
}
