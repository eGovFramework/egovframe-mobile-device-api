import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/barcode/datasources/barcode_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/barcode_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barcode_connection_status_controller.g.dart';

class BarcodeConnectionStatusSnapshot {
  final BarcodeDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const BarcodeConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class BarcodeConnectionStatus extends _$BarcodeConnectionStatus {
  final BarcodeServerConnectionService _networkService = BarcodeServerConnectionService();

  @override
  Future<BarcodeConnectionStatusSnapshot> build() async {
    ref.watch(barcodeConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<BarcodeConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(barcodeConnectionProvider);
    final sqliteService = ref.read(barcodeSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return BarcodeConnectionStatusSnapshot(
          activeSource: BarcodeDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return BarcodeConnectionStatusSnapshot(
        activeSource: BarcodeDataSourceStatus.externalServer,
        statusDetail: AppConfig.barcodeServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return BarcodeConnectionStatusSnapshot(
      activeSource: BarcodeDataSourceStatus.disconnected,
      statusDetail: AppConfig.barcodeServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
