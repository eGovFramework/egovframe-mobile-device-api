import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_result.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/view_model/interface_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/widgets/interface_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/widgets/interface_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/text_form.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'interface_description.dart';
import 'interface_success.dart';

class InterfaceScreen extends ConsumerStatefulWidget {
  const InterfaceScreen({super.key});

  @override
  ConsumerState<InterfaceScreen> createState() => _InterfaceScreen();
}

class _InterfaceScreen extends ConsumerState<InterfaceScreen>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  InterfaceMain get _notifier => ref.read(interfaceMainProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSavedSession());
  }

  Future<void> _checkSavedSession() async {
    final result = await _notifier.checkSavedSession();
    if (!mounted) return;

    switch (result) {
      case InterfaceSessionValid(:final userId, :final password):
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InterfaceSuccessPage(userId: userId, userPw: password),
          ),
        );
      case InterfaceSessionExpired():
      case InterfaceSessionNone():
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _idController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await _notifier.login(
      id: _idController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (!mounted) return;

    switch (result) {
      case InterfaceLoginSuccess(:final message):
        await _showSuccessDialog(message);
        _navigateToSuccessPage();
      case InterfaceLoginFailure(:final message):
        await _showLoginErrorDialog(message);
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await _notifier.register(
      id: _idController.text.trim(),
      password: _passwordController.text.trim(),
      email: _emailController.text.trim(),
    );
    if (!mounted) return;

    switch (result) {
      case InterfaceRegisterSuccess(:final message):
        await _showSuccessDialog(message);
        _refreshPage();
      case InterfaceRegisterAccountExists(:final message):
        await _showErrorDialog(message);
      case InterfaceRegisterFailure(:final message):
        await _showErrorDialog(message);
    }
  }

  Future<void> _showSuccessDialog(String message) async {
    final l10n = AppLocalizations.of(context)!;
    await showStatusToast(
      context,
      variant: StatusVariant.success,
      title: l10n.commonSuccess,
      message: resolveAppMessage(l10n, message),
    );
  }

  Future<void> _showLoginErrorDialog(String message) async {
    final l10n = AppLocalizations.of(context)!;
    await showInfoAlert(
      context,
      title: l10n.interfaceLoginFailedTitle,
      message: resolveAppMessage(l10n, message),
      confirmText: 'OK',
      showCancel: false,
    );
  }

  Future<void> _showErrorDialog(String message) async {
    final l10n = AppLocalizations.of(context)!;
    await showInfoAlert(
      context,
      title: l10n.commonError,
      message: resolveAppMessage(l10n, message),
    );
  }

  void _refreshPage() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InterfaceScreen()),
      );
    }
  }

  void _navigateToSuccessPage() {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => InterfaceSuccessPage(
            userId: _idController.text.trim(),
            userPw: _passwordController.text.trim(),
          ),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final interfaceState = ref.watch(interfaceMainProvider);

    return FeatureShell(
      title: l10n.interfaceApiTitle,
      currentAppTargetPage: 'interface',
      guidePage: const InterfaceFunctionPage(),
      mainFunctionBody: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _idController,
                  label: l10n.interfaceUserIdLabel,
                  hintText: l10n.interfaceUserIdHint,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.interfaceUserIdRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PasswordTextFormField(
                  controller: _passwordController,
                  label: l10n.interfacePasswordLabel,
                  hintText: l10n.interfacePasswordHint,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.interfacePasswordRequired;
                    }
                    if (value.length < 6) {
                      return l10n.interfacePasswordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _emailController,
                  label: l10n.interfaceEmailLabel,
                  hintText: l10n.interfaceEmailHint,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!value.contains('@')) {
                        return l10n.interfaceEmailInvalid;
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const InterfaceConnectionBar(),
              ],
            ),
          ),
        ),
      ),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.sendButton(
            text: l10n.interfaceLoginButton,
            onServerConnected: () async {
              if (interfaceState.isLoading) return;
              await _handleLogin();
            },
            resolveConnection: InterfaceConnectionResolver.resolveConnection,
          ),
          ServerConnectionButtonFactory.sendButton(
            text: l10n.interfaceRegisterButton,
            onServerConnected: () async {
              if (interfaceState.isLoading) return;
              await _handleRegister();
            },
            resolveConnection: InterfaceConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }
}
