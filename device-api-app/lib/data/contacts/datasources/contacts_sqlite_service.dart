import 'package:egovframe_mobile_deviceapi_app/config/contacts_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef ContactsSqliteSetupStatus = SqliteSetupStatus;

class ContactsSqliteService {
  final FeatureTableService _featureTable;

  ContactsSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => ContactsSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<ContactsSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<ContactsSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> uploadContactsInfo(String fileName, ContactsInfo info) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;

    final sn = await _featureTable.nextMaxIntColumn(
      fileName,
      _schema,
      'sn',
      filterColumn: 'uuid',
      filterValue: info.uuid,
    );

    return _featureTable.insertRow(
      fileName,
      _schema,
      {
        ...info.toSqliteRow(),
        'sn': sn,
      },
    );
  }

  Future<List<ContactsInfo>> getContactsList(String fileName) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToContactsInfo)
        .where((item) => item.useYn == 'Y')
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<bool> deleteContactInfo(String fileName, ContactsInfo info) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;

    final sn = info.sn;
    final uuid = info.uuid.trim();
    if (sn <= 0 || uuid.isEmpty) return false;

    return _featureTable.updateRow(
      fileName,
      _schema,
      {'useYn': 'N'},
      {'sn': sn, 'uuid': uuid},
    );
  }

  Future<bool> deleteAllContactsInfo(String fileName) async {
    final items = await getContactsList(fileName);
    if (items.isEmpty) {
      return true;
    }

    for (final item in items) {
      final success = await deleteContactInfo(fileName, item);
      if (!success) {
        return false;
      }
    }
    return true;
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  ContactsInfo _rowToContactsInfo(Map<String, Object?> row) {
    return ContactsInfo.fromJson({
      'sn': row['sn'],
      'name': row['name'],
      'telno': row['telno'],
      'emails': row['emails'],
      'useYn': row['useYn'],
      'uuid': row['uuid'],
    });
  }
}
