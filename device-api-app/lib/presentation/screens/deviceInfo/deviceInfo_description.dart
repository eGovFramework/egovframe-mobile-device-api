import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

class DeviceFunctionPage extends StatefulWidget {
  const DeviceFunctionPage({super.key});

  @override
  State<DeviceFunctionPage> createState() => _DeviceFunctionPageState();
}

class _DeviceFunctionPageState extends State<DeviceFunctionPage> {
  Map<String, dynamic>? deviceInfoData;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfoData();
  }

  Future<void> _loadDeviceInfoData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('deviceInfo');
    setState(() {
      deviceInfoData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (deviceInfoData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final title1 = deviceInfoData!['title1'];
    final featureDescription = deviceInfoData!['featureDescription'];
    final systemStatus = deviceInfoData!['systemStatus'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBox(
              text: title1?['content'] ?? 'DeviceInfo API를 통해 모바일 디바이스의 메타 데이터 정보를 조회하고, 조회된 정보를 서버에 전송, 조회, 삭제할 수 있는 기능을 제공합니다.',
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
            
            // systemStatus 섹션
            if (systemStatus != null) ...[
              _buildSection(
                systemStatus['title'] ?? '시스템 상태',
                systemStatus['content'] ?? '',
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

