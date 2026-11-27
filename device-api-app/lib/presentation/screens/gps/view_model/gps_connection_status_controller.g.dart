// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_connection_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GpsConnectionStatus)
const gpsConnectionStatusProvider = GpsConnectionStatusProvider._();

final class GpsConnectionStatusProvider
    extends
        $AsyncNotifierProvider<
          GpsConnectionStatus,
          GpsConnectionStatusSnapshot
        > {
  const GpsConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gpsConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gpsConnectionStatusHash();

  @$internal
  @override
  GpsConnectionStatus create() => GpsConnectionStatus();
}

String _$gpsConnectionStatusHash() =>
    r'0271ecf24f2d8028ca5a0d1c0bc945a3e158b2e3';

abstract class _$GpsConnectionStatus
    extends $AsyncNotifier<GpsConnectionStatusSnapshot> {
  FutureOr<GpsConnectionStatusSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<GpsConnectionStatusSnapshot>,
              GpsConnectionStatusSnapshot
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<GpsConnectionStatusSnapshot>,
                GpsConnectionStatusSnapshot
              >,
              AsyncValue<GpsConnectionStatusSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
