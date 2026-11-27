import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/usecases/media_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/media_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/state/media_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_controller.g.dart';

MediaUseCase _mediaUseCase(Ref ref) => ref.read(mediaUseCaseProvider);

@riverpod
class MediaMain extends _$MediaMain {
  @override
  MediaMainState build() {
    Future.microtask(initialize);
    return MediaMainState.initial();
  }

  Future<void> initialize() async {
    final deviceUuid = await _mediaUseCase(ref).getDeviceUuid();
    state = state.copyWith(deviceUuid: deviceUuid);
    await reloadLocalMediaList();
  }

  Future<void> reloadLocalMediaList() async {
    if (state.deviceUuid.isEmpty) return;

    state = state.copyWith(isLoading: true);
    final result = await _mediaUseCase(ref).loadLocalMediaList();

    switch (result) {
      case MediaLocalListSuccess(:final items):
        state = state.copyWith(isLoading: false, mediaFiles: items);
      case MediaLocalListFailure():
        state = state.copyWith(isLoading: false, mediaFiles: []);
    }
  }

  void startSelectionMode() {
    state = state.copyWith(isSelectionMode: true, selectedFiles: {});
  }

  void exitSelectionMode() {
    state = state.copyWith(isSelectionMode: false, selectedFiles: {});
  }

  void toggleFileSelection(String filePath) {
    final updated = Set<String>.from(state.selectedFiles);
    if (updated.contains(filePath)) {
      updated.remove(filePath);
    } else {
      updated.add(filePath);
    }

    state = state.copyWith(
      selectedFiles: updated,
      isSelectionMode: updated.isNotEmpty,
    );
  }

  Future<MediaPickResult> pickImage(ImageSource source) async {
    return _mediaUseCase(ref).pickImage(source);
  }

  Future<MediaPickResult> pickVideo(ImageSource source) async {
    return _mediaUseCase(ref).pickVideo(source);
  }

  Future<MediaSaveResult> savePickedImage(
    XFile file, {
    ImageSource? captureSource,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await _mediaUseCase(ref).saveImageFile(
      file,
      captureSource: captureSource,
    );

    switch (result) {
      case MediaSaveSuccess():
        await reloadLocalMediaList();
      case MediaSaveFailure():
        state = state.copyWith(isLoading: false);
    }

    if (state.isLoading) {
      state = state.copyWith(isLoading: false);
    }
    return result;
  }

  Future<MediaSaveResult> savePickedVideo(
    XFile file, {
    ImageSource? captureSource,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await _mediaUseCase(ref).saveVideoFile(
      file,
      captureSource: captureSource,
    );

    switch (result) {
      case MediaSaveSuccess():
        await reloadLocalMediaList();
      case MediaSaveFailure():
        state = state.copyWith(isLoading: false);
    }

    if (state.isLoading) {
      state = state.copyWith(isLoading: false);
    }
    return result;
  }

  Future<MediaDeleteBatchResult> deleteSelectedFiles() async {
    if (state.selectedFiles.isEmpty) {
      return const MediaDeleteBatchFailure(MediaMessageKeys.noFilesToDelete);
    }

    state = state.copyWith(isLoading: true);
    final result = await _mediaUseCase(ref).deleteSelectedFiles(
      selectedPaths: state.selectedFiles,
      mediaFiles: state.mediaFiles,
    );

    exitSelectionMode();
    await reloadLocalMediaList();
    return result;
  }

  Future<MediaUploadResult> uploadSelectedFiles() async {
    if (state.selectedFiles.isEmpty) {
      return const MediaUploadFailure(MediaMessageKeys.noFilesToUpload);
    }

    state = state.copyWith(isLoading: true);

    final filesToUpload = <File>[];
    for (final filePath in state.selectedFiles) {
      final file = File(filePath);
      if (await file.exists()) {
        filesToUpload.add(file);
      }
    }

    final result = await _mediaUseCase(ref).uploadFiles(
      files: filesToUpload,
      uuid: state.deviceUuid,
    );

    exitSelectionMode();
    await reloadLocalMediaList();
    return result;
  }

  Future<MediaDownloadUrlResult> getServerDownloadUrl(int serverSn) async {
    return _mediaUseCase(ref).getMediaDownloadUrl(serverSn);
  }
}

@riverpod
class MediaList extends _$MediaList {
  @override
  MediaListState build() {
    Future.microtask(initialize);
    return MediaListState.initial();
  }

  Future<void> initialize() async {
    final deviceUuid = await _mediaUseCase(ref).getDeviceUuid();
    state = state.copyWith(deviceUuid: deviceUuid);
    await reload();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _mediaUseCase(
      ref,
    ).loadServerMediaList(state.deviceUuid);

    switch (result) {
      case MediaServerListSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          serverMediaFiles: items,
          errorMessage: '',
        );
      case MediaServerListEmpty():
        state = state.copyWith(
          isLoading: false,
          serverMediaFiles: [],
          errorMessage: '',
        );
      case MediaServerListFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          serverMediaFiles: [],
          errorMessage: message,
        );
    }
  }

  Future<MediaDownloadResult> downloadServerMedia(
    MediaFileInfo mediaFile,
  ) async {
    state = state.copyWith(
      isDownloading: true,
      downloadingFileName: mediaFile.name,
      downloadProgress: 0.0,
    );

    final result = await _mediaUseCase(ref).downloadMedia(
      mediaFile.fileSn ?? 0,
      mediaFile.name,
      (progress) {
        state = state.copyWith(downloadProgress: progress);
      },
    );

    state = state.copyWith(
      isDownloading: false,
      clearDownloadingFileName: true,
      downloadProgress: 0.0,
    );
    return result;
  }

  Future<MediaServerDeleteResult> deleteServerMedia(
    MediaFileInfo mediaFile,
  ) async {
    final result = await _mediaUseCase(ref).deleteMediaFromServer(mediaFile);

    if (result is MediaServerDeleteSuccess) {
      await reload();
    }
    return result;
  }
}

@riverpod
class MediaDetail extends _$MediaDetail {
  @override
  MediaDetailState build(MediaFileInfo mediaFile) {
    return MediaDetailState(mediaFile: mediaFile);
  }

  Future<MediaDownloadResult> downloadMedia() async {
    state = state.copyWith(isDownloading: true, downloadProgress: 0.0);

    final result = await _mediaUseCase(ref).downloadMedia(
      state.mediaFile.fileSn ?? 0,
      state.mediaFile.name,
      (progress) {
        state = state.copyWith(downloadProgress: progress);
      },
    );

    state = state.copyWith(isDownloading: false, downloadProgress: 0.0);
    return result;
  }

  Future<MediaServerDeleteResult> deleteMedia() async {
    state = state.copyWith(isLoading: true);
    final result = await _mediaUseCase(ref).deleteMediaFromServer(state.mediaFile);
    state = state.copyWith(isLoading: false);
    return result;
  }
}
