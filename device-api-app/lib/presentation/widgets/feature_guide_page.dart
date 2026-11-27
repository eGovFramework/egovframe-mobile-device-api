import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// 기능설명 탭 공통 레이아웃 — [data/feature_data.json]의 앱 사용 방법 + 기능 설명을 표시합니다.
///
/// JSON 섹션 구조:
/// - `title1`: 개요
/// - `usageGuide`: 앱 사용 방법 (title, content)
/// - `featureDescription`: 기능 설명 (title, items)
/// - 기타 키: [additionalSectionKeys]로 지정 (예: systemStatus)
class FeatureGuidePage extends StatefulWidget {
  final String sectionKey;
  final List<String> additionalSectionKeys;

  const FeatureGuidePage({
    super.key,
    required this.sectionKey,
    this.additionalSectionKeys = const [],
  });

  @override
  State<FeatureGuidePage> createState() => _FeatureGuidePageState();
}

class _FeatureGuidePageState extends State<FeatureGuidePage> {
  Map<String, dynamic>? _sectionData;

  @override
  void initState() {
    super.initState();
    _loadSectionData();
  }

  Future<void> _loadSectionData() async {
    await TextService.loadTextData();
    final data = TextService.getSection(widget.sectionKey);
    if (!mounted) return;
    setState(() => _sectionData = data);
  }

  Map<String, dynamic>? _readSectionMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return null;
  }

  Map<String, String>? _resolveUsageGuide() {
    if (_sectionData == null) return null;
    final usageGuide = _readSectionMap(_sectionData!['usageGuide']);
    if (usageGuide == null) return null;
    final l10n = AppLocalizations.of(context)!;
    return {
      'title': usageGuide['title']?.toString() ?? l10n.featureGuideUsageTitle,
      'content': usageGuide['content']?.toString() ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_sectionData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final title1 = _readSectionMap(_sectionData!['title1']);
    final featureDescription = _readSectionMap(
      _sectionData!['featureDescription'],
    );
    final usageGuide = _resolveUsageGuide();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title1 != null)
              _GuideIntro(
                title: title1['title']?.toString() ?? '',
                content: title1['content']?.toString() ?? '',
              ),
            if (usageGuide != null &&
                (usageGuide['content']?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 24),
              _GuideSectionHeader(
                title: usageGuide['title'] ?? l10n.featureGuideUsageTitle,
              ),
              const SizedBox(height: 12),
              _GuideUsageCard(content: usageGuide['content'] ?? ''),
            ],
            if (featureDescription != null) ...[
              const SizedBox(height: 24),
              _GuideSectionHeader(
                title:
                    featureDescription['title']?.toString() ??
                    l10n.featureGuideFeatureTitle,
              ),
              const SizedBox(height: 12),
              ..._buildFeatureItems(featureDescription['items']),
            ],
            for (final key in widget.additionalSectionKeys) ...[
              if (_readSectionMap(_sectionData![key]) != null) ...[
                const SizedBox(height: 24),
                _buildAdditionalSection(_readSectionMap(_sectionData![key])!),
              ],
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureItems(dynamic items) {
    final list = (items as List<dynamic>?) ?? [];
    return list.map((item) {
      final itemText = item.toString();
      final parts = itemText.split(' : ');
      final title = parts.isNotEmpty ? parts[0] : '';
      final content = parts.length > 1
          ? parts.sublist(1).join(' : ')
          : itemText;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _GuideFeatureCard(title: title, content: content),
      );
    }).toList();
  }

  Widget _buildAdditionalSection(Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GuideSectionHeader(title: section['title']?.toString() ?? ''),
        const SizedBox(height: 12),
        _GuideTextCard(content: section['content']?.toString() ?? ''),
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
        if (title.isNotEmpty)
          Text(title, style: EgovText.title.copyWith(color: EgovColor.gray90)),
        if (title.isNotEmpty && content.isNotEmpty) const SizedBox(height: 8),
        if (content.isNotEmpty)
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
  final String content;

  const _GuideUsageCard({required this.content});

  @override
  Widget build(BuildContext context) {
    final lines = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    final numberedLines = lines
        .where((line) => RegExp(r'^\d+\.').hasMatch(line))
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EgovColor.primary5,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EgovColor.primary20),
      ),
      child: numberedLines.length >= 2
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < numberedLines.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _UsageStepLine(text: numberedLines[i]),
                ],
              ],
            )
          : Text(
              content,
              style: EgovText.regular.copyWith(
                color: EgovColor.gray70,
                height: 1.6,
              ),
            ),
    );
  }
}

class _UsageStepLine extends StatelessWidget {
  final String text;

  const _UsageStepLine({required this.text});

  @override
  Widget build(BuildContext context) {
    final match = RegExp(r'^(\d+)\.\s*(.*)$').firstMatch(text.trim());
    final stepNumber = match?.group(1) ?? '';
    final stepText = match?.group(2) ?? text;

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
            stepText,
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
          if (content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(content, style: EgovText.caption.copyWith(height: 1.5)),
          ],
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
