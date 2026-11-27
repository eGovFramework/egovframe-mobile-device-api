import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_scan_session_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/state/barcode_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/view/barcode_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/view/barcode_scan_page.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/view_model/barcode_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/view_model/barcode_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/widgets/barcode_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/widgets/barcode_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/widgets/barcode_permission_util.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/widgets/barcode_connection_resolver.dart';

import 'barcode_description.dart';

class BarcodePage extends ConsumerStatefulWidget {
  const BarcodePage({super.key});

  @override
  ConsumerState<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends ConsumerState<BarcodePage> {
  BarcodeMain get _notifier => ref.read(barcodeMainProvider.notifier);

  Future<void> _openScanner() async {
    final l10n = AppLocalizations.of(context)!;

    // 카메라 권한 확인
    final granted = await BarcodePermissionUtil.ensureCameraPermission();
    if (!granted) {
      if (!mounted) return;
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.barcodePermissionDenied,
      );
      return;
    }

    if (!mounted) return;

    // 스캔 성공 시 결과값 페이지에 출력
    final result = await Navigator.push<BarcodeScanSessionResult>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScanPage()),
    );

    if (result != null) {
      _notifier.applyScanResult(result);
    }
  }

  Future<void> _uploadBarcodeInfo() async {
    final l10n = AppLocalizations.of(context)!;

    if (_notifier.buildUploadInfo() == null) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.barcodeNoScanData,
      );
      return;
    }

    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.barcodeSaveTitle,
      message: l10n.barcodeSaveConfirm,
    );
    if (!confirmed || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(l10n.barcodeUploading),
            ],
          ),
        );
      },
    );

    final result = await _notifier.uploadBarcodeInfo();

    if (!mounted) return;
    Navigator.of(context).pop();

    switch (result) {
      case BarcodeUploadSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.barcodeSaveSuccess,
        );
      case BarcodeUploadFailure(:final message):
        final localizedMessage = resolveAppMessage(l10n, message);
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: localizedMessage,
        );
    }
  }

  Future<void> _navigateToList() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeListPage()),
    );
  }

  Widget _buildMainFunctionBody(BarcodeMainState mainState) {
    if (mainState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(barcodeConnectionStatusProvider.notifier).refresh();
      },
      color: EgovColor.primary50,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: BarcodeOverview(
          scan: mainState.scan,
          capturedAt: mainState.capturedAt,
          onScanTap: _openScanner,
          footer: const BarcodeConnectionBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(barcodeMainProvider);

    return FeatureShell(
      currentAppTargetPage: 'barcode',
      title: l10n.barcodeApiTitle,
      guidePage: const BarcodeFunctionPage(),
      mainFunctionBody: _buildMainFunctionBody(mainState),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.barcodeListButton,
            onServerConnected: _navigateToList,
            resolveConnection: BarcodeConnectionResolver.resolveConnection,
          ),
          ServerConnectionButtonFactory.uploadButton(
            text: l10n.barcodeSaveButton,
            onServerConnected: _uploadBarcodeInfo,
            resolveConnection: BarcodeConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }
}
