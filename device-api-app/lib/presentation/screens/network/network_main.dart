import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/network_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/network_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:flutter/material.dart';

import 'network_description.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NetworkService _networkService = NetworkService();
  final NetworkRepository _networkRepository = getIt<NetworkRepository>();
  
  NetworkInfo? _currentNetworkInfo;
  bool _isLoading = false;
  bool _isConnected = false;
  String _networkQuality = '확인 중...';
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {}); // 탭 변경 시 UI 업데이트
      }
    });
    _initializeNetwork();
    _setupConnectivityListener();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  /// 네트워크 초기화
  Future<void> _initializeNetwork() async {
    setState(() => _isLoading = true);
    
    try {
      await _getCurrentNetworkInfo();
      await _checkNetworkQuality();
    } catch (e) {
      _showErrorDialog('네트워크 초기화 오류: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 네트워크 연결 상태 변경 감지
  void _setupConnectivityListener() {
    _connectivitySubscription = _networkService.connectivityStream.listen(
      (ConnectivityResult result) {
        setState(() {
          _isConnected = result != ConnectivityResult.none;
        });
        
        if (_isConnected) {
          _getCurrentNetworkInfo();
          _checkNetworkQuality();
        }
      },
    );
  }

  /// 현재 네트워크 정보 가져오기
  Future<void> _getCurrentNetworkInfo() async {
    try {
      final networkInfo = await _networkService.getCurrentNetworkInfo();
      final isAvailable = await _networkService.isNetworkAvailable();
      
      setState(() {
        _currentNetworkInfo = networkInfo;
        _isConnected = isAvailable;
      });
    } catch (e) {
      debugPrint('현재 네트워크 정보 가져오기 오류: $e');
    }
  }


  /// 네트워크 품질 확인
  Future<void> _checkNetworkQuality() async {
    try {
      final quality = await _networkService.getNetworkQuality();
      setState(() {
        _networkQuality = quality;
      });
    } catch (e) {
      debugPrint('네트워크 품질 확인 오류: $e');
      setState(() {
        _networkQuality = '알 수 없음';
      });
    }
  }

  /// 네트워크 정보를 서버에 전송
  Future<void> _sendNetworkInfoToServer() async {
    if (_currentNetworkInfo == null) {
      _showErrorDialog('현재 네트워크 정보를 가져올 수 없습니다.');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final success = await _networkRepository.sendNetworkInfo(_currentNetworkInfo!);
      
      if (success) {
        if (mounted) {
          showStatusDialog(
            context,
            variant: StatusVariant.success,
            title: '성공',
            message: '네트워크 정보가 서버에 저장되었습니다.',
          );
        }
      } else {
        _showErrorDialog('네트워크 정보 전송에 실패했습니다.');
      }
    } catch (e) {
      _showErrorDialog('네트워크 정보 전송 중 오류가 발생했습니다: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 네트워크 목록 화면으로 이동
  void _navigateToNetworkList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NetworkListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: 'Network API',
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
                const NetworkFunctionPage(),
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
                ServerConnectionButtonFactory.listButton(
                  text: '목록',
                  onServerConnected: () async => _navigateToNetworkList(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 네트워크 목록을 다시 시도해주세요.',
                ),
                ServerConnectionButtonFactory.sendButton(
                  text: '정보 전송',
                  onServerConnected: () async => _sendNetworkInfoToServer(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 네트워크 정보 전송을 다시 시도해주세요.',
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

  /// 주요기능 탭 내용
  Widget _buildMainFunctionTab() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: _initializeNetwork,
            color: EgovColor.primary50,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoBox(
                    text: '네트워크 상태를 체크하고 정보를 서버에 저장할 수 있습니다. 실시간으로 네트워크 상태가 모니터링됩니다.',
                  ),
                  const SizedBox(height: 24),
                  
                  // 현재 네트워크 상태
                  _buildCurrentNetworkStatus(),
                ],
              ),
            ),
          );
  }

  /// 현재 네트워크 상태 위젯
  Widget _buildCurrentNetworkStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isConnected ? EgovColor.success5 : EgovColor.danger5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isConnected ? EgovColor.success50 : EgovColor.danger50,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isConnected ? EgovColor.success50 : EgovColor.danger50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  color: EgovColor.white100,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 네트워크 상태',
                      style: EgovText.captionBold,
                    ),
                    Text(
                      _isConnected ? '연결됨' : '연결 안됨',
                      style: EgovText.title.copyWith(
                        color: _isConnected ? EgovColor.success60 : EgovColor.danger60,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: EgovColor.white100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: EgovColor.gray20),
                ),
                child: Text(
                  _networkQuality,
                  style: EgovText.caption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          if (_currentNetworkInfo != null) ...[
            const SizedBox(height: 16),
            Divider(color: EgovColor.gray20),
            const SizedBox(height: 16),
            
            _buildNetworkInfoRow('네트워크 타입', 
                '${NetworkInfo.getNetworkIcon(_currentNetworkInfo!.networkType)} ${_currentNetworkInfo!.networkTypeName}'),
            _buildNetworkInfoRow('디바이스', _currentNetworkInfo!.deviceName),
            if (_currentNetworkInfo!.ipAddress != null)
              _buildNetworkInfoRow('IP 주소', _currentNetworkInfo!.ipAddress!),
            if (_currentNetworkInfo!.ssid != null)
              _buildNetworkInfoRow('WiFi SSID', _currentNetworkInfo!.ssid!),
          ],
        ],
      ),
    );
  }

  /// 네트워크 정보 행 위젯
  Widget _buildNetworkInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: EgovText.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: EgovText.caption,
            ),
          ),
        ],
      ),
    );
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
}
