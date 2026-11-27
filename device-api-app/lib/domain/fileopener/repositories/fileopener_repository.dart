import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_result.dart';

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
  Future<List<FileOpenerInfo>> getLocalFileList();
  Future<FileOpenerPlatformResult> openFile(FileOpenerInfo fileInfo);
  Future<List<FileOpenerInfo>?> pickFiles({required bool allowMultiple});
  Future<bool> deleteLocalFile(FileOpenerInfo fileInfo);
}

