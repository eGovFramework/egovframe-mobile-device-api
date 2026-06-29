import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/device_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/format_utils.dart';
import 'package:flutter/material.dart';

import 'deviceInfo_description.dart';
import 'deviceInfo_list.dart';

class DeviceDetailedPage extends StatefulWidget {
  final DeviceInfo device;
  
  const DeviceDetailedPage({
    super.key,
    required this.device,
  });

  @override
  State<DeviceDetailedPage> createState() => _DeviceDetailedPageState();
}

class _DeviceDetailedPageState extends State<DeviceDetailedPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  bool isDeleting = false;
  DeviceInfo? deviceInfo;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    _fetchDeviceDetail();
  }

  /// 서버에서 디바이스 상세 정보 조회
  Future<void> _fetchDeviceDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final uuid = await DeviceIdService.getDeviceId();
      final device = await DeviceService.fetchDeviceInfoDetail(widget.device.sn, uuid);
      
      if (mounted) {
        setState(() {
          if (device != null) {
            deviceInfo = device;
            isLoading = false;
          } else {
            errorMessage = '디바이스 정보를 불러올 수 없습니다.';
            isLoading = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = '오류가 발생했습니다: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _deleteDevice() async {
    setState(() {
      isDeleting = true;
    });

    try {
      final deviceSn = deviceInfo?.sn ?? widget.device.sn;
      final uuid = await DeviceIdService.getDeviceId();
      final success = await DeviceService.deleteDeviceInfo(deviceSn, uuid);

      if (mounted) {
        setState(() {
          isDeleting = false;
        });

        if (success) {
          await showStatusDialog(
            context,
            variant: StatusVariant.success,
            title: '성공',
            message: '디바이스가 성공적으로 삭제되었습니다.',
          );
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          showStatusDialog(
            context,
            variant: StatusVariant.error,
            title: '오류',
            message: '삭제 실패: 서버에서 처리할 수 없습니다.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isDeleting = false;
        });
        showStatusDialog(
          context,
          variant: StatusVariant.error,
          title: '오류',
          message: '오류가 발생했습니다: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: '디바이스 상세정보',
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
                    : errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error, size: 64, color: EgovColor.danger50),
                                  const SizedBox(height: 16),
                                  Text(
                                    errorMessage!,
                                    style: EgovText.regular.copyWith(color: EgovColor.danger50),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _fetchDeviceDetail,
                                    child: const Text('다시 시도'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : deviceInfo == null
                            ? Center(
                                child: Text(
                                  '디바이스 정보를 불러올 수 없습니다.',
                                  style: EgovText.regular.copyWith(color: EgovColor.gray40),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    InfoBox(
                                      text: '선택한 디바이스의 상세 정보를 확인하고 관리할 수 있습니다.',
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            CommonTable(
                                              title: 'Device 상세정보',
                                              data: [
                                                {'label': '일련번호', 'value': '${deviceInfo!.sn}'},
                                                {'label': 'UUID', 'value': deviceInfo!.uuid},
                                                {'label': '운영체제', 'value': deviceInfo!.os},
                                                {'label': '네트워크 정보', 'value': deviceInfo!.ntwrkDeviceInfo},
                                                {'label': '프로그램 버전', 'value': deviceInfo!.pgVer},
                                                {'label': '디바이스명', 'value': deviceInfo!.deviceNm},
                                                {'label': '사용 여부', 'value': deviceInfo!.useYn == 'Y' ? '사용' : '미사용'},
                                                if (deviceInfo!.telno != null)
                                                  {'label': '연락처 개수', 'value': deviceInfo!.telno!},
                                                if (deviceInfo!.strgeInfo != 0)
                                                  {'label': '스토리지 정보', 'value': FormatUtils.formatFileSize(deviceInfo!.strgeInfo)},
                                              ],
                                            ),
                                          ],
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
                  text: '목록',
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceListPage(
                        uuid: deviceInfo?.uuid ?? widget.device.uuid,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.list,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
                CustomButton(
                  text: '삭제',
                  onTap: (isLoading || isDeleting) ? null : _deleteDevice,
                  icon: isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(EgovColor.white100),
                        ),
                      )
                    : const Icon(
                        Icons.delete,
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
