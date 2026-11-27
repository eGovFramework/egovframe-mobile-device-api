enum DeviceConnectionMode {
  server,
  sqlite,
}

class DeviceConnectionState {
  final DeviceConnectionMode mode;
  final String? sqliteDbFileName;

  const DeviceConnectionState({
    this.mode = DeviceConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == DeviceConnectionMode.sqlite && sqliteDbFileName != null;

  DeviceConnectionState copyWith({
    DeviceConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return DeviceConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
