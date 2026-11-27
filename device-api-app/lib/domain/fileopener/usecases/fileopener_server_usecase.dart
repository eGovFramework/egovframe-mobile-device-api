import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/repositories/fileopener_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_opener_message_keys.dart';

class FileopenerServerUseCase {
  final ServerFileRepository repository;

  FileopenerServerUseCase(this.repository);

  /// 로컬 파일 목록 조회
  Future<FileOpenerLocalListResult> loadLocalFileList() async {
    try {
      final items = await repository.getLocalFileList();
      if (items.isEmpty) {
        return const FileOpenerLocalListEmpty();
      }
      return FileOpenerLocalListSuccess(items);
    } catch (e) {
      return FileOpenerLocalListFailure(
        '${FileOpenerMessageKeys.localListFailedPrefix}$e',
      );
    }
  }

  /// 파일 열기
  Future<FileOpenerOpenResult> openFile(FileOpenerInfo fileInfo) async {
    try {
      final result = await repository.openFile(fileInfo);
      return mapOpenResult(result);
    } catch (e) {
      return FileOpenerOpenFailure('${FileOpenerMessageKeys.openErrorPrefix}$e');
    }
  }

  /// 파일 선택 (피커)
  Future<FileOpenerPickResult> pickFiles({required bool allowMultiple}) async {
    try {
      final files = await repository.pickFiles(allowMultiple: allowMultiple);
      if (files == null || files.isEmpty) {
        return const FileOpenerPickCancelled();
      }
      return FileOpenerPickSuccess(files);
    } catch (e) {
      return FileOpenerPickFailure('${FileOpenerMessageKeys.pickErrorPrefix}$e');
    }
  }

  /// 로컬 파일 삭제
  Future<FileOpenerDeleteResult> deleteLocalFile(
    FileOpenerInfo fileInfo,
  ) async {
    try {
      final success = await repository.deleteLocalFile(fileInfo);
      if (success) {
        return FileOpenerDeleteSuccess(fileInfo.fileName);
      }
      return const FileOpenerDeleteFailure(FileOpenerMessageKeys.deleteFailed);
    } catch (e) {
      return FileOpenerDeleteFailure(
        '${FileOpenerMessageKeys.deleteErrorPrefix}$e',
      );
    }
  }

  /// 서버 파일 목록 조회
  Future<FileOpenerServerListResult> loadServerFileList() async {
    try {
      final items = await repository.getServerFileList();
      if (items.isEmpty) {
        return const FileOpenerServerListEmpty();
      }
      return FileOpenerServerListSuccess(items);
    } catch (e) {
      return FileOpenerServerListFailure(
        '${FileOpenerMessageKeys.serverListErrorPrefix}$e',
      );
    }
  }

  /// 서버 파일 다운로드 (진행률 콜백 지원)
  Future<FileOpenerDownloadResult> downloadServerFile(
    ServerFileInfo serverFile, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final fileInfo = onProgress != null
          ? await repository.downloadServerFileWithProgress(
              serverFile,
              onProgress,
            )
          : await repository.downloadServerFile(serverFile);

      if (fileInfo != null) {
        return FileOpenerDownloadSuccess(
          fileInfo: fileInfo,
          message:
              '${FileOpenerMessageKeys.downloadSuccessPrefix}${serverFile.orignlFileNm}',
        );
      }
      return const FileOpenerDownloadFailure(FileOpenerMessageKeys.downloadFailed);
    } catch (e) {
      return FileOpenerDownloadFailure(
        '${FileOpenerMessageKeys.downloadErrorPrefix}$e',
      );
    }
  }
}
