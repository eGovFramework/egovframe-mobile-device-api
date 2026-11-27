import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/contacts_message_keys.dart';

sealed class ContactsUploadResult {
  const ContactsUploadResult();
}

class ContactsUploadSuccess extends ContactsUploadResult {
  const ContactsUploadSuccess();
}

class ContactsUploadFailure extends ContactsUploadResult {
  final String message;

  const ContactsUploadFailure(this.message);
}

sealed class ContactsUploadBatchResult {
  const ContactsUploadBatchResult();
}

class ContactsUploadBatchSuccess extends ContactsUploadBatchResult {
  final int count;

  const ContactsUploadBatchSuccess(this.count);
}

class ContactsUploadBatchFailure extends ContactsUploadBatchResult {
  final String message;

  const ContactsUploadBatchFailure(this.message);
}

sealed class ContactsDeviceLoadResult {
  const ContactsDeviceLoadResult();
}

class ContactsDeviceLoadSuccess extends ContactsDeviceLoadResult {
  final List<ContactPreview> items;

  const ContactsDeviceLoadSuccess(this.items);
}

class ContactsDeviceLoadEmpty extends ContactsDeviceLoadResult {
  const ContactsDeviceLoadEmpty();
}

class ContactsDeviceLoadFailure extends ContactsDeviceLoadResult {
  final String message;

  const ContactsDeviceLoadFailure(this.message);
}

sealed class ContactsListLoadResult {
  const ContactsListLoadResult();
}

class ContactsListLoadSuccess extends ContactsListLoadResult {
  final List<ContactsInfo> items;

  const ContactsListLoadSuccess(this.items);
}

class ContactsListLoadEmpty extends ContactsListLoadResult {
  final String message;

  const ContactsListLoadEmpty([this.message = ContactsMessageKeys.emptyList]);
}

class ContactsListLoadFailure extends ContactsListLoadResult {
  final String message;

  const ContactsListLoadFailure(this.message);
}

sealed class ContactsDeleteAllResult {
  const ContactsDeleteAllResult();
}

class ContactsDeleteAllSuccess extends ContactsDeleteAllResult {
  const ContactsDeleteAllSuccess();
}

class ContactsDeleteAllFailure extends ContactsDeleteAllResult {
  final String message;

  const ContactsDeleteAllFailure(this.message);
}

sealed class ContactsDeleteBatchResult {
  const ContactsDeleteBatchResult();
}

class ContactsDeleteBatchSuccess extends ContactsDeleteBatchResult {
  final int count;

  const ContactsDeleteBatchSuccess(this.count);
}

class ContactsDeleteBatchFailure extends ContactsDeleteBatchResult {
  final String message;

  const ContactsDeleteBatchFailure(this.message);
}

sealed class ContactsDeviceSaveBatchResult {
  const ContactsDeviceSaveBatchResult();
}

class ContactsDeviceSaveBatchSuccess extends ContactsDeviceSaveBatchResult {
  final int count;
  final int skippedDuplicateCount;

  const ContactsDeviceSaveBatchSuccess(
    this.count, {
    this.skippedDuplicateCount = 0,
  });
}

class ContactsDeviceSaveBatchFailure extends ContactsDeviceSaveBatchResult {
  final String message;

  const ContactsDeviceSaveBatchFailure(this.message);
}
