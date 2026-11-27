import 'package:egovframe_mobile_deviceapi_app/data/fileopener/datasources/file_opener_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/repositories/fileopener_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef FileOpenerConnectionReader = FileOpenerConnectionState Function();

class FileOpenerSqliteRepositoryImpl implements ServerFileRepository {
  final FileOpenerSqliteService _service;
  final FileOpenerConnectionReader _readConnection;

  FileOpenerSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<List<ServerFileInfo>> getServerFileList() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getServerFileList(dbFileName);
  }

  @override
  Future<FileOpenerInfo?> downloadServerFile(ServerFileInfo serverFile) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return null;
    return _service.downloadServerFile(dbFileName, serverFile);
  }

  @override
  Future<FileOpenerInfo?> downloadServerFileWithProgress(
    ServerFileInfo serverFile,
    Function(double progress)? onProgress,
  ) async {
    onProgress?.call(1.0);
    return downloadServerFile(serverFile);
  }

  @override
  Future<bool> checkServerConnection() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    final status = await _service.validateSetup(dbFileName);
    return status == SqliteSetupStatus.ready;
  }

  @override
  Future<List<FileOpenerInfo>> getDownloadedServerFiles() {
    throw UnsupportedError('SQLite 모드에서는 로컬 다운로드 목록을 사용하지 않습니다.');
  }

  @override
  Future<bool> deleteDownloadedServerFile(FileOpenerInfo fileInfo) {
    throw UnsupportedError('SQLite 모드에서는 로컬 다운로드 삭제를 사용하지 않습니다.');
  }

  @override
  Future<List<FileOpenerInfo>> getLocalFileList() {
    throw UnsupportedError('SQLite 모드에서는 로컬 파일 목록을 사용하지 않습니다.');
  }

  @override
  Future<FileOpenerPlatformResult> openFile(FileOpenerInfo fileInfo) {
    throw UnsupportedError('SQLite 모드에서는 파일 열기를 사용하지 않습니다.');
  }

  @override
  Future<List<FileOpenerInfo>?> pickFiles({required bool allowMultiple}) {
    throw UnsupportedError('SQLite 모드에서는 파일 선택을 사용하지 않습니다.');
  }

  @override
  Future<bool> deleteLocalFile(FileOpenerInfo fileInfo) {
    throw UnsupportedError('SQLite 모드에서는 로컬 파일 삭제를 사용하지 않습니다.');
  }
}
