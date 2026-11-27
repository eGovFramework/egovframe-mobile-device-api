// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeviceConnection)
const deviceConnectionProvider = DeviceConnectionProvider._();

final class DeviceConnectionProvider
    extends $NotifierProvider<DeviceConnection, DeviceConnectionState> {
  const DeviceConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceConnectionHash();

  @$internal
  @override
  DeviceConnection create() => DeviceConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceConnectionState>(value),
    );
  }
}

String _$deviceConnectionHash() => r'000c9cf67d17626193533f195e016983b8b6dba6';

abstract class _$DeviceConnection extends $Notifier<DeviceConnectionState> {
  DeviceConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DeviceConnectionState, DeviceConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeviceConnectionState, DeviceConnectionState>,
              DeviceConnectionState,
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

@ProviderFor(deviceSqliteService)
const deviceSqliteServiceProvider = DeviceSqliteServiceProvider._();

final class DeviceSqliteServiceProvider
    extends
        $FunctionalProvider<
          DeviceSqliteService,
          DeviceSqliteService,
          DeviceSqliteService
        >
    with $Provider<DeviceSqliteService> {
  const DeviceSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceSqliteService create(Ref ref) {
    return deviceSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceSqliteService>(value),
    );
  }
}

String _$deviceSqliteServiceHash() =>
    r'086adfbee579723062304d1d22a804de80d9c7e5';
