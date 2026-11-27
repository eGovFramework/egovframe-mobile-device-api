enum AiChatConnectionMode {
  server,
  sqlite,
}

class AiChatConnectionState {
  final AiChatConnectionMode mode;
  final String? sqliteDbFileName;

  const AiChatConnectionState({
    this.mode = AiChatConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == AiChatConnectionMode.sqlite && sqliteDbFileName != null;

  AiChatConnectionState copyWith({
    AiChatConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return AiChatConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
