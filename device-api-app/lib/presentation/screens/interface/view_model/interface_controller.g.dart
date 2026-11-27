// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interface_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InterfaceMain)
const interfaceMainProvider = InterfaceMainProvider._();

final class InterfaceMainProvider
    extends $NotifierProvider<InterfaceMain, InterfaceMainState> {
  const InterfaceMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interfaceMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interfaceMainHash();

  @$internal
  @override
  InterfaceMain create() => InterfaceMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterfaceMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterfaceMainState>(value),
    );
  }
}

String _$interfaceMainHash() => r'93d23d6433951dae37373f405823b373f7c6d9c5';

abstract class _$InterfaceMain extends $Notifier<InterfaceMainState> {
  InterfaceMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<InterfaceMainState, InterfaceMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InterfaceMainState, InterfaceMainState>,
              InterfaceMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(InterfaceSuccess)
const interfaceSuccessProvider = InterfaceSuccessFamily._();

final class InterfaceSuccessProvider
    extends $NotifierProvider<InterfaceSuccess, InterfaceSuccessState> {
  const InterfaceSuccessProvider._({
    required InterfaceSuccessFamily super.from,
    required ({String userId, String userPw}) super.argument,
  }) : super(
         retry: null,
         name: r'interfaceSuccessProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$interfaceSuccessHash();

  @override
  String toString() {
    return r'interfaceSuccessProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  InterfaceSuccess create() => InterfaceSuccess();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterfaceSuccessState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterfaceSuccessState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is InterfaceSuccessProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$interfaceSuccessHash() => r'0397f11953613139f0bc44be67346bf9ce6e613f';

final class InterfaceSuccessFamily extends $Family
    with
        $ClassFamilyOverride<
          InterfaceSuccess,
          InterfaceSuccessState,
          InterfaceSuccessState,
          InterfaceSuccessState,
          ({String userId, String userPw})
        > {
  const InterfaceSuccessFamily._()
    : super(
        retry: null,
        name: r'interfaceSuccessProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InterfaceSuccessProvider call({
    required String userId,
    required String userPw,
  }) => InterfaceSuccessProvider._(
    argument: (userId: userId, userPw: userPw),
    from: this,
  );

  @override
  String toString() => r'interfaceSuccessProvider';
}

abstract class _$InterfaceSuccess extends $Notifier<InterfaceSuccessState> {
  late final _$args = ref.$arg as ({String userId, String userPw});
  String get userId => _$args.userId;
  String get userPw => _$args.userPw;

  InterfaceSuccessState build({required String userId, required String userPw});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(userId: _$args.userId, userPw: _$args.userPw);
    final ref = this.ref as $Ref<InterfaceSuccessState, InterfaceSuccessState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InterfaceSuccessState, InterfaceSuccessState>,
              InterfaceSuccessState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
