import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';

abstract class StreamingRepository {
  Future<List<StreamingMediaInfo>> getMediaList();

  Future<bool> updatePlayCount(int sn);

  String buildStreamingUrl({
    required int sn,
    int fileSn = 0,
    required String uuid,
  });
}
