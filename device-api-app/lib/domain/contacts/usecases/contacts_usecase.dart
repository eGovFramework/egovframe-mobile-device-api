import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_device_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/repositories/contacts_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/contacts_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class ContactsUseCase {
  final ContactsRepository repository;

  ContactsUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  Future<bool> requestContactsPermission() => repository.requestContactsPermission();

  Future<ContactsDeviceLoadResult> loadDeviceContacts() async {
    try {
      final granted = await repository.requestContactsPermission();
      if (!granted) {
        return const ContactsDeviceLoadFailure(
          ContactsMessageKeys.permissionDenied,
        );
      }

      final items = await repository.fetchDeviceContacts();
      if (items.isEmpty) {
        return const ContactsDeviceLoadEmpty();
      }
      return ContactsDeviceLoadSuccess(items);
    } catch (e) {
      return ContactsDeviceLoadFailure(
        '${ContactsMessageKeys.contactsLoadErrorPrefix}$e',
      );
    }
  }

  Future<ContactsUploadResult> uploadContactsToServer(ContactsInfo info) async {
    if (info.uuid.isEmpty) {
      return const ContactsUploadFailure(ContactsMessageKeys.noUuid);
    }
    if (info.name.isEmpty && info.telno.isEmpty && info.emails.isEmpty) {
      return const ContactsUploadFailure(ContactsMessageKeys.noHeadingData);
    }

    try {
      final success = await repository.uploadContactsInfo(info);
      if (success) {
        return const ContactsUploadSuccess();
      }
      return const ContactsUploadFailure(ContactsMessageKeys.uploadFailed);
    } catch (e) {
      return ContactsUploadFailure('${ContactsMessageKeys.uploadErrorPrefix}$e');
    }
  }

  Future<ContactsListLoadResult> loadContactsList() async {
    try {
      final items = await repository.getContactsList();
      if (items.isEmpty) {
        return const ContactsListLoadEmpty();
      }
      return ContactsListLoadSuccess(items);
    } catch (e) {
      return ContactsListLoadFailure('${ContactsMessageKeys.listLoadErrorPrefix}$e');
    }
  }

  Future<ContactsDeleteBatchResult> deleteContactsItems(
    List<ContactsInfo> items,
  ) async {
    if (items.isEmpty) {
      return const ContactsDeleteBatchFailure(ContactsMessageKeys.noSelection);
    }

    for (final item in items) {
      try {
        final success = await repository.deleteContactInfo(item);
        if (!success) {
          return const ContactsDeleteBatchFailure(ContactsMessageKeys.deleteFailed);
        }
      } catch (e) {
        return ContactsDeleteBatchFailure(
          '${ContactsMessageKeys.genericErrorPrefix}$e',
        );
      }
    }

    return ContactsDeleteBatchSuccess(items.length);
  }

  Future<bool> requestContactsWritePermission() =>
      repository.requestContactsWritePermission();

  Future<ContactsDeviceSaveBatchResult> saveContactsToDevice(
    List<ContactsInfo> items,
  ) async {
    if (items.isEmpty) {
      return const ContactsDeviceSaveBatchFailure(ContactsMessageKeys.noSelection);
    }

    final savableItems = items.where((item) => item.hasDeviceSaveData).toList();
    if (savableItems.isEmpty) {
      return const ContactsDeviceSaveBatchFailure(
        ContactsMessageKeys.noHeadingData,
      );
    }

    try {
      final granted = await requestContactsWritePermission();
      if (!granted) {
        return const ContactsDeviceSaveBatchFailure(
          ContactsMessageKeys.writePermissionDenied,
        );
      }

      final deviceContacts = await repository.fetchDeviceContacts();
      final seenKeys = <String>{};
      final newItems = <ContactsInfo>[];
      var skippedDuplicateCount = 0;

      for (final item in savableItems) {
        final matchKey = contactsDeviceMatchKey(item);
        if (seenKeys.contains(matchKey)) {
          skippedDuplicateCount++;
          continue;
        }
        seenKeys.add(matchKey);

        if (contactsIsDuplicateOnDevice(item, deviceContacts)) {
          skippedDuplicateCount++;
          continue;
        }

        newItems.add(item);
      }

      for (final item in newItems) {
        final success = await repository.saveContactToDevice(item);
        if (!success) {
          return const ContactsDeviceSaveBatchFailure(
            ContactsMessageKeys.saveToDeviceFailed,
          );
        }
      }

      return ContactsDeviceSaveBatchSuccess(
        newItems.length,
        skippedDuplicateCount: skippedDuplicateCount,
      );
    } catch (e) {
      return ContactsDeviceSaveBatchFailure(
        '${ContactsMessageKeys.genericErrorPrefix}$e',
      );
    }
  }

  Future<ContactsDeleteAllResult> deleteAllContactsFromServer() async {
    try {
      final success = await repository.deleteAllContactsInfo();
      if (success) {
        return const ContactsDeleteAllSuccess();
      }
      return const ContactsDeleteAllFailure(ContactsMessageKeys.deleteFailed);
    } catch (e) {
      return ContactsDeleteAllFailure('${ContactsMessageKeys.genericErrorPrefix}$e');
    }
  }
}
