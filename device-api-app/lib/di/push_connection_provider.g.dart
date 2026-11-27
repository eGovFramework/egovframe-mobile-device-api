// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PushConnection)
const pushConnectionProvider = PushConnectionProvider._();

final class PushConnectionProvider
    extends $NotifierProvider<PushConnection, PushConnectionState> {
  const PushConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushConnectionHash();

  @$internal
  @override
  PushConnection create() => PushConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushConnectionState>(value),
    );
  }
}

String _$pushConnectionHash() => r'8c4b4731b20d6acd0a7f5f9d0a5f036447f13de2';

abstract class _$PushConnection extends $Notifier<PushConnectionState> {
  PushConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PushConnectionState, PushConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PushConnectionState, PushConnectionState>,
              PushConnectionState,
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

@ProviderFor(pushSqliteService)
const pushSqliteServiceProvider = PushSqliteServiceProvider._();

final class PushSqliteServiceProvider
    extends
        $FunctionalProvider<
          PushSqliteService,
          PushSqliteService,
          PushSqliteService
        >
    with $Provider<PushSqliteService> {
  const PushSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<PushSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushSqliteService create(Ref ref) {
    return pushSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushSqliteService>(value),
    );
  }
}

String _$pushSqliteServiceHash() => r'0734dd982ad3bd7e685745febd74f6acdac74d60';
