import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

class InterfaceFunctionPage extends StatefulWidget {
  const InterfaceFunctionPage({super.key});

  @override
  State<InterfaceFunctionPage> createState() => _InterfaceFunctionPageState();
}

class _InterfaceFunctionPageState extends State<InterfaceFunctionPage> {
  Map<String, dynamic>? interfaceData;

  @override
  void initState() {
    super.initState();
    _loadInterfaceData();
  }

  Future<void> _loadInterfaceData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('interface');
    setState(() {
      interfaceData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (interfaceData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final title1 = interfaceData!['title1'];
    final featureDescription = interfaceData!['featureDescription'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBox(
              text: title1?['content'] ?? 'Interface API를 통해 사용자 로그인, 회원가입, 로그아웃, 회원탈퇴 등의 인증 기능을 제공합니다.',
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

