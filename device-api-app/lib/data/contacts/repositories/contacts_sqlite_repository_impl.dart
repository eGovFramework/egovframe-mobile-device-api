import 'package:egovframe_mobile_deviceapi_app/data/contacts/datasources/contacts_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/repositories/contacts_repository.dart';

typedef ContactsConnectionReader = ContactsConnectionState Function();

class ContactsSqliteRepositoryImpl implements ContactsRepository {
  final ContactsSqliteService _service;
  final ContactsConnectionReader _readConnection;

  ContactsSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<bool> requestContactsPermission() {
    throw UnsupportedError('SQLite 모드에서는 디바이스 연락처 권한을 사용하지 않습니다.');
  }

  @override
  Future<bool> requestContactsWritePermission() {
    throw UnsupportedError('SQLite 모드에서는 디바이스 연락처 권한을 사용하지 않습니다.');
  }

  @override
  Future<List<ContactPreview>> fetchDeviceContacts() {
    throw UnsupportedError('SQLite 모드에서는 디바이스 연락처 조회를 사용하지 않습니다.');
  }

  @override
  Future<bool> uploadContactsInfo(ContactsInfo info) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.uploadContactsInfo(dbFileName, info);
  }

  @override
  Future<List<ContactsInfo>> getContactsList() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getContactsList(dbFileName);
  }

  @override
  Future<bool> deleteContactInfo(ContactsInfo info) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteContactInfo(dbFileName, info);
  }

  @override
  Future<bool> deleteAllContactsInfo() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteAllContactsInfo(dbFileName);
  }

  @override
  Future<bool> saveContactToDevice(ContactsInfo info) {
    throw UnsupportedError('SQLite 모드에서는 디바이스 연락처 저장을 사용하지 않습니다.');
  }
}
