// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NetworkConnectionStatus)
const networkConnectionStatusProvider = NetworkConnectionStatusProvider._();

final class NetworkConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          NetworkConnectionStatus,
          NetworkConnectionStatusSnapshot
        > {
  const NetworkConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkConnectionStatusHash();

  @$internal
  @override
  NetworkConnectionStatus create() => NetworkConnectionStatus();
}

String _$networkConnectionStatusHash() =>
    r'279e77f55a38e0043734caf9a6595964a6ca8e34';

abstract class _$NetworkConnectionStatus
    extends $AsyncNotifier<NetworkConnectionStatusSnapshot> {
  FutureOr<NetworkConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NetworkConnectionStatusSnapshot>,
              NetworkConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NetworkConnectionStatusSnapshot>,
                NetworkConnectionStatusSnapshot
              >,
              AsyncValue<NetworkConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
