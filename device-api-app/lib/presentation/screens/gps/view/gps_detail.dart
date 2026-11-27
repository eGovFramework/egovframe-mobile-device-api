import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:flutter/material.dart';

class GpsDetailPage extends StatefulWidget {
  final GpsInfo gpsInfo;

  const GpsDetailPage({super.key, required this.gpsInfo});

  @override
  State<GpsDetailPage> createState() => _GpsDetailPageState();
}

class _GpsDetailPageState extends State<GpsDetailPage> {
  bool isLoading = false;

  /// Timestamp를 로컬 시간으로 포맷
  String _formatTimestamp(DateTime timestamp) {
    // UTC 시간인 경우 로컬 시간으로 변환
    final localTime = timestamp.isUtc
        ? timestamp.toLocal()
        : timestamp.add(Duration(hours: 9));
    return '${localTime.year}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')} ${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}:${localTime.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ApiFeatureShell(
      popToApiMainCount: 2,
      feature: ApiFeature.gps,
      title: l10n.gpsDetailTitle,
      mainFunctionBody: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoBox(text: l10n.gpsDetailInfo),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          CommonTable(
                            title: l10n.gpsDetailTableTitle,
                            data: [
                              {
                                'label': l10n.commonUuidLabel,
                                'value': widget.gpsInfo.uuid,
                              },
                              {
                                'label': l10n.gpsLatitudeLabel,
                                'value': widget.gpsInfo.latitude
                                    .toStringAsFixed(6),
                              },
                              {
                                'label': l10n.gpsLongitudeLabel,
                                'value': widget.gpsInfo.longitude
                                    .toStringAsFixed(6),
                              },
                              {
                                'label': l10n.gpsAccuracyLabel,
                                'value':
                                    widget.gpsInfo.accrcy?.toStringAsFixed(2) ??
                                    l10n.commonNotAvailable,
                              },
                              {
                                'label': l10n.commonTimestampLabel,
                                'value': _formatTimestamp(
                                  widget.gpsInfo.timestamp,
                                ),
                              },
                            ],
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
}
