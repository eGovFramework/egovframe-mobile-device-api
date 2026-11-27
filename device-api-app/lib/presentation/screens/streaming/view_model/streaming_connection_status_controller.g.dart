// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StreamingConnectionStatus)
const streamingConnectionStatusProvider = StreamingConnectionStatusProvider._();

final class StreamingConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          StreamingConnectionStatus,
          StreamingConnectionStatusSnapshot
        > {
  const StreamingConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamingConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamingConnectionStatusHash();

  @$internal
  @override
  StreamingConnectionStatus create() => StreamingConnectionStatus();
}

String _$streamingConnectionStatusHash() =>
    r'2b2711435a04d2e6b60282ed0be7bdfc98ed2e34';

abstract class _$StreamingConnectionStatus
    extends $AsyncNotifier<StreamingConnectionStatusSnapshot> {
  FutureOr<StreamingConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<StreamingConnectionStatusSnapshot>,
              StreamingConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<StreamingConnectionStatusSnapshot>,
                StreamingConnectionStatusSnapshot
              >,
              AsyncValue<StreamingConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
