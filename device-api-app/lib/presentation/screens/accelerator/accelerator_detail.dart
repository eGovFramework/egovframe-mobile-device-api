import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/accelerometer_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/accelerator_info.dart';
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
import 'package:egovframe_mobile_deviceapi_app/utils/format_utils.dart';
import 'package:flutter/material.dart';

import 'accelerator_description.dart';
import 'accelerator_list.dart';

class AcceleratorDetailPage extends StatefulWidget {
  final AcceleratorInfo acceleratorInfo;
  
  const AcceleratorDetailPage({
    super.key,
    required this.acceleratorInfo,
  });

  @override
  State<AcceleratorDetailPage> createState() => _AcceleratorDetailPageState();
}

class _AcceleratorDetailPageState extends State<AcceleratorDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _deleteAcceleratorInfo() async {
    if (widget.acceleratorInfo.sn == null) {
      showStatusDialog(
        context,
        variant: StatusVariant.error,
        title: '오류',
        message: '삭제할 가속도 정보를 식별할 수 없습니다.',
      );
      return;
    }

    try {
      final result = await showPromptDialog(
        context,
        title: '가속도 정보 삭제',
        message: '이 가속도 정보를 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
      );

      if (result == true) {
        setState(() => isLoading = true);

        final uuid = await DeviceIdService.getDeviceId();
        final success = await AccelerometerService.deleteAcceleratorInfo(
          uuid: uuid,
          sn: widget.acceleratorInfo.sn!,
        );

        if (mounted) {
          setState(() => isLoading = false);

          if (success) {
            await showStatusDialog(
              context,
              variant: StatusVariant.success,
              title: '성공',
              message: '가속도 정보가 성공적으로 삭제되었습니다.',
            );
            if (mounted) {
              Navigator.pop(context, true);
            }
          } else {
            showStatusDialog(
              context,
              variant: StatusVariant.error,
              title: '오류',
              message: '가속도 정보 삭제에 실패했습니다.',
            );
          }
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() => isLoading = false);
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'AcceleratorDetailPage._deleteAcceleratorInfo',
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
        title: '가속도 상세정보',
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
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            InfoBox(
                              text: '선택한 가속도 정보의 상세 내용을 확인하고 관리할 수 있습니다.',
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    CommonTable(
                                      title: 'Accelerator 상세정보',
                                      data: [
                                        {'label': 'UUID', 'value': widget.acceleratorInfo.uuid},
                                        {'label': 'X축', 'value': widget.acceleratorInfo.xAxis.toStringAsFixed(6)},
                                        {'label': 'Y축', 'value': widget.acceleratorInfo.yAxis.toStringAsFixed(6)},
                                        {'label': 'Z축', 'value': widget.acceleratorInfo.zAxis.toStringAsFixed(6)},
                                        {'label': '저장일자', 'value': FormatUtils.formatTimestampToDate(int.parse(widget.acceleratorInfo.timestamp))},
                                        {'label': '사용 여부', 'value': widget.acceleratorInfo.useYn == 'Y' ? '사용' : '미사용'},
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
                      builder: (context) => const AcceleratorListPage(),
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
                  onTap: isLoading ? null : _deleteAcceleratorInfo,
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
