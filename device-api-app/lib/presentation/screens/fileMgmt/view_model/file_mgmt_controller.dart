import 'dart:async';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/entities/file_mgmt_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/usecases/file_mgmt_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_mgmt_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileMgmt/state/file_mgmt_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/file_mgmt_sample_content.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_mgmt_controller.g.dart';

FileMgmtUseCase _useCase(Ref ref) => ref.read(fileMgmtUseCaseProvider);

@Riverpod(keepAlive: true)
class FileMgmtMain extends _$FileMgmtMain {
  bool _isInitializing = false;

  @override
  FileMgmtMainState build() => FileMgmtMainState.initial();

  Future<FileMgmtInitResult> initialize() async {
    if (state.rootPath.isNotEmpty) {
      return FileMgmtInitSuccess(
        rootPath: state.rootPath,
        currentPath: state.currentPath,
        contents: state.currentContents,
      );
    }
    if (_isInitializing) {
      return const FileMgmtInitFailure(FileMgmtMessageKeys.initInProgress);
    }

    _isInitializing = true;
    state = state.copyWith(isLoading: true);

    try {
      final hasPermission = await _useCase(ref).requestPermissions();
      if (!hasPermission) {
        state = state.copyWith(isLoading: false);
        return const FileMgmtInitPermissionDenied();
      }

      String currentPath;
      try {
        currentPath = await _useCase(ref).getDocumentsRoot();
        appLog('파일 시스템 초기화 완료');
      } catch (e) {
        state = state.copyWith(isLoading: false);
        return FileMgmtInitFailure(
          '${FileMgmtMessageKeys.cannotAccessDocumentsPrefix}$e',
        );
      }

      state = state.copyWith(currentPath: currentPath, rootPath: currentPath);

      final loadResult = await _loadDirectoryContentsInternal();
      if (loadResult is FileMgmtDirectoryFailure) {
        state = state.copyWith(isLoading: false);
        return FileMgmtInitFailure(loadResult.message);
      }

      state = state.copyWith(isLoading: false);

      if (Platform.isIOS && state.currentContents.isEmpty) {
        unawaited(_createWelcomeFileIfNeeded(currentPath));
      }

      return FileMgmtInitSuccess(
        rootPath: state.rootPath,
        currentPath: state.currentPath,
        contents: state.currentContents,
      );
    } catch (e) {
      appLog('파일 시스템 초기화 오류: $e');
      state = state.copyWith(isLoading: false);
      return FileMgmtInitFailure('${FileMgmtMessageKeys.initErrorPrefix}$e');
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _createWelcomeFileIfNeeded(String currentPath) async {
    try {
      final l10n = readPresentationLocalizations();
      await _useCase(ref).createSampleFile(
        parentPath: currentPath,
        fileName: 'welcome.txt',
        content: FileMgmtSampleContent.welcome(l10n),
      );
      await _loadDirectoryContentsInternal();
    } catch (e) {
      appLog('초기 샘플 파일 생성 실패: $e');
    }
  }

  Future<FileMgmtDirectoryResult> reloadDirectory() async {
    state = state.copyWith(isLoading: true);
    final result = await _loadDirectoryContentsInternal();
    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<FileMgmtDirectoryResult> _loadDirectoryContentsInternal() async {
    final result = await _useCase(ref).listDirectory(state.currentPath);
    if (result is FileMgmtDirectorySuccess) {
      state = state.copyWith(
        currentContents: result.contents,
        selectedItems: {},
        isSelectionMode: false,
      );
    }
    return result;
  }

  Future<FileMgmtDirectoryResult> navigateToDirectory(String path) async {
    final history = List<String>.from(state.pathHistory)
      ..add(state.currentPath);
    state = state.copyWith(currentPath: path, pathHistory: history);
    return reloadDirectory();
  }

  Future<FileMgmtDirectoryResult> navigateBack() async {
    if (state.pathHistory.isEmpty) {
      return const FileMgmtDirectorySuccess([]);
    }
    final history = List<String>.from(state.pathHistory);
    final previous = history.removeLast();
    state = state.copyWith(currentPath: previous, pathHistory: history);
    return reloadDirectory();
  }

  Future<FileMgmtDirectoryResult> navigateToRoot() async {
    if (state.rootPath.isEmpty) {
      return const FileMgmtDirectorySuccess([]);
    }
    state = state.copyWith(currentPath: state.rootPath, pathHistory: []);
    return reloadDirectory();
  }

  void exitSelectionMode() {
    state = state.copyWith(isSelectionMode: false, selectedItems: {});
  }

  void updateItemSelection(String path, bool selected) {
    final updated = Set<String>.from(state.selectedItems);
    if (selected) {
      updated.add(path);
    } else {
      updated.remove(path);
    }
    state = state.copyWith(
      selectedItems: updated,
      isSelectionMode: updated.isNotEmpty,
    );
  }

  void startSelectionWithItem(String path) {
    state = state.copyWith(isSelectionMode: true, selectedItems: {path});
  }

  void setSelectionForSingleAction(String path) {
    state = state.copyWith(selectedItems: {path});
  }

  Future<Map<String, dynamic>> getFileInfo(String path) =>
      _useCase(ref).getFileInfo(path);

  Future<FileMgmtOperationResult> createDirectory(String name) async {
    state = state.copyWith(isLoading: true);
    final result = await _useCase(ref).createDirectory(
      parentPath: state.currentPath,
      name: name,
    );
    if (result is FileMgmtOperationSuccess) {
      await _loadDirectoryContentsInternal();
    }
    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<FileMgmtOperationResult> createSampleFile(String fileName) async {
    state = state.copyWith(isLoading: true);
    try {
      final l10n = readPresentationLocalizations();
      final result = await _useCase(ref).createSampleFile(
        parentPath: state.currentPath,
        fileName: fileName,
        content: FileMgmtSampleContent.forFileName(l10n, fileName),
      );
      if (result is FileMgmtOperationSuccess) {
        await _loadDirectoryContentsInternal();
      }
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return FileMgmtOperationFailure(
        '${FileMgmtMessageKeys.sampleFileCreateErrorPrefix}$e',
      );
    }
  }

  Future<FileMgmtOperationResult> deleteSelectedItems() async {
    state = state.copyWith(isLoading: true);
    final result = await _useCase(ref).deletePaths(state.selectedItems);
    if (result is FileMgmtOperationSuccess) {
      await _loadDirectoryContentsInternal();
    }
    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<FileMgmtOperationResult> copySelectedItems(
    String destinationPath,
  ) async {
    state = state.copyWith(isLoading: true);
    final l10n = readPresentationLocalizations();
    final result = await _useCase(ref).copyPaths(
      sourcePaths: state.selectedItems,
      destinationDir: destinationPath,
      copySuffix: FileMgmtSampleContent.copySuffix(l10n),
    );
    if (result is FileMgmtOperationSuccess) {
      await _loadDirectoryContentsInternal();
    }
    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<FileMgmtOperationResult> moveSelectedItems(
    String destinationPath,
  ) async {
    state = state.copyWith(isLoading: true);
    final result = await _useCase(ref).movePaths(
      sourcePaths: state.selectedItems,
      destinationDir: destinationPath,
    );
    if (result is FileMgmtOperationSuccess) {
      await _loadDirectoryContentsInternal();
    }
    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<FileMgmtOperationResult> renameItem(
    String sourcePath,
    String newName,
  ) async {
    final result = await _useCase(ref).renameItem(
      sourcePath: sourcePath,
      directoryPath: state.currentPath,
      newName: newName,
    );
    if (result is FileMgmtOperationSuccess) {
      await _loadDirectoryContentsInternal();
    }
    return result;
  }

  Future<void> openPermissionSettings() async {
    await _useCase(ref).openPermissionSettings();
  }
}
