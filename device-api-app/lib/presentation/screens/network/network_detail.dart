import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/network_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';

import 'network_list.dart';

class NetworkDetailPage extends StatefulWidget {
  final NetworkInfo networkInfo;
  
  const NetworkDetailPage({
    super.key,
    required this.networkInfo,
  });

  @override
  State<NetworkDetailPage> createState() => _NetworkDetailPageState();
}

class _NetworkDetailPageState extends State<NetworkDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  final NetworkRepository _networkRepository = getIt<NetworkRepository>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _deleteNetworkInfo() async {
    try {
      final result = await showPromptDialog(
        context,
        title: '네트워크 정보 삭제',
        message: '이 네트워크 정보를 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
      );

      if (result == true) {
        setState(() {
          isLoading = true;
        });

        try {
          final uuid = await DeviceIdService.getDeviceId();
          final success = await _networkRepository.deleteNetworkInfo(
            sn: widget.networkInfo.sn ?? '',
            uuid: uuid,
          );

          if (mounted) {
            setState(() {
              isLoading = false;
            });

            if (success) {
              await showStatusDialog(
                context,
                variant: StatusVariant.success,
                title: '성공',
                message: '네트워크 정보가 성공적으로 삭제되었습니다.',
              );
              if (mounted) {
                Navigator.pop(context, true);
              }
            } else {
              showStatusDialog(
                context,
                variant: StatusVariant.error,
                title: '오류',
                message: '네트워크 정보 삭제에 실패했습니다.',
              );
            }
          }
        } catch (e, stackTrace) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            await ErrorHandler.handleException(
              context,
              e,
              stackTrace: stackTrace,
              logContext: 'NetworkDetailPage._deleteNetworkInfo',
            );
          }
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,

          stackTrace: stackTrace,
          logContext: 'NetworkDetailPage._deleteNetworkInfo',
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
        title: '네트워크 상세정보',
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
                const Center(
                  child: Text(
                    '네트워크 기능 설명',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                // 주요기능 탭
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            InfoBox(
                              text: '선택한 네트워크 정보의 상세 내용을 확인하고 관리할 수 있습니다.',
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    CommonTable(
                                      title: 'Network 상세정보',
                                      data: [
                                        {'label': 'SN', 'value': widget.networkInfo.sn?.toString() ?? 'N/A'},
                                        {'label': '디바이스 ID', 'value': widget.networkInfo.deviceId},
                                        {'label': '네트워크 타입', 'value': widget.networkInfo.networkTypeName},
                                        {'label': '디바이스명', 'value': widget.networkInfo.deviceName},
                                        if (widget.networkInfo.ipAddress != null)
                                          {'label': 'IP 주소', 'value': widget.networkInfo.ipAddress!},
                                        if (widget.networkInfo.macAddress != null)
                                          {'label': 'MAC 주소', 'value': widget.networkInfo.macAddress!},
                                        if (widget.networkInfo.ssid != null)
                                          {'label': 'SSID', 'value': widget.networkInfo.ssid!},
                                        // {'label': '등록일', 'value': widget.networkInfo.registDate.toString()},
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
                      builder: (context) => const NetworkListScreen(),
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
                  onTap: isLoading ? null : _deleteNetworkInfo,
                  icon: isLoading 
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
                  normalColor: EgovColor.danger50,
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
