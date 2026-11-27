enum StreamingConnectionMode {
  server,
  sqlite,
}

class StreamingConnectionState {
  final StreamingConnectionMode mode;
  final String? sqliteDbFileName;

  const StreamingConnectionState({
    this.mode = StreamingConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == StreamingConnectionMode.sqlite && sqliteDbFileName != null;

  StreamingConnectionState copyWith({
    StreamingConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return StreamingConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
