import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Google Maps API 키 미설정 시 표시하는 대체 지도 영역
class GpsMapFallback extends StatelessWidget {
  final Position? position;

  const GpsMapFallback({super.key, this.position});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: EgovColor.gray5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EgovColor.gray20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 40, color: EgovColor.gray40),
                  const SizedBox(height: 8),
                  Text(
                    l10n.gpsMapApiNotConfiguredTitle,
                    style: EgovText.title.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.gpsMapApiNotConfiguredMessage,
                    style: EgovText.caption.copyWith(color: EgovColor.gray60),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
