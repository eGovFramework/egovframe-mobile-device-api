import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_readwrite_message_keys.dart';

sealed class FileReadWriteLocalListResult {
  const FileReadWriteLocalListResult();
}

class FileReadWriteLocalListSuccess extends FileReadWriteLocalListResult {
  final List<FileInfo> items;

  const FileReadWriteLocalListSuccess(this.items);
}

class FileReadWriteLocalListEmpty extends FileReadWriteLocalListResult {
  final String message;

  const FileReadWriteLocalListEmpty([
    this.message = FileReadWriteMessageKeys.noLocalFiles,
  ]);
}

class FileReadWriteLocalListFailure extends FileReadWriteLocalListResult {
  final String message;

  const FileReadWriteLocalListFailure(this.message);
}

sealed class FileReadWriteServerListResult {
  const FileReadWriteServerListResult();
}

class FileReadWriteServerListSuccess extends FileReadWriteServerListResult {
  final List<FileInfo> items;

  const FileReadWriteServerListSuccess(this.items);
}

class FileReadWriteServerListEmpty extends FileReadWriteServerListResult {
  final String message;

  const FileReadWriteServerListEmpty([
    this.message = FileReadWriteMessageKeys.noServerFiles,
  ]);
}

class FileReadWriteServerListFailure extends FileReadWriteServerListResult {
  final String message;

  const FileReadWriteServerListFailure(this.message);
}

sealed class FileReadWriteCreateResult {
  const FileReadWriteCreateResult();
}

class FileReadWriteCreateSuccess extends FileReadWriteCreateResult {
  final String fileName;
  final String message;

  const FileReadWriteCreateSuccess({
    required this.fileName,
    this.message = FileReadWriteMessageKeys.createSuccess,
  });
}

class FileReadWriteCreateFailure extends FileReadWriteCreateResult {
  final String message;

  const FileReadWriteCreateFailure(this.message);
}

sealed class FileReadWriteReadResult {
  const FileReadWriteReadResult();
}

class FileReadWriteReadSuccess extends FileReadWriteReadResult {
  final String fileName;
  final String content;

  const FileReadWriteReadSuccess({
    required this.fileName,
    required this.content,
  });
}

class FileReadWriteReadFailure extends FileReadWriteReadResult {
  final String message;

  const FileReadWriteReadFailure(this.message);
}

sealed class FileReadWriteImportResult {
  const FileReadWriteImportResult();
}

class FileReadWriteImportSuccess extends FileReadWriteImportResult {
  final int count;

  const FileReadWriteImportSuccess(this.count);
}

class FileReadWriteImportCancelled extends FileReadWriteImportResult {
  const FileReadWriteImportCancelled();
}

class FileReadWriteImportFailure extends FileReadWriteImportResult {
  final String message;

  const FileReadWriteImportFailure(this.message);
}

sealed class FileReadWriteDeleteResult {
  const FileReadWriteDeleteResult();
}

class FileReadWriteDeleteSuccess extends FileReadWriteDeleteResult {
  final String fileName;

  const FileReadWriteDeleteSuccess(this.fileName);
}

class FileReadWriteDeleteFailure extends FileReadWriteDeleteResult {
  final String message;

  const FileReadWriteDeleteFailure(this.message);
}

sealed class FileReadWriteBatchDeleteResult {
  const FileReadWriteBatchDeleteResult();

  int get successCount;
  int get failCount;
  List<String> get failedFiles;
  bool get isAllSuccess => failCount == 0;
}

class FileReadWriteBatchDeleteSuccess extends FileReadWriteBatchDeleteResult {
  @override
  final int successCount;
  @override
  final int failCount;
  @override
  final List<String> failedFiles;

  const FileReadWriteBatchDeleteSuccess({
    required this.successCount,
    this.failCount = 0,
    this.failedFiles = const [],
  });
}

class FileReadWriteBatchDeleteEmpty extends FileReadWriteBatchDeleteResult {
  const FileReadWriteBatchDeleteEmpty();

  @override
  int get successCount => 0;

  @override
  int get failCount => 0;

  @override
  List<String> get failedFiles => const [];
}

sealed class FileReadWriteUploadResult {
  const FileReadWriteUploadResult();
}

class FileReadWriteUploadSuccess extends FileReadWriteUploadResult {
  final int successCount;
  final int failCount;
  final String message;

  const FileReadWriteUploadSuccess({
    required this.successCount,
    this.failCount = 0,
    this.message = FileReadWriteMessageKeys.uploadSuccess,
  });
}

class FileReadWriteUploadFailure extends FileReadWriteUploadResult {
  final String message;

  const FileReadWriteUploadFailure(this.message);
}

sealed class FileReadWriteServerDeleteResult {
  const FileReadWriteServerDeleteResult();
}

class FileReadWriteServerDeleteSuccess extends FileReadWriteServerDeleteResult {
  final String fileName;

  const FileReadWriteServerDeleteSuccess(this.fileName);
}

class FileReadWriteServerDeleteFailure extends FileReadWriteServerDeleteResult {
  final String message;

  const FileReadWriteServerDeleteFailure(this.message);
}
