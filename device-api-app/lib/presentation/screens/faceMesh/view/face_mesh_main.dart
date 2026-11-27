import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/state/face_mesh_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view/face_mesh_camera_page.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view/face_mesh_description.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view/face_mesh_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view_model/face_mesh_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view_model/face_mesh_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/widgets/face_mesh_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/widgets/face_mesh_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/widgets/face_mesh_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/widgets/face_mesh_permission_util.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/bottom_sheet.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class FaceMeshPage extends ConsumerStatefulWidget {
  const FaceMeshPage({super.key});

  @override
  ConsumerState<FaceMeshPage> createState() => _FaceMeshPageState();
}

class _FaceMeshPageState extends ConsumerState<FaceMeshPage> {
  FaceMeshMain get _notifier =>
      ref.read(faceMeshMainProvider.notifier);

  Future<void> _showPickOptions() async {
    final l10n = AppLocalizations.of(context)!;

    await showAppActionSheet(
      context,
      title: l10n.faceMeshPickImageTitle,
      message: l10n.faceMeshPickImageMessage,
      actions: [
        AppBottomSheetAction(
          label: l10n.faceMeshPickFromCamera,
          icon: Icons.camera_alt,
          onTap: () => _pickAndDetect(ImageSource.camera),
        ),
        AppBottomSheetAction(
          label: l10n.faceMeshPickFromGallery,
          icon: Icons.photo_library,
          onTap: () => _pickAndDetect(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<void> _pickAndDetect(ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;

    if (source == ImageSource.camera) {
      final granted =
          await FaceMeshPermissionUtil.ensureCameraPermission();
      if (!granted) {
        if (!mounted) return;
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: l10n.faceMeshPermissionDenied,
        );
        return;
      }
    } else {
      final granted =
          await FaceMeshPermissionUtil.ensurePhotosPermission();
      if (!granted) {
        if (!mounted) return;
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: l10n.faceMeshPermissionDenied,
        );
        return;
      }
    }

    final result = await _notifier.pickAndDetect(source);
    if (!mounted) return;

    switch (result) {
      case FaceMeshPickSuccess(:final session):
        if (!session.hasFaces) {
          await showStatusToast(
            context,
            variant: StatusVariant.error,
            title: l10n.commonError,
            message: l10n.faceMeshNoFacesDetected,
          );
        } else {
          await showStatusToast(
            context,
            variant: StatusVariant.success,
            title: l10n.commonSuccess,
            message: l10n.faceMeshSuccess(session.faceCount),
          );
        }
      case FaceMeshPickCancelled():
        break;
      case FaceMeshPickPermissionDenied(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
      case FaceMeshPickFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  Future<void> _openLiveCamera() async {
    final l10n = AppLocalizations.of(context)!;

    final granted = await FaceMeshPermissionUtil.ensureCameraPermission();
    if (!granted) {
      if (!mounted) return;
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.faceMeshPermissionDenied,
      );
      return;
    }

    if (!mounted) return;

    final session = await Navigator.push<FaceMeshSession>(
      context,
      MaterialPageRoute(
        builder: (context) => const FaceMeshCameraPage(),
      ),
    );

    if (session == null || !mounted) return;

    _notifier.applySession(session);

    if (!session.hasFaces) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.faceMeshNoFacesDetected,
      );
    } else {
      await showStatusToast(
        context,
        variant: StatusVariant.success,
        title: l10n.commonSuccess,
        message: l10n.faceMeshSuccess(session.faceCount),
      );
    }
  }

  Future<void> _uploadSession() async {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.read(faceMeshMainProvider).session;

    if (session == null || !session.hasFaces) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.faceMeshNoDetectionData,
      );
      return;
    }

    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.faceMeshSaveTitle,
      message: l10n.faceMeshSaveConfirm,
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
              Text(l10n.faceMeshUploading),
            ],
          ),
        );
      },
    );

    final result = await _notifier.uploadSession();

    if (!mounted) return;
    Navigator.of(context).pop();

    switch (result) {
      case FaceMeshUploadSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.faceMeshUploadSuccess,
        );
      case FaceMeshUploadFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  Future<void> _navigateToList() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: FaceMeshListPage.routeName),
        builder: (context) => const FaceMeshListPage(),
      ),
    );
  }

  Widget _buildMainFunctionBody(FaceMeshMainState mainState) {
    if (mainState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(faceMeshConnectionStatusProvider.notifier).refresh();
      },
      color: EgovColor.primary50,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: FaceMeshOverview(
          session: mainState.session,
          isProcessing: mainState.isProcessing,
          onPickImageTap: _showPickOptions,
          onLiveCameraTap: _openLiveCamera,
          footer: const FaceMeshConnectionBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(faceMeshMainProvider);

    return FeatureShell(
      currentAppTargetPage: 'faceMesh',
      title: l10n.faceMeshApiTitle,
      guidePage: const FaceMeshFunctionPage(),
      mainFunctionBody: _buildMainFunctionBody(mainState),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButtonFactory.listButton(
            text: l10n.faceMeshListButton,
            onServerConnected: _navigateToList,
            resolveConnection:
                FaceMeshConnectionResolver.resolveConnection,
          ),
          ServerConnectionButtonFactory.uploadButton(
            text: l10n.faceMeshSaveButton,
            onServerConnected: _uploadSession,
            resolveConnection:
                FaceMeshConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }
}
