import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

/// Compass 기능설명 탭
class CompassFunctionPage extends StatelessWidget {
  const CompassFunctionPage({super.key});

  static const _featureItems = <(String, String)>[
    ('나침반 정보 조회', 'flutter_compass 패키지로 방위각(0~360°)을 실시간 조회하고 나침반 UI로 표시'),
    ('나침반 정보 저장', '조회된 정보를 COMPASS 테이블(sn, uuid, drc, accrcy, useYn, timestamp)에 저장'),
    ('나침반 정보 목록', '서버 MySQL 또는 로컬 SQLite compass 테이블 목록 조회'),
    ('나침반 정보 삭제', '목록에서 항목을 선택한 뒤 서버/SQLite의 해당 나침반 기록 삭제'),
    ('SQLite 연동', 'MySQL COMPASS와 동일 스키마의 compass 테이블로 로컬 CRUD'),
  ];

  static const _usageSteps = [
    "'주요기능' 탭에서 '나침반 조회' 버튼을 눌러 실시간 방위각을 확인합니다.",
    '나침반 다이얼이 디바이스 방향에 따라 회전합니다.',
    "'정보 저장' 버튼으로 현재 나침반 정보를 서버에 전송합니다.",
    "'정보 목록' 버튼으로 서버에 저장된 나침반 기록을 확인하고, 목록에서 항목을 선택해 삭제할 수 있습니다.",
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GuideIntro(
              title: l10n.compassTitle,
              content: l10n.compassGuideOverview,
            ),
            const SizedBox(height: 24),
            _GuideSectionHeader(title: l10n.featureGuideUsageTitle),
            const SizedBox(height: 12),
            const _GuideUsageCard(steps: _usageSteps),
            const SizedBox(height: 24),
            _GuideSectionHeader(title: l10n.featureGuideFeatureTitle),
            const SizedBox(height: 12),
            for (final (title, content) in _featureItems)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GuideFeatureCard(title: title, content: content),
              ),
            const SizedBox(height: 12),
            _GuideSectionHeader(title: l10n.commonGuideSqliteNoteTitle),
            const SizedBox(height: 12),
            _GuideTextCard(content: l10n.compassGuideSqliteNote),
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
          style: EgovText.regular.copyWith(
            color: EgovColor.gray70,
            height: 1.5,
          ),
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
