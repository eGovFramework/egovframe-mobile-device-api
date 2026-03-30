import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

/// GPS 기능 설명 페이지
class GpsFunctionPage extends StatelessWidget {
  const GpsFunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBox(
              text: 'GPS 기능을 통해 현재 위치 정보를 실시간으로 조회하고, 지도에 표시하며, 서버에 저장할 수 있습니다.',
            ),
            const SizedBox(height: 24),
            
            // 기능 설명 섹션
            _buildSection(
              '위치 정보 조회',
              '현재 디바이스의 GPS 위치 정보를 실시간으로 가져옵니다.\n'
              '• 위도, 경도, 정확도 정보 제공\n'
              '• 위치 권한 자동 요청 및 확인\n'
              '• 한국 지역 범위 검증',
            ),
            
            const SizedBox(height: 20),
            
            _buildSection(
              '지도 표시',
              'Google Maps를 통해 현재 위치를 시각적으로 확인할 수 있습니다.\n'
              '• 실시간 위치 마커 표시\n'
              '• 자동 카메라 이동\n'
              '• 줌 레벨 조정',
            ),
            
            const SizedBox(height: 20),
            
            _buildSection(
              '데이터 저장',
              'GPS 정보를 로컬과 서버에 동시에 저장합니다.\n'
              '• 로컬 JSON 파일 저장\n'
              '• 서버 DB 저장 (REST API)\n'
              '• 저장 이력 관리',
            ),
            
            const SizedBox(height: 20),
            
            _buildSection(
              '주요 기능',
              '• 현재 위치 가져오기\n'
              '• 위치 정보 저장\n'
              '• 저장된 위치 목록 조회\n'
              '• 위치 데이터 삭제\n'
              '• 서버 동기화',
            ),
            
            const SizedBox(height: 20),
            
            _buildSection(
              '주의사항',
              '• 위치 권한이 필요합니다\n'
              '• 인터넷 연결이 필요합니다 (서버 저장용)\n'
              '• 정확한 위치를 위해 실외에서 사용하세요\n'
              '• 배터리 사용량이 증가할 수 있습니다',
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
