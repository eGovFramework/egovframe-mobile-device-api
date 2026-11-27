// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compass_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CompassConnection)
const compassConnectionProvider = CompassConnectionProvider._();

final class CompassConnectionProvider
    extends $NotifierProvider<CompassConnection, CompassConnectionState> {
  const CompassConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compassConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compassConnectionHash();

  @$internal
  @override
  CompassConnection create() => CompassConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompassConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompassConnectionState>(value),
    );
  }
}

String _$compassConnectionHash() => r'f7bfee52ef5eca7a56ac4dcfe2ba8d8a1373a778';

abstract class _$CompassConnection extends $Notifier<CompassConnectionState> {
  CompassConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<CompassConnectionState, CompassConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CompassConnectionState, CompassConnectionState>,
              CompassConnectionState,
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

@ProviderFor(compassSqliteService)
const compassSqliteServiceProvider = CompassSqliteServiceProvider._();

final class CompassSqliteServiceProvider
    extends
        $FunctionalProvider<
          CompassSqliteService,
          CompassSqliteService,
          CompassSqliteService
        >
    with $Provider<CompassSqliteService> {
  const CompassSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compassSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compassSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<CompassSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompassSqliteService create(Ref ref) {
    return compassSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompassSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompassSqliteService>(value),
    );
  }
}

String _$compassSqliteServiceHash() =>
    r'd3cb4bbe055f0e6053156f17da41fcf62bbf2e56';
