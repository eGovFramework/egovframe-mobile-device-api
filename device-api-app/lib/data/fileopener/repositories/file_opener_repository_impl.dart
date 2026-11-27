import 'package:egovframe_mobile_deviceapi_app/data/fileopener/repositories/file_opener_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileopener/repositories/file_opener_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/repositories/fileopener_repository.dart';

class ServerFileRepositoryImpl implements ServerFileRepository {
  final FileOpenerRemoteRepositoryImpl _remote;
  final FileOpenerSqliteRepositoryImpl _sqlite;
  final FileOpenerConnectionReader _readConnection;

  ServerFileRepositoryImpl({
    required FileOpenerRemoteRepositoryImpl remote,
    required FileOpenerSqliteRepositoryImpl sqlite,
    required FileOpenerConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  ServerFileRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<List<ServerFileInfo>> getServerFileList() =>
      _active.getServerFileList();

  @override
  Future<FileOpenerInfo?> downloadServerFile(ServerFileInfo serverFile) =>
      _active.downloadServerFile(serverFile);

  @override
  Future<FileOpenerInfo?> downloadServerFileWithProgress(
    ServerFileInfo serverFile,
    Function(double progress)? onProgress,
  ) =>
      _active.downloadServerFileWithProgress(serverFile, onProgress);

  @override
  Future<bool> checkServerConnection() => _active.checkServerConnection();

  @override
  Future<List<FileOpenerInfo>> getDownloadedServerFiles() =>
      _remote.getDownloadedServerFiles();

  @override
  Future<bool> deleteDownloadedServerFile(FileOpenerInfo fileInfo) =>
      _remote.deleteDownloadedServerFile(fileInfo);

  @override
  Future<List<FileOpenerInfo>> getLocalFileList() => _remote.getLocalFileList();

  @override
  Future<FileOpenerPlatformResult> openFile(FileOpenerInfo fileInfo) =>
      _remote.openFile(fileInfo);

  @override
  Future<List<FileOpenerInfo>?> pickFiles({required bool allowMultiple}) =>
      _remote.pickFiles(allowMultiple: allowMultiple);

  @override
  Future<bool> deleteLocalFile(FileOpenerInfo fileInfo) =>
      _remote.deleteLocalFile(fileInfo);
}
