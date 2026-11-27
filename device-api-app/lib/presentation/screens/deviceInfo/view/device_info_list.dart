import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/state/device_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/view_model/device_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/widgets/device_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_info_detailed.dart';

class DeviceListPage extends ConsumerStatefulWidget {
  final String uuid;

  const DeviceListPage({super.key, required this.uuid});

  @override
  ConsumerState<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends ConsumerState<DeviceListPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(deviceListProvider(widget.uuid));
    final notifier = ref.read(deviceListProvider(widget.uuid).notifier);

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.deviceInfo,
      title: l10n.deviceInfoApiTitle,
      mainFunctionBody: listState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _buildListContent(l10n, listState, notifier),
            ),
    );
  }

  Widget _buildListContent(
    AppLocalizations l10n,
    DeviceListState listState,
    DeviceList notifier,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: notifier.reload,
      );
    }

    if (listState.deviceList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.deviceInfoEmptyList);
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      child: ListView.builder(
        itemCount: listState.deviceList.length,
        itemBuilder: (context, index) {
          final device = listState.deviceList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceDetailedPage(device: device),
                    ),
                  );

                  if (result == true) {
                    await notifier.reload();
                  }
                },
                child: DeviceCard(
                  title: device.uuid.length > 25
                      ? '${device.uuid.substring(0, 25)}...'
                      : device.uuid,
                  subtitle: l10n.deviceInfoNetworkConnectionType(
                    device.ntwrkDeviceInfo,
                  ),
                  detailLabel: l10n.deviceInfoLabelOs,
                  detailValue: device.os,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
