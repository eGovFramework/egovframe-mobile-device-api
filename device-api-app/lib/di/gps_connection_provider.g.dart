// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GpsConnection)
const gpsConnectionProvider = GpsConnectionProvider._();

final class GpsConnectionProvider
    extends $NotifierProvider<GpsConnection, GpsConnectionState> {
  const GpsConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gpsConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gpsConnectionHash();

  @$internal
  @override
  GpsConnection create() => GpsConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GpsConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GpsConnectionState>(value),
    );
  }
}

String _$gpsConnectionHash() => r'c07d1cdf730f6584c22a0d53f80cbd0650c159f3';

abstract class _$GpsConnection extends $Notifier<GpsConnectionState> {
  GpsConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GpsConnectionState, GpsConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GpsConnectionState, GpsConnectionState>,
              GpsConnectionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(sqliteService)
const sqliteServiceProvider = SqliteServiceProvider._();

final class SqliteServiceProvider
    extends $FunctionalProvider<SqliteService, SqliteService, SqliteService>
    with $Provider<SqliteService> {
  const SqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sqliteServiceHash();

  @$internal
  @override
  $ProviderElement<SqliteService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SqliteService create(Ref ref) {
    return sqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SqliteService>(value),
    );
  }
}

String _$sqliteServiceHash() => r'2d68e0715f68f3b4487f7c8097df3c7778991ae9';

@ProviderFor(featureTableService)
const featureTableServiceProvider = FeatureTableServiceProvider._();

final class FeatureTableServiceProvider
    extends
        $FunctionalProvider<
          FeatureTableService,
          FeatureTableService,
          FeatureTableService
        >
    with $Provider<FeatureTableService> {
  const FeatureTableServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureTableServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureTableServiceHash();

  @$internal
  @override
  $ProviderElement<FeatureTableService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FeatureTableService create(Ref ref) {
    return featureTableService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeatureTableService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeatureTableService>(value),
    );
  }
}

String _$featureTableServiceHash() =>
    r'432c2831bc8ee63ad0b25735d6268165a942c7cc';

@ProviderFor(gpsSqliteService)
const gpsSqliteServiceProvider = GpsSqliteServiceProvider._();

final class GpsSqliteServiceProvider
    extends
        $FunctionalProvider<
          GpsSqliteService,
          GpsSqliteService,
          GpsSqliteService
        >
    with $Provider<GpsSqliteService> {
  const GpsSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gpsSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gpsSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<GpsSqliteService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GpsSqliteService create(Ref ref) {
    return gpsSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GpsSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GpsSqliteService>(value),
    );
  }
}

String _$gpsSqliteServiceHash() => r'77bee7cc250e7b444132acf5d3ba1c4383c3535f';
