import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:egovframe_mobile_deviceapi_app/di/device_connection_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sqlite_manager_provider.g.dart';

@Riverpod(keepAlive: true)
SqliteRepository sqliteManagerRepository(Ref ref) =>
    SqliteRepositoryImpl(ref.watch(sqliteServiceProvider));

@Riverpod(keepAlive: true)
SqliteUseCase sqliteManagerUseCase(Ref ref) =>
    SqliteUseCase(ref.watch(sqliteManagerRepositoryProvider));
