import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/interface_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/textForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../screens/application_list_main.dart';
import 'interface_description.dart';
import 'interface_success.dart';

class InterfaceScreen extends StatefulWidget{
  const InterfaceScreen({super.key});

  @override
  State<InterfaceScreen> createState() => _InterfaceScreen();
}

class _InterfaceScreen extends State<InterfaceScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver{
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  static final storage = FlutterSecureStorage();
    dynamic userInfo = '';

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if(mounted){
        setState(() {}); // 탭 변경 시 UI 업데이트
      }
    });
  }

  _asyncMethod() async {
    final loginStatus = await storage.read(key: 'login');
    final savedUserId = await storage.read(key: 'userId');
    final savedPassword = await storage.read(key: 'password');
    final loginTimeStr = await storage.read(key: 'loginTime');

    if (loginStatus != null && savedUserId != null && savedPassword != null) {
      // 세션 만료 시간 확인
      bool isSessionValid = true;
      
      if (loginTimeStr != null) {
        try {
          final loginTime = DateTime.parse(loginTimeStr);
          final now = DateTime.now();
          
          if (now.difference(loginTime) > AppConfig.sessionTimeout) {
            // 세션이 만료되었으면 저장된 정보 삭제
            isSessionValid = false;
            await storage.delete(key: 'login');
            await storage.delete(key: 'userId');
            await storage.delete(key: 'password');
            await storage.delete(key: 'loginTime');
          }
        } catch (e) {
          print('세션 시간 파싱 오류: $e');
          isSessionValid = false;
        }
      }
      
      // 세션이 유효하면 자동으로 성공 페이지로 이동
      if (isSessionValid && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InterfaceSuccessPage(
              userId: savedUserId,
              userPw: savedPassword,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 로그인 기능
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await InterfaceService.login(
        _idController.text.trim(),
        _passwordController.text.trim(),
      );

      if (result['success'] && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final interfaceInfo = data['interfaceInfo'];
        
        if (interfaceInfo == null) {
          _showErrorDialog('아이디 또는 비밀번호가 올바르지 않습니다.');
          return;
        }
        
        // flutter_secure_storage에 평문 비밀번호 저장
        final now = DateTime.now();
        await storage.write(key: 'password', value: _passwordController.text.trim());
        await storage.write(key: 'userId', value: _idController.text.trim());
        await storage.write(key: 'login', value: 'true');
        await storage.write(key: 'loginTime', value: now.toIso8601String());
        
        await _showSuccessDialog('로그인 성공');
        if (mounted) {
          _navigateToSuccessPage();
        }
      } else {
        _showErrorDialog(result['message'] ?? '로그인에 실패했습니다.');
      }
    } catch (e) {
      _showErrorDialog('오류가 발생했습니다: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 회원가입 기능
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 먼저 계정 존재 여부 확인
      final accountExists = await InterfaceService.checkAccountExists(
        _idController.text.trim(),
        _passwordController.text.trim(),
        _emailController.text.trim(),
      );

      if (accountExists) {
        _showErrorDialog('이미 존재하는 계정입니다. 로그인을 진행하세요.');
        return;
      }

      // 계정이 없으면 회원가입 진행
      final result = await InterfaceService.register(
        _idController.text.trim(),
        _passwordController.text.trim(),
        _emailController.text.trim(),
      );

      if (result['success']) {
        final now = DateTime.now();
        await storage.write(key: 'password', value: _passwordController.text.trim());
        await storage.write(key: 'userId', value: _idController.text.trim());
        await storage.write(key: 'login', value: 'true');
        await storage.write(key: 'loginTime', value: now.toIso8601String());
        
        _showSuccessDialog('회원가입이 완료되었습니다.');
        _refreshPage();
      } else {
        _showErrorDialog('회원가입에 실패했습니다: ${result['message']}');
      }
    } catch (e) {
      _showErrorDialog('오류가 발생했습니다: $e');
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

  Future<void> _showErrorDialog(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.error,
      title: '오류',
      message: message,
    );
  }

// 새로고침
  void _refreshPage() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InterfaceScreen(),
        ),
      );
    }
  }

  void _navigateToSuccessPage() async {
    final savedPassword = await storage.read(key: 'password');
    final savedUserId = await storage.read(key: 'userId');
    
    if (mounted) {
      // 현재 화면(로그인 페이지)을 제거하고 성공 페이지로 이동
      // 첫 번째 화면(메인 화면)만 유지하고 나머지는 모두 제거
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => InterfaceSuccessPage(
            userId: savedUserId ?? _idController.text.trim(),
            userPw: savedPassword ?? _passwordController.text.trim(),
          ),
        ),
        (route) => route.isFirst, // 첫 번째 화면(메인 화면)만 유지
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
          title: 'Interface (Login) API',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
          onPressed: () {
            if (mounted) {
              if (Navigator.canPop(context)) {
                Navigator.maybePop(context);
              } else {
                // 뒤로 갈 수 없으면 홈으로 이동
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApplicationListMain(
                      title: 'MobileDevice API Application List',
                    ),
                  ),
                  (route) => false,
                );
              }
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
                  //기능설명
                  const InterfaceFunctionPage(),
                  // 주요기능
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          InfoBox(text: '로그인 기능을 하는 인터페이스'),
                          const SizedBox(height: 16),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  controller: _idController,
                                  label: '사용자 ID',
                                  hintText: 'ID를 입력하세요',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'ID를 입력해주세요';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                PasswordTextFormField(
                                  controller: _passwordController,
                                  label: '비밀번호',
                                  hintText: '비밀번호를 입력하세요',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '비밀번호를 입력해주세요';
                                    }
                                    if (value.length < 6) {
                                      return '비밀번호는 6자 이상이어야 합니다';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextFormField(
                                  controller: _emailController,
                                  label: '이메일',
                                  hintText: '이메일을 입력하세요',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (!value.contains('@')) {
                                        return '올바른 이메일 형식을 입력해주세요';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // 라이센스
                  const License(),
                ],
              )
          ),
          if (_tabController.index == 1)
            BottomButtonRow(
              buttons: [
                ServerConnectionButtonFactory.sendButton(
                  text: '로그인',
                  onServerConnected: () async => _handleLogin(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                ),
                ServerConnectionButtonFactory.sendButton(
                  text: '회원가입',
                  onServerConnected: () async => _handleRegister(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
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
