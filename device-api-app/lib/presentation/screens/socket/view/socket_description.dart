import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

/// Socket(WebSocket 채팅) 기능설명 탭
class SocketFunctionPage extends StatelessWidget {
  const SocketFunctionPage({super.key});

  static const _featureItems = <(String, String)>[
    ('WebSocket 채팅', 'web_socket_client로 ws://서버/websocket/chat.ws 에 연결. 웹 chat-sockjs 페이지와 msg:발신자:내용 형식으로 상호 채팅'),
    ('메시지 저장', '미저장 채팅 메시지를 SOCKET_MESSAGE 테이블(sn은 UUID별 순번)에 일괄 저장. 이미 저장된 메시지(savedSn)는 건너뜀'),
    ('메시지 목록', '서버 MySQL 또는 로컬 SQLite socket_message 테이블 목록 조회'),
    ('메시지 삭제', '서버/SQLite에 저장된 채팅 메시지 전체 초기화'),
    ('SQLite 연동', 'MySQL SOCKET_MESSAGE와 동일 스키마의 socket_message 테이블로 로컬 CRUD'),
  ];

  static const _usageSteps = [
    "웹 브라우저에서 http://서버IP:9700/chat-sockjs 페이지를 열고 닉네임을 입력한 뒤 Connect 합니다.",
    "'주요기능' 탭에서 닉네임을 입력하고 'WebSocket 연결' 버튼을 누르면 같은 서버(ws://서버IP:9700/websocket/chat.ws)에 연결되며 채팅 화면으로 이동합니다.",
    "연결 후에는 메인 화면에서 '연결 종료'로 끊거나 '채팅'으로 다시 채팅 화면에 들어갈 수 있습니다.",
    '채팅 화면에서 메시지를 입력·전송하면 웹·앱 간 실시간 채팅이 가능합니다. (형식: msg:발신자:내용)',
    "'메시지 저장' 버튼으로 아직 저장되지 않은 채팅 메시지를 서버 또는 SQLite에 일괄 저장합니다. (SN은 UUID별 순번, 이미 저장된 메시지는 건너뜀)",
    "'메시지 목록' 버튼으로 저장된 채팅 기록을 확인하고, 목록 화면에서 전체 삭제할 수 있습니다.",
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
              title: l10n.socketTitle,
              content: l10n.socketGuideOverview,
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
            _GuideTextCard(content: l10n.socketGuideSqliteNote),
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
