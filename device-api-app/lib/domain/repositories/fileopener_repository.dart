import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_opener_info.dart';

abstract class ServerFileRepository {
  Future<List<ServerFileInfo>> getServerFileList();
  Future<FileOpenerInfo?> downloadServerFile(ServerFileInfo serverFile);
  Future<FileOpenerInfo?> downloadServerFileWithProgress(
    ServerFileInfo serverFile,
    Function(double progress)? onProgress,
  );
  Future<List<FileOpenerInfo>> getDownloadedServerFiles();
  Future<bool> deleteDownloadedServerFile(FileOpenerInfo fileInfo);
  Future<bool> checkServerConnection();
}

