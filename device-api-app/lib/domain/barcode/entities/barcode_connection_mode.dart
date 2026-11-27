enum BarcodeConnectionMode {
  server,
  sqlite,
}

class BarcodeConnectionState {
  final BarcodeConnectionMode mode;
  final String? sqliteDbFileName;

  const BarcodeConnectionState({
    this.mode = BarcodeConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == BarcodeConnectionMode.sqlite && sqliteDbFileName != null;

  BarcodeConnectionState copyWith({
    BarcodeConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return BarcodeConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
