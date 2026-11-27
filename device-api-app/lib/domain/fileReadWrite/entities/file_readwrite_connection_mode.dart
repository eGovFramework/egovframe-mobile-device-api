enum FileReadWriteConnectionMode {
  server,
  sqlite,
}

class FileReadWriteConnectionState {
  final FileReadWriteConnectionMode mode;
  final String? sqliteDbFileName;

  const FileReadWriteConnectionState({
    this.mode = FileReadWriteConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == FileReadWriteConnectionMode.sqlite && sqliteDbFileName != null;

  FileReadWriteConnectionState copyWith({
    FileReadWriteConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return FileReadWriteConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
