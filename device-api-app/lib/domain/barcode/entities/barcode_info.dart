import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

class BarcodeInfo {
  final int sn;
  final String? uuid;
  final String codeType;
  final String codeText;
  final String useYn;
  final String codeDt;

  const BarcodeInfo({
    required this.sn,
    this.uuid,
    required this.codeType,
    required this.codeText,
    required this.useYn,
    required this.codeDt,
  });

  factory BarcodeInfo.fromJson(Map<String, dynamic> json) {
    return BarcodeInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asOptionalString(json, ['uuid', 'UUID']),
      codeType: JsonRead.asString(json, ['codeType', 'code_type', 'CODE_TYPE']),
      codeText: JsonRead.asString(json, ['codeText', 'code_text', 'CODE_TEXT']),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'N',
      ),
      codeDt: JsonRead.asString(json, ['codeDt', 'code_dt', 'CODE_DT']),
    );
  }

  Map<String, String> toUploadFields() {
    return {
      'uuid': uuid!,
      'codeType': codeType,
      'codeText': codeText,
      'useYn': useYn,
      'codeDt': codeDt,
    };
  }

  Map<String, Object?> toSqliteRow() {
    return {
      'sn': sn,
      if (uuid != null && uuid!.isNotEmpty) 'uuid': uuid,
      'codeType': codeType,
      'codeText': codeText,
      'useYn': useYn,
      'codeDt': codeDt,
    };
  }
}
