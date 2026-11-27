enum FaceMeshConnectionMode {
  server,
  sqlite,
}

class FaceMeshConnectionState {
  final FaceMeshConnectionMode mode;
  final String? sqliteDbFileName;

  const FaceMeshConnectionState({
    this.mode = FaceMeshConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == FaceMeshConnectionMode.sqlite && sqliteDbFileName != null;

  FaceMeshConnectionState copyWith({
    FaceMeshConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return FaceMeshConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
