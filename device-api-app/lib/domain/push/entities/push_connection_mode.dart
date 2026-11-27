enum PushConnectionMode {
  server,
  sqlite,
}

class PushConnectionState {
  final PushConnectionMode mode;
  final String? sqliteDbFileName;

  const PushConnectionState({
    this.mode = PushConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == PushConnectionMode.sqlite && sqliteDbFileName != null;

  PushConnectionState copyWith({
    PushConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return PushConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
