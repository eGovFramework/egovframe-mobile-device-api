// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accelerator_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AcceleratorConnectionStatus)
const acceleratorConnectionStatusProvider =
    AcceleratorConnectionStatusProvider._();

final class AcceleratorConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          AcceleratorConnectionStatus,
          AcceleratorConnectionStatusSnapshot
        > {
  const AcceleratorConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceleratorConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceleratorConnectionStatusHash();

  @$internal
  @override
  AcceleratorConnectionStatus create() => AcceleratorConnectionStatus();
}

String _$acceleratorConnectionStatusHash() =>
    r'25e2299a7a4a5ae119e662663726acae942bc0d4';

abstract class _$AcceleratorConnectionStatus
    extends $AsyncNotifier<AcceleratorConnectionStatusSnapshot> {
  FutureOr<AcceleratorConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<AcceleratorConnectionStatusSnapshot>,
              AcceleratorConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AcceleratorConnectionStatusSnapshot>,
                AcceleratorConnectionStatusSnapshot
              >,
              AsyncValue<AcceleratorConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
