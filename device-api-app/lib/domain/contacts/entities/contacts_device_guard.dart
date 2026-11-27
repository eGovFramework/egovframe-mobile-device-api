import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';

String contactsNormalizePhone(String phone) {
  return phone.replaceAll(RegExp(r'\D'), '');
}

bool contactsIsDuplicateOnDevice(
  ContactsInfo info,
  List<ContactPreview> deviceContacts,
) {
  final infoPhone = contactsNormalizePhone(info.telno);
  final infoEmail = info.emails.toLowerCase().trim();
  final infoName = info.name.trim().toLowerCase();

  for (final device in deviceContacts) {
    final devicePhone = contactsNormalizePhone(device.phone);
    if (infoPhone.isNotEmpty &&
        devicePhone.isNotEmpty &&
        infoPhone == devicePhone) {
      return true;
    }

    final deviceEmail = device.email.toLowerCase().trim();
    if (infoEmail.isNotEmpty &&
        deviceEmail.isNotEmpty &&
        infoEmail == deviceEmail) {
      return true;
    }

    final deviceName = device.name.trim().toLowerCase();
    if (infoPhone.isEmpty &&
        infoEmail.isEmpty &&
        infoName.isNotEmpty &&
        deviceName == infoName) {
      return true;
    }
  }

  return false;
}

String contactsDeviceMatchKey(ContactsInfo info) {
  final phone = contactsNormalizePhone(info.telno);
  if (phone.isNotEmpty) {
    return 'p:$phone';
  }

  final email = info.emails.toLowerCase().trim();
  if (email.isNotEmpty) {
    return 'e:$email';
  }

  return 'n:${info.name.trim().toLowerCase()}';
}
