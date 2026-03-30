import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_description.dart';
import 'package:flutter/material.dart';

class DeviceFunctionPage extends StatelessWidget {
  const DeviceFunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: FeatureDescription(
          infoBoxText: 'DeviceAPI 기능을 이용하여 모바일 디바이스의 메타 데이터 정보를 조회하고 조회된 정보를 서버에 전송, 조회, 삭제 할 수 있는 기능을 제공합니다.',
          tableTitle: '개발 환경 정보',
          tableData: [
            {'label': 'Local 디바이스 개발 환경', 'value': 'Android 2024.3.1'},
            {'label': '서버 사이드 개발 환경', 'value': '전자정부표준프레임워크 개발환경 4.3'},
            {'label': 'Mash up Open API 연계', 'value': 'N/A'},
            {'label': '테스트 디바이스', 'value': 'Android 16.0'},
            {'label': '테스트 플랫폼', 'value': 'Android SDK API 36'},
            {'label': '추가 라이브러리 적용', 'value': '스토리지 정보 조회를 위한 추가 플러그인 적용'},
          ],
        ),
      ),
    );
  }
}
