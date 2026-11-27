import 'package:egovframe_mobile_deviceapi_app/data/accelerator/datasources/accelerator_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accelerator_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class AcceleratorConnection extends _$AcceleratorConnection {
  @override
  AcceleratorConnectionState build() => const AcceleratorConnectionState();

  void useServer() {
    state = const AcceleratorConnectionState(
      mode: AcceleratorConnectionMode.server,
    );
  }

  void useSqlite(String dbFileName) {
    state = AcceleratorConnectionState(
      mode: AcceleratorConnectionMode.sqlite,
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
AcceleratorSqliteService acceleratorSqliteService(Ref ref) =>
    AcceleratorSqliteService(ref.watch(featureTableServiceProvider));
