import 'package:egovframe_mobile_deviceapi_app/data/datasources/accelerometer_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/accelerator_widget.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/three_d_cube.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:flutter/material.dart';

import 'accelerator_description.dart';
import 'accelerator_list.dart';

class AcceleratorInfoPage extends StatefulWidget {
  const AcceleratorInfoPage({super.key});

  @override
  State<AcceleratorInfoPage> createState() => _AcceleratorInfoPageState();
}

class _AcceleratorInfoPageState extends State<AcceleratorInfoPage> 
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  late AccelerometerService _accelerometerService;
  bool isLoading = true;
  double xAxis = 0.0;  // X축 초기값 (앞뒤 기울기)
  double yAxis = 0.0;  // Y축 초기값 (좌우 기울기)  
  double zAxis = 0.0;  // Z축 초기값 (회전)
  
  String timestamp = '';
  bool isAccelerometerActive = false;
  String deviceUuid = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 생명주기 관찰자 추가
    
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if(mounted){
        setState(() {}); // 탭 변경 시 UI 업데이트
      }
    });
    
    _accelerometerService = AccelerometerService();
    _getDeviceUuid();
    _startAccelerometer();
  }

  Future<void> _getDeviceUuid() async {
    deviceUuid = await DeviceUuidUtil.getDeviceUuid();
  }

  void _startAccelerometer() {
    _accelerometerService.startAccelerometer();
    
    _accelerometerService.accelerometerStream.listen(
      (event) {
        if (mounted) {
          if (xAxis != event.x || yAxis != event.y || zAxis != event.z) {
            setState(() {
              xAxis = event.x;
              yAxis = event.y;
              zAxis = event.z;
              final now = DateTime.now().toUtc().add(const Duration(hours: 9)); // 한국 시간 (UTC+9)
              timestamp = now.millisecondsSinceEpoch.toString(); // Unix timestamp (밀리초)
              isAccelerometerActive = true;
              isLoading = false;
            });
          }
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      },
      onDone: () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      },
    );
  }

  Future<void> _saveAcceleratorInfo() async {
    try {
      // 로딩 상태 표시
      setState(() {
        isLoading = true;
      });

      // useYn 설정
      const useYn = "Y";
      
      // API 호출
      final success = await AccelerometerService.saveAcceleratorInfo(
        AcceleratorInfo(
          uuid: deviceUuid.isNotEmpty ? deviceUuid : 'unknown_device', // 실제 디바이스 UUID 사용
          xAxis: xAxis,
          yAxis: yAxis,
          zAxis: zAxis,
          timestamp: timestamp,
          useYn: useYn,
        ),
      );

      // 로딩 상태 해제
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      if (success) {
        _showSuccessDialog('가속도 정보 저장 성공');
      } else {
        _showErrorDialog('데이터 전송 중 오류가 발생했습니다.');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('오류가 발생했습니다: $e');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 생명주기 관찰자 제거
    _tabController.dispose();
    _accelerometerService.dispose(); // 가속도계 서비스 정리
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
        // 앱이 백그라운드로 갈 때 센서 중지
        print('App paused - stopping accelerometer');
        _accelerometerService.stopAccelerometer();
        break;
      case AppLifecycleState.resumed:
        // 앱이 포그라운드로 올 때 센서 재시작
        print('App resumed - starting accelerometer');
        _startAccelerometer();
        break;
      case AppLifecycleState.inactive:
        // 앱이 비활성화될 때 (전화 수신 등)
        print('App inactive - stopping accelerometer');
        _accelerometerService.stopAccelerometer();
        break;
      case AppLifecycleState.detached:
        // 앱이 완전히 종료될 때
        print('App detached - cleaning up accelerometer');
        _accelerometerService.dispose();
        break;
      default:
        break;
    }
  }

  Future<void> _showSuccessDialog(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.success,
      title: '성공',
      message: message,
    );
  }

  Future<void> _showErrorDialog(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.error,
      title: '오류',
      message: message,
    );
  }

  void _navigateToList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcceleratorListPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: 'Accelerator Info API',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: CustomTabBar(
          controller: _tabController,
          tabs: const ['기능설명', '주요기능', '라이선스'],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 기능설명 탭
                const AcceleratorFunctionPage(),
                // 주요기능 탭
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        InfoBox(
                          text: '가속기 기능',
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            ThreeDCube(
                              xAxis: xAxis,
                              yAxis: yAxis,
                              zAxis: zAxis,
                            ),
                            const SizedBox(height: 30),
                            AccelerationDisplay(
                              xAxis: xAxis,
                              yAxis: yAxis,
                              zAxis: zAxis,
                              timestamp: timestamp,
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 라이선스 탭
                const License(),
              ],
            ),
          ),
          if (_tabController.index == 1)
            BottomButtonRow(
              buttons: [
                ServerConnectionButtonFactory.listButton(
                  text: '목록',
                  onServerConnected: () async => _navigateToList(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                ),
                ServerConnectionButtonFactory.uploadButton(
                  text: '저장',
                  onServerConnected: () async => _saveAcceleratorInfo(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                ),
              ],
            )
          else
            const SizedBox.shrink(),
          const Footer(),
        ],
      ),
    );
  }
}
