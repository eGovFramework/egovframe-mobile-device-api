import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/sqlite/src/config/sqlite_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/datasources/downloads_export_channel.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/column_definition.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/column_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/database_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/index_definition.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/table_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/table_schema.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  final Map<String, Database> _openConnections = {};

  Future<String> _resolvePath(String fileName) async {
    final normalized = _normalizeFileName(fileName);
    final dir = await getDatabasesPath();
    return p.join(dir, normalized);
  }

  String _normalizeFileName(String fileName) {
    return fileName.endsWith(SqliteConfig.dbFileExtension)
        ? fileName
        : '$fileName${SqliteConfig.dbFileExtension}';
  }

  Future<void> _closeConnection(String fileName) async {
    final normalized = _normalizeFileName(fileName);
    final db = _openConnections.remove(normalized);
    await db?.close();
  }

  Future<Database> _open(String fileName) async {
    final normalized = _normalizeFileName(fileName);

    if (_openConnections.containsKey(normalized)) {
      return _openConnections[normalized]!;
    }

    final path = await _resolvePath(normalized);
    final db = await openDatabase(path);
    _openConnections[normalized] = db;
    return db;
  }

  int _parseUserVersion(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return int.tryParse('$raw') ?? 0;
  }

  Future<int> _readVersion(String fileName) async {
    final db = await _open(fileName);
    final result = await db.rawQuery('PRAGMA user_version');
    return _parseUserVersion(result.first['user_version']);
  }

  /// SQLite 기본 user_version은 0이다. 앱에서 새로 만든 DB와 같이 최소 1로 맞춘다.
  Future<int> _ensureMinimumVersion(
    String fileName, {
    int minimum = 1,
  }) async {
    final current = await _readVersion(fileName);
    if (current >= minimum) return current;

    final db = await _open(fileName);
    await db.execute('PRAGMA user_version = $minimum');
    return minimum;
  }

  Future<List<DatabaseInfo>> listDatabases() async {
    final dir = await getDatabasesPath();
    final directory = Directory(dir);

    if (!await directory.exists()) {
      return [];
    }

    final files = await directory
        .list()
        .where((entity) => entity is File)
        .cast<File>()
        .where((file) => file.path.endsWith(SqliteConfig.dbFileExtension))
        .toList();

    final result = <DatabaseInfo>[];
    for (final file in files) {
      final stat = await file.stat();
      final fileName = p.basename(file.path);
      var version = 1;
      try {
        version = await _ensureMinimumVersion(fileName);
      } catch (_) {}

      result.add(
        DatabaseInfo(
          fileName: fileName,
          path: file.path,
          sizeBytes: stat.size,
          modifiedAt: stat.modified,
          version: version,
        ),
      );
    }

    result.sort((a, b) => a.displayName.compareTo(b.displayName));
    return result;
  }

  Future<void> createDatabase(String name, {int version = 1}) async {
    final sanitized = _sanitizeName(name);
    if (sanitized.isEmpty) {
      throw ArgumentError('invalid_database_name');
    }

    final path = await _resolvePath(sanitized);
    if (await File(path).exists()) {
      throw StateError('database_already_exists');
    }

    final db = await openDatabase(
      path,
      version: version,
      onCreate: (db, v) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
    await db.close();
  }

  Future<void> deleteDatabase(String fileName) async {
    await _closeConnection(fileName);
    final path = await _resolvePath(fileName);
    await databaseFactory.deleteDatabase(path);
  }

  Future<String> exportDatabase(String fileName) async {
    await _closeConnection(fileName);
    final sourcePath = await _resolvePath(fileName);
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('database_not_found');
    }

    final backupName = _backupFileName(fileName);

    if (Platform.isAndroid) {
      await DownloadsExportChannel.saveToDownloads(
        sourcePath: sourcePath,
        displayName: backupName,
      );
      return backupName;
    }

    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      throw StateError('downloads_unavailable');
    }

    final targetPath = p.join(downloadsDir.path, backupName);
    await source.copy(targetPath);
    return backupName;
  }

  Future<String> prepareDatabaseShare(String fileName) async {
    await _closeConnection(fileName);
    final sourcePath = await _resolvePath(fileName);
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('database_not_found');
    }

    final cacheDir = await getTemporaryDirectory();
    final backupName = _backupFileName(fileName);
    final targetPath = p.join(cacheDir.path, backupName);
    await source.copy(targetPath);
    return targetPath;
  }

  String _backupFileName(String fileName) {
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final base = _normalizeFileName(fileName).replaceAll('.db', '');
    return '${base}_$timestamp.db';
  }

  Future<void> importDatabase(String sourcePath, String targetName) async {
    final sanitized = _sanitizeName(targetName);
    if (sanitized.isEmpty) {
      throw ArgumentError('invalid_database_name');
    }

    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('import_file_not_found');
    }

    final targetPath = await _resolvePath(sanitized);
    if (await File(targetPath).exists()) {
      throw StateError('database_already_exists');
    }

    await source.copy(targetPath);
    try {
      await _ensureMinimumVersion(sanitized);
    } catch (_) {
      await _closeConnection(sanitized);
    }
  }

  Future<List<TableInfo>> listTables(String fileName) async {
    final db = await _open(fileName);
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' "
      "AND name NOT LIKE 'sqlite_%' "
      "AND LOWER(name) != 'android_metadata' "
      "ORDER BY name",
    );

    final tables = <TableInfo>[];
    for (final row in rows) {
      final tableName = row['name'] as String;
      final countResult = await db.rawQuery(
        'SELECT COUNT(*) AS count FROM "$tableName"',
      );
      final count = Sqflite.firstIntValue(countResult) ?? 0;
      tables.add(TableInfo(name: tableName, rowCount: count));
    }
    return tables;
  }

  Future<void> createTable(
    String fileName,
    String tableName,
    List<ColumnDefinition> columns, {
    List<IndexDefinition> indexes = const [],
  }) async {
    if (columns.isEmpty) {
      throw ArgumentError('columns_required');
    }

    final sanitizedTable = _sanitizeName(tableName);
    if (sanitizedTable.isEmpty) {
      throw ArgumentError('invalid_table_name');
    }

    final columnSql = columns.map((column) => column.toSqlFragment()).join(', ');
    final sql = 'CREATE TABLE IF NOT EXISTS "$sanitizedTable" ($columnSql)';

    final db = await _open(fileName);
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute(sql);

    for (final index in indexes) {
      if (index.columns.isEmpty) continue;
      await db.execute(index.toCreateSql(sanitizedTable));
    }
  }

  Future<void> addColumn(
    String fileName,
    String tableName,
    ColumnDefinition column,
  ) async {
    final sanitizedColumn = _sanitizeName(column.name);
    if (sanitizedColumn.isEmpty) {
      throw ArgumentError('invalid_column_name');
    }

    final db = await _open(fileName);
    final sql =
        'ALTER TABLE "$tableName" ADD COLUMN "$sanitizedColumn" ${column.toAlterAddSql()}';
    await db.execute(sql);
  }

  Future<TableSchema> getTableSchema(String fileName, String tableName) async {
    final db = await _open(fileName);
    final columnRows = await db.rawQuery('PRAGMA table_info("$tableName")');
    final columns = columnRows.map(ColumnInfo.fromPragma).toList();

    final indexRows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='index' "
      "AND tbl_name=? AND name NOT LIKE 'sqlite_%'",
      [tableName],
    );
    final indexes = indexRows
        .map((row) => row['name'] as String)
        .where((name) => name.isNotEmpty)
        .toList();

    return TableSchema(
      tableName: tableName,
      columns: columns,
      indexes: indexes,
    );
  }

  Future<List<String>> getTableColumns(String fileName, String tableName) async {
    final schema = await getTableSchema(fileName, tableName);
    return schema.columns.map((column) => column.name).toList();
  }

  Future<List<Map<String, Object?>>> queryTable(
    String fileName,
    String tableName,
  ) async {
    final db = await _open(fileName);
    return db.rawQuery('SELECT rowid AS __rowid__, * FROM "$tableName"');
  }

  Future<int> insertRow(
    String fileName,
    String tableName,
    Map<String, Object?> values,
  ) async {
    final db = await _open(fileName);
    final filtered = Map<String, Object?>.from(values)..remove('__rowid__');
    return db.insert(tableName, filtered);
  }

  Future<int> updateRow(
    String fileName,
    String tableName,
    Map<String, Object?> values,
    Map<String, Object?> where,
  ) async {
    final db = await _open(fileName);
    final filtered = Map<String, Object?>.from(values)..remove('__rowid__');
    final whereClause = where.keys.map((key) => '"$key" = ?').join(' AND ');
    return db.update(
      tableName,
      filtered,
      where: whereClause,
      whereArgs: where.values.toList(),
    );
  }

  Future<int> deleteRow(
    String fileName,
    String tableName,
    Map<String, Object?> where,
  ) async {
    final db = await _open(fileName);
    final whereClause = where.keys.map((key) => '"$key" = ?').join(' AND ');
    return db.delete(
      tableName,
      where: whereClause,
      whereArgs: where.values.toList(),
    );
  }

  String _sanitizeName(String value) {
    return value.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
  }
}
