import 'package:egovframe_mobile_deviceapi_app/data/contacts/datasources/contacts_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class ContactsConnection extends _$ContactsConnection {
  @override
  ContactsConnectionState build() => const ContactsConnectionState();

  void useServer() {
    state = const ContactsConnectionState(mode: ContactsConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = ContactsConnectionState(
      mode: ContactsConnectionMode.sqlite,
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
ContactsSqliteService contactsSqliteService(Ref ref) =>
    ContactsSqliteService(ref.watch(featureTableServiceProvider));
