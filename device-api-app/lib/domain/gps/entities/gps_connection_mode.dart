enum GpsConnectionMode {
  server,
  sqlite,
}

class GpsConnectionState {
  final GpsConnectionMode mode;
  final String? sqliteDbFileName;

  const GpsConnectionState({
    this.mode = GpsConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == GpsConnectionMode.sqlite && sqliteDbFileName != null;

  GpsConnectionState copyWith({
    GpsConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return GpsConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
