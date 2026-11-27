import 'dart:async';

import 'package:egovframe_mobile_deviceapi_app/data/accelerator/datasources/accelerometer_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/usecases/accelerator_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/accelerator_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/state/accelerator_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';

part 'accelerator_controller.g.dart';

AccelerometerService _accelerometerService(Ref ref) =>
    ref.read(accelerometerServiceProvider);
AcceleratorUseCase _acceleratorUseCase(Ref ref) =>
    ref.read(acceleratorUseCaseProvider);

@riverpod
class AcceleratorMain extends _$AcceleratorMain {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  @override
  AcceleratorMainState build() {
    ref.onDispose(() {
      stopAccelerometer();
    });
    Future.microtask(initialize);
    return AcceleratorMainState.initial();
  }

  Future<void> initialize() async {
    final deviceUuid = await _acceleratorUseCase(ref).getDeviceUuid();
    state = state.copyWith(deviceUuid: deviceUuid);
    startAccelerometer();
  }

  void startAccelerometer() {
    final service = _accelerometerService(ref);
    service.startAccelerometer();

    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = service.accelerometerStream.listen(
      (event) {
        if (state.xAxis == event.x &&
            state.yAxis == event.y &&
            state.zAxis == event.z) {
          return;
        }

        final now = DateTime.now().toUtc().add(const Duration(hours: 9));
        state = state.copyWith(
          xAxis: event.x,
          yAxis: event.y,
          zAxis: event.z,
          timestamp: now.millisecondsSinceEpoch.toString(),
          isAccelerometerActive: true,
          isLoading: false,
        );
      },
      onError: (_) {
        state = state.copyWith(isLoading: false);
      },
      onDone: () {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  void stopAccelerometer() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _accelerometerService(ref).stopAccelerometer();
  }

  void handleAppLifecyclePaused() {
    stopAccelerometer();
  }

  void handleAppLifecycleResumed() {
    startAccelerometer();
  }

  Future<AcceleratorSaveResult> saveCurrentReading() async {
    state = state.copyWith(isLoading: true);

    final uuid = await _acceleratorUseCase(ref).getDeviceUuid();
    if (uuid.isEmpty) {
      state = state.copyWith(isLoading: false);
      return const AcceleratorSaveFailure(AcceleratorMessageKeys.noUuid);
    }

    if (state.deviceUuid != uuid) {
      state = state.copyWith(deviceUuid: uuid);
    }

    final result = await _acceleratorUseCase(ref).saveAcceleratorInfo(
      AcceleratorInfo(
        sn: 0,
        uuid: uuid,
        xAxis: state.xAxis,
        yAxis: state.yAxis,
        zAxis: state.zAxis,
        timestamp: state.timestamp,
        useYn: 'Y',
      ),
    );

    state = state.copyWith(isLoading: false);
    return result;
  }
}

@riverpod
class AcceleratorList extends _$AcceleratorList {
  @override
  AcceleratorListState build() {
    Future.microtask(initialize);
    return AcceleratorListState.initial();
  }

  Future<void> initialize() async {
    final deviceUuid = await _acceleratorUseCase(ref).getDeviceUuid();
    state = state.copyWith(deviceUuid: deviceUuid);
    await reload();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _acceleratorUseCase(
      ref,
    ).loadAcceleratorList(state.deviceUuid);

    switch (result) {
      case AcceleratorListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          acceleratorInfoList: items,
          errorMessage: '',
        );
      case AcceleratorListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          acceleratorInfoList: [],
          errorMessage: '',
        );
      case AcceleratorListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          acceleratorInfoList: [],
          errorMessage: message,
        );
    }
  }
}

@riverpod
class AcceleratorDetail extends _$AcceleratorDetail {
  @override
  AcceleratorDetailState build(int sn) {
    return AcceleratorDetailState.initial(sn: sn);
  }

  void initialize(AcceleratorInfo fallbackInfo) {
    state = state.copyWith(
      fallbackInfo: fallbackInfo,
      acceleratorInfo: fallbackInfo,
      isLoading: false,
    );
  }

  Future<AcceleratorDeleteResult> deleteAccelerator() async {
    state = state.copyWith(isDeleting: true);

    final info = state.acceleratorInfo ?? state.fallbackInfo;
    if (info == null) {
      state = state.copyWith(isDeleting: false);
      return const AcceleratorDeleteFailure(
        AcceleratorMessageKeys.invalidSerial,
      );
    }

    final result =
        await _acceleratorUseCase(ref).deleteAcceleratorFromServer(info);

    state = state.copyWith(isDeleting: false);
    return result;
  }
}
