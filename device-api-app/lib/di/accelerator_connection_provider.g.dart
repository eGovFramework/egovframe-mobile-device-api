// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accelerator_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AcceleratorConnection)
const acceleratorConnectionProvider = AcceleratorConnectionProvider._();

final class AcceleratorConnectionProvider
    extends
        $NotifierProvider<AcceleratorConnection, AcceleratorConnectionState> {
  const AcceleratorConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceleratorConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceleratorConnectionHash();

  @$internal
  @override
  AcceleratorConnection create() => AcceleratorConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceleratorConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceleratorConnectionState>(value),
    );
  }
}

String _$acceleratorConnectionHash() =>
    r'ff0ce9c2ca0e49ad3d5b8d57344d707072314016';

abstract class _$AcceleratorConnection
    extends $Notifier<AcceleratorConnectionState> {
  AcceleratorConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AcceleratorConnectionState, AcceleratorConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AcceleratorConnectionState,
                AcceleratorConnectionState
              >,
              AcceleratorConnectionState,
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

@ProviderFor(acceleratorSqliteService)
const acceleratorSqliteServiceProvider = AcceleratorSqliteServiceProvider._();

final class AcceleratorSqliteServiceProvider
    extends
        $FunctionalProvider<
          AcceleratorSqliteService,
          AcceleratorSqliteService,
          AcceleratorSqliteService
        >
    with $Provider<AcceleratorSqliteService> {
  const AcceleratorSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceleratorSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceleratorSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<AcceleratorSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AcceleratorSqliteService create(Ref ref) {
    return acceleratorSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceleratorSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceleratorSqliteService>(value),
    );
  }
}

String _$acceleratorSqliteServiceHash() =>
    r'd342530009d9f108e242ec80ddc8614533bdc848';
