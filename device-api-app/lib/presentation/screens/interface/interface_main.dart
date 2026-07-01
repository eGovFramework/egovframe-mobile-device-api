import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/interface_credential_storage.dart';
import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface_input_validator.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/interface_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/textForm.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/password_encryption.dart';
import 'package:flutter/material.dart';

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
  late final InterfaceUseCase _interfaceUseCase;
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

    dynamic userInfo = '';

  @override
  void initState(){
    super.initState();
    _interfaceUseCase = getIt<InterfaceUseCase>();
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
    final session = await InterfaceCredentialStorage.readSession();

    if (session != null) {
      bool isSessionValid = true;

      if (session.loginTime != null) {
        final now = DateTime.now();
        if (now.difference(session.loginTime!) > AppConfig.sessionTimeout) {
          isSessionValid = false;
          await InterfaceCredentialStorage.clear();
        }
      }

      if (isSessionValid && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InterfaceSuccessPage(
              userId: session.userId,
              userPw: session.hashedPassword,
              isPasswordHashed: true,
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
      final result = await _interfaceUseCase.login(
        _idController.text.trim(),
        _passwordController.text.trim(),
      );

      if (result['success'] && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final interfaceInfo = data['interfaceInfo'];
        
        if (interfaceInfo == null) {
          await ErrorHandler.showErrorDialog(context, '아이디 또는 비밀번호가 올바르지 않습니다.');
          return;
        }
        
        // flutter_secure_storage에 해시된 비밀번호 저장
        await InterfaceCredentialStorage.save(
          _idController.text.trim(),
          _passwordController.text.trim(),
        );
        
        await _showSuccessDialog('로그인 성공');
        if (mounted) {
          _navigateToSuccessPage();
        }
      } else {
        await ErrorHandler.showErrorDialog(context, result['message'] ?? '로그인에 실패했습니다.');
      }
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'InterfacePage._handleLogin',
        );
      }
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

    final emailError = InterfaceInputValidator.validateEmail(
      _emailController.text,
      required: true,
    );
    if (emailError != null) {
      await ErrorHandler.showErrorDialog(context, emailError);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 먼저 계정 존재 여부 확인
      final accountExists = await _interfaceUseCase.checkAccountExists(
        _idController.text.trim(),
        _passwordController.text.trim(),
        _emailController.text.trim(),
      );

      if (accountExists) {
        await ErrorHandler.showErrorDialog(context, '이미 존재하는 계정입니다. 로그인을 진행하세요.');
        return;
      }

      // 계정이 없으면 회원가입 진행
      final result = await _interfaceUseCase.register(
        _idController.text.trim(),
        _passwordController.text.trim(),
        _emailController.text.trim(),
      );

      if (result['success']) {
        await InterfaceCredentialStorage.save(
          _idController.text.trim(),
          _passwordController.text.trim(),
        );
        
        _showSuccessDialog('회원가입이 완료되었습니다.');
        _refreshPage();
      } else {
        await ErrorHandler.showErrorDialog(context, '회원가입에 실패했습니다: ${result['message']}');
      }
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'InterfacePage._handleRegister',
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
    final session = await InterfaceCredentialStorage.readSession();
    final hashedPassword = session?.hashedPassword ??
        PasswordEncryption.encryptPassword(
          _passwordController.text.trim(),
          session?.userId ?? _idController.text.trim(),
        );

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => InterfaceSuccessPage(
            userId: session?.userId ?? _idController.text.trim(),
            userPw: hashedPassword,
            isPasswordHashed: true,
          ),
        ),
        (route) => route.isFirst,
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  controller: _idController,
                                  label: '사용자 ID',
                                  hintText: 'ID를 입력하세요',
                                  maxLength: InterfaceInputValidator.userIdMaxLength,
                                  validator: InterfaceInputValidator.validateUserId,
                                ),
                                const SizedBox(height: 16),
                                PasswordTextFormField(
                                  controller: _passwordController,
                                  label: '비밀번호',
                                  hintText: '비밀번호를 입력하세요',
                                  maxLength: InterfaceInputValidator.userPwMaxLength,
                                  validator: InterfaceInputValidator.validateUserPw,
                                ),
                                const SizedBox(height: 16),
                                CustomTextFormField(
                                  controller: _emailController,
                                  label: '이메일',
                                  hintText: '이메일을 입력하세요',
                                  keyboardType: TextInputType.emailAddress,
                                  maxLength: InterfaceInputValidator.emailMaxLength,
                                  validator: (value) => InterfaceInputValidator.validateEmail(
                                    value,
                                    required: false,
                                  ),
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
