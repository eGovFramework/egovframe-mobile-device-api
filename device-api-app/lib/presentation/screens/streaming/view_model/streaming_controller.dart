import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/usecases/streaming_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/state/streaming_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streaming_controller.g.dart';

StreamingUseCase _streamingUseCase(Ref ref) => ref.read(streamingUseCaseProvider);

@riverpod
class StreamingList extends _$StreamingList {
  @override
  StreamingListState build() {
    Future.microtask(reload);
    return StreamingListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _streamingUseCase(ref).loadMediaList();

    switch (result) {
      case StreamingListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          mediaList: items,
          errorMessage: '',
        );
      case StreamingListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          mediaList: [],
          errorMessage: '',
        );
      case StreamingListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          mediaList: [],
          errorMessage: message,
        );
    }
  }

  Future<void> incrementPlayCount(int sn) async {
    final result = await _streamingUseCase(ref).updatePlayCount(sn);
    if (result is StreamingPlayCountUpdateSuccess) {
      final updated = state.mediaList
          .map((item) {
            if (item.sn != sn) return item;
            final count = int.tryParse(item.revivCo) ?? 0;
            return item.copyWith(revivCo: '${count + 1}');
          })
          .toList();
      state = state.copyWith(mediaList: updated);
    }
  }

  Future<String> buildStreamingUrl(StreamingMediaInfo item) async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    return _streamingUseCase(ref).buildStreamingUrl(item, uuid);
  }
}
