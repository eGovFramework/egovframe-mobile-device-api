// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BarcodeConnection)
const barcodeConnectionProvider = BarcodeConnectionProvider._();

final class BarcodeConnectionProvider
    extends $NotifierProvider<BarcodeConnection, BarcodeConnectionState> {
  const BarcodeConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeConnectionHash();

  @$internal
  @override
  BarcodeConnection create() => BarcodeConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarcodeConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarcodeConnectionState>(value),
    );
  }
}

String _$barcodeConnectionHash() => r'a5c6716c9410108e23cc3191a4aade8f6fd38be9';

abstract class _$BarcodeConnection extends $Notifier<BarcodeConnectionState> {
  BarcodeConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<BarcodeConnectionState, BarcodeConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BarcodeConnectionState, BarcodeConnectionState>,
              BarcodeConnectionState,
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

@ProviderFor(barcodeSqliteService)
const barcodeSqliteServiceProvider = BarcodeSqliteServiceProvider._();

final class BarcodeSqliteServiceProvider
    extends
        $FunctionalProvider<
          BarcodeSqliteService,
          BarcodeSqliteService,
          BarcodeSqliteService
        >
    with $Provider<BarcodeSqliteService> {
  const BarcodeSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<BarcodeSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BarcodeSqliteService create(Ref ref) {
    return barcodeSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarcodeSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarcodeSqliteService>(value),
    );
  }
}

String _$barcodeSqliteServiceHash() =>
    r'd5da1d481cb67b3e4552a0a8c3720dc3c22bc39f';
