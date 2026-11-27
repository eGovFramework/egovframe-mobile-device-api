import 'dart:async';

import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_heading.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/usecases/compass_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/compass_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/state/compass_state.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compass_controller.g.dart';

CompassUseCase _compassUseCase(Ref ref) => ref.read(compassUseCaseProvider);

const Duration _compassReadTimeout = Duration(seconds: 8);

@riverpod
class CompassMain extends _$CompassMain {
  StreamSubscription<CompassHeading>? _headingSubscription;
  Timer? _watchTimeout;

  @override
  CompassMainState build() {
    ref.onDispose(_cancelWatch);
    Future.microtask(initialize);
    return CompassMainState.initial();
  }

  Future<void> initialize() async {
    final uuid = await _compassUseCase(ref).getDeviceUuid();
    state = state.copyWith(isLoading: false, uuid: uuid);
  }

  Future<void> startWatching() async {
    if (FlutterCompass.events == null) {
      state = state.copyWith(
        loadError: CompassMessageKeys.sensorUnavailable,
      );
      return;
    }

    state = state.copyWith(
      isWatching: true,
      isAwaitingReading: true,
      clearCapturedAt: true,
      heading: const CompassHeading.inactive(),
      clearLoadError: true,
    );

    _watchTimeout?.cancel();
    _watchTimeout = Timer(_compassReadTimeout, _onWatchTimeout);

    _headingSubscription?.cancel();
    _headingSubscription = _compassUseCase(ref).watchHeading().listen(
      (heading) {
        if (heading.magneticHeading == null) {
          return;
        }

        _watchTimeout?.cancel();
        final capturedAt = state.capturedAt ?? DateTime.now();
        state = state.copyWith(
          heading: heading,
          capturedAt: capturedAt,
          isAwaitingReading: false,
        );
      },
      onError: (Object error) {
        stopWatching();
        state = state.copyWith(
          isWatching: false,
          isAwaitingReading: false,
          loadError: '${CompassMessageKeys.sensorErrorPrefix}$error',
        );
      },
    );
  }

  void stopWatching() {
    _cancelWatch();
    if (!state.isWatching && !state.isAwaitingReading) {
      return;
    }

    state = state.copyWith(
      isWatching: false,
      isAwaitingReading: false,
      clearCapturedAt: true,
      heading: const CompassHeading.inactive(),
      clearLoadError: true,
    );
  }

  void handleAppLifecyclePaused() {
    stopWatching();
  }

  void handleAppLifecycleResumed() {
    startWatching();
  }

  void _onWatchTimeout() {
    if (!state.isWatching || !state.isAwaitingReading) {
      return;
    }

    stopWatching();
    state = state.copyWith(
      isWatching: false,
      isAwaitingReading: false,
      clearCapturedAt: true,
      heading: const CompassHeading.inactive(),
      loadError: CompassMessageKeys.sensorUnavailable,
    );
  }

  void _cancelWatch() {
    _watchTimeout?.cancel();
    _watchTimeout = null;
    _headingSubscription?.cancel();
    _headingSubscription = null;
  }

  CompassInfo? buildUploadInfo() {
    final heading = state.heading;
    final capturedAt = state.capturedAt;
    if (!heading.isActive ||
        heading.magneticHeading == null ||
        capturedAt == null) {
      return null;
    }

    return CompassInfo(
      sn: 0,
      uuid: state.uuid,
      drc: heading.magneticHeading!.toStringAsFixed(1),
      accrcy: heading.headingAccuracy ?? '',
      useYn: 'Y',
      timestamp: KstDateTimeUtil.format(capturedAt),
    );
  }

  Future<CompassUploadResult> uploadCompassInfo() async {
    final info = buildUploadInfo();
    if (info == null) {
      return const CompassUploadFailure(CompassMessageKeys.noHeadingData);
    }
    return _compassUseCase(ref).uploadCompassToServer(info);
  }
}

@riverpod
class CompassList extends _$CompassList {
  @override
  CompassListState build() {
    Future.microtask(reload);
    return CompassListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _compassUseCase(ref).loadCompassList();

    switch (result) {
      case CompassListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          compassList: items,
          errorMessage: '',
        );
      case CompassListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          compassList: [],
          errorMessage: '',
        );
      case CompassListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          compassList: [],
          errorMessage: message,
        );
    }
  }

  Future<CompassDeleteBatchResult> deleteSelectedItems(
    List<CompassInfo> items,
  ) async {
    return _compassUseCase(ref).deleteCompassItems(items);
  }
}
