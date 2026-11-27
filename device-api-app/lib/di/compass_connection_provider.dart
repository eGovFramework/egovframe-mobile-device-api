import 'package:egovframe_mobile_deviceapi_app/data/compass/datasources/compass_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compass_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class CompassConnection extends _$CompassConnection {
  @override
  CompassConnectionState build() => const CompassConnectionState();

  void useServer() {
    state = const CompassConnectionState(mode: CompassConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = CompassConnectionState(
      mode: CompassConnectionMode.sqlite,
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
CompassSqliteService compassSqliteService(Ref ref) =>
    CompassSqliteService(ref.watch(featureTableServiceProvider));
