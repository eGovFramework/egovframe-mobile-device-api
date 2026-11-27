import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';

class StreamingListState {
  final bool isLoading;
  final List<StreamingMediaInfo> mediaList;
  final String errorMessage;

  const StreamingListState({
    required this.isLoading,
    required this.mediaList,
    required this.errorMessage,
  });

  factory StreamingListState.initial() {
    return const StreamingListState(
      isLoading: true,
      mediaList: [],
      errorMessage: '',
    );
  }

  StreamingListState copyWith({
    bool? isLoading,
    List<StreamingMediaInfo>? mediaList,
    String? errorMessage,
  }) {
    return StreamingListState(
      isLoading: isLoading ?? this.isLoading,
      mediaList: mediaList ?? this.mediaList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
