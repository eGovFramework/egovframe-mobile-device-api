import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

class AcceleratorFunctionPage extends StatefulWidget {
  const AcceleratorFunctionPage({super.key});

  @override
  State<AcceleratorFunctionPage> createState() => _AcceleratorFunctionPageState();
}

class _AcceleratorFunctionPageState extends State<AcceleratorFunctionPage> {
  Map<String, dynamic>? acceleratorData;

  @override
  void initState() {
    super.initState();
    _loadAcceleratorData();
  }

  Future<void> _loadAcceleratorData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('accelerator');
    setState(() {
      acceleratorData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (acceleratorData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final title1 = acceleratorData!['title1'];
    final featureDescription = acceleratorData!['featureDescription'];
    final usageGuide = acceleratorData!['usageGuide'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBox(
              text: title1?['content'] ?? '가속도계 기능을 통해 디바이스의 가속도, 자이로스코프, 자력계 데이터를 실시간으로 수집하고 서버에 저장할 수 있습니다.',
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

