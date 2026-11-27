import 'package:egovframe_mobile_deviceapi_app/data/contacts/repositories/contacts_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/contacts/repositories/contacts_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsRemoteRepositoryImpl _remote;
  final ContactsSqliteRepositoryImpl _sqlite;
  final ContactsConnectionReader _readConnection;

  ContactsRepositoryImpl({
    required ContactsRemoteRepositoryImpl remote,
    required ContactsSqliteRepositoryImpl sqlite,
    required ContactsConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  ContactsRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<bool> requestContactsPermission() => _remote.requestContactsPermission();

  @override
  Future<bool> requestContactsWritePermission() =>
      _remote.requestContactsWritePermission();

  @override
  Future<List<ContactPreview>> fetchDeviceContacts() =>
      _remote.fetchDeviceContacts();

  @override
  Future<bool> uploadContactsInfo(ContactsInfo info) =>
      _active.uploadContactsInfo(info);

  @override
  Future<List<ContactsInfo>> getContactsList() => _active.getContactsList();

  @override
  Future<bool> deleteContactInfo(ContactsInfo info) =>
      _active.deleteContactInfo(info);

  @override
  Future<bool> deleteAllContactsInfo() => _active.deleteAllContactsInfo();

  @override
  Future<bool> saveContactToDevice(ContactsInfo info) =>
      _remote.saveContactToDevice(info);
}
