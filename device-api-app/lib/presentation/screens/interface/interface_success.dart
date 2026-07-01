import 'package:egovframe_mobile_deviceapi_app/data/datasources/interface_credential_storage.dart';
import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/interface_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';

import '../../screens/application_list_main.dart';
import 'interface_description.dart';
import 'interface_main.dart';

class InterfaceSuccessPage extends StatefulWidget {
  final String userId;
  final String userPw;
  final bool isPasswordHashed;

  const InterfaceSuccessPage({
    super.key,
    required this.userId,
    required this.userPw,
    this.isPasswordHashed = false,
  });

  @override
  State<InterfaceSuccessPage> createState() => _InterfaceSuccessPageState();
}

class _InterfaceSuccessPageState extends State<InterfaceSuccessPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final InterfaceUseCase _interfaceUseCase;
  late TabController _tabController;
  bool _isLoading = false;
  bool _isDataLoading = true;
  Map<String, dynamic> _userInfo = {};

  @override
  void initState() {
    super.initState();
    _interfaceUseCase = getIt<InterfaceUseCase>();
    WidgetsBinding.instance.addObserver(this);

    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {}); // 탭 변경 시 UI 업데이트
      }
    });
    
    // 사용자 정보 조회
    _loadUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  // 사용자 정보 로드
  Future<void> _loadUserInfo() async {
    try {
      final result = await _interfaceUseCase.getUserInfo(
        widget.userId,
        widget.userPw,
        isPasswordHashed: widget.isPasswordHashed,
      );

      if (result['success']) {
        setState(() {
          _userInfo = result['data'] ?? {};
          _isDataLoading = false;
        });
      } else {
        setState(() {
          _isDataLoading = false;
        });
        await ErrorHandler.showErrorDialog(context, '사용자 정보를 불러올 수 없습니다: ${result['message'] ?? '알 수 없는 오류'}');
      }
    } catch (e, stackTrace) {
      setState(() {
        _isDataLoading = false;
      });
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'InterfaceSuccessPage._loadUserInfo',
        );
      }
    }
  }

  // 로그아웃 기능
  void _handleLogout() {
    showPromptDialog(
      context,
      title: '로그아웃',
      message: '로그아웃 하시겠습니까?',
      confirmText: '로그아웃',
      cancelText: '취소',
      onConfirm: _performLogout,
    );
  }

  // 실제 로그아웃
  Future<void> _performLogout() async {
    await InterfaceCredentialStorage.clear();
    
    await _showSuccessDialog('로그아웃되었습니다.');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const InterfaceScreen(),
        ),
        (route) => false, // 모든 이전 페이지 제거
      );
    }
  }

  // 회원탈퇴 기능
  Future<void> _handleWithdrawal() async {
    final bool? confirmed = await showPromptDialog(
      context,
      title: '회원탈퇴',
      message: '정말로 회원탈퇴를 진행하시겠습니까?\n이 작업은 되돌릴 수 없습니다.',
      confirmText: '탈퇴',
      cancelText: '취소',
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _interfaceUseCase.withdraw(
        widget.userId,
        widget.userPw,
        isPasswordHashed: widget.isPasswordHashed,
      );

      if (result['success']) {
        await InterfaceCredentialStorage.clear();
        
        await _showSuccessDialog('회원탈퇴가 완료되었습니다.');
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const InterfaceScreen(),
            ),
            (route) => false, // 모든 이전 페이지 제거
          );
        }
      } else {
        await ErrorHandler.showErrorDialog(context, '회원탈퇴에 실패했습니다: ${result['message']}');
      }
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'InterfaceSuccessPage._handleWithdrawal',
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showSuccessDialog(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.success,
      title: '성공',
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: 'Interface (Success) API',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
          onPressed: () {
            if (mounted) {
              // 로그인 성공 후에는 항상 메인 화면으로 이동
              // 로그인 페이지로 돌아가지 않도록 함
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ApplicationListMain(
                    title: 'MobileDevice API Application List',
                  ),
                ),
                (route) => route.isFirst, // 첫 번째 화면(메인 화면)까지만 유지
              );
            }
          },
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
                const InterfaceFunctionPage(),
                // 주요기능 탭
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const InfoBox(text: '로그인 성공! 사용자 정보를 확인할 수 있습니다.'),
                        const SizedBox(height: 16),
                        // 사용자 정보 표시
                        _isDataLoading
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: EgovColor.gray30),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '사용자 정보',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow('사용자 ID', _userInfo['userId'] ?? widget.userId),
                                    const SizedBox(height: 12),
                                    _buildInfoRow('비밀번호', '••••••••'),
                                    const SizedBox(height: 12),
                                    _buildInfoRow('이메일', _userInfo['emails'] ?? '정보 없음'),
                                    if (_userInfo['uuid'] != null) ...[
                                      const SizedBox(height: 12),
                                      _buildInfoRow('UUID', _userInfo['uuid']),
                                    ],
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                // 라이센스 탭
                const License(),
              ],
            ),
          ),
          if (_tabController.index == 1)
            BottomButtonRow(
              buttons: [
                CustomButton(
                  text: '로그아웃',
                  onTap: _handleLogout,
                  icon: const Icon(
                    Icons.logout,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
                CustomButton(
                  text: '회원탈퇴',
                  onTap: _isLoading ? null : _handleWithdrawal,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(EgovColor.white100),
                          ),
                        )
                      : const Icon(
                          Icons.person_remove,
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
