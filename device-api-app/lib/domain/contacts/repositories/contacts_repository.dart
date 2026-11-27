import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';

abstract class ContactsRepository {
  Future<bool> requestContactsPermission();

  Future<bool> requestContactsWritePermission();

  Future<List<ContactPreview>> fetchDeviceContacts();

  Future<bool> uploadContactsInfo(ContactsInfo info);

  Future<List<ContactsInfo>> getContactsList();

  Future<bool> deleteContactInfo(ContactsInfo info);

  Future<bool> deleteAllContactsInfo();

  Future<bool> saveContactToDevice(ContactsInfo info);
}
