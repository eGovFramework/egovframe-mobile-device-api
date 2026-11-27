import 'package:egovframe_mobile_deviceapi_app/data/streaming/datasources/streaming_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/repositories/streaming_repository.dart';

class StreamingRemoteRepositoryImpl implements StreamingRepository {
  @override
  Future<List<StreamingMediaInfo>> getMediaList() async {
    final response = await StreamingService.fetchMediaInfoList();
    if (response.resultState != 'OK') {
      return [];
    }

    return response.items.map(StreamingMediaInfo.fromJson).toList();
  }

  @override
  Future<bool> updatePlayCount(int sn) async {
    final response = await StreamingService.updateMediaInfoRevivCo(sn);
    if (response == null) {
      return false;
    }

    return (response['resultState'] ?? '').toString() == 'OK';
  }

  @override
  String buildStreamingUrl({
    required int sn,
    int fileSn = 0,
    required String uuid,
  }) =>
      StreamingService.buildStreamingUrl(sn: sn, fileSn: fileSn, uuid: uuid);
}
