import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_heading.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/widgets/compass_dial.dart';
import 'package:flutter/material.dart';

class CompassOverview extends StatelessWidget {
  final CompassHeading heading;
  final bool isWatching;
  final Widget? footer;

  const CompassOverview({
    super.key,
    required this.heading,
    required this.isWatching,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final headingValue = heading.magneticHeading;
    final displayHeading = headingValue?.toStringAsFixed(1) ?? '-';
    final displayAccuracy = heading.headingAccuracy?.isNotEmpty == true
        ? heading.headingAccuracy!
        : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: CompassDial(
            heading: headingValue,
            isActive: isWatching && headingValue != null,
          ),
        ),
        const SizedBox(height: 24),
        _InfoRow(
          label: l10n.compassHeadingLabel,
          value: l10n.compassDegrees(displayHeading),
        ),
        const SizedBox(height: 8),
        _InfoRow(label: l10n.compassAccuracyLabel, value: displayAccuracy),
        if (footer != null) ...[
          const SizedBox(height: 24),
          footer!,
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: EgovColor.gray5,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EgovColor.gray20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: EgovText.medium.copyWith(color: EgovColor.gray70),
          ),
          const Spacer(),
          Text(
            value,
            style: EgovText.medium.copyWith(
              color: EgovColor.primary50,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
