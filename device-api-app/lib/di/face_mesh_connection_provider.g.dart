// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_mesh_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FaceMeshConnection)
const faceMeshConnectionProvider = FaceMeshConnectionProvider._();

final class FaceMeshConnectionProvider
    extends $NotifierProvider<FaceMeshConnection, FaceMeshConnectionState> {
  const FaceMeshConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceMeshConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceMeshConnectionHash();

  @$internal
  @override
  FaceMeshConnection create() => FaceMeshConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaceMeshConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaceMeshConnectionState>(value),
    );
  }
}

String _$faceMeshConnectionHash() =>
    r'afd46f54e2e72ce63fffaba832ec1234559191fe';

abstract class _$FaceMeshConnection extends $Notifier<FaceMeshConnectionState> {
  FaceMeshConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<FaceMeshConnectionState, FaceMeshConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FaceMeshConnectionState, FaceMeshConnectionState>,
              FaceMeshConnectionState,
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

@ProviderFor(faceMeshSqliteService)
const faceMeshSqliteServiceProvider = FaceMeshSqliteServiceProvider._();

final class FaceMeshSqliteServiceProvider
    extends
        $FunctionalProvider<
          FaceMeshSqliteService,
          FaceMeshSqliteService,
          FaceMeshSqliteService
        >
    with $Provider<FaceMeshSqliteService> {
  const FaceMeshSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceMeshSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceMeshSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<FaceMeshSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FaceMeshSqliteService create(Ref ref) {
    return faceMeshSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaceMeshSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaceMeshSqliteService>(value),
    );
  }
}

String _$faceMeshSqliteServiceHash() =>
    r'96e04e5397870168fe591f7afc0c2b73d7f0a4d1';
