import 'package:egovframe_mobile_deviceapi_app/data/gps/datasources/gps_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gps_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class GpsConnection extends _$GpsConnection {
  @override
  GpsConnectionState build() => const GpsConnectionState();

  void useServer() {
    state = const GpsConnectionState(mode: GpsConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = GpsConnectionState(
      mode: GpsConnectionMode.sqlite,
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
GpsSqliteService gpsSqliteService(Ref ref) =>
    GpsSqliteService(ref.watch(featureTableServiceProvider));
