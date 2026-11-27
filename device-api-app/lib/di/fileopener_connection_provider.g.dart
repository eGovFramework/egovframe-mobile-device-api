// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fileopener_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FileOpenerConnection)
const fileOpenerConnectionProvider = FileOpenerConnectionProvider._();

final class FileOpenerConnectionProvider
    extends $NotifierProvider<FileOpenerConnection, FileOpenerConnectionState> {
  const FileOpenerConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileOpenerConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileOpenerConnectionHash();

  @$internal
  @override
  FileOpenerConnection create() => FileOpenerConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileOpenerConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileOpenerConnectionState>(value),
    );
  }
}

String _$fileOpenerConnectionHash() =>
    r'6228ebee09ac0dd31a928d0520f3a292d830125b';

abstract class _$FileOpenerConnection
    extends $Notifier<FileOpenerConnectionState> {
  FileOpenerConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<FileOpenerConnectionState, FileOpenerConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FileOpenerConnectionState, FileOpenerConnectionState>,
              FileOpenerConnectionState,
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

@ProviderFor(fileOpenerSqliteService)
const fileOpenerSqliteServiceProvider = FileOpenerSqliteServiceProvider._();

final class FileOpenerSqliteServiceProvider
    extends
        $FunctionalProvider<
          FileOpenerSqliteService,
          FileOpenerSqliteService,
          FileOpenerSqliteService
        >
    with $Provider<FileOpenerSqliteService> {
  const FileOpenerSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileOpenerSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileOpenerSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<FileOpenerSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileOpenerSqliteService create(Ref ref) {
    return fileOpenerSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileOpenerSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileOpenerSqliteService>(value),
    );
  }
}

String _$fileOpenerSqliteServiceHash() =>
    r'7bf6e227e9507d40407a3ea3c06cafd39dc0f651';
