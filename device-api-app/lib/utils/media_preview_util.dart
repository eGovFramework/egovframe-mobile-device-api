import 'package:egovframe_mobile_deviceapi_app/data/media/datasources/media_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';

/// 서버 미디어 미리보기용 fileSn·다운로드 URL 해석
int? resolveMediaFileSn(MediaFileInfo info) {
  if (info.fileSn != null && info.fileSn! > 0) {
    return info.fileSn;
  }
  if (info.serverSn != null && info.serverSn! > 0) {
    return info.serverSn;
  }
  return null;
}

String? resolveServerMediaDownloadUrl(MediaFileInfo info) {
  final fileSn = resolveMediaFileSn(info);
  final uuid = info.uuid?.trim() ?? '';
  if (fileSn == null || uuid.isEmpty) {
    return null;
  }
  return MediaService.getMediaDownloadUrl(fileSn, uuid: uuid);
}
