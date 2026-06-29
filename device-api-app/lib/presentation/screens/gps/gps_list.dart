import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/gps_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:flutter/material.dart';
import 'gps_description.dart';
import 'gps_detail.dart';

class GpsListPage extends StatefulWidget {
  const GpsListPage({super.key});

  @override
  State<GpsListPage> createState() => _GpsListPageState();
}

class _GpsListPageState extends State<GpsListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<GpsInfo> gpsInfoList = [];
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
    _getDeviceUuid();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 디바이스 UUID 생성
  Future<void> _getDeviceUuid() async {
    deviceUuid = await DeviceIdService.getDeviceId();

    _loadGpsInfoList();
  }

  Future<void> _loadGpsInfoList() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final result = await GpsService.loadGpsInfoList(deviceUuid);

      if (mounted) {
        if (result.isNotEmpty) {
          setState(() {
            gpsInfoList = result;
            isLoading = false;
          });
        } else {
          setState(() {
            gpsInfoList = [];

            errorMessage = 'GPS 정보가 없습니다.';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'GPS 정보 목록을 불러오는 중 오류가 발생했습니다: $e';
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
        title: 'GPS API',
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
                const GpsFunctionPage(),
                // 주요기능 탭
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            InfoBox(
                              text: '서버에 저장된 GPS 위치 정보들의 리스트를 조회합니다.',
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
                                              _loadGpsInfoList();
                                            },
                                            child: const Text('다시 시도'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : gpsInfoList.isEmpty
                                  ? Center(
                                      child: Text(
                                        '저장된 GPS 정보가 없습니다.',

                                        style: EgovText.regular.copyWith(
                                          color: EgovColor.gray40,
                                        ),
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: _loadGpsInfoList,

                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(0),

                                        itemCount: gpsInfoList.length,

                                        itemBuilder: (context, index) {
                                          final gpsInfo = gpsInfoList[index];

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),

                                            child: GestureDetector(
                                              onTap: () async {
                                                final result =
                                                    await Navigator.push(
                                                      context,

                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            GpsDetailPage(
                                                              gpsInfo: gpsInfo,
                                                            ),
                                                      ),
                                                    );

                                                if (result == true) {
                                                  setState(() {
                                                    isLoading = true;

                                                    errorMessage = '';
                                                  });

                                                  _loadGpsInfoList();
                                                }
                                              },

                                              child: DeviceCardExtended(
                                                title: 'UUID : ${gpsInfo.uuid}',

                                                details: [
                                                  {
                                                    'label': '위도',
                                                    'value': gpsInfo.latitude
                                                        .toStringAsFixed(6),
                                                  },

                                                  {
                                                    'label': '경도',
                                                    'value': gpsInfo.longitude
                                                        .toStringAsFixed(6),
                                                  },

                                                  {
                                                    'label': '정확도',
                                                    'value': gpsInfo
                                                        .formattedAccuracy,
                                                  },
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

                    _loadGpsInfoList();
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
            const SizedBox.shrink(),

          const Footer(),
        ],
      ),
    );
  }
}

// 확장된 DeviceCard 위젯
class DeviceCardExtended extends StatelessWidget {
  final String title;

  final String? subtitle;

  final List<Map<String, String>> details;

  final VoidCallback? onTap;

  final bool showArrow;

  final bool isSelected;

  const DeviceCardExtended({
    super.key,

    required this.title,

    this.subtitle,

    required this.details,

    this.onTap,

    this.showArrow = true,

    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: ShapeDecoration(
        color: EgovColor.white100,

        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: isSelected ? 3 : 1,

            color: isSelected ? EgovColor.primary50 : EgovColor.gray20,
          ),

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

                            style: const TextStyle(
                              color: EgovColor.gray90,

                              fontSize: 19,

                              fontFamily: 'Pretendard GOV',

                              fontWeight: FontWeight.w700,

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

                        style: const TextStyle(
                          color: EgovColor.gray70,

                          fontSize: 15,

                          fontFamily: 'Pretendard GOV',

                          fontWeight: FontWeight.w400,

                          height: 1.50,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],

                  ...details.map(
                    (detail) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        mainAxisAlignment: MainAxisAlignment.start,

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            '${detail['label']} :',

                            style: const TextStyle(
                              color: Color(0xFF1E2124),

                              fontSize: 13,

                              fontFamily: 'Pretendard GOV',

                              fontWeight: FontWeight.w700,

                              height: 1.50,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              detail['value'] ?? '',

                              style: const TextStyle(
                                color: EgovColor.gray90,

                                fontSize: 13,

                                fontFamily: 'Pretendard GOV',

                                fontWeight: FontWeight.w400,

                                height: 1.50,
                              ),

                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
