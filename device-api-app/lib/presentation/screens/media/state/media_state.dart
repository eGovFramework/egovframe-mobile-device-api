import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';

class MediaMainState {
  final String deviceUuid;
  final List<MediaFileInfo> mediaFiles;
  final bool isLoading;
  final bool isSelectionMode;
  final Set<String> selectedFiles;

  const MediaMainState({
    this.deviceUuid = '',
    this.mediaFiles = const [],
    this.isLoading = false,
    this.isSelectionMode = false,
    this.selectedFiles = const {},
  });

  factory MediaMainState.initial() => const MediaMainState();

  MediaMainState copyWith({
    String? deviceUuid,
    List<MediaFileInfo>? mediaFiles,
    bool? isLoading,
    bool? isSelectionMode,
    Set<String>? selectedFiles,
  }) {
    return MediaMainState(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      isLoading: isLoading ?? this.isLoading,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedFiles: selectedFiles ?? this.selectedFiles,
    );
  }
}

class MediaListState {
  final String deviceUuid;
  final List<MediaFileInfo> serverMediaFiles;
  final bool isLoading;
  final String errorMessage;
  final bool isDownloading;
  final String? downloadingFileName;
  final double downloadProgress;

  const MediaListState({
    this.deviceUuid = '',
    this.serverMediaFiles = const [],
    this.isLoading = true,
    this.errorMessage = '',
    this.isDownloading = false,
    this.downloadingFileName,
    this.downloadProgress = 0.0,
  });

  factory MediaListState.initial() => const MediaListState();

  MediaListState copyWith({
    String? deviceUuid,
    List<MediaFileInfo>? serverMediaFiles,
    bool? isLoading,
    String? errorMessage,
    bool? isDownloading,
    String? downloadingFileName,
    bool clearDownloadingFileName = false,
    double? downloadProgress,
  }) {
    return MediaListState(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      serverMediaFiles: serverMediaFiles ?? this.serverMediaFiles,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadingFileName: clearDownloadingFileName
          ? null
          : (downloadingFileName ?? this.downloadingFileName),
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}

class MediaDetailState {
  final MediaFileInfo mediaFile;
  final bool isLoading;
  final bool isDownloading;
  final double downloadProgress;

  const MediaDetailState({
    required this.mediaFile,
    this.isLoading = false,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
  });

  MediaDetailState copyWith({
    MediaFileInfo? mediaFile,
    bool? isLoading,
    bool? isDownloading,
    double? downloadProgress,
  }) {
    return MediaDetailState(
      mediaFile: mediaFile ?? this.mediaFile,
      isLoading: isLoading ?? this.isLoading,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}
