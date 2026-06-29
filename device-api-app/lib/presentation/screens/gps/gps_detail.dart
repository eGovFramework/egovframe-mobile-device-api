import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/gps_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:flutter/material.dart';

import 'gps_description.dart';
import 'gps_list.dart';

class GpsDetailPage extends StatefulWidget {
  final GpsInfo gpsInfo;
  
  const GpsDetailPage({
    super.key,
    required this.gpsInfo,
  });

  @override
  State<GpsDetailPage> createState() => _GpsDetailPageState();
}

class _GpsDetailPageState extends State<GpsDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;

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

  /// Timestamp를 로컬 시간으로 포맷
  String _formatTimestamp(DateTime timestamp) {
    // UTC 시간인 경우 로컬 시간으로 변환
    final localTime = timestamp.isUtc ? timestamp.toLocal() : timestamp.add(Duration(hours: 9));
    return '${localTime.year}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')} ${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}:${localTime.second.toString().padLeft(2, '0')}';
  }

  Future<void> _deleteGpsInfo() async {
    if (widget.gpsInfo.sn == null) {
      showStatusDialog(
        context,
        variant: StatusVariant.error,
        title: '오류',
        message: '삭제할 GPS 정보를 식별할 수 없습니다.',
      );
      return;
    }

    try {
      final result = await showPromptDialog(
        context,
        title: 'GPS 정보 삭제',
        message: '이 GPS 정보를 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
      );

      if (result == true) {
        setState(() => isLoading = true);

        final uuid = await DeviceIdService.getDeviceId();
        final success = await GpsService.deleteGpsInfoBySn(
          uuid: uuid,
          sn: widget.gpsInfo.sn!,
        );

        if (mounted) {
          setState(() => isLoading = false);

          if (success) {
            await showStatusDialog(
              context,
              variant: StatusVariant.success,
              title: '성공',
              message: 'GPS 정보가 성공적으로 삭제되었습니다.',
            );
            if (mounted) {
              Navigator.pop(context, true);
            }
          } else {
            showStatusDialog(
              context,
              variant: StatusVariant.error,
              title: '오류',
              message: 'GPS 정보 삭제에 실패했습니다.',
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
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
        title: 'GPS 상세정보',
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
                const GpsFunctionPage(),
                // 주요기능 탭
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            InfoBox(
                              text: '선택한 GPS 정보의 상세 내용을 확인하고 관리할 수 있습니다.',
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    CommonTable(
                                      title: 'GPS 상세정보',
                                      data: [
                                        {'label': 'UUID', 'value': widget.gpsInfo.uuid},
                                        {'label': '위도', 'value': widget.gpsInfo.latitude.toStringAsFixed(6)},
                                        {'label': '경도', 'value': widget.gpsInfo.longitude.toStringAsFixed(6)},
                                        {'label': '정확도', 'value': widget.gpsInfo.accrcy?.toStringAsFixed(2) ?? 'N/A'},
                                        {'label': '타임스탬프', 'value': _formatTimestamp(widget.gpsInfo.timestamp)},
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
                      builder: (context) => const GpsListPage(),
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
                  onTap: isLoading ? null : _deleteGpsInfo,
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
            const SizedBox.shrink(),
          const Footer(),
        ],
      ),
    );
  }
}
