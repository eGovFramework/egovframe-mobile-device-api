import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

/// 서버 MEDIA 테이블 항목
class StreamingMediaInfo {
  final int sn;
  final int fileSn;
  final String mdSj;
  final String mdCode;
  final String revivCo;

  const StreamingMediaInfo({
    required this.sn,
    required this.fileSn,
    required this.mdSj,
    required this.mdCode,
    required this.revivCo,
  });

  factory StreamingMediaInfo.fromJson(Map<String, dynamic> json) {
    return StreamingMediaInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      fileSn: JsonRead.asInt(json, ['fileSn', 'FILE_SN', 'file_sn']),
      mdSj: JsonRead.asString(json, ['mdSj', 'MD_SJ', 'md_sj']),
      mdCode: JsonRead.asString(json, ['mdCode', 'MD_CODE', 'md_code']),
      revivCo: JsonRead.asString(
        json,
        ['revivCo', 'REVIV_CO', 'reviv_co'],
        defaultValue: '0',
      ),
    );
  }

  StreamingMediaInfo copyWith({String? revivCo}) {
    return StreamingMediaInfo(
      sn: sn,
      fileSn: fileSn,
      mdSj: mdSj,
      mdCode: mdCode,
      revivCo: revivCo ?? this.revivCo,
    );
  }

  bool get hasPlayableFile => fileSn > 0;
}
