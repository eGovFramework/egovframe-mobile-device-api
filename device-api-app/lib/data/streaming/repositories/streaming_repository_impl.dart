import 'package:egovframe_mobile_deviceapi_app/data/streaming/repositories/streaming_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/streaming/repositories/streaming_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/repositories/streaming_repository.dart';

class StreamingRepositoryImpl implements StreamingRepository {
  final StreamingRemoteRepositoryImpl _remote;
  final StreamingSqliteRepositoryImpl _sqlite;
  final StreamingConnectionReader _readConnection;

  StreamingRepositoryImpl({
    required StreamingRemoteRepositoryImpl remote,
    required StreamingSqliteRepositoryImpl sqlite,
    required StreamingConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  StreamingRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<List<StreamingMediaInfo>> getMediaList() => _active.getMediaList();

  @override
  Future<bool> updatePlayCount(int sn) => _active.updatePlayCount(sn);

  @override
  String buildStreamingUrl({
    required int sn,
    int fileSn = 0,
    required String uuid,
  }) =>
      _remote.buildStreamingUrl(sn: sn, fileSn: fileSn, uuid: uuid);
}
