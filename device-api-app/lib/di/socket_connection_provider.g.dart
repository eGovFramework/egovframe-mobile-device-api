// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SocketConnection)
const socketConnectionProvider = SocketConnectionProvider._();

final class SocketConnectionProvider
    extends $NotifierProvider<SocketConnection, SocketConnectionState> {
  const SocketConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketConnectionHash();

  @$internal
  @override
  SocketConnection create() => SocketConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocketConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocketConnectionState>(value),
    );
  }
}

String _$socketConnectionHash() => r'ce5f2446acb67c1df2caa1c9d02bfbfd6789e9e0';

abstract class _$SocketConnection extends $Notifier<SocketConnectionState> {
  SocketConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SocketConnectionState, SocketConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SocketConnectionState, SocketConnectionState>,
              SocketConnectionState,
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

@ProviderFor(socketSqliteService)
const socketSqliteServiceProvider = SocketSqliteServiceProvider._();

final class SocketSqliteServiceProvider
    extends
        $FunctionalProvider<
          SocketSqliteService,
          SocketSqliteService,
          SocketSqliteService
        >
    with $Provider<SocketSqliteService> {
  const SocketSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<SocketSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SocketSqliteService create(Ref ref) {
    return socketSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocketSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocketSqliteService>(value),
    );
  }
}

String _$socketSqliteServiceHash() =>
    r'06b58cec02ef89e0b731d54a6cc64408743aa5c1';
