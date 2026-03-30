import 'package:egovframe_mobile_deviceapi_app/data/datasources/file_opener_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/fileopener_repository.dart';

class ServerFileRepositoryImpl implements ServerFileRepository {
  ServerFileRepositoryImpl();

  @override
  Future<List<ServerFileInfo>> getServerFileList() async {
    return await FileOpenerService.getServerFileList();
  }

  @override
  Future<FileOpenerInfo?> downloadServerFile(ServerFileInfo serverFile) async {
    return await FileOpenerService.downloadServerFile(serverFile);
  }

  @override
  Future<FileOpenerInfo?> downloadServerFileWithProgress(
    ServerFileInfo serverFile,
    Function(double progress)? onProgress,
  ) async {
    return await FileOpenerService.downloadServerFileWithProgress(serverFile, onProgress);
  }

  @override
  Future<List<FileOpenerInfo>> getDownloadedServerFiles() async {
    return await FileOpenerService.getDownloadedServerFiles();
  }

  @override
  Future<bool> deleteDownloadedServerFile(FileOpenerInfo fileInfo) async {
    return await FileOpenerService.deleteDownloadedServerFile(fileInfo);
  }

  @override
  Future<bool> checkServerConnection() async {
    return await FileOpenerService.checkServerConnection();
  }
}

