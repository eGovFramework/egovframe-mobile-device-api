import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/datasources/face_mesh_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'face_mesh_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class FaceMeshConnection extends _$FaceMeshConnection {
  @override
  FaceMeshConnectionState build() => const FaceMeshConnectionState();

  void useServer() {
    state = const FaceMeshConnectionState(
      mode: FaceMeshConnectionMode.server,
    );
  }

  void useSqlite(String dbFileName) {
    state = FaceMeshConnectionState(
      mode: FaceMeshConnectionMode.sqlite,
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
FaceMeshSqliteService faceMeshSqliteService(Ref ref) =>
    FaceMeshSqliteService(ref.watch(featureTableServiceProvider));
