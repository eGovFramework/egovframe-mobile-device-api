import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

/// Push 기능설명 탭
class PushFunctionPage extends StatelessWidget {
  const PushFunctionPage({super.key});

  static const _featureItems = <(String, String)>[
    (
      'FCM 자동 준비',
      '앱 실행 시 알림 권한을 확인하고 FCM 등록 토큰을 자동 발급합니다.',
    ),
    (
      '푸시 수신',
      '서버 웹(/fcm) 또는 업무 시스템에서 발송한 FCM 푸시를 이 앱에서 수신합니다.',
    ),
    (
      '디바이스 등록',
      'FCM 토큰과 디바이스 정보를 PUSH_DEVICE 테이블에 저장합니다.',
    ),
    (
      '수신 메시지 목록',
      '서버 PUSH_MESSAGE 테이블에서 현재 기기 UUID로 수신한 메시지 이력을 조회합니다.',
    ),
    (
      '등록 디바이스 삭제',
      '서버/SQLite에 저장된 등록 디바이스 목록 전체 초기화',
    ),
    (
      'SQLite 연동',
      'MySQL PUSH_DEVICE와 동일 스키마의 push_device 테이블로 로컬 CRUD',
    ),
  ];

  static const _usageSteps = [
    '앱 실행 시 알림 권한을 허용하면 FCM 토큰이 자동 발급됩니다.',
    '하단 「디바이스 등록」으로 FCM 토큰을 서버에 저장합니다.',
    'PC 브라우저에서 서버 /fcm 페이지로 접속해 메시지를 작성·발송합니다.',
    '「수신 목록」에서 이 기기로 발송된 메시지 이력을 확인할 수 있습니다.',
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
              title: l10n.pushTitle,
              content: l10n.pushGuideOverview,
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
            _GuideTextCard(content: l10n.pushGuideSqliteNote),
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
