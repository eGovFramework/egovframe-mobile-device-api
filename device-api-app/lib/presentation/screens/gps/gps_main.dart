import 'dart:async';

import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/gps_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/gps_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/gps_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/gps_location_display.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/minimal_map_widget.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GpsMainPage extends StatefulWidget {
  const GpsMainPage({super.key});

  @override
  State<GpsMainPage> createState() => _GpsMainPageState();
}

class _GpsMainPageState extends State<GpsMainPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Position? _currentPosition;
  String _statusMessage = 'GPS 기능을 사용하여 현재 위치를 확인할 수 있습니다.';
  bool _isLoading = false;
  List<GpsInfo> _gpsInfoList = [];
  String _deviceUuid = '';

  // Use Cases
  late final GpsUseCase _gpsUseCase;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    _gpsUseCase = getIt<GpsUseCase>();
    _initializeDeviceUuid();
    // 권한 요청
    _requestLocationPermissionOnStart();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 디바이스 UUID 초기화
  Future<void> _initializeDeviceUuid() async {
    _deviceUuid = await DeviceIdService.getDeviceId();
    _loadGpsInfoList();
  }

  /// 권한 요청
  Future<void> _requestLocationPermissionOnStart() async {
    try {
      // 권한 관리자를 통해 위치 권한 요청
      final permissionStatus =
          await PermissionManager.requestLocationPermission();

      switch (permissionStatus) {
        case PermissionStatus.granted:
          setState(() {
            _statusMessage = 'GPS 모드가 활성화되었습니다. 위치를 가져오려면 버튼을 눌러주세요.';
          });
          break;
        case PermissionStatus.denied:
          setState(() {
            _statusMessage = '위치 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.';
          });
          break;
        case PermissionStatus.permanentlyDenied:
          setState(() {
            _statusMessage = '위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.';
          });
          break;
        default:
          setState(() {
            _statusMessage = '위치 권한 상태를 확인할 수 없습니다.';
          });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'GPS 초기화 중 오류가 발생했습니다: $e';
      });
    }
  }

  /// 현재 위치 호출
  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // 권한 확인
      final permissionStatus =
          await PermissionManager.requestLocationPermission();

      if (permissionStatus != PermissionStatus.granted) {
        setState(() {
          _statusMessage = PermissionManager.getPermissionMessage(
            permissionStatus,
            '위치',
          );
        });

        if (permissionStatus == PermissionStatus.permanentlyDenied) {
          await PermissionManager.showPermissionSettingsDialog(context, '위치');
        }
        return;
      }

      // 현재 위치 호출
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      setState(() {
        _currentPosition = position;
      });

      if (!mounted) return;
      // await showStatusDialog(
      //   context,
      //   variant: StatusVariant.success,
      //   title: '현재 위치',
      //   message:
      //       '위도: ${position.latitude.toStringAsFixed(6)}\n경도: ${position.longitude.toStringAsFixed(6)}',
      // );
    } catch (e) {
      if (mounted) {
        await showStatusDialog(
          context,
          variant: StatusVariant.error,
          title: '오류',
          message: '위치 가져오기 실패: $e',
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 현재 GPS 정보를 저장
  Future<void> _saveCurrentGpsInfo() async {
    if (_currentPosition == null) {
      _showErrorDialog('저장할 위치 정보가 없습니다. 먼저 위치를 가져와주세요.');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _statusMessage = 'GPS 정보를 저장하는 중...';
      });

      final gpsInfo = GpsInfo(
        uuid: _deviceUuid,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        altitude: _currentPosition!.altitude,
        accrcy: _currentPosition!.accuracy,
        timestamp: _currentPosition!.timestamp,
      );

      // Use Case를 통해 GPS 정보 저장
      final success = await _gpsUseCase.saveGpsInfo(gpsInfo);

      if (success) {
        setState(() {
          _statusMessage = 'GPS 정보가 저장되었습니다.';
          _gpsInfoList.insert(0, gpsInfo);
        });
        _showSuccessDialog('GPS 정보가 성공적으로 저장되었습니다.');
      } else {
        setState(() {
          _statusMessage = 'GPS 정보 저장에 실패했습니다.';
        });
        _showErrorDialog('GPS 정보 저장에 실패했습니다.');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'GPS 정보 저장 중 오류가 발생했습니다: $e';
      });
      _showErrorDialog('GPS 정보 저장 중 오류가 발생했습니다: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// GPS 정보 목록 호출
  Future<void> _loadGpsInfoList() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (_deviceUuid.isNotEmpty) {
        _gpsInfoList = await _gpsUseCase.getGpsInfoList(_deviceUuid);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _gpsInfoList = [];
      });
    }
  }

  /// 오류 다이얼로그
  Future<void> _showErrorDialog(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.error,
      title: '오류',
      message: message,
    );
  }

  /// 성공 다이얼로그
  Future<void> _showSuccessDialog(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.success,
      title: '성공',
      message: message,
    );
  }

  /// Timestamp를 로컬 시간으로 포맷
  String _formatTimestamp(DateTime timestamp) {
    // UTC 시간인 경우 로컬 시간으로 변환
    final localTime = timestamp.isUtc ? timestamp.toLocal() : timestamp.add(Duration(hours: 9));
    return '${localTime.year}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')} ${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
  }

  /// GPS 정보를 삭제
  Future<void> _deleteGpsInfo(int index) async {
    try {
      setState(() {
        _gpsInfoList.removeAt(index);
        _statusMessage = 'GPS 정보가 삭제되었습니다.';
      });
      await _showSuccessDialog('GPS 정보가 삭제되었습니다.');
      // 삭제 후 목록 다시 로드
      if (mounted) {
        await _loadGpsInfoList();
      }
    } catch (e) {
      _showErrorDialog('GPS 정보 삭제 중 오류가 발생했습니다: $e');
    }
  }

  /// 모든 GPS 정보를 삭제
  Future<void> _clearAllGpsInfo() async {
    try {
      setState(() {
        _gpsInfoList.clear();
        _statusMessage = '모든 GPS 정보가 삭제되었습니다.';
      });
      await _showSuccessDialog('모든 GPS 정보가 삭제되었습니다.');
      // 삭제 후 목록 다시 로드
      if (mounted) {
        await _loadGpsInfoList();
      }
    } catch (e) {
      _showErrorDialog('GPS 정보 삭제 중 오류가 발생했습니다: $e');
    }
  }

  /// GPS 정보를 서버에 업로드
  Future<bool> _uploadGpsInfoToServer() async {
    try {
      if (_gpsInfoList.isEmpty) {
        _showErrorDialog('업로드할 GPS 정보가 없습니다.');
        return false;
      }

      // 서버 업로드 로직 (실제 구현 필요)
      await Future.delayed(const Duration(seconds: 2)); // 시뮬레이션

      setState(() {
        _statusMessage = 'GPS 정보가 서버에 업로드되었습니다.';
      });

      return true;
    } catch (e) {
      _showErrorDialog('서버 업로드 중 오류가 발생했습니다: $e');
      return false;
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
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // 수평 스와이프 비활성화
              children: [
                // 기능설명 탭
                const GpsFunctionPage(),
                // 주요기능 탭
                _buildMainFunctionTab(),
                // 라이선스 탭
                const License(),
              ],
            ),
          ),
          if (_tabController.index == 1)
            BottomButtonRow(
              buttons: [
                CustomButton(
                  text: '서버 목록',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GpsListPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.list,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
                ServerConnectionButtonFactory.uploadButton(
                  text: '저장',
                  onServerConnected: () async => _saveCurrentGpsInfo(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// 주요기능
  Widget _buildMainFunctionTab() {
    return Column(
      children: [
        // 상단 정보 박스
        Padding(
          padding: const EdgeInsets.all(16),
          child: InfoBox(text: 'GPS 기능을 통해 현재 위치 정보를 실시간으로 조회, 저장할 수 있습니다.'),
        ),
        Stack(
          children: [
            MinimalMapWidget(
              initialLatitude: _currentPosition?.latitude,
              initialLongitude: _currentPosition?.longitude,
              currentPosition: _currentPosition, // 현재 위치 전달
              initialZoom: 15.0,
              onLocationChanged: (Position position) async {
                setState(() {
                  _currentPosition = position;
                });
                if (!mounted) return;
                // await showStatusDialog(
                //   context,
                //   variant: StatusVariant.success,
                //   title: '현재 위치',
                //   message: '현재 위치가 업데이트되었습니다.',
                // );
              },
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: _isLoading ? null : _getCurrentLocation,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: EgovColor.primary50,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: EgovColor.black25,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: EgovColor.white100,
                              ),
                            )
                          : const Icon(
                              Icons.my_location,
                              color: EgovColor.white100,
                              size: 22,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 현재 위치 정보 표시
                  GpsLocationDisplay(
                    position: _currentPosition,
                    timestamp: _currentPosition
                        ?.timestamp
                        .add(Duration(hours: 9))
                        .millisecondsSinceEpoch
                        .toString(),
                  ),

                  const SizedBox(height: 20),

                  // GPS 정보
                  if (_gpsInfoList.isNotEmpty) ...[
                    const Text(
                      '저장된 GPS 정보',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: EgovColor.white100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('위도')),
                        DataColumn(label: Text('경도')),
                        DataColumn(label: Text('정확도')),
                        DataColumn(label: Text('고도')),
                        DataColumn(label: Text('시간')),
                        DataColumn(label: Text('삭제')),
                      ],
                      rows: _gpsInfoList.asMap().entries.map((entry) {
                        final index = entry.key;
                        final gpsInfo = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text(gpsInfo.latitude.toStringAsFixed(6))),
                            DataCell(
                              Text(gpsInfo.longitude.toStringAsFixed(6)),
                            ),
                            DataCell(
                              Text(gpsInfo.accrcy?.toStringAsFixed(1) ?? 'N/A'),
                            ),
                            DataCell(
                              Text(
                                gpsInfo.altitude?.toStringAsFixed(1) ?? 'N/A',
                              ),
                            ),
                            DataCell(Text(_formatTimestamp(gpsInfo.timestamp))),
                            DataCell(
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: EgovColor.danger50,
                                ),
                                onPressed: () => _deleteGpsInfo(index),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          text: '전체 삭제',
                          onTap: _clearAllGpsInfo,
                          icon: const Icon(
                            Icons.delete_forever,
                            color: EgovColor.white100,
                            size: 20,
                          ),
                        ),
                        ServerConnectionButtonFactory.uploadButton(
                          text: '서버 업로드',
                          onServerConnected: () async =>
                              _uploadGpsInfoToServer(),
                          errorTitle: '서버 연결 오류',
                          errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                        ),
                      ],
                    ),
                  ] else ...[
                    const Text(
                      '저장된 GPS 정보가 없습니다.',
                      style: TextStyle(fontSize: 16, color: EgovColor.black0),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
