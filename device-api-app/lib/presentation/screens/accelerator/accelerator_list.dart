import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/accelerometer_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';

import 'accelerator_description.dart';
import 'accelerator_detail.dart';

class AcceleratorListPage extends StatefulWidget {
  const AcceleratorListPage({super.key});

  @override
  State<AcceleratorListPage> createState() => _AcceleratorListPageState();
}

class _AcceleratorListPageState extends State<AcceleratorListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AcceleratorInfo> acceleratorInfoList = [];
  bool isLoading = true;
  String errorMessage = '';

  String deviceUuid = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    _initList();
  }

  Future<void> _initList() async {
    deviceUuid = await DeviceIdService.getDeviceId();
    _loadAcceleratorInfoList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAcceleratorInfoList() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final list = await AccelerometerService.getAcceleratorInfoList(
        deviceUuid,
      );

      if (mounted) {
        setState(() {
          acceleratorInfoList = list;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e, stackTrace, context: 'AcceleratorListPage._loadAcceleratorInfoList');
      if (mounted) {
        setState(() {
          errorMessage = ErrorHandler.messageFor(e);
          isLoading = false;
        });
      }
    }
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
                const AcceleratorFunctionPage(),
                // 주요기능 탭
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            InfoBox(text: '서버에 저장된 가속도 정보들의 리스트를 조회 합니다.'),
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
                                              _loadAcceleratorInfoList();
                                            },
                                            child: const Text('다시 시도'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : acceleratorInfoList.isEmpty
                                      ? Center(
                                          child: Text(
                                            '저장된 가속도 정보가 없습니다.',
                                            style: EgovText.regular.copyWith(color: EgovColor.gray40),
                                          ),
                                        )
                                      : RefreshIndicator(
                                          onRefresh: _loadAcceleratorInfoList,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(0),
                                            itemCount: acceleratorInfoList.length,
                                            itemBuilder: (context, index) {
                                              final info = acceleratorInfoList[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    final result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => AcceleratorDetailPage(acceleratorInfo: info),
                                                      ),
                                                    );
                                                    
                                                    if (result == true) {
                                                      setState(() {
                                                        isLoading = true;
                                                        errorMessage = '';
                                                      });
                                                      _loadAcceleratorInfoList();
                                                    }
                                                  },
                                                  child: DeviceCardExtended(
                                                    title: 'UUID : ${info.uuid}',
                                                    subtitle: '시간 : ${info.timestamp}',
                                                    details: [
                                                      {'label': 'X축', 'value': '${info.xAxis.toStringAsFixed(2)}'},
                                                      {'label': 'Y축', 'value': '${info.yAxis.toStringAsFixed(2)}'},
                                                      {'label': 'Z축', 'value': '${info.zAxis.toStringAsFixed(2)}'},
                                                    ],
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
                    _loadAcceleratorInfoList();
                  },
                  icon: const Icon(
                    Icons.refresh,
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

class DeviceCardExtended extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Map<String, String>> details;
  final VoidCallback? onTap;
  final bool showArrow;

  const DeviceCardExtended({
    super.key,
    required this.title,
    this.subtitle,
    required this.details,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: EgovColor.white100,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: EgovColor.gray20),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: EgovText.title.copyWith(
                              fontSize: 19,
                              height: 1.50,
                            ),
                          ),
                        ),
                        if (showArrow) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: EgovColor.gray40,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        subtitle!,
                        style: EgovText.regular.copyWith(
                          color: EgovColor.gray70,
                          fontSize: 15,
                          height: 1.50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  ...details
                      .map(
                        (detail) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${detail['label']} :',
                                style: EgovText.captionBold.copyWith(
                                  height: 1.50,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  detail['value'] ?? '',
                                  style: EgovText.caption.copyWith(
                                    color: EgovColor.gray90,
                                    height: 1.50,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
