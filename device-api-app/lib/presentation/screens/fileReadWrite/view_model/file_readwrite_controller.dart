import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/usecases/file_readwrite_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_readwrite_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/state/file_readwrite_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_readwrite_controller.g.dart';

FileReadwriteUseCase _useCase(Ref ref) =>
    ref.read(fileReadwriteUseCaseProvider);

@riverpod
class FileReadWriteMain extends _$FileReadWriteMain {
  @override
  FileReadWriteMainState build() {
    Future.microtask(initialize);
    return FileReadWriteMainState.initial();
  }

  Future<void> initialize() async {
    final deviceUuid = await _useCase(ref).getDeviceUuid();
    state = state.copyWith(deviceUuid: deviceUuid);
    await reloadLocalFileList();
  }

  Future<void> reloadLocalFileList() async {
    if (state.deviceUuid.isEmpty) return;

    state = state.copyWith(
      isLoading: true,
      statusMessage: '${FileReadWriteMessageKeys.listLoadingPrefix}0',
      selectedFiles: {},
      isSelectionMode: false,
    );

    final result = await _useCase(ref).loadLocalFileList(state.deviceUuid);

    switch (result) {
      case FileReadWriteLocalListSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          fileList: items,
          statusMessage:
              '${FileReadWriteMessageKeys.listUpdatedPrefix}${items.length}',
        );
      case FileReadWriteLocalListEmpty():
        state = state.copyWith(
          isLoading: false,
          fileList: [],
          statusMessage: FileReadWriteMessageKeys.noLocalFiles,
        );
      case FileReadWriteLocalListFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          fileList: [],
          statusMessage: message,
        );
    }
  }

  void startSelectionMode() {
    state = state.copyWith(isSelectionMode: true, selectedFiles: {});
  }

  void exitSelectionMode() {
    state = state.copyWith(isSelectionMode: false, selectedFiles: {});
  }

  void toggleFileSelection(String fileName) {
    final updated = Set<String>.from(state.selectedFiles);
    if (updated.contains(fileName)) {
      updated.remove(fileName);
    } else {
      updated.add(fileName);
    }
    state = state.copyWith(
      selectedFiles: updated,
      isSelectionMode: updated.isNotEmpty,
    );
  }

  void clearSelection() {
    state = state.copyWith(selectedFiles: {}, isSelectionMode: false);
  }

  Future<FileReadWriteCreateResult> createTextFile({
    required String fileName,
    required String content,
  }) async {
    state = state.copyWith(
      isLoading: true,
      statusMessage: FileReadWriteMessageKeys.createInProgress,
    );

    final result = await _useCase(
      ref,
    ).createTextFile(fileName: fileName, content: content);

    switch (result) {
      case FileReadWriteCreateSuccess(:final fileName):
        state = state.copyWith(
          isLoading: false,
          statusMessage: '${FileReadWriteMessageKeys.createSuccess}|$fileName',
          selectedFiles: {},
          isSelectionMode: false,
        );
        await reloadLocalFileList();
      case FileReadWriteCreateFailure(:final message):
        state = state.copyWith(isLoading: false, statusMessage: message);
    }

    return result;
  }

  Future<FileReadWriteReadResult> readFile(String fileName) {
    return _useCase(ref).readTextFile(fileName);
  }

  Future<FileReadWriteReadResult> readFileByPath({
    required String filePath,
    required String fileName,
  }) {
    return _useCase(ref).readTextFileByPath(
      filePath: filePath,
      fileName: fileName,
    );
  }

  Future<FileReadWriteImportResult> importLocalFiles() async {
    state = state.copyWith(
      isLoading: true,
      statusMessage: FileReadWriteMessageKeys.importInProgress,
    );

    final result = await _useCase(ref).importLocalFiles();

    switch (result) {
      case FileReadWriteImportSuccess(:final count):
        state = state.copyWith(
          isLoading: false,
          statusMessage:
              '${FileReadWriteMessageKeys.importSuccessPrefix}$count',
        );
        await reloadLocalFileList();
      case FileReadWriteImportCancelled():
        state = state.copyWith(isLoading: false);
      case FileReadWriteImportFailure(:final message):
        state = state.copyWith(isLoading: false, statusMessage: message);
    }

    return result;
  }

  FileInfo? findFileByName(String fileName) {
    for (final file in state.fileList) {
      if (file.fileName == fileName) return file;
    }
    return null;
  }

  Future<FileReadWriteDeleteResult> deleteFile(String fileName) async {
    final fileInfo = findFileByName(fileName);
    if (fileInfo == null) {
      return const FileReadWriteDeleteFailure(
        FileReadWriteMessageKeys.fileNotFound,
      );
    }

    final result = await _useCase(ref).deleteLocalFile(fileInfo.filePath);

    switch (result) {
      case FileReadWriteDeleteSuccess():
        final updated = Set<String>.from(state.selectedFiles)..remove(fileName);
        state = state.copyWith(
          selectedFiles: updated,
          isSelectionMode: updated.isNotEmpty,
        );
        await reloadLocalFileList();
      case FileReadWriteDeleteFailure():
        break;
    }

    return result;
  }

  Future<FileReadWriteBatchDeleteResult> deleteSelectedFiles() async {
    if (state.selectedFiles.isEmpty) {
      return const FileReadWriteBatchDeleteEmpty();
    }

    state = state.copyWith(
      isLoading: true,
      statusMessage:
          '${FileReadWriteMessageKeys.deletingSelectedPrefix}${state.selectedFiles.length}',
    );

    final paths = state.selectedFiles
        .map((name) => findFileByName(name)?.filePath)
        .whereType<String>()
        .toList();

    final result = await _useCase(ref).deleteLocalFiles(paths);

    switch (result) {
      case FileReadWriteBatchDeleteSuccess(
        :final successCount,
        :final failCount,
      ):
        state = state.copyWith(
          isLoading: false,
          statusMessage:
              '${FileReadWriteMessageKeys.deleteSummaryPrefix}$successCount|$failCount',
          selectedFiles: {},
          isSelectionMode: false,
        );
        await reloadLocalFileList();
      case FileReadWriteBatchDeleteEmpty():
        state = state.copyWith(isLoading: false);
    }

    return result;
  }

  Future<FileReadWriteUploadResult> uploadSelectedFiles() async {
    if (state.selectedFiles.isEmpty) {
      return const FileReadWriteUploadFailure(
        FileReadWriteMessageKeys.noFilesSelectedForUpload,
      );
    }

    state = state.copyWith(
      isLoading: true,
      statusMessage:
          '${FileReadWriteMessageKeys.uploadingSelectedPrefix}${state.selectedFiles.length}',
    );

    final filesToUpload = <File>[];
    for (final fileName in state.selectedFiles) {
      final fileInfo = findFileByName(fileName);
      if (fileInfo == null) continue;
      final file = File(fileInfo.filePath);
      if (await file.exists()) {
        filesToUpload.add(file);
      }
    }

    if (filesToUpload.isEmpty) {
      state = state.copyWith(isLoading: false);
      return const FileReadWriteUploadFailure(
        FileReadWriteMessageKeys.noValidUploadFiles,
      );
    }

    final result = await _useCase(
      ref,
    ).uploadFiles(deviceUuid: state.deviceUuid, files: filesToUpload);

    switch (result) {
      case FileReadWriteUploadSuccess(:final successCount, :final failCount):
        state = state.copyWith(
          isLoading: false,
          statusMessage:
              '${FileReadWriteMessageKeys.uploadSummaryPrefix}$successCount|$failCount',
          selectedFiles: {},
          isSelectionMode: false,
        );
        if (successCount > 0) {
          await reloadLocalFileList();
        }
      case FileReadWriteUploadFailure(:final message):
        state = state.copyWith(isLoading: false, statusMessage: message);
    }

    return result;
  }
}

@riverpod
class FileReadWriteList extends _$FileReadWriteList {
  @override
  FileReadWriteListState build() {
    Future.microtask(initialize);
    return FileReadWriteListState.initial();
  }

  Future<void> initialize() async {
    final deviceUuid = await _useCase(ref).getDeviceUuid();
    state = state.copyWith(deviceUuid: deviceUuid);
    await reload();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _useCase(ref).loadServerFileList(state.deviceUuid);

    switch (result) {
      case FileReadWriteServerListSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          serverFileList: items,
          errorMessage: '',
        );
      case FileReadWriteServerListEmpty():
        state = state.copyWith(
          isLoading: false,
          serverFileList: [],
          errorMessage: '',
        );
      case FileReadWriteServerListFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          serverFileList: [],
          errorMessage: message,
        );
    }
  }

  Future<FileReadWriteServerDeleteResult> deleteServerFile(
    FileInfo serverFile,
  ) async {
    final result = await _useCase(
      ref,
    ).deleteServerFile(sn: serverFile.sn, fileName: serverFile.fileName);

    if (result is FileReadWriteServerDeleteSuccess) {
      await reload();
    }

    return result;
  }
}

@riverpod
class FileReadWriteDetail extends _$FileReadWriteDetail {
  @override
  FileReadWriteDetailState build() => FileReadWriteDetailState.initial();

  Future<FileReadWriteServerDeleteResult> deleteServerFile(
    FileInfo serverFile,
  ) async {
    state = state.copyWith(isDeleting: true);

    final result = await _useCase(
      ref,
    ).deleteServerFile(sn: serverFile.sn, fileName: serverFile.fileName);

    state = state.copyWith(isDeleting: false);
    return result;
  }
}
