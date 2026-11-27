import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/application_list_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/view/interface_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/view_model/interface_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterfaceSuccessPage extends ConsumerStatefulWidget {
  final String userId;

  final String userPw;

  const InterfaceSuccessPage({
    super.key,

    required this.userId,

    required this.userPw,
  });

  @override
  ConsumerState<InterfaceSuccessPage> createState() =>
      _InterfaceSuccessPageState();
}

class _InterfaceSuccessPageState extends ConsumerState<InterfaceSuccessPage> {
  InterfaceSuccess get _notifier => ref.read(
    interfaceSuccessProvider(
      userId: widget.userId,

      userPw: widget.userPw,
    ).notifier,
  );

  void _handleLogout() {
    final l10n = AppLocalizations.of(context)!;

    showPromptDialog(
      context,

      title: l10n.interfaceLogoutTitle,

      message: l10n.interfaceLogoutConfirm,

      confirmText: l10n.interfaceLogoutButton,

      cancelText: l10n.commonCancel,

      onConfirm: _performLogout,
    );
  }

  Future<void> _performLogout() async {
    final result = await _notifier.logout();

    if (!mounted) return;

    switch (result) {
      case InterfaceLogoutSuccess(:final message):
        await _showSuccessDialog(message);
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const InterfaceScreen()),
          (route) => false,
        );
    }
  }

  Future<void> _handleWithdrawal() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showPromptDialog(
      context,

      title: l10n.interfaceWithdrawTitle,

      message: l10n.interfaceWithdrawConfirm,

      confirmText: l10n.interfaceWithdrawButton,

      cancelText: l10n.commonCancel,
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final result = await _notifier.withdraw();

    if (!mounted) return;

    switch (result) {
      case InterfaceWithdrawSuccess(:final message):
        await _showSuccessDialog(message);
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const InterfaceScreen()),
          (route) => false,
        );

      case InterfaceWithdrawFailure(:final message):
        _showErrorDialog(message);
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

  Future<void> _showErrorDialog(String message) async {
    final l10n = AppLocalizations.of(context)!;

    await showStatusToast(
      context,

      variant: StatusVariant.error,

      title: l10n.commonError,

      message: resolveAppMessage(l10n, message),
    );
  }

  void _navigateToApplicationList() {
    final l10n = AppLocalizations.of(context)!;

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (context) =>
            ApplicationListMain(title: l10n.applicationListTitle),
      ),

      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final successState = ref.watch(
      interfaceSuccessProvider(userId: widget.userId, userPw: widget.userPw),
    );

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.interface,

      title: l10n.interfaceSuccessApiTitle,

      appBarBuilder: (_) {
        return CustomAppBar(
          title: l10n.interfaceSuccessApiTitle,

          hideHomeButton: true,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: EgovColor.white100),

            onPressed: _navigateToApplicationList,
          ),
        );
      },

      mainFunctionBody: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              InfoBox(text: l10n.interfaceLoginSuccessInfo),

              const SizedBox(height: 16),

              successState.isDataLoading
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
                          Text(
                            l10n.interfaceUserInfoTitle,

                            style: TextStyle(
                              fontSize: 18,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          _buildInfoRow(
                            l10n.interfaceUserInfoId,

                            successState.userInfo['userId'] ?? widget.userId,
                          ),

                          const SizedBox(height: 12),

                          _buildInfoRow(
                            l10n.interfaceUserInfoPassword,
                            '••••••',
                          ),

                          const SizedBox(height: 12),

                          _buildInfoRow(
                            l10n.interfaceUserInfoEmail,
                            successState.userInfo['emails'] ??
                                l10n.interfaceUserInfoUnavailable,
                          ),

                          if (successState.userInfo['uuid'] != null) ...[
                            const SizedBox(height: 12),

                            _buildInfoRow(
                              l10n.interfaceUserInfoUuid,

                              successState.userInfo['uuid'],
                            ),
                          ],
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),

      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.interfaceLogoutButton,

            onTap: _handleLogout,

            icon: const Icon(Icons.logout, color: EgovColor.white100, size: 20),
          ),

          CustomButton(
            text: l10n.interfaceWithdrawButton,

            onTap: successState.isLoading ? null : _handleWithdrawal,

            icon: successState.isLoading
                ? const SizedBox(
                    width: 20,

                    height: 20,

                    child: CircularProgressIndicator(
                      strokeWidth: 2,

                      valueColor: AlwaysStoppedAnimation<Color>(
                        EgovColor.white100,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person_remove,

                    color: EgovColor.white100,

                    size: 20,
                  ),
          ),
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

            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),

        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
