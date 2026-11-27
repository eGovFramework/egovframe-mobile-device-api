import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view/iot_saved_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view_model/iot_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/widgets/iot_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/widgets/iot_log_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IotListPage extends ConsumerStatefulWidget {
  const IotListPage({super.key});

  @override
  ConsumerState<IotListPage> createState() => _IotListPageState();
}

class _IotListPageState extends ConsumerState<IotListPage> {
  Future<void> _openSavedList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IotSavedListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(iotMainProvider);
    final logs = mainState.logs;

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.iot,
      title: l10n.iotApiTitle,
      mainFunctionBody: Padding(
        padding: const EdgeInsets.all(16),
        child: logs.isEmpty
            ? ServerListEmptyMessage(message: l10n.iotLogEmpty)
            : ListView.separated(
                itemCount: logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return IotLogCard(log: logs[index]);
                },
              ),
      ),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButton(
            text: l10n.iotSavedListButton,
            onServerConnected: _openSavedList,
            resolveConnection: IotConnectionResolver.resolveConnection,
            icon: const Icon(Icons.list_alt, color: EgovColor.white100, size: 20),
          ),
        ],
      ),
    );
  }
}
