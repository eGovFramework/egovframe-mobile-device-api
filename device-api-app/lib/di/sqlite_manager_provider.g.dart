// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sqlite_manager_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sqliteManagerRepository)
const sqliteManagerRepositoryProvider = SqliteManagerRepositoryProvider._();

final class SqliteManagerRepositoryProvider
    extends
        $FunctionalProvider<
          SqliteRepository,
          SqliteRepository,
          SqliteRepository
        >
    with $Provider<SqliteRepository> {
  const SqliteManagerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sqliteManagerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sqliteManagerRepositoryHash();

  @$internal
  @override
  $ProviderElement<SqliteRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SqliteRepository create(Ref ref) {
    return sqliteManagerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SqliteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SqliteRepository>(value),
    );
  }
}

String _$sqliteManagerRepositoryHash() =>
    r'e892499d971d84df0f1876c2000d03aaa15915c2';

@ProviderFor(sqliteManagerUseCase)
const sqliteManagerUseCaseProvider = SqliteManagerUseCaseProvider._();

final class SqliteManagerUseCaseProvider
    extends $FunctionalProvider<SqliteUseCase, SqliteUseCase, SqliteUseCase>
    with $Provider<SqliteUseCase> {
  const SqliteManagerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sqliteManagerUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sqliteManagerUseCaseHash();

  @$internal
  @override
  $ProviderElement<SqliteUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SqliteUseCase create(Ref ref) {
    return sqliteManagerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SqliteUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SqliteUseCase>(value),
    );
  }
}

String _$sqliteManagerUseCaseHash() =>
    r'1e0682308c225d5cac1dd28b97f895dcf4939c87';
