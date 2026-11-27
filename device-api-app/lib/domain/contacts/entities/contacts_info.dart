import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

class ContactsInfo {
  final int sn;
  final String name;
  final String telno;
  final String emails;
  final String useYn;
  final String uuid;

  const ContactsInfo({
    required this.sn,
    required this.name,
    required this.telno,
    required this.emails,
    required this.useYn,
    required this.uuid,
  });

  factory ContactsInfo.fromJson(Map<String, dynamic> json) {
    return ContactsInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      name: JsonRead.asString(json, ['name', 'NAME'], trim: true),
      telno: JsonRead.asString(json, ['telno', 'TELNO'], trim: true),
      emails: JsonRead.asString(json, ['emails', 'EMAILS'], trim: true),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'N',
        trim: true,
      ),
      uuid: JsonRead.asString(json, ['uuid', 'UUID'], trim: true),
    );
  }

  Map<String, String> toUploadFields() {
    return {
      'name': name,
      'telno': telno,
      'emails': emails,
      'useYn': useYn,
      'uuid': uuid,
    };
  }

  /// SQLite insert용 행. sn 채번은 datasource에서 덮어쓴다.
  Map<String, Object?> toSqliteRow() {
    return {
      'sn': sn,
      'name': name,
      'telno': telno,
      'emails': emails,
      'useYn': useYn,
      'uuid': uuid,
    };
  }

  bool get hasDeviceSaveData =>
      name.isNotEmpty || telno.isNotEmpty || emails.isNotEmpty;
}
