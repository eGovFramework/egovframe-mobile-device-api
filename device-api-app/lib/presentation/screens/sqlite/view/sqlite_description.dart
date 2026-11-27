import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

/// SQLite Manager 기능설명 탭
class SqliteFunctionPage extends StatelessWidget {
  final String? databaseName;

  const SqliteFunctionPage({super.key, this.databaseName});

  static const _usageSteps = [
    "메인 화면에서 'DB 생성' 또는 'DB 가져오기'로 내부 DB를 준비합니다.",
    'DB를 탭하면 테이블 목록을 확인할 수 있습니다.',
    "'테이블 생성'으로 컬럼·인덱스·외래키를 설정해 테이블을 만듭니다.",
    '다른 기능 앱(기기 정보 등)과 연동할 때는 해당 앱의 스키마와 같은 테이블·컬럼을 만듭니다.',
    '테이블을 탭하면 데이터를 조회·추가·수정·삭제할 수 있습니다.',
    '테이블 메뉴에서 스키마 보기, 컬럼 추가(ALTER TABLE)가 가능합니다.',
    'DB 메뉴에서 Downloads 저장·공유·삭제를 수행합니다.',
  ];

  static const _featureItems = <(String, String)>[
    ('DB 관리', '내부 DB 생성·삭제·Downloads 저장·가져오기·공유'),
    ('테이블 관리', 'CREATE TABLE로 테이블 생성, 컬럼·인덱스·외래키 설정'),
    ('스키마 관리', 'PRAGMA table_info로 컬럼 조회, ALTER TABLE로 컬럼 추가'),
    ('데이터 CRUD', 'insert / query / update / delete로 행 추가·조회·수정·삭제'),
    ('파일 연동', '.db, .sqlite, .sqlite3 파일을 import하여 읽고 수정한 뒤 export'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (databaseName != null)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EgovColor.information5,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: EgovColor.information20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sqliteDatabaseGuideTitle,
                  style: EgovText.captionBold,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.sqliteDatabaseGuideBody(databaseName!),
                  style: EgovText.caption.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GuideIntro(
                    title: l10n.sqliteFeatureTitle,
                    content: l10n.sqliteFeatureDescription,
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
                  _GuideSectionHeader(title: l10n.sqliteGuideBasicsTitle),
                  const SizedBox(height: 12),
                  _GuideTextCard(content: l10n.sqliteGuideBasicsContent),
                  const SizedBox(height: 24),
                  _GuideSectionHeader(title: l10n.sqliteGuideColumnTypesTitle),
                  const SizedBox(height: 12),
                  _GuideTextCard(content: l10n.sqliteGuideColumnTypesContent),
                  const SizedBox(height: 24),
                  _GuideSectionHeader(title: l10n.sqliteGuideDesignTipsTitle),
                  const SizedBox(height: 12),
                  _GuideTextCard(content: l10n.sqliteGuideDesignTipsContent),
                ],
              ),
            ),
          ),
        ),
      ],
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
