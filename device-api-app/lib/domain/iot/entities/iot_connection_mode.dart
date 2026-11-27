enum IotConnectionMode {
  server,
  sqlite,
}

class IotConnectionState {
  final IotConnectionMode mode;
  final String? sqliteDbFileName;

  const IotConnectionState({
    this.mode = IotConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == IotConnectionMode.sqlite && sqliteDbFileName != null;

  IotConnectionState copyWith({
    IotConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return IotConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}

typedef IotConnectionReader = IotConnectionState Function();
