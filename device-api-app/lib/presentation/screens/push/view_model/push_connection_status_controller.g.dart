// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PushConnectionStatus)
const pushConnectionStatusProvider = PushConnectionStatusProvider._();

final class PushConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          PushConnectionStatus,
          PushConnectionStatusSnapshot
        > {
  const PushConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushConnectionStatusHash();

  @$internal
  @override
  PushConnectionStatus create() => PushConnectionStatus();
}

String _$pushConnectionStatusHash() =>
    r'd2e12f1729eabc55ebabf996104ece56b4bcaf87';

abstract class _$PushConnectionStatus
    extends $AsyncNotifier<PushConnectionStatusSnapshot> {
  FutureOr<PushConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PushConnectionStatusSnapshot>,
              PushConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PushConnectionStatusSnapshot>,
                PushConnectionStatusSnapshot
              >,
              AsyncValue<PushConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
