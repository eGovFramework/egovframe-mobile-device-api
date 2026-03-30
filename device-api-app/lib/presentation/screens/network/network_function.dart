import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

class NetworkFunctionPage extends StatelessWidget {
  const NetworkFunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBox(
              text: '네트워크 기능을 통해 현재 네트워크 상태를 실시간으로 모니터링하고, 네트워크 정보를 서버에 저장할 수 있습니다.',
            ),
            const SizedBox(height: 24),
            
            // 기능 설명 섹션
            _buildSection(
              '네트워크 상태 모니터링',
              '현재 디바이스의 네트워크 연결 상태를 실시간으로 확인합니다.\n'
              '• WiFi, 모바일 데이터, 이더넷 연결 상태 확인\n'
              '• 네트워크 품질 평가\n'
              '• 연결 상태 변경 실시간 감지',
            ),
            
            const SizedBox(height: 20),
            
            _buildSection(
              '네트워크 정보 수집',
              '현재 연결된 네트워크의 상세 정보를 수집합니다.\n'
              '• 네트워크 타입 (WiFi, 4G, 5G 등)\n'
              '• IP 주소, MAC 주소\n'
              '• WiFi SSID 정보',
            ),
            
            const SizedBox(height: 20),
            
            _buildSection(
              '데이터 저장',
              '네트워크 정보를 서버에 저장합니다.\n'
              '• 서버 DB 저장 (REST API)\n'
              '• 저장된 네트워크 정보 목록 조회\n'
              '• 네트워크 정보 삭제',
            ),
            
            const SizedBox(height: 20),
            
            _buildSection(
              '주요 기능',
              '• 현재 네트워크 상태 확인\n'
              '• 네트워크 정보 수집\n'
              '• 네트워크 정보 서버 전송\n'
              '• 저장된 네트워크 목록 조회\n'
              '• 네트워크 정보 삭제',
            ),
            
            const SizedBox(height: 20),
            
            _buildSection(
              '주의사항',
              '• 인터넷 연결이 필요합니다 (서버 저장용)\n'
              '• WiFi 정보는 WiFi 연결 시에만 제공됩니다\n'
              '• 일부 네트워크 정보는 보안상 제한될 수 있습니다',
            ),
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

