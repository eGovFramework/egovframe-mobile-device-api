enum SocketConnectionMode {
  server,
  sqlite,
}

class SocketConnectionState {
  final SocketConnectionMode mode;
  final String? sqliteDbFileName;

  const SocketConnectionState({
    this.mode = SocketConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == SocketConnectionMode.sqlite && sqliteDbFileName != null;

  SocketConnectionState copyWith({
    SocketConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return SocketConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
