// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compass_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CompassConnectionStatus)
const compassConnectionStatusProvider = CompassConnectionStatusProvider._();

final class CompassConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          CompassConnectionStatus,
          CompassConnectionStatusSnapshot
        > {
  const CompassConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compassConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compassConnectionStatusHash();

  @$internal
  @override
  CompassConnectionStatus create() => CompassConnectionStatus();
}

String _$compassConnectionStatusHash() =>
    r'3f0fa34b501d832db0da78bf677447b21d79af8c';

abstract class _$CompassConnectionStatus
    extends $AsyncNotifier<CompassConnectionStatusSnapshot> {
  FutureOr<CompassConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CompassConnectionStatusSnapshot>,
              CompassConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CompassConnectionStatusSnapshot>,
                CompassConnectionStatusSnapshot
              >,
              AsyncValue<CompassConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
