enum AcceleratorConnectionMode {
  server,
  sqlite,
}

class AcceleratorConnectionState {
  final AcceleratorConnectionMode mode;
  final String? sqliteDbFileName;

  const AcceleratorConnectionState({
    this.mode = AcceleratorConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == AcceleratorConnectionMode.sqlite && sqliteDbFileName != null;

  AcceleratorConnectionState copyWith({
    AcceleratorConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return AcceleratorConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
