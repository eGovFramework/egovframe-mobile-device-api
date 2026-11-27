enum FileOpenerConnectionMode {
  server,
  sqlite,
}

class FileOpenerConnectionState {
  final FileOpenerConnectionMode mode;
  final String? sqliteDbFileName;

  const FileOpenerConnectionState({
    this.mode = FileOpenerConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == FileOpenerConnectionMode.sqlite && sqliteDbFileName != null;

  FileOpenerConnectionState copyWith({
    FileOpenerConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return FileOpenerConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
