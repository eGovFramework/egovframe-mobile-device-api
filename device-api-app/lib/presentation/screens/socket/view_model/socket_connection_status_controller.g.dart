// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SocketConnectionStatus)
const socketConnectionStatusProvider = SocketConnectionStatusProvider._();

final class SocketConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          SocketConnectionStatus,
          SocketConnectionStatusSnapshot
        > {
  const SocketConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketConnectionStatusHash();

  @$internal
  @override
  SocketConnectionStatus create() => SocketConnectionStatus();
}

String _$socketConnectionStatusHash() =>
    r'3ee63ea2857304082b472003aae684f3bcda6d5d';

abstract class _$SocketConnectionStatus
    extends $AsyncNotifier<SocketConnectionStatusSnapshot> {
  FutureOr<SocketConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SocketConnectionStatusSnapshot>,
              SocketConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SocketConnectionStatusSnapshot>,
                SocketConnectionStatusSnapshot
              >,
              AsyncValue<SocketConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
