import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_opener_message_keys.dart';

/// 플랫폼 파일 열기 API의 원시 결과 (Repository → UseCase 매핑용)
class FileOpenerPlatformResult {
  final bool success;
  final String message;

  const FileOpenerPlatformResult({
    required this.success,
    required this.message,
  });
}

sealed class FileOpenerLocalListResult {
  const FileOpenerLocalListResult();
}

class FileOpenerLocalListSuccess extends FileOpenerLocalListResult {
  final List<FileOpenerInfo> items;

  const FileOpenerLocalListSuccess(this.items);
}

class FileOpenerLocalListEmpty extends FileOpenerLocalListResult {
  final String message;

  const FileOpenerLocalListEmpty([
    this.message = FileOpenerMessageKeys.noLocalFiles,
  ]);
}

class FileOpenerLocalListFailure extends FileOpenerLocalListResult {
  final String message;

  const FileOpenerLocalListFailure(this.message);
}

sealed class FileOpenerServerListResult {
  const FileOpenerServerListResult();
}

class FileOpenerServerListSuccess extends FileOpenerServerListResult {
  final List<ServerFileInfo> items;

  const FileOpenerServerListSuccess(this.items);
}

class FileOpenerServerListEmpty extends FileOpenerServerListResult {
  final String message;

  const FileOpenerServerListEmpty([
    this.message = FileOpenerMessageKeys.noServerFiles,
  ]);
}

class FileOpenerServerListFailure extends FileOpenerServerListResult {
  final String message;

  const FileOpenerServerListFailure(this.message);
}

sealed class FileOpenerOpenResult {
  const FileOpenerOpenResult();
}

class FileOpenerOpenSuccess extends FileOpenerOpenResult {
  const FileOpenerOpenSuccess();
}

class FileOpenerOpenFailure extends FileOpenerOpenResult {
  final String message;

  const FileOpenerOpenFailure(this.message);
}

sealed class FileOpenerPickResult {
  const FileOpenerPickResult();
}

class FileOpenerPickSuccess extends FileOpenerPickResult {
  final List<FileOpenerInfo> files;

  const FileOpenerPickSuccess(this.files);
}

class FileOpenerPickCancelled extends FileOpenerPickResult {
  const FileOpenerPickCancelled();
}

class FileOpenerPickFailure extends FileOpenerPickResult {
  final String message;

  const FileOpenerPickFailure(this.message);
}

sealed class FileOpenerDeleteResult {
  const FileOpenerDeleteResult();
}

class FileOpenerDeleteSuccess extends FileOpenerDeleteResult {
  final String fileName;

  const FileOpenerDeleteSuccess(this.fileName);
}

class FileOpenerDeleteFailure extends FileOpenerDeleteResult {
  final String message;

  const FileOpenerDeleteFailure(this.message);
}

sealed class FileOpenerDownloadResult {
  const FileOpenerDownloadResult();
}

class FileOpenerDownloadSuccess extends FileOpenerDownloadResult {
  final FileOpenerInfo fileInfo;
  final String message;

  const FileOpenerDownloadSuccess({
    required this.fileInfo,
    this.message = FileOpenerMessageKeys.downloadSuccess,
  });
}

class FileOpenerDownloadFailure extends FileOpenerDownloadResult {
  final String message;

  const FileOpenerDownloadFailure(this.message);
}

/// 플랫폼 결과를 Domain 결과로 변환
FileOpenerOpenResult mapOpenResult(FileOpenerPlatformResult result) {
  if (result.success) {
    return const FileOpenerOpenSuccess();
  }
  return FileOpenerOpenFailure(
    result.message.isNotEmpty ? result.message : FileOpenerMessageKeys.openFailed,
  );
}
