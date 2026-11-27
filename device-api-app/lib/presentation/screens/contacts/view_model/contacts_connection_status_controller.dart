import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/contacts/datasources/contacts_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/contacts_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_connection_status_controller.g.dart';

class ContactsConnectionStatusSnapshot {
  final ContactsDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const ContactsConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class ContactsConnectionStatus extends _$ContactsConnectionStatus {
  final ContactsServerConnectionService _networkService = ContactsServerConnectionService();

  @override
  Future<ContactsConnectionStatusSnapshot> build() async {
    ref.watch(contactsConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<ContactsConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(contactsConnectionProvider);
    final sqliteService = ref.read(contactsSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return ContactsConnectionStatusSnapshot(
          activeSource: ContactsDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return ContactsConnectionStatusSnapshot(
        activeSource: ContactsDataSourceStatus.externalServer,
        statusDetail: AppConfig.contactsServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return ContactsConnectionStatusSnapshot(
      activeSource: ContactsDataSourceStatus.disconnected,
      statusDetail: AppConfig.contactsServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
