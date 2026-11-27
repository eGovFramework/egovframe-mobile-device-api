import 'package:egovframe_mobile_deviceapi_app/data/contacts/datasources/contacts_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/repositories/contacts_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class ContactsRemoteRepositoryImpl implements ContactsRepository {
  @override
  Future<bool> requestContactsPermission() => ContactsService.requestPermission();

  @override
  Future<bool> requestContactsWritePermission() =>
      ContactsService.requestWritePermission();

  @override
  Future<List<ContactPreview>> fetchDeviceContacts() =>
      ContactsService.fetchDeviceContacts();

  @override
  Future<bool> uploadContactsInfo(ContactsInfo info) async {
    final response = await ContactsService.postContactInfo(info.toUploadFields());
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    if (resultState == 'OK') {
      return true;
    }

    final useYn = (response['useYn'] ?? '').toString();
    return useYn == 'OK';
  }

  @override
  Future<List<ContactsInfo>> getContactsList() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    final rawList = await ContactsService.fetchContactInfoList(uuid);
    return rawList.map(ContactsInfo.fromJson).toList();
  }

  @override
  Future<bool> deleteContactInfo(ContactsInfo info) async {
    if (info.sn <= 0) {
      return false;
    }

    final uuid = info.uuid.isNotEmpty
        ? info.uuid
        : await DeviceUuidUtil.getDeviceUuid();
    if (uuid.isEmpty) {
      return false;
    }

    final response = await ContactsService.deleteContactInfo(
      sn: info.sn,
      uuid: uuid,
    );
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }

  @override
  Future<bool> deleteAllContactsInfo() async {
    final items = await getContactsList();
    if (items.isEmpty) {
      return true;
    }

    for (final item in items) {
      final success = await deleteContactInfo(item);
      if (!success) {
        return false;
      }
    }
    return true;
  }

  @override
  Future<bool> saveContactToDevice(ContactsInfo info) =>
      ContactsService.saveContactToDevice(info);
}
