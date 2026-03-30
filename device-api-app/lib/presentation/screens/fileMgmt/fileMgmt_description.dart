import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

class FileFunctionPage extends StatefulWidget {
  const FileFunctionPage({super.key});

  @override
  State<FileFunctionPage> createState() => _FileFunctionPageState();
}

class _FileFunctionPageState extends State<FileFunctionPage> {
  Map<String, dynamic>? fileMgmtData;

  @override
  void initState() {
    super.initState();
    _loadFileMgmtData();
  }

  Future<void> _loadFileMgmtData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('fileMgmt');
    setState(() {
      fileMgmtData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (fileMgmtData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final title1 = fileMgmtData!['title1'];
    final featureDescription = fileMgmtData!['featureDescription'];
    final usageGuide = fileMgmtData!['usageGuide'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBox(
              text: title1?['content'] ?? 'File Management API를 통해 모바일 디바이스의 파일 시스템에 접근하여 파일과 폴더를 생성, 수정, 삭제, 복사, 이동할 수 있는 기능을 제공합니다.',
            ),
            const SizedBox(height: 24),
            
            // featureDescription 섹션 - 각 item을 개별 섹션으로 표시
            if (featureDescription != null) ...[
              ...((featureDescription['items'] as List<dynamic>?) ?? []).map((item) {
                final itemText = item.toString();
                final parts = itemText.split(' : ');
                final title = parts.isNotEmpty ? parts[0] : '';
                final content = parts.length > 1 ? parts.sublist(1).join(' : ') : itemText;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildSection(title, content),
                );
              }).toList(),
            ],
            
            // usageGuide 섹션
            if (usageGuide != null) ...[
              _buildSection(
                usageGuide['title'] ?? '주의사항',
                usageGuide['content'] ?? '',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: EgovColor.primary50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: EgovColor.gray70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

