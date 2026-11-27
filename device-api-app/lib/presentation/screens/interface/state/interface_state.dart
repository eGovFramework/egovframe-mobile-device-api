class InterfaceMainState {
  final bool isLoading;

  const InterfaceMainState({this.isLoading = false});

  factory InterfaceMainState.initial() => const InterfaceMainState();

  InterfaceMainState copyWith({bool? isLoading}) {
    return InterfaceMainState(isLoading: isLoading ?? this.isLoading);
  }
}

class InterfaceSuccessState {
  final String userId;
  final String userPw;
  final bool isLoading;
  final bool isDataLoading;
  final Map<String, dynamic> userInfo;

  const InterfaceSuccessState({
    required this.userId,
    required this.userPw,
    this.isLoading = false,
    this.isDataLoading = true,
    this.userInfo = const {},
  });

  InterfaceSuccessState copyWith({
    String? userId,
    String? userPw,
    bool? isLoading,
    bool? isDataLoading,
    Map<String, dynamic>? userInfo,
  }) {
    return InterfaceSuccessState(
      userId: userId ?? this.userId,
      userPw: userPw ?? this.userPw,
      isLoading: isLoading ?? this.isLoading,
      isDataLoading: isDataLoading ?? this.isDataLoading,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}
