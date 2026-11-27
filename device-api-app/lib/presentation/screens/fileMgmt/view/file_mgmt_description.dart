import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

class FileFunctionPage extends StatelessWidget {
  const FileFunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final featureItems = <(String, String)>[
      (l10n.fileMgmtGuideFeatureExploreTitle, l10n.fileMgmtGuideFeatureExploreContent),
      (l10n.fileMgmtGuideFeatureCreateTitle, l10n.fileMgmtGuideFeatureCreateContent),
      (l10n.fileMgmtGuideFeatureEditTitle, l10n.fileMgmtGuideFeatureEditContent),
      (l10n.fileMgmtGuideFeatureInfoTitle, l10n.fileMgmtGuideFeatureInfoContent),
    ];
    final usageSteps = [
      l10n.fileMgmtGuideUsage1,
      l10n.fileMgmtGuideUsage2,
      l10n.fileMgmtGuideUsage3,
      l10n.fileMgmtGuideUsage4,
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GuideIntro(
              title: l10n.fileMgmtFeatureTitle,
              content: l10n.fileMgmtGuideOverview,
            ),
            const SizedBox(height: 24),
            _GuideSectionHeader(title: l10n.featureGuideUsageTitle),
            const SizedBox(height: 12),
            _GuideUsageCard(steps: usageSteps),
            const SizedBox(height: 24),
            _GuideSectionHeader(title: l10n.featureGuideFeatureTitle),
            const SizedBox(height: 12),
            for (final (title, content) in featureItems)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GuideFeatureCard(title: title, content: content),
              ),
            const SizedBox(height: 12),
            _GuideSectionHeader(title: l10n.fileMgmtGuideNoteTitle),
            const SizedBox(height: 12),
            _GuideTextCard(content: l10n.fileMgmtGuideNote),
          ],
        ),
      ),
    );
  }
}

class _GuideIntro extends StatelessWidget {
  final String title;
  final String content;

  const _GuideIntro({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: EgovText.title.copyWith(color: EgovColor.gray90)),
        const SizedBox(height: 8),
        Text(
          content,
          style: EgovText.regular.copyWith(color: EgovColor.gray70, height: 1.5),
        ),
      ],
    );
  }
}

class _GuideSectionHeader extends StatelessWidget {
  final String title;

  const _GuideSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: EgovColor.primary50,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: EgovText.subtitle.copyWith(color: EgovColor.gray90)),
      ],
    );
  }
}

class _GuideUsageCard extends StatelessWidget {
  final List<String> steps;

  const _GuideUsageCard({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _UsageStepLine(stepNumber: '${i + 1}', text: steps[i]),
          ],
        ],
      ),
    );
  }
}

class _UsageStepLine extends StatelessWidget {
  final String stepNumber;
  final String text;

  const _UsageStepLine({required this.stepNumber, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: EgovColor.primary50,
            shape: BoxShape.circle,
          ),
          child: Text(
            stepNumber,
            style: EgovText.captionBold.copyWith(
              color: EgovColor.white100,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: EgovText.regular.copyWith(color: EgovColor.gray70, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _GuideFeatureCard extends StatelessWidget {
  final String title;
  final String content;

  const _GuideFeatureCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EgovColor.white100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EgovColor.gray20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: EgovText.medium.copyWith(
              fontWeight: FontWeight.w700,
              color: EgovColor.primary50,
            ),
          ),
          const SizedBox(height: 8),
          Text(content, style: EgovText.caption.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}

class _GuideTextCard extends StatelessWidget {
  final String content;

  const _GuideTextCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EgovColor.gray5,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EgovColor.gray20),
      ),
      child: Text(
        content,
        style: EgovText.regular.copyWith(color: EgovColor.gray70, height: 1.6),
      ),
    );
  }
}
