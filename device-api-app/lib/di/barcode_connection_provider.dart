import 'package:egovframe_mobile_deviceapi_app/data/barcode/datasources/barcode_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barcode_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class BarcodeConnection extends _$BarcodeConnection {
  @override
  BarcodeConnectionState build() => const BarcodeConnectionState();

  void useServer() {
    state = const BarcodeConnectionState(mode: BarcodeConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = BarcodeConnectionState(
      mode: BarcodeConnectionMode.sqlite,
      sqliteDbFileName: dbFileName,
    );
  }
}

@Riverpod(keepAlive: true)
SqliteService sqliteService(Ref ref) => SqliteService();

@Riverpod(keepAlive: true)
FeatureTableService featureTableService(Ref ref) =>
    FeatureTableService(ref.watch(sqliteServiceProvider));

@Riverpod(keepAlive: true)
BarcodeSqliteService barcodeSqliteService(Ref ref) =>
    BarcodeSqliteService(ref.watch(featureTableServiceProvider));
