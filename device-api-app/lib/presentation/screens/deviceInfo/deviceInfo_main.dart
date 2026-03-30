import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/device_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/format_utils.dart';
import 'package:flutter/material.dart';

import 'deviceInfo_description.dart';
import 'deviceInfo_list.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DeviceInfo? deviceInfo;
  bool isLoading = true;
  
  late final DeviceUseCase _deviceUseCase;
  
  @override
  void initState() {
    super.initState();
    print('=== DeviceInfoPage.initState 시작 ===');
    
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    
    // Use Cases 초기화
    print('DeviceUseCase 의존성 주입 시도...');
    try {
      _deviceUseCase = getIt<DeviceUseCase>();
      print('DeviceUseCase 의존성 주입 성공: $_deviceUseCase');
    } catch (e) {
      print('DeviceUseCase 의존성 주입 실패: $e');
    }
    
    print('_getDeviceInfo() 호출...');
    _getDeviceInfo();
    print('=== DeviceInfoPage.initState 완료 ===');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getDeviceInfo() async {
    try {
      print('=== DeviceInfoPage._getDeviceInfo 시작 ===');
      
      setState(() {
        isLoading = true;
      });
      
      print('DeviceUseCase 초기화 확인: $_deviceUseCase');
      
      print('DeviceUseCase.getDeviceInfo() 호출 중...');
      deviceInfo = await _deviceUseCase.getDeviceInfo();
      print('DeviceInfo 조회 완료: $deviceInfo');
      
    } catch (e, stackTrace) {
      print('=== DeviceInfoPage._getDeviceInfo 오류 ===');
      print('오류: $e');
      print('스택 트레이스: $stackTrace');
      
      ErrorHandler.logError(e, null, context: 'DeviceInfoPage._getDeviceInfo');
      final errorType = ErrorHandler.detectErrorType(e);
      final errorMessage = ErrorHandler.getErrorMessage(e, errorType);
      await ErrorHandler.showErrorDialog(
        context,
        errorMessage,
        title: '디바이스 정보 조회 실패',
        onRetry: _getDeviceInfo,
        retryText: '다시 시도',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      print('=== DeviceInfoPage._getDeviceInfo 완료 ===');
    }
  }


  Future<void> _uploadDeviceInfo() async {
    if (deviceInfo == null) {
      await showStatusDialog(
        context,
        variant: StatusVariant.error,
        title: '오류',
        message: '업로드할 디바이스 정보가 없습니다.',
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("정보 업로드 중..."),
              ],
            ),
          );
        },
      );

      final success = await _deviceUseCase.uploadDeviceInfo(deviceInfo!);
      
      Navigator.of(context).pop();

      if (success) {
        await showStatusDialog(
          context,
          variant: StatusVariant.success,
          title: '성공',
          message: '정보 업로드가 성공적으로 완료되었습니다.',
        );
      } else {
        await showStatusDialog(
          context,
          variant: StatusVariant.error,
          title: '오류',
          message: '서버에 정보 업로드에 실패했습니다.',
        );
      }
    } catch (e) {
      // Close loading dialog if it's still open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      ErrorHandler.logError(e, null, context: 'DeviceInfoPage._uploadDeviceInfo');
      final errorType = ErrorHandler.detectErrorType(e);
      final errorMessage = ErrorHandler.getErrorMessage(e, errorType);
      await showStatusDialog(
        context,
        variant: StatusVariant.error,
        title: '오류',
        message: errorMessage,
      );
    }
  }


  Future<void> _showErrorDialog(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.error,
      title: '오류',
      message: message,
    );
  }

  Future<void> _navigateToServerList() async {
    if (deviceInfo == null) {
      _showErrorDialog('디바이스 정보가 없어 서버 목록을 조회할 수 없습니다.');
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceListPage(uuid: deviceInfo!.uuid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: 'DeviceInfo API',
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
                const DeviceFunctionPage(),
                // 주요기능 탭
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              InfoBox(
                                text: '모바일 디바이스의 하드웨어 및 소프트웨어 정보를 실시간으로 조회하고, 네트워크 상태, 연락처 정보 등을 확인할 수 있습니다.',
                              ),
                              const SizedBox(height: 16),
                              CommonTable(
                                title: 'Device 상세정보',
                                data: deviceInfo != null ? [
                                  {'label': 'OS', 'value': deviceInfo!.os},
                                  {'label': 'UUID', 'value': deviceInfo!.uuid},
                                  {'label': 'Program Version', 'value': deviceInfo!.pgVer},
                                  {'label': 'Network Info', 'value': deviceInfo!.ntwrkDeviceInfo},
                                  {'label': 'Device Name', 'value': deviceInfo!.deviceNm},
                                  {'label': '연락처 개수', 'value': deviceInfo!.telno ?? '-'},
                                  {'label': '스토리지 용량', 'value': FormatUtils.formatFileSize(deviceInfo!.strgeInfo)},
                                ] : [],
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
                  text: '서버목록조회',
                  onServerConnected: () async => _navigateToServerList(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                ),
                ServerConnectionButtonFactory.uploadButton(
                  text: '정보 업로드',
                  onServerConnected: () async => _uploadDeviceInfo(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                ),
              ],
            )
          else
            const SizedBox.shrink(), // 빈 공간으로 처리
          const Footer(),
        ],
      ),
    );
  }
}
