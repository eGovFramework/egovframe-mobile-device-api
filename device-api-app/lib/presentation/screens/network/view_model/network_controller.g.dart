// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NetworkMain)
const networkMainProvider = NetworkMainProvider._();

final class NetworkMainProvider
    extends $NotifierProvider<NetworkMain, NetworkMainState> {
  const NetworkMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkMainHash();

  @$internal
  @override
  NetworkMain create() => NetworkMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkMainState>(value),
    );
  }
}

String _$networkMainHash() => r'd5a088c99c4473ccbc5119917912f70b96f83915';

abstract class _$NetworkMain extends $Notifier<NetworkMainState> {
  NetworkMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NetworkMainState, NetworkMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkMainState, NetworkMainState>,
              NetworkMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NetworkList)
const networkListProvider = NetworkListProvider._();

final class NetworkListProvider
    extends $NotifierProvider<NetworkList, NetworkListState> {
  const NetworkListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkListHash();

  @$internal
  @override
  NetworkList create() => NetworkList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkListState>(value),
    );
  }
}

String _$networkListHash() => r'ecab8ff26bfb319e090d5f1679fedd2f75aa6c5d';

abstract class _$NetworkList extends $Notifier<NetworkListState> {
  NetworkListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NetworkListState, NetworkListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkListState, NetworkListState>,
              NetworkListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NetworkDetail)
const networkDetailProvider = NetworkDetailFamily._();

final class NetworkDetailProvider
    extends $NotifierProvider<NetworkDetail, NetworkDetailState> {
  const NetworkDetailProvider._({
    required NetworkDetailFamily super.from,
    required NetworkInfo super.argument,
  }) : super(
         retry: null,
         name: r'networkDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$networkDetailHash();

  @override
  String toString() {
    return r'networkDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NetworkDetail create() => NetworkDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NetworkDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$networkDetailHash() => r'535fe0cc07225f5cea2246da3fd3d44cc4ee534c';

final class NetworkDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          NetworkDetail,
          NetworkDetailState,
          NetworkDetailState,
          NetworkDetailState,
          NetworkInfo
        > {
  const NetworkDetailFamily._()
    : super(
        retry: null,
        name: r'networkDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NetworkDetailProvider call(NetworkInfo networkInfo) =>
      NetworkDetailProvider._(argument: networkInfo, from: this);

  @override
  String toString() => r'networkDetailProvider';
}

abstract class _$NetworkDetail extends $Notifier<NetworkDetailState> {
  late final _$args = ref.$arg as NetworkInfo;
  NetworkInfo get networkInfo => _$args;

  NetworkDetailState build(NetworkInfo networkInfo);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<NetworkDetailState, NetworkDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkDetailState, NetworkDetailState>,
              NetworkDetailState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
