import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/usecases/push_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/push_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/state/push_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_controller.g.dart';

PushUseCase _pushUseCase(Ref ref) => ref.read(pushUseCaseProvider);

@riverpod
class PushMain extends _$PushMain {
  @override
  PushMainState build() {
    Future.microtask(_autoSetupOnLaunch);
    return PushMainState.initial();
  }

  Future<void> _autoSetupOnLaunch() async {
    await _runAutoSetup(showLoading: true);
  }

  Future<void> _runAutoSetup({required bool showLoading}) async {
    if (showLoading) {
      state = state.copyWith(
        isLoading: true,
        clearLoadError: true,
        permissionDenied: false,
      );
    }

    final result = await _pushUseCase(ref).initializeNotifications();
    final info = await _pushUseCase(ref).collectPushDeviceInfo();

    switch (result) {
      case PushInitSuccess():
        state = state.copyWith(
          isLoading: false,
          isInitialized: true,
          permissionDenied: false,
          clearLoadError: true,
          uuid: info.uuid,
          tokenId: info.tokenId,
          deviceNm: info.deviceNm,
          osType: info.osType,
          osVer: info.osVer,
          ntwrkDeviceInfo: info.ntwrkDeviceInfo,
        );
      case PushInitFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          isInitialized: false,
          permissionDenied: message == PushMessageKeys.permissionDenied,
          loadError: message,
          uuid: info.uuid,
          tokenId: info.tokenId,
          deviceNm: info.deviceNm,
          osType: info.osType,
          osVer: info.osVer,
          ntwrkDeviceInfo: info.ntwrkDeviceInfo,
        );
    }
  }

  Future<void> reloadDeviceInfo() async {
    await _runAutoSetup(showLoading: false);
  }

  Future<PushInitResult> retrySetup() async {
    await _runAutoSetup(showLoading: true);
    if (state.isInitialized) {
      return const PushInitSuccess();
    }
    return PushInitFailure(state.loadError ?? PushMessageKeys.initFailed);
  }

  PushDeviceInfo? buildRegisterInfo() {
    if (!state.canRegister) {
      return null;
    }

    return PushDeviceInfo(
      sn: 0,
      uuid: state.uuid,
      ntwrkDeviceInfo: state.ntwrkDeviceInfo,
      osVer: state.osVer,
      deviceNm: state.deviceNm,
      useYn: 'Y',
      osType: state.osType,
      tokenId: state.tokenId,
    );
  }

  Future<bool> isDeviceAlreadyRegistered() async {
    if (state.uuid.isEmpty) {
      return false;
    }
    return _pushUseCase(ref).isDeviceRegistered(state.uuid);
  }

  Future<PushUploadResult> registerPushDevice() async {
    final info = buildRegisterInfo();
    if (info == null) {
      return const PushUploadFailure(PushMessageKeys.noDeviceData);
    }
    return _pushUseCase(ref).registerPushDevice(info);
  }
}

@riverpod
class PushList extends _$PushList {
  @override
  PushListState build() {
    Future.microtask(reload);
    return PushListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _pushUseCase(ref).loadPushMessageList();

    switch (result) {
      case PushListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          messageList: items,
          errorMessage: '',
        );
      case PushListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          messageList: [],
          errorMessage: '',
        );
      case PushListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          messageList: [],
          errorMessage: message,
        );
    }
  }
}
