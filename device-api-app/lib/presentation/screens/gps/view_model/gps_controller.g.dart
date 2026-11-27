// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GpsMain)
const gpsMainProvider = GpsMainProvider._();

final class GpsMainProvider extends $NotifierProvider<GpsMain, GpsMainState> {
  const GpsMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gpsMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gpsMainHash();

  @$internal
  @override
  GpsMain create() => GpsMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GpsMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GpsMainState>(value),
    );
  }
}

String _$gpsMainHash() => r'fbb84c947e25bb9d056338078177dc5c1b367552';

abstract class _$GpsMain extends $Notifier<GpsMainState> {
  GpsMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GpsMainState, GpsMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GpsMainState, GpsMainState>,
              GpsMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GpsList)
const gpsListProvider = GpsListProvider._();

final class GpsListProvider extends $NotifierProvider<GpsList, GpsListState> {
  const GpsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gpsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gpsListHash();

  @$internal
  @override
  GpsList create() => GpsList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GpsListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GpsListState>(value),
    );
  }
}

String _$gpsListHash() => r'e99f95b5a2a31cd6c0b5804c78780c9aa463d5b8';

abstract class _$GpsList extends $Notifier<GpsListState> {
  GpsListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GpsListState, GpsListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GpsListState, GpsListState>,
              GpsListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
