import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/repositories/streaming_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/streaming_message_keys.dart';

class StreamingUseCase {
  final StreamingRepository repository;

  StreamingUseCase(this.repository);

  Future<StreamingListLoadResult> loadMediaList() async {
    try {
      final items = await repository.getMediaList();
      if (items.isEmpty) {
        return const StreamingListLoadEmpty();
      }
      return StreamingListLoadSuccess(items);
    } catch (e) {
      return StreamingListLoadFailure(
        '${StreamingMessageKeys.listLoadErrorPrefix}$e',
      );
    }
  }

  Future<StreamingPlayCountUpdateResult> updatePlayCount(int sn) async {
    try {
      final success = await repository.updatePlayCount(sn);
      if (success) {
        return const StreamingPlayCountUpdateSuccess();
      }
      return const StreamingPlayCountUpdateFailure(
        StreamingMessageKeys.playCountUpdateFailed,
      );
    } catch (e) {
      return StreamingPlayCountUpdateFailure(
        '${StreamingMessageKeys.genericErrorPrefix}$e',
      );
    }
  }

  String buildStreamingUrl(StreamingMediaInfo item, String uuid) =>
      repository.buildStreamingUrl(
        sn: item.sn,
        fileSn: item.fileSn,
        uuid: uuid,
      );
}
