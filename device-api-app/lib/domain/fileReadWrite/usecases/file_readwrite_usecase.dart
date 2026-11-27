import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/repositories/file_readwrite_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_readwrite_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class FileReadwriteUseCase {
  final FileRepository repository;

  FileReadwriteUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  /// 로컬 파일 목록 조회
  Future<FileReadWriteLocalListResult> loadLocalFileList(String deviceUuid) async {
    try {
      final items = await repository.getAllLocalFiles(deviceUuid);
      if (items.isEmpty) {
        return const FileReadWriteLocalListEmpty();
      }
      return FileReadWriteLocalListSuccess(items);
    } catch (e) {
      return FileReadWriteLocalListFailure(
        '${FileReadWriteMessageKeys.listLoadFailedPrefix}$e',
      );
    }
  }

  /// 텍스트 파일 생성
  Future<FileReadWriteCreateResult> createTextFile({
    required String fileName,
    required String content,
  }) async {
    if (fileName.trim().isEmpty) {
      return const FileReadWriteCreateFailure(
        FileReadWriteMessageKeys.createFailedPrefix,
      );
    }
    if (content.trim().isEmpty) {
      return const FileReadWriteCreateFailure(
        FileReadWriteMessageKeys.createFailedPrefix,
      );
    }

    final fullFileName =
        fileName.contains('.') ? fileName.trim() : '${fileName.trim()}.txt';

    try {
      final success = await repository.writeTextFile(fullFileName, content.trim());
      if (success) {
        return FileReadWriteCreateSuccess(fileName: fullFileName);
      }
      return const FileReadWriteCreateFailure(
        FileReadWriteMessageKeys.createFailedPrefix,
      );
    } catch (e) {
      return FileReadWriteCreateFailure(
        '${FileReadWriteMessageKeys.createFailedPrefix}$e',
      );
    }
  }

  /// 텍스트 파일 읽기 (Documents 루트 파일명)
  Future<FileReadWriteReadResult> readTextFile(String fileName) async {
    try {
      final content = await repository.readTextFile(fileName);
      if (content != null) {
        return FileReadWriteReadSuccess(fileName: fileName, content: content);
      }
      return FileReadWriteReadFailure(
        '${FileReadWriteMessageKeys.readFailedPrefix}$fileName',
      );
    } catch (e) {
      return FileReadWriteReadFailure(
        '${FileReadWriteMessageKeys.readFailedPrefix}$e',
      );
    }
  }

  /// 텍스트 파일 읽기 (전체 경로)
  Future<FileReadWriteReadResult> readTextFileByPath({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final content = await repository.readTextFileByPath(filePath);
      if (content != null) {
        return FileReadWriteReadSuccess(fileName: fileName, content: content);
      }
      return FileReadWriteReadFailure(
        '${FileReadWriteMessageKeys.readFailedPrefix}$fileName',
      );
    } catch (e) {
      return FileReadWriteReadFailure(
        '${FileReadWriteMessageKeys.readFailedPrefix}$e',
      );
    }
  }

  /// 로컬 저장소에서 파일 가져오기 (file_picker)
  Future<FileReadWriteImportResult> importLocalFiles() async {
    try {
      final imported = await repository.importLocalFiles();
      if (imported.isEmpty) {
        return const FileReadWriteImportCancelled();
      }
      return FileReadWriteImportSuccess(imported.length);
    } catch (e) {
      return FileReadWriteImportFailure(
        '${FileReadWriteMessageKeys.importFailedPrefix}$e',
      );
    }
  }

  /// 로컬 파일 단건 삭제
  Future<FileReadWriteDeleteResult> deleteLocalFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const FileReadWriteDeleteFailure(
          FileReadWriteMessageKeys.fileNotFound,
        );
      }
      final fileName = file.path.split(Platform.pathSeparator).last;
      await file.delete();
      return FileReadWriteDeleteSuccess(fileName);
    } catch (e) {
      return FileReadWriteDeleteFailure(
        '${FileReadWriteMessageKeys.deleteFailedPrefix}$e',
      );
    }
  }

  /// 로컬 파일 다건 삭제
  Future<FileReadWriteBatchDeleteResult> deleteLocalFiles(
    List<String> filePaths,
  ) async {
    int successCount = 0;
    int failCount = 0;
    final failedFiles = <String>[];

    for (final path in filePaths) {
      final result = await deleteLocalFile(path);
      switch (result) {
        case FileReadWriteDeleteSuccess():
          successCount++;
        case FileReadWriteDeleteFailure():
          failCount++;
          failedFiles.add(path.split(Platform.pathSeparator).last);
      }
    }

    return FileReadWriteBatchDeleteSuccess(
      successCount: successCount,
      failCount: failCount,
      failedFiles: failedFiles,
    );
  }

  /// 선택된 파일들을 서버에 업로드
  Future<FileReadWriteUploadResult> uploadFiles({
    required String deviceUuid,
    required List<File> files,
  }) async {
    if (deviceUuid.isEmpty) {
      return const FileReadWriteUploadFailure(
        FileReadWriteMessageKeys.noDeviceUuid,
      );
    }
    if (files.isEmpty) {
      return const FileReadWriteUploadFailure(
        FileReadWriteMessageKeys.noUploadFiles,
      );
    }

    try {
      final result =
          await repository.uploadFile(uuid: deviceUuid, files: files);

      if (result['success'] != true) {
        final errorMessage =
            result['message'] ?? result['resultMessage'] ?? '';
        return FileReadWriteUploadFailure(
          '${FileReadWriteMessageKeys.uploadFailedPrefix}$errorMessage',
        );
      }

      int successCount;
      int failCount;

      if (result['fileResults'] is List) {
        final totalFiles = (result['totalFiles'] ?? files.length) as int;
        final fileResults = result['fileResults'] as List<dynamic>;
        successCount =
            fileResults.where((r) => r['insertSuccess'] == true).length;
        failCount = totalFiles - successCount;
      } else {
        successCount = files.length;
        failCount = 0;
      }

      return FileReadWriteUploadSuccess(
        successCount: successCount,
        failCount: failCount,
      );
    } catch (e) {
      return FileReadWriteUploadFailure(
        '${FileReadWriteMessageKeys.uploadErrorPrefix}$e',
      );
    }
  }

  /// 서버 파일 목록 조회
  Future<FileReadWriteServerListResult> loadServerFileList(
    String deviceUuid,
  ) async {
    if (deviceUuid.isEmpty) {
      return const FileReadWriteServerListFailure(
        FileReadWriteMessageKeys.noDeviceUuid,
      );
    }

    try {
      final items = await repository.getFileInfoList(deviceUuid);
      if (items.isEmpty) {
        return const FileReadWriteServerListEmpty();
      }
      return FileReadWriteServerListSuccess(items);
    } catch (e) {
      return _mapServerListError(e);
    }
  }

  FileReadWriteServerListResult _mapServerListError(Object e) {
    return FileReadWriteServerListFailure(
      '${FileReadWriteMessageKeys.serverListFailedPrefix}$e',
    );
  }

  /// 서버 파일 삭제
  Future<FileReadWriteServerDeleteResult> deleteServerFile({
    required int sn,
    required String fileName,
  }) async {
    try {
      final success = await repository.deleteServerFile(sn: sn);
      if (success) {
        return FileReadWriteServerDeleteSuccess(fileName);
      }
      return FileReadWriteServerDeleteFailure(
        '${FileReadWriteMessageKeys.serverDeleteFailedPrefix}$fileName',
      );
    } catch (e) {
      return FileReadWriteServerDeleteFailure(
        '${FileReadWriteMessageKeys.serverDeleteFailedPrefix}$e',
      );
    }
  }
}
