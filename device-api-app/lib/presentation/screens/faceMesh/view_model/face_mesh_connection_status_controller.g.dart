// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_mesh_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FaceMeshConnectionStatus)
const faceMeshConnectionStatusProvider = FaceMeshConnectionStatusProvider._();

final class FaceMeshConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          FaceMeshConnectionStatus,
          FaceMeshConnectionStatusSnapshot
        > {
  const FaceMeshConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceMeshConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceMeshConnectionStatusHash();

  @$internal
  @override
  FaceMeshConnectionStatus create() => FaceMeshConnectionStatus();
}

String _$faceMeshConnectionStatusHash() =>
    r'49d58ff39c3715ab5b5c2892186f410a1d178068';

abstract class _$FaceMeshConnectionStatus
    extends $AsyncNotifier<FaceMeshConnectionStatusSnapshot> {
  FutureOr<FaceMeshConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<FaceMeshConnectionStatusSnapshot>,
              FaceMeshConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<FaceMeshConnectionStatusSnapshot>,
                FaceMeshConnectionStatusSnapshot
              >,
              AsyncValue<FaceMeshConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
