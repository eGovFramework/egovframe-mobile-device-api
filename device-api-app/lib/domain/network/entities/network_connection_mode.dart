enum NetworkConnectionMode {
  server,
  sqlite,
}

class NetworkConnectionState {
  final NetworkConnectionMode mode;
  final String? sqliteDbFileName;

  const NetworkConnectionState({
    this.mode = NetworkConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == NetworkConnectionMode.sqlite && sqliteDbFileName != null;

  NetworkConnectionState copyWith({
    NetworkConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return NetworkConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
