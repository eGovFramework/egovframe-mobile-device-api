enum IotDataSourceKind { server, sqlite }

class IotDataSourceSnapshot {
  final IotDataSourceKind kind;
  final bool reachable;
  final bool sqliteReady;
  final bool sqliteToggleOn;
  final List<String> readyDatabases;
  final String? selectedDbFileName;

  const IotDataSourceSnapshot({
    required this.kind,
    required this.reachable,
    required this.sqliteReady,
    required this.sqliteToggleOn,
    required this.readyDatabases,
    this.selectedDbFileName,
  });
}
