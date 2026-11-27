import 'dart:async';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/fileopener/datasources/file_opener_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileopener/models/downloaded_file_data.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/repositories/fileopener_repository.dart';

class FileOpenerRemoteRepositoryImpl implements ServerFileRepository {
  FileOpenerRemoteRepositoryImpl();

  @override
  Future<List<ServerFileInfo>> getServerFileList() async {
    try {
      final jsonResponse = await FileOpenerService.fetchServerFileList();

      if (jsonResponse['resultState'] != 'OK') {
        throw Exception('서버에서 오류가 발생했습니다: ${jsonResponse['resultState']}');
      }

      final resultSet = jsonResponse['resultSet'] as List<dynamic>? ?? [];
      return resultSet
          .whereType<Map>()
          .map((item) => ServerFileInfo.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on SocketException {
      throw Exception('네트워크 연결을 확인해주세요.');
    } on TimeoutException {
      throw Exception('서버 응답이 너무 느립니다. 잠시 후 다시 시도해주세요.');
    } on FormatException {
      throw Exception('서버 응답 형식이 올바르지 않습니다.');
    } catch (e) {
      throw Exception('서버 파일 목록을 불러올 수 없습니다: $e');
    }
  }

  @override
  Future<FileOpenerInfo?> downloadServerFile(ServerFileInfo serverFile) async {
    final downloaded = await FileOpenerService.downloadServerFileBySn(
      fileSn: serverFile.fileSn,
      orignlFileNm: serverFile.orignlFileNm,
      fileExtension: serverFile.fileExtension,
      mimeType: serverFile.mimeType,
    );
    return downloaded == null ? null : _toFileOpenerInfo(downloaded);
  }

  @override
  Future<FileOpenerInfo?> downloadServerFileWithProgress(
    ServerFileInfo serverFile,
    Function(double progress)? onProgress,
  ) async {
    final downloaded = await FileOpenerService.downloadServerFileBySnWithProgress(
      fileSn: serverFile.fileSn,
      orignlFileNm: serverFile.orignlFileNm,
      fileExtension: serverFile.fileExtension,
      mimeType: serverFile.mimeType,
      onProgress: onProgress,
    );
    return downloaded == null ? null : _toFileOpenerInfo(downloaded);
  }

  FileOpenerInfo _toFileOpenerInfo(DownloadedFileData data) {
    return FileOpenerInfo(
      fileName: data.fileName,
      filePath: data.filePath,
      fileExtension: data.fileExtension,
      mimeType: data.mimeType,
      fileSize: data.fileSize,
      lastModified: data.lastModified,
      isLocalFile: true,
      downloadUrl: data.downloadUrl,
    );
  }

  @override
  Future<List<FileOpenerInfo>> getDownloadedServerFiles() async {
    return FileOpenerService.getDownloadedServerFiles();
  }

  @override
  Future<bool> deleteDownloadedServerFile(FileOpenerInfo fileInfo) async {
    return FileOpenerService.deleteDownloadedServerFile(fileInfo);
  }

  @override
  Future<bool> checkServerConnection() async {
    return FileOpenerService.checkServerConnection();
  }

  @override
  Future<List<FileOpenerInfo>> getLocalFileList() async {
    return FileOpenerService.getLocalFileList();
  }

  @override
  Future<FileOpenerPlatformResult> openFile(FileOpenerInfo fileInfo) async {
    return FileOpenerService.openFile(fileInfo);
  }

  @override
  Future<List<FileOpenerInfo>?> pickFiles({required bool allowMultiple}) async {
    return FileOpenerService.pickFiles(allowMultiple: allowMultiple);
  }

  @override
  Future<bool> deleteLocalFile(FileOpenerInfo fileInfo) async {
    return FileOpenerService.deleteFile(fileInfo);
  }
}
