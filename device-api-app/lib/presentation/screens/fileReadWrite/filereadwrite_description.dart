import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

class FileReadWriteFunctionPage extends StatefulWidget {
  const FileReadWriteFunctionPage({super.key});

  @override
  State<FileReadWriteFunctionPage> createState() => _FileReadWriteFunctionPageState();
}

class _FileReadWriteFunctionPageState extends State<FileReadWriteFunctionPage> {
  Map<String, dynamic>? fileReadWriteData;

  @override
  void initState() {
    super.initState();
    _loadFileReadWriteData();
  }

  Future<void> _loadFileReadWriteData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('fileReadWrite');
    setState(() {
      fileReadWriteData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (fileReadWriteData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final title1 = fileReadWriteData!['title1'];
    final featureDescription = fileReadWriteData!['featureDescription'];
    final usageGuide = fileReadWriteData!['usageGuide'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBox(
              text: title1?['content'] ?? 'File Read/Write API를 통해 로컬 파일을 생성, 조회, 삭제하고 서버와 파일을 주고받을 수 있습니다.',
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
                usageGuide['title'] ?? '사용 가이드',
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

