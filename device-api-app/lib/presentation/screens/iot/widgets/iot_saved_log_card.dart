import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

class IotSavedLogCard extends StatelessWidget {
  final IotMessageInfo info;

  const IotSavedLogCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isIncoming = info.direction == 'incoming';
    final directionLabel =
        isIncoming ? l10n.iotLogIncoming : l10n.iotLogOutgoing;
    final typeLabel = info.messageType == 'command'
        ? l10n.iotMessageTypeCommand
        : l10n.iotMessageTypeTelemetry;
    final directionColor =
        isIncoming ? EgovColor.primary50 : EgovColor.secondary50;
    final payloadPreview = info.payload.length > 80
        ? '${info.payload.substring(0, 80)}...'
        : info.payload;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: EgovColor.white100,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: EgovColor.gray20),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$directionLabel · $typeLabel',
            style: TextStyle(
              color: directionColor,
              fontSize: 19,
              fontFamily: 'Pretendard GOV',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            info.topic,
            style: EgovText.regular.copyWith(
              color: EgovColor.gray70,
              fontSize: 15,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            payloadPreview,
            style: EgovText.caption.copyWith(
              color: EgovColor.gray90,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.iotTimestampLabel}: ${info.timestamp}',
            style: EgovText.caption.copyWith(color: EgovColor.gray50),
          ),
        ],
      ),
    );
  }
}
