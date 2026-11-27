import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/usecases/interface_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/state/interface_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interface_controller.g.dart';

InterfaceUseCase _interfaceUseCase(Ref ref) =>
    ref.read(interfaceUseCaseProvider);

@riverpod
class InterfaceMain extends _$InterfaceMain {
  @override
  InterfaceMainState build() => InterfaceMainState.initial();

  Future<InterfaceSessionResult> checkSavedSession() async {
    return _interfaceUseCase(ref).checkSavedSession();
  }

  Future<InterfaceLoginResult> login({
    required String id,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await _interfaceUseCase(ref).login(id, password);
    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<InterfaceRegisterResult> register({
    required String id,
    required String password,
    required String email,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await _interfaceUseCase(ref).register(id, password, email);
    state = state.copyWith(isLoading: false);
    return result;
  }
}

@riverpod
class InterfaceSuccess extends _$InterfaceSuccess {
  @override
  InterfaceSuccessState build({
    required String userId,
    required String userPw,
  }) {
    Future.microtask(loadUserInfo);
    return InterfaceSuccessState(userId: userId, userPw: userPw);
  }

  Future<InterfaceUserInfoResult> loadUserInfo() async {
    state = state.copyWith(isDataLoading: true);

    final result = await _interfaceUseCase(
      ref,
    ).getUserInfo(state.userId, state.userPw);

    switch (result) {
      case InterfaceUserInfoSuccess(:final userInfo):
        state = state.copyWith(isDataLoading: false, userInfo: userInfo);
      case InterfaceUserInfoFailure():
        state = state.copyWith(isDataLoading: false);
    }

    return result;
  }

  Future<InterfaceLogoutResult> logout() async {
    return _interfaceUseCase(ref).logout();
  }

  Future<InterfaceWithdrawResult> withdraw() async {
    state = state.copyWith(isLoading: true);
    final result = await _interfaceUseCase(
      ref,
    ).withdraw(state.userId, state.userPw);
    state = state.copyWith(isLoading: false);
    return result;
  }
}
