// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NetworkConnection)
const networkConnectionProvider = NetworkConnectionProvider._();

final class NetworkConnectionProvider
    extends $NotifierProvider<NetworkConnection, NetworkConnectionState> {
  const NetworkConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkConnectionHash();

  @$internal
  @override
  NetworkConnection create() => NetworkConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkConnectionState>(value),
    );
  }
}

String _$networkConnectionHash() => r'e3fdc82741ba6dca75be35086d19322aa49aebfe';

abstract class _$NetworkConnection extends $Notifier<NetworkConnectionState> {
  NetworkConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<NetworkConnectionState, NetworkConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkConnectionState, NetworkConnectionState>,
              NetworkConnectionState,
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

@ProviderFor(networkSqliteService)
const networkSqliteServiceProvider = NetworkSqliteServiceProvider._();

final class NetworkSqliteServiceProvider
    extends
        $FunctionalProvider<
          NetworkSqliteService,
          NetworkSqliteService,
          NetworkSqliteService
        >
    with $Provider<NetworkSqliteService> {
  const NetworkSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<NetworkSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NetworkSqliteService create(Ref ref) {
    return networkSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkSqliteService>(value),
    );
  }
}

String _$networkSqliteServiceHash() =>
    r'286464ddfe14603e42f8d6efa57b523da0f18ee5';
