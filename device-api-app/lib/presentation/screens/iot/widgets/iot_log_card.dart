import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';
import 'package:flutter/material.dart';

class IotLogCard extends StatelessWidget {
  final IotMessageLog log;

  const IotLogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isIncoming = log.direction == IotMessageDirection.incoming;
    final directionLabel =
        isIncoming ? l10n.iotLogIncoming : l10n.iotLogOutgoing;
    final typeLabel = log.messageType == IotMessageType.telemetry
        ? l10n.iotMessageTypeTelemetry
        : l10n.iotMessageTypeCommand;
    final directionColor =
        isIncoming ? EgovColor.primary50 : EgovColor.secondary50;

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
          Row(
            children: [
              Expanded(
                child: Text(
                  '$directionLabel · $typeLabel',
                  style: TextStyle(
                    color: directionColor,
                    fontSize: 19,
                    fontFamily: 'Pretendard GOV',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
              ),
              if (log.isSynced)
                Text(
                  l10n.iotLogSynced,
                  style: EgovText.captionBold.copyWith(
                    color: EgovColor.primary50,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            log.topic,
            style: EgovText.regular.copyWith(
              color: EgovColor.gray70,
              fontSize: 15,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            log.payload,
            style: EgovText.caption.copyWith(
              color: EgovColor.gray90,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            KstDateTimeUtil.format(log.at),
            style: EgovText.caption.copyWith(color: EgovColor.gray50),
          ),
        ],
      ),
    );
  }
}
