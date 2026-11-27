// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_readwrite_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FileReadWriteConnection)
const fileReadWriteConnectionProvider = FileReadWriteConnectionProvider._();

final class FileReadWriteConnectionProvider
    extends
        $NotifierProvider<
          FileReadWriteConnection,
          FileReadWriteConnectionState
        > {
  const FileReadWriteConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileReadWriteConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileReadWriteConnectionHash();

  @$internal
  @override
  FileReadWriteConnection create() => FileReadWriteConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileReadWriteConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileReadWriteConnectionState>(value),
    );
  }
}

String _$fileReadWriteConnectionHash() =>
    r'671a7f085d586279757e7939c890b52774fb593d';

abstract class _$FileReadWriteConnection
    extends $Notifier<FileReadWriteConnectionState> {
  FileReadWriteConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<FileReadWriteConnectionState, FileReadWriteConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                FileReadWriteConnectionState,
                FileReadWriteConnectionState
              >,
              FileReadWriteConnectionState,
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

@ProviderFor(fileReadWriteSqliteService)
const fileReadWriteSqliteServiceProvider =
    FileReadWriteSqliteServiceProvider._();

final class FileReadWriteSqliteServiceProvider
    extends
        $FunctionalProvider<
          FileReadWriteSqliteService,
          FileReadWriteSqliteService,
          FileReadWriteSqliteService
        >
    with $Provider<FileReadWriteSqliteService> {
  const FileReadWriteSqliteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileReadWriteSqliteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileReadWriteSqliteServiceHash();

  @$internal
  @override
  $ProviderElement<FileReadWriteSqliteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileReadWriteSqliteService create(Ref ref) {
    return fileReadWriteSqliteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileReadWriteSqliteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileReadWriteSqliteService>(value),
    );
  }
}

String _$fileReadWriteSqliteServiceHash() =>
    r'e0f74c10e910442c5675ed0df7612053a75957cd';
