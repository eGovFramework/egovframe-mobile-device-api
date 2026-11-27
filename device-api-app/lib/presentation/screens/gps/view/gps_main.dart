import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/view_model/gps_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/view/gps_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/widgets/gps_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/widgets/gps_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/widgets/gps_location_display.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/state/gps_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/widgets/minimal_map_widget.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class GpsMainPage extends ConsumerStatefulWidget {
  const GpsMainPage({super.key});

  @override
  ConsumerState<GpsMainPage> createState() => _GpsMainPageState();
}

class _GpsMainPageState extends ConsumerState<GpsMainPage> {
  final Set<int> _selectedSns = {};

  GpsMain get _notifier => ref.read(gpsMainProvider.notifier);

  Future<void> _handleFetchLocation() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _notifier.fetchCurrentLocation();
    if (!mounted) return;
    switch (result) {
      case GpsLocationPermissionDenied(:final permission):
        if (permission.status == GpsPermissionStatus.permanentlyDenied) {
          await PermissionManager.showPermissionSettingsDialog(
            context,
            l10n.gpsPermissionLocation,
          );
        }
      case GpsLocationFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
      case GpsLocationSuccess():
        break;
    }
  }

  Future<void> _handleSaveLocation() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.gpsSaveTitle,
      message: l10n.gpsSaveConfirm,
    );
    if (!confirmed || !mounted) return;

    final result = await _notifier.saveCurrentLocation();
    if (!mounted) return;

    switch (result) {
      case GpsSaveSuccess(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: resolveAppMessage(l10n, message),
        );
      case GpsSaveFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  Future<void> _handleDeleteSelected() async {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref
        .read(gpsMainProvider)
        .savedGpsList
        .where((item) => item.sn > 0 && _selectedSns.contains(item.sn))
        .toList();

    if (selected.isEmpty) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.gpsNoSelection,
      );
      return;
    }

    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.gpsDeleteSelectedTitle,
      message: l10n.gpsDeleteSelectedConfirm(selected.length),
    );
    if (!confirmed || !mounted) return;

    final result = await _notifier.deleteSelectedItems(selected);
    if (!mounted) return;

    switch (result) {
      case GpsDeleteBatchSuccess():
        setState(_selectedSns.clear);
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.gpsDeleteSelectedSuccess,
        );
        await _notifier.reloadLocalGpsList();
      case GpsDeleteBatchFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  Future<bool> _handleServerUpload() async {
    final l10n = AppLocalizations.of(context)!;
    final gpsState = ref.read(gpsMainProvider);
    if (gpsState.savedGpsList.isEmpty) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.gpsEmptyList,
      );
      return false;
    }

    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.gpsRegisterTitle,
      message: l10n.gpsRegisterConfirm,
    );
    if (!confirmed) return false;

    return _notifier.simulateServerUpload();
  }

  String _formatTimestamp(DateTime timestamp) {
    final localTime = timestamp.isUtc
        ? timestamp.toLocal()
        : timestamp.add(const Duration(hours: 9));
    return '${localTime.year}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')} ${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gpsState = ref.watch(gpsMainProvider);

    return ApiFeatureShell(
      feature: ApiFeature.gps,
      title: l10n.gpsApiTitle,
      mainFunctionBody: _buildMainFunctionTab(l10n, gpsState),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.gpsServerListButton,
            onServerConnected: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GpsListPage()),
              );
            },
            resolveConnection: GpsConnectionResolver.resolveConnection,
          ),
          ServerConnectionButtonFactory.uploadButton(
            text: l10n.gpsSaveButton,
            onServerConnected: _handleSaveLocation,
            resolveConnection: GpsConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }

  Widget _buildMainFunctionTab(AppLocalizations l10n, GpsMainState gpsState) {
    return Column(
      children: [
        Stack(
          children: [
            MinimalMapWidget(
              initialLatitude: gpsState.currentPosition?.latitude,
              initialLongitude: gpsState.currentPosition?.longitude,
              currentPosition: gpsState.currentPosition,
              initialZoom: 15.0,
              onLocationChanged: (Position position) {
                _notifier.updatePositionFromMap(position);
              },
            ),
            if (AppConfig.isGoogleMapsConfigured)
              Positioned(
                right: 12,
                top: 12,
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: gpsState.isLoading ? null : _handleFetchLocation,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: EgovColor.primary50,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: EgovColor.black25,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: gpsState.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: EgovColor.white100,
                                ),
                              )
                            : const Icon(
                                Icons.my_location,
                                color: EgovColor.white100,
                                size: 22,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GpsLocationDisplay(
                    position: gpsState.currentPosition,
                    timestamp: gpsState.currentPosition?.timestamp
                        .add(const Duration(hours: 9))
                        .millisecondsSinceEpoch
                        .toString(),
                  ),
                  const SizedBox(height: 20),
                  if (gpsState.savedGpsList.isNotEmpty) ...[
                    Text(
                      l10n.gpsSavedListTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: EgovColor.white100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DataTable(
                      showCheckboxColumn: true,
                      columns: [
                        DataColumn(label: Text(l10n.gpsLatitudeLabel)),
                        DataColumn(label: Text(l10n.gpsLongitudeLabel)),
                        DataColumn(label: Text(l10n.gpsAccuracyLabel)),
                        DataColumn(label: Text(l10n.gpsAltitudeLabel)),
                        DataColumn(label: Text(l10n.commonTimeLabel)),
                      ],
                      rows: gpsState.savedGpsList.map((gpsInfo) {
                        final selected =
                            gpsInfo.sn > 0 && _selectedSns.contains(gpsInfo.sn);
                        return DataRow(
                          selected: selected,
                          onSelectChanged: gpsInfo.sn <= 0
                              ? null
                              : (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      _selectedSns.add(gpsInfo.sn);
                                    } else {
                                      _selectedSns.remove(gpsInfo.sn);
                                    }
                                  });
                                },
                          cells: [
                            DataCell(Text(gpsInfo.latitude.toStringAsFixed(6))),
                            DataCell(
                              Text(gpsInfo.longitude.toStringAsFixed(6)),
                            ),
                            DataCell(
                              Text(
                                gpsInfo.accrcy?.toStringAsFixed(1) ??
                                    l10n.commonNotAvailable,
                              ),
                            ),
                            DataCell(
                              Text(
                                gpsInfo.altitude?.toStringAsFixed(1) ??
                                    l10n.commonNotAvailable,
                              ),
                            ),
                            DataCell(Text(_formatTimestamp(gpsInfo.timestamp))),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          text: l10n.gpsDeleteSelectedButton,
                          onTap: _handleDeleteSelected,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: EgovColor.white100,
                            size: 20,
                          ),
                          normalColor: EgovColor.point50,
                        ),
                        ServerConnectionButtonFactory.uploadButton(
                          text: l10n.gpsServerUploadButton,
                          onServerConnected: _handleServerUpload,
                          resolveConnection:
                              GpsConnectionResolver.resolveConnection,
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      l10n.gpsEmptyList,
                      style: TextStyle(fontSize: 16, color: EgovColor.black0),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const GpsConnectionBar(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
