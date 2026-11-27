// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IotConnection)
const iotConnectionProvider = IotConnectionProvider._();

final class IotConnectionProvider
    extends $NotifierProvider<IotConnection, IotConnectionState> {
  const IotConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iotConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iotConnectionHash();

  @$internal
  @override
  IotConnection create() => IotConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IotConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IotConnectionState>(value),
    );
  }
}

String _$iotConnectionHash() => r'2c60299606b96fe3a98fa63de6b6a901af3fa2f2';

abstract class _$IotConnection extends $Notifier<IotConnectionState> {
  IotConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IotConnectionState, IotConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IotConnectionState, IotConnectionState>,
              IotConnectionState,
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

@ProviderFor(iotSqliteService)
const iotSqliteServiceProvider = IotSqliteServiceProvider._();

final class IotSqliteServiceProvider
    extends
        $FunctionalProvider<
          IotSqliteService,
          IotSqliteService,
          IotSqliteService
        >
    with $Provider<IotSqliteService> {
  const IotSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iotSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iotSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<IotSqliteService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IotSqliteService create(Ref ref) {
    return iotSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IotSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IotSqliteService>(value),
    );
  }
}

String _$iotSqliteServiceHash() => r'4fad6bfbf71c915b63dc22e6d9a49f08d9db8aa2';
