import 'package:egovframe_mobile_deviceapi_app/data/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/network_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/network_detail.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:flutter/material.dart';

import 'network_description.dart';

class NetworkListScreen extends StatefulWidget {
  const NetworkListScreen({super.key});

  @override
  State<NetworkListScreen> createState() => _NetworkListScreenState();
}

class _NetworkListScreenState extends State<NetworkListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NetworkService _networkService = NetworkService();
  final NetworkRepository _networkRepository = getIt<NetworkRepository>();
  
  List<NetworkInfo> _networkInfoList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {}); // 탭 변경 시 UI 업데이트
      }
    });
    _loadNetworkInfoList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 네트워크 정보 목록 로드
  Future<void> _loadNetworkInfoList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final uuid = await _networkService.getDeviceId();
      final networkInfoList = await _networkRepository.getNetworkInfoList(uuid: uuid);
      if (mounted) {
        setState(() {
          _networkInfoList = networkInfoList.cast<NetworkInfo>();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '네트워크 정보 목록 조회 오류: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// 네트워크 정보 삭제
  Future<void> _deleteNetworkInfo(NetworkInfo networkInfo) async {
    try {
      final success = await _networkRepository.deleteNetworkInfo(sn: networkInfo.sn ?? '');
      if (success) {
        showStatusDialog(
          context,
          variant: StatusVariant.success,
          title: '성공',
          message: '네트워크 정보가 삭제되었습니다.',
        );
        await _loadNetworkInfoList(); // 목록 새로고침
      } else {
        _showErrorDialog('네트워크 정보 삭제에 실패했습니다.');
      }
    } catch (e) {
      _showErrorDialog('네트워크 정보 삭제 오류: $e');
    }
  }

  /// 오류 다이얼로그 표시
  Future<void> _showErrorDialog(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.error,
      title: '오류',
      message: message,
    );
  }

  /// 네트워크 정보 카드 위젯
  Widget _buildNetworkInfoCard(NetworkInfo networkInfo) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NetworkDetailPage(networkInfo: networkInfo),
          ),
        );
        
        if (result == true) {
          setState(() {
            _isLoading = true;
            _errorMessage = '';
          });
          _loadNetworkInfoList();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: EgovColor.white100,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: EgovColor.gray20,
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
                              '${networkInfo.networkTypeName}',
                              style: const TextStyle(
                                color: EgovColor.gray90,
                                fontSize: 19,
                                fontFamily: 'Pretendard GOV',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: EgovColor.gray40,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('SN', networkInfo.sn ?? ''),
                    _buildDetailRow('디바이스 ID', networkInfo.deviceId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 상세 정보 행 위젯
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label :',
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
              value,
              style: const TextStyle(
                color: Color(0xFF1E2124),
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
          // 주요기능 탭에서만 버튼 표시
          if (_tabController.index == 1)
            BottomButtonRow(
              buttons: [
                CustomButton(
                  text: '새로고침',
                  onTap: () {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = '';
                    });
                    _loadNetworkInfoList();
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

  /// 주요기능 탭 내용
  Widget _buildMainFunctionTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                InfoBox(
                  text: '서버에 저장된 네트워크 정보들의 리스트를 조회합니다.',
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, size: 64, color: EgovColor.danger50),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage,
                                style: EgovText.regular.copyWith(color: EgovColor.danger50),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                    _errorMessage = '';
                                  });
                                  _loadNetworkInfoList();
                                },
                                child: const Text('다시 시도'),
                              ),
                            ],
                          ),
                        )
                      : _networkInfoList.isEmpty
                          ? Center(
                              child: Text(
                                '저장된 네트워크 정보가 없습니다.',
                                style: EgovText.regular.copyWith(color: EgovColor.gray40),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadNetworkInfoList,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: _networkInfoList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildNetworkInfoCard(_networkInfoList[index]),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          );
  }
}
