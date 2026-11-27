enum MediaConnectionMode {
  server,
  sqlite,
}

class MediaConnectionState {
  final MediaConnectionMode mode;
  final String? sqliteDbFileName;

  const MediaConnectionState({
    this.mode = MediaConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == MediaConnectionMode.sqlite && sqliteDbFileName != null;

  MediaConnectionState copyWith({
    MediaConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return MediaConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
