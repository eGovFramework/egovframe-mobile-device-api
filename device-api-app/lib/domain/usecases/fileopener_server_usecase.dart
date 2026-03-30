import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/fileopener_repository.dart';

class FileopenerServerUseCase {
  final ServerFileRepository repository;

  FileopenerServerUseCase(this.repository);

  /// 서버 파일 목록 조회
  Future<List<ServerFileInfo>> getServerFileList() async {
    return await repository.getServerFileList();
  }

  /// 서버 파일 다운로드
  Future<FileOpenerInfo?> downloadServerFile(ServerFileInfo serverFile) async {
    return await repository.downloadServerFile(serverFile);
  }

  /// 진행률 콜백과 함께 서버 파일 다운로드
  Future<FileOpenerInfo?> downloadServerFileWithProgress(
    ServerFileInfo serverFile,
    Function(double progress)? onProgress,
  ) async {
    return await repository.downloadServerFileWithProgress(serverFile, onProgress);
  }
}
