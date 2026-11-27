import 'package:egovframe_mobile_deviceapi_app/data/streaming/datasources/streaming_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/repositories/streaming_repository.dart';

typedef StreamingConnectionReader = StreamingConnectionState Function();

class StreamingSqliteRepositoryImpl implements StreamingRepository {
  final StreamingSqliteService _service;
  final StreamingConnectionReader _readConnection;

  StreamingSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<List<StreamingMediaInfo>> getMediaList() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getMediaList(dbFileName);
  }

  @override
  Future<bool> updatePlayCount(int sn) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.updatePlayCount(dbFileName, sn);
  }

  @override
  String buildStreamingUrl({
    required int sn,
    int fileSn = 0,
    required String uuid,
  }) {
    throw UnsupportedError('SQLite 모드에서는 서버 스트리밍 URL을 사용할 수 없습니다.');
  }
}
