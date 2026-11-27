import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/view_model/network_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/view/network_detail.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/state/network_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkListScreen extends ConsumerStatefulWidget {
  const NetworkListScreen({super.key});

  @override
  ConsumerState<NetworkListScreen> createState() => _NetworkListScreenState();
}

class _NetworkListScreenState extends ConsumerState<NetworkListScreen> {
  NetworkList get _notifier => ref.read(networkListProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(networkListProvider);

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.network,
      title: l10n.networkApiTitle,
      mainFunctionBody: _buildMainFunctionTab(l10n, listState),
    );
  }

  Widget _buildMainFunctionTab(
    AppLocalizations l10n,
    NetworkListState listState,
  ) {
    return listState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: _buildListContent(l10n, listState),
          );
  }

  Widget _buildListContent(AppLocalizations l10n, NetworkListState listState) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: _notifier.reload,
      );
    }
    if (listState.networkInfoList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.networkEmptyList);
    }
    return RefreshIndicator(
      onRefresh: _notifier.reload,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: listState.networkInfoList.length,
        itemBuilder: (context, index) {
          final networkInfo = listState.networkInfoList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildNetworkInfoCard(l10n, networkInfo),
          );
        },
      ),
    );
  }

  Widget _buildNetworkInfoCard(AppLocalizations l10n, NetworkInfo networkInfo) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NetworkDetailPage(networkInfo: networkInfo),
          ),
        );

        if (result == true) {
          await _notifier.reload();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: EgovColor.white100,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: EgovColor.gray20),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            networkInfo.networkTypeName,
                            style: const TextStyle(
                              color: EgovColor.gray90,
                              fontSize: 19,
                              fontFamily: 'Pretendard GOV',
                              fontWeight: FontWeight.w700,
                              height: 1.50,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: EgovColor.gray40,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(l10n.commonSn, networkInfo.sn ?? ''),
                    _buildDetailRow(
                      l10n.networkDeviceIdLabel,
                      networkInfo.deviceId,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label :',
            style: const TextStyle(
              color: Color(0xFF1E2124),
              fontSize: 13,
              fontFamily: 'Pretendard GOV',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1E2124),
                fontSize: 13,
                fontFamily: 'Pretendard GOV',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
