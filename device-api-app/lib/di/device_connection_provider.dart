import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/datasources/device_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class DeviceConnection extends _$DeviceConnection {
  @override
  DeviceConnectionState build() => const DeviceConnectionState();

  void useServer() {
    state = const DeviceConnectionState(mode: DeviceConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = DeviceConnectionState(
      mode: DeviceConnectionMode.sqlite,
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
DeviceSqliteService deviceSqliteService(Ref ref) =>
    DeviceSqliteService(ref.watch(featureTableServiceProvider));
