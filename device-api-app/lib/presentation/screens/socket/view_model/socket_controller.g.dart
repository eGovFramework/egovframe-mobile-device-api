// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SocketMain)
const socketMainProvider = SocketMainProvider._();

final class SocketMainProvider
    extends $NotifierProvider<SocketMain, SocketMainState> {
  const SocketMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketMainHash();

  @$internal
  @override
  SocketMain create() => SocketMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocketMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocketMainState>(value),
    );
  }
}

String _$socketMainHash() => r'51deffec764276acb1f1a22a988336f9a9e58679';

abstract class _$SocketMain extends $Notifier<SocketMainState> {
  SocketMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SocketMainState, SocketMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SocketMainState, SocketMainState>,
              SocketMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SocketList)
const socketListProvider = SocketListProvider._();

final class SocketListProvider
    extends $NotifierProvider<SocketList, SocketListState> {
  const SocketListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketListHash();

  @$internal
  @override
  SocketList create() => SocketList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocketListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocketListState>(value),
    );
  }
}

String _$socketListHash() => r'fdfcc6d88823ccf774eb5203494acf23ef926b96';

abstract class _$SocketList extends $Notifier<SocketListState> {
  SocketListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SocketListState, SocketListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SocketListState, SocketListState>,
              SocketListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
