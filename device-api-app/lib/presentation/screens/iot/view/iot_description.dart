import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

/// IoT MQTT 기능설명 탭
class IotFunctionPage extends StatelessWidget {
  const IotFunctionPage({super.key});

  static const _featureItems = <(String, String)>[
    (
      'MQTT 연결',
      'mqtt5_client로 RabbitMQ MQTT plugin(기본 1883)에 연결합니다. 사용자/비밀번호 인증을 지원합니다.',
    ),
    (
      '텔레메트리 구독',
      'iot/{deviceId}/telemetry 토픽을 구독하여 온습도 JSON을 수신·표시합니다.',
    ),
    (
      '제어 명령 발행',
      'iot/{deviceId}/command 토픽으로 전원 제어 JSON을 publish 합니다. (action: power, value: on/off)',
    ),
    (
      '자동 저장',
      '데이터 저장소(서버/SQLite)가 연결되어 있으면, 온·습도가 이전 값과 다를 때와 명령 발송 시 DB에 자동 저장합니다.',
    ),
    (
      '로컬 테스트',
      '실제 IoT 기기 없이도 MQTT Explorer로 동일 토픽에 publish/subscribe 하여 검증할 수 있습니다.',
    ),
  ];

  static const _usageSteps = [
    'MQTT 바의 연결 버튼으로 브로커에 접속합니다. Host/Port/계정/Device ID는 서버 properties의 mqtt 값이며, 공기계는 PC 사설 IP, Android 에뮬레이터는 10.0.2.2 입니다.',
    '메인에서 데이터 저장소(서버 또는 SQLite)를 연결한 뒤 온습도·명령을 사용합니다.',
    '온·습도 값이 바뀌거나 명령을 발송하면 저장소에 자동 저장됩니다. 메시지 로그의 목록에서 저장 이력을 확인합니다.',
    'MQTT Explorer로 iot/device01/telemetry 에 publish 하면 앱에 값이 표시됩니다.',
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
              title: l10n.iotTitle,
              content: l10n.iotGuideOverview,
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
            _GuideSectionHeader(title: l10n.iotGuideNoteTitle),
            const SizedBox(height: 12),
            _GuideTextCard(content: l10n.iotGuideNote),
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
