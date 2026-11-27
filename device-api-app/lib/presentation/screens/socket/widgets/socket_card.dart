import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

class SocketCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String detailLabel;
  final String detailValue;

  const SocketCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detailLabel,
    required this.detailValue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            title,
            style: const TextStyle(
              color: EgovColor.gray90,
              fontSize: 19,
              fontFamily: 'Pretendard GOV',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: EgovText.regular.copyWith(
              color: EgovColor.gray70,
              fontSize: 15,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.commonLabelSuffix(detailLabel),
                style: EgovText.captionBold.copyWith(height: 1.50),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  detailValue,
                  style: EgovText.caption.copyWith(
                    color: EgovColor.gray90,
                    height: 1.50,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
