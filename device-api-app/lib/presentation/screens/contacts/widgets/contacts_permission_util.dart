import 'package:egovframe_mobile_deviceapi_app/data/contacts/datasources/contacts_service.dart';

class ContactsPermissionUtil {
  static Future<bool> ensureContactsPermission() async {
    return ContactsService.requestPermission();
  }
}
