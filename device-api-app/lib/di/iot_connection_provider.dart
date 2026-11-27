import 'package:egovframe_mobile_deviceapi_app/data/iot/datasources/iot_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iot_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class IotConnection extends _$IotConnection {
  @override
  IotConnectionState build() => const IotConnectionState();

  void useServer() {
    state = const IotConnectionState(mode: IotConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = IotConnectionState(
      mode: IotConnectionMode.sqlite,
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
IotSqliteService iotSqliteService(Ref ref) =>
    IotSqliteService(ref.watch(featureTableServiceProvider));
