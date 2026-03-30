import 'package:egovframe_mobile_deviceapi_app/data/repositories/device_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/device_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/device_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:flutter/material.dart';

import 'deviceInfo_description.dart';
import 'deviceInfo_detailed.dart';

class DeviceListPage extends StatefulWidget {
  final String uuid;
  
  const DeviceListPage({super.key, required this.uuid});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DeviceInfo> deviceList = [];
  bool isLoading = true;
  String errorMessage = '';
  late DeviceUseCase _deviceUseCase;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    _deviceUseCase = DeviceUseCase(DeviceRepositoryImpl());
    _fetchDeviceList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchDeviceList() async {
    try {
      final deviceListResult = await _deviceUseCase.getDeviceList(widget.uuid);
      
      setState(() {
        deviceList = deviceListResult;
        isLoading = false;
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
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
          onTap: (index) {
            if (index == 1) {
              Navigator.pop(context);
            }
          },
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
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            InfoBox(
                              text: '서버에 저장된 모바일 디바이스의 메타 데이터 정보들의 리스트를 조회 합니다.',
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: errorMessage.isNotEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.error, size: 64, color: EgovColor.danger50),
                                          const SizedBox(height: 16),
                                          Text(
                                            errorMessage,
                                            style: EgovText.regular.copyWith(color: EgovColor.danger50),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isLoading = true;
                                                errorMessage = '';
                                              });
                                              _fetchDeviceList();
                                            },
                                            child: const Text('다시 시도'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : deviceList.isEmpty
                                      ? Center(
                                          child: Text(
                                            '저장된 기기 정보가 없습니다.',
                                            style: EgovText.regular.copyWith(color: EgovColor.gray40),
                                          ),
                                        )
                                      : RefreshIndicator(
                                          onRefresh: _fetchDeviceList,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(0),
                                            itemCount: deviceList.length,
                                            itemBuilder: (context, index) {
                                              final device = deviceList[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: _TouchFeedbackWidget(
                                                  onTap: () async {
                                                    final result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => DeviceDetailedPage(device: device),
                                                      ),
                                                    );
                                                    
                                                    if (result == true) {
                                                      setState(() {
                                                        isLoading = true;
                                                        errorMessage = '';
                                                      });
                                                      _fetchDeviceList();
                                                    }
                                                  },
                                                  child: DeviceCard(
                                                    title: device.uuid.length > 25 ? '${device.uuid.substring(0, 25)}...' : device.uuid,
                                                    subtitle: 'Network Connection Type : ${device.ntwrkDeviceInfo}',
                                                    detailLabel: 'OS',
                                                    detailValue: device.os,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                            ),
                          ],
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
                CustomButton(
                  text: '새로고침',
                  onTap: () {
                    setState(() {
                      isLoading = true;
                      errorMessage = '';
                    });
                    _fetchDeviceList();
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
                CustomButton(
                  text: '이전 화면',
                  onTap: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: EgovColor.white100,
                    size: 20,
                  ),
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

class _TouchFeedbackWidget extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _TouchFeedbackWidget({
    required this.onTap,
    required this.child,
  });

  @override
  State<_TouchFeedbackWidget> createState() => _TouchFeedbackWidgetState();
}

class _TouchFeedbackWidgetState extends State<_TouchFeedbackWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: isPressed 
            ? [
                BoxShadow(
                  color: EgovColor.black10,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : [
                BoxShadow(
                  color: EgovColor.black25,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: Transform.scale(
          scale: isPressed ? 0.95 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
} 
