enum InterfaceConnectionMode {
  server,
  sqlite,
}

class InterfaceConnectionState {
  final InterfaceConnectionMode mode;
  final String? sqliteDbFileName;

  const InterfaceConnectionState({
    this.mode = InterfaceConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == InterfaceConnectionMode.sqlite && sqliteDbFileName != null;

  InterfaceConnectionState copyWith({
    InterfaceConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return InterfaceConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
