import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contact_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_device_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/contacts/entities/contacts_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

/// 연락처 조회 및 서버 HTTP 통신 (device-api-web /ctt REST)
class ContactsService {
  static Future<bool> requestWritePermission() async {
    try {
      return FlutterContacts.requestPermission(readonly: false);
    } catch (e) {
      appLog('ContactsService.requestWritePermission failed: $e');
      return false;
    }
  }

  static Contact _toDeviceContact(ContactsInfo info) {
    final displayName = info.name.isNotEmpty
        ? info.name
        : (info.telno.isNotEmpty ? info.telno : info.emails);

    return Contact(
      displayName: displayName,
      name: Name(first: info.name),
      phones: info.telno.isNotEmpty ? [Phone(info.telno)] : <Phone>[],
      emails: info.emails.isNotEmpty ? [Email(info.emails)] : <Email>[],
    );
  }

  static String normalizePhone(String phone) => contactsNormalizePhone(phone);

  static bool isDuplicateOnDevice(
    ContactsInfo info,
    List<ContactPreview> deviceContacts,
  ) =>
      contactsIsDuplicateOnDevice(info, deviceContacts);

  static Future<bool> saveContactToDevice(ContactsInfo info) async {
    if (!info.hasDeviceSaveData) {
      return false;
    }

    try {
      await FlutterContacts.insertContact(_toDeviceContact(info));
      return true;
    } catch (e) {
      appLog('ContactsService.saveContactToDevice failed: $e');
      return false;
    }
  }

  static Future<bool> requestPermission() async {
    try {
      return FlutterContacts.requestPermission(readonly: true);
    } catch (e) {
      appLog('ContactsService.requestPermission failed: $e');
      return false;
    }
  }

  static Future<List<ContactPreview>> fetchDeviceContacts() async {
    try {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      return contacts.map(ContactPreview.fromContact).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } catch (e) {
      appLog('ContactsService.fetchDeviceContacts failed: $e');
      return [];
    }
  }

  /// 서버: 연락처 정보 등록
  static Future<Map<String, dynamic>?> postContactInfo(
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse(AppConfig.getContactsUrl('/insertContactInfo.do'));

    try {
      final resp = await DeviceApiClient.post(uri, body: fields);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('ContactsService.postContactInfo failed: $e');
      return null;
    }
  }

  /// 서버: 연락처 정보 목록 조회
  static Future<List<Map<String, dynamic>>> fetchContactInfoList(
    String uuid,
  ) async {
    if (uuid.isEmpty) {
      return [];
    }
    final uri = Uri.parse(
      AppConfig.getContactsUrl('/selectContactInfoList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return [];
      }

      return resp.list('contactInfoList');
    } catch (e) {
      appLog('ContactsService.fetchContactInfoList failed: $e');
      return [];
    }
  }

  /// 서버: 연락처 정보 논리 삭제 (sn + uuid, USEYN='N')
  static Future<Map<String, dynamic>?> deleteContactInfo({
    required int sn,
    required String uuid,
  }) async {
    final uri = Uri.parse(
      AppConfig.getContactsUrl('/deleteContactInfo.do'),
    ).replace(queryParameters: {'sn': sn.toString(), 'uuid': uuid});

    try {
      final resp = await DeviceApiClient.delete(uri);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('ContactsService.deleteContactInfo failed: $e');
      return null;
    }
  }
}
