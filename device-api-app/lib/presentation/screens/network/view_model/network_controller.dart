import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/data/network/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/usecases/network_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/network_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/state/network_state.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_controller.g.dart';

NetworkService _networkService(Ref ref) => ref.read(networkServiceProvider);
NetworkUseCase _networkUseCase(Ref ref) => ref.read(networkUseCaseProvider);

@riverpod
class NetworkMain extends _$NetworkMain {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  NetworkMainState build() {
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
    });
    Future.microtask(initialize);
    _setupConnectivityListener();
    return NetworkMainState.initial();
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      await refreshNetworkInfo();
      await checkNetworkQuality();
    } catch (e) {
      appLog('네트워크 초기화 오류: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = _networkService(ref).connectivityStream.listen((
      result,
    ) {
      final isConnected = result != ConnectivityResult.none;
      state = state.copyWith(isConnected: isConnected);

      if (isConnected) {
        refreshNetworkInfo();
        checkNetworkQuality();
      }
    });
  }

  Future<void> refreshNetworkInfo() async {
    try {
      final networkInfo = await _networkService(ref).getCurrentNetworkInfo();
      final isAvailable = await _networkService(ref).isNetworkAvailable();

      state = state.copyWith(
        currentNetworkInfo: networkInfo,
        isConnected: isAvailable,
      );
    } catch (e) {
      appLog('현재 네트워크 정보 가져오기 오류: $e');
    }
  }

  Future<void> checkNetworkQuality() async {
    try {
      final quality = await _networkService(ref).getNetworkQuality();
      state = state.copyWith(networkQuality: quality);
    } catch (e) {
      appLog('네트워크 품질 확인 오류: $e');
      state = state.copyWith(networkQuality: NetworkMessageKeys.unknownQuality);
    }
  }

  Future<NetworkSendResult> sendNetworkInfoToServer() async {
    final networkInfo = state.currentNetworkInfo;
    if (networkInfo == null) {
      return const NetworkSendFailure(NetworkMessageKeys.noCurrentInfo);
    }

    state = state.copyWith(isLoading: true);
    final result = await _networkUseCase(ref).sendNetworkInfo(networkInfo);
    state = state.copyWith(isLoading: false);
    return result;
  }
}

@riverpod
class NetworkList extends _$NetworkList {
  @override
  NetworkListState build() {
    Future.microtask(initialize);
    return NetworkListState.initial();
  }

  Future<void> initialize() async {
    final deviceUuid = await _networkUseCase(ref).getDeviceUuid();
    state = state.copyWith(deviceUuid: deviceUuid);
    await reload();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _networkUseCase(
      ref,
    ).loadNetworkInfoList(uuid: state.deviceUuid);

    switch (result) {
      case NetworkListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          networkInfoList: items,
          errorMessage: '',
        );
      case NetworkListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          networkInfoList: [],
          errorMessage: '',
        );
      case NetworkListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          networkInfoList: [],
          errorMessage: message,
        );
    }
  }

  Future<NetworkDeleteResult> deleteItem(NetworkInfo networkInfo) async {
    final result = await _networkUseCase(
      ref,
    ).deleteNetworkInfo(info: networkInfo);

    if (result is NetworkDeleteSuccess) {
      await reload();
    }

    return result;
  }
}

@riverpod
class NetworkDetail extends _$NetworkDetail {
  @override
  NetworkDetailState build(NetworkInfo networkInfo) {
    return NetworkDetailState(networkInfo: networkInfo);
  }

  Future<NetworkDeleteResult> deleteNetworkInfo() async {
    state = state.copyWith(isLoading: true);

    final result = await _networkUseCase(
      ref,
    ).deleteNetworkInfo(info: state.networkInfo);

    state = state.copyWith(isLoading: false);
    return result;
  }
}
