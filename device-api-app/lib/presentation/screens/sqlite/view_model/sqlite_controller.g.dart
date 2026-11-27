// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sqlite_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SqliteMain)
const sqliteMainProvider = SqliteMainProvider._();

final class SqliteMainProvider
    extends $NotifierProvider<SqliteMain, SqliteMainState> {
  const SqliteMainProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sqliteMainProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sqliteMainHash();

  @$internal
  @override
  SqliteMain create() => SqliteMain();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SqliteMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SqliteMainState>(value),
    );
  }
}

String _$sqliteMainHash() => r'6052d01746951b7cc3e96bd40daa3bd0286baaef';

abstract class _$SqliteMain extends $Notifier<SqliteMainState> {
  SqliteMainState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SqliteMainState, SqliteMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SqliteMainState, SqliteMainState>,
              SqliteMainState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SqliteDatabaseDetail)
const sqliteDatabaseDetailProvider = SqliteDatabaseDetailFamily._();

final class SqliteDatabaseDetailProvider
    extends $NotifierProvider<SqliteDatabaseDetail, SqliteDatabaseDetailState> {
  const SqliteDatabaseDetailProvider._({
    required SqliteDatabaseDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sqliteDatabaseDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sqliteDatabaseDetailHash();

  @override
  String toString() {
    return r'sqliteDatabaseDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SqliteDatabaseDetail create() => SqliteDatabaseDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SqliteDatabaseDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SqliteDatabaseDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SqliteDatabaseDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sqliteDatabaseDetailHash() =>
    r'1b962e7707b3b75908bba3acef3ba630573f1d2f';

final class SqliteDatabaseDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          SqliteDatabaseDetail,
          SqliteDatabaseDetailState,
          SqliteDatabaseDetailState,
          SqliteDatabaseDetailState,
          String
        > {
  const SqliteDatabaseDetailFamily._()
    : super(
        retry: null,
        name: r'sqliteDatabaseDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SqliteDatabaseDetailProvider call(String fileName) =>
      SqliteDatabaseDetailProvider._(argument: fileName, from: this);

  @override
  String toString() => r'sqliteDatabaseDetailProvider';
}

abstract class _$SqliteDatabaseDetail
    extends $Notifier<SqliteDatabaseDetailState> {
  late final _$args = ref.$arg as String;
  String get fileName => _$args;

  SqliteDatabaseDetailState build(String fileName);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<SqliteDatabaseDetailState, SqliteDatabaseDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SqliteDatabaseDetailState, SqliteDatabaseDetailState>,
              SqliteDatabaseDetailState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SqliteTableData)
const sqliteTableDataProvider = SqliteTableDataFamily._();

final class SqliteTableDataProvider
    extends $NotifierProvider<SqliteTableData, SqliteTableDataState> {
  const SqliteTableDataProvider._({
    required SqliteTableDataFamily super.from,
    required ({String fileName, String tableName}) super.argument,
  }) : super(
         retry: null,
         name: r'sqliteTableDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sqliteTableDataHash();

  @override
  String toString() {
    return r'sqliteTableDataProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SqliteTableData create() => SqliteTableData();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SqliteTableDataState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SqliteTableDataState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SqliteTableDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sqliteTableDataHash() => r'3f32b440f68cd444a89d1a196831ad55692a1f5e';

final class SqliteTableDataFamily extends $Family
    with
        $ClassFamilyOverride<
          SqliteTableData,
          SqliteTableDataState,
          SqliteTableDataState,
          SqliteTableDataState,
          ({String fileName, String tableName})
        > {
  const SqliteTableDataFamily._()
    : super(
        retry: null,
        name: r'sqliteTableDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SqliteTableDataProvider call({
    required String fileName,
    required String tableName,
  }) => SqliteTableDataProvider._(
    argument: (fileName: fileName, tableName: tableName),
    from: this,
  );

  @override
  String toString() => r'sqliteTableDataProvider';
}

abstract class _$SqliteTableData extends $Notifier<SqliteTableDataState> {
  late final _$args = ref.$arg as ({String fileName, String tableName});
  String get fileName => _$args.fileName;
  String get tableName => _$args.tableName;

  SqliteTableDataState build({
    required String fileName,
    required String tableName,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      fileName: _$args.fileName,
      tableName: _$args.tableName,
    );
    final ref = this.ref as $Ref<SqliteTableDataState, SqliteTableDataState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SqliteTableDataState, SqliteTableDataState>,
              SqliteTableDataState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SqliteTableSchema)
const sqliteTableSchemaProvider = SqliteTableSchemaFamily._();

final class SqliteTableSchemaProvider
    extends $NotifierProvider<SqliteTableSchema, SqliteTableSchemaState> {
  const SqliteTableSchemaProvider._({
    required SqliteTableSchemaFamily super.from,
    required ({String fileName, String tableName}) super.argument,
  }) : super(
         retry: null,
         name: r'sqliteTableSchemaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sqliteTableSchemaHash();

  @override
  String toString() {
    return r'sqliteTableSchemaProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SqliteTableSchema create() => SqliteTableSchema();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SqliteTableSchemaState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SqliteTableSchemaState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SqliteTableSchemaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sqliteTableSchemaHash() => r'fd63b4259969309ec25e82f9225f1faf5d6d2fd7';

final class SqliteTableSchemaFamily extends $Family
    with
        $ClassFamilyOverride<
          SqliteTableSchema,
          SqliteTableSchemaState,
          SqliteTableSchemaState,
          SqliteTableSchemaState,
          ({String fileName, String tableName})
        > {
  const SqliteTableSchemaFamily._()
    : super(
        retry: null,
        name: r'sqliteTableSchemaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SqliteTableSchemaProvider call({
    required String fileName,
    required String tableName,
  }) => SqliteTableSchemaProvider._(
    argument: (fileName: fileName, tableName: tableName),
    from: this,
  );

  @override
  String toString() => r'sqliteTableSchemaProvider';
}

abstract class _$SqliteTableSchema extends $Notifier<SqliteTableSchemaState> {
  late final _$args = ref.$arg as ({String fileName, String tableName});
  String get fileName => _$args.fileName;
  String get tableName => _$args.tableName;

  SqliteTableSchemaState build({
    required String fileName,
    required String tableName,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      fileName: _$args.fileName,
      tableName: _$args.tableName,
    );
    final ref =
        this.ref as $Ref<SqliteTableSchemaState, SqliteTableSchemaState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SqliteTableSchemaState, SqliteTableSchemaState>,
              SqliteTableSchemaState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
