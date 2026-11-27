import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

class StreamingOverview extends StatelessWidget {
  final Widget? footer;

  const StreamingOverview({super.key, this.footer});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoBox(text: l10n.streamingMainIntro),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: EgovColor.primary5,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: EgovColor.primary20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.featureGuideFeatureTitle,
                style: EgovText.subtitle.copyWith(color: EgovColor.gray90),
              ),
              const SizedBox(height: 8),
              _GuideBullet(text: l10n.streamingGuideFeatureList),
              const SizedBox(height: 4),
              _GuideBullet(text: l10n.streamingGuideFeaturePlay),
              const SizedBox(height: 4),
              _GuideBullet(text: l10n.streamingGuideFeatureCount),
            ],
          ),
        ),
        if (footer != null) ...[
          const SizedBox(height: 16),
          footer!,
        ],
      ],
    );
  }
}

class _GuideBullet extends StatelessWidget {
  final String text;

  const _GuideBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: EgovColor.gray70)),
        Expanded(
          child: Text(
            text,
            style: EgovText.regular.copyWith(
              color: EgovColor.gray70,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
