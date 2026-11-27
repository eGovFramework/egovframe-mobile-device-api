import 'package:egovframe_mobile_deviceapi_app/data/interface/datasources/interface_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interface_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class InterfaceConnection extends _$InterfaceConnection {
  @override
  InterfaceConnectionState build() => const InterfaceConnectionState();

  void useServer() {
    state = const InterfaceConnectionState(mode: InterfaceConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = InterfaceConnectionState(
      mode: InterfaceConnectionMode.sqlite,
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
InterfaceSqliteService interfaceSqliteService(Ref ref) =>
    InterfaceSqliteService(ref.watch(featureTableServiceProvider));
