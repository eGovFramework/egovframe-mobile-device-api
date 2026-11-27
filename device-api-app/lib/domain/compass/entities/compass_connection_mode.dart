enum CompassConnectionMode {
  server,
  sqlite,
}

class CompassConnectionState {
  final CompassConnectionMode mode;
  final String? sqliteDbFileName;

  const CompassConnectionState({
    this.mode = CompassConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == CompassConnectionMode.sqlite && sqliteDbFileName != null;

  CompassConnectionState copyWith({
    CompassConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return CompassConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
