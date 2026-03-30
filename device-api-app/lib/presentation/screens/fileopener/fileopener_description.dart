import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

class FileOpenerFunctionPage extends StatefulWidget {
  const FileOpenerFunctionPage({super.key});

  @override
  State<FileOpenerFunctionPage> createState() => _FileOpenerFunctionPageState();
}

class _FileOpenerFunctionPageState extends State<FileOpenerFunctionPage> {
  Map<String, dynamic>? fileOpenerData;

  @override
  void initState() {
    super.initState();
    _loadFileOpenerData();
  }

  Future<void> _loadFileOpenerData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('fileopener');
    setState(() {
      fileOpenerData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (fileOpenerData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final title1 = fileOpenerData!['title1'];
    final featureDescription = fileOpenerData!['featureDescription'];
    final usageGuide = fileOpenerData!['usageGuide'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBox(
              text: title1?['content'] ?? 'File Opener API를 통해 다양한 파일 형식을 열고, 로컬과 서버에서 파일을 관리할 수 있습니다.',
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

