// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interface_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InterfaceConnection)
const interfaceConnectionProvider = InterfaceConnectionProvider._();

final class InterfaceConnectionProvider
    extends $NotifierProvider<InterfaceConnection, InterfaceConnectionState> {
  const InterfaceConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interfaceConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interfaceConnectionHash();

  @$internal
  @override
  InterfaceConnection create() => InterfaceConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterfaceConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterfaceConnectionState>(value),
    );
  }
}

String _$interfaceConnectionHash() =>
    r'bbd5835cc9212398bf1735c93af94acb6aaad26a';

abstract class _$InterfaceConnection
    extends $Notifier<InterfaceConnectionState> {
  InterfaceConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<InterfaceConnectionState, InterfaceConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InterfaceConnectionState, InterfaceConnectionState>,
              InterfaceConnectionState,
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

@ProviderFor(interfaceSqliteService)
const interfaceSqliteServiceProvider = InterfaceSqliteServiceProvider._();

final class InterfaceSqliteServiceProvider
    extends
        $FunctionalProvider<
          InterfaceSqliteService,
          InterfaceSqliteService,
          InterfaceSqliteService
        >
    with $Provider<InterfaceSqliteService> {
  const InterfaceSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interfaceSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interfaceSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<InterfaceSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InterfaceSqliteService create(Ref ref) {
    return interfaceSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterfaceSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterfaceSqliteService>(value),
    );
  }
}

String _$interfaceSqliteServiceHash() =>
    r'40642c8c0886b7145d7ccf8e52e523048b2b8130';
