import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/usecases/fileopener_server_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/state/fileopener_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fileopener_controller.g.dart';

FileopenerServerUseCase _useCase(Ref ref) =>
    ref.read(fileopenerServerUseCaseProvider);

List<FileOpenerInfo> _applyFiltersToFiles({
  required List<FileOpenerInfo> files,
  FileType? selectedFileType,
  required String sortBy,
  required bool sortAscending,
}) {
  var filtered = List<FileOpenerInfo>.from(files);

  if (selectedFileType != null) {
    filtered = filtered.where((f) => f.fileType == selectedFileType).toList();
  }

  filtered.sort((a, b) {
    int comparison = 0;
    switch (sortBy) {
      case 'size':
        comparison = a.fileSize.compareTo(b.fileSize);
      case 'date':
        comparison = a.lastModified.compareTo(b.lastModified);
      default:
        comparison = a.fileName.compareTo(b.fileName);
    }
    return sortAscending ? comparison : -comparison;
  });

  return filtered;
}

@riverpod
class FileOpenerMain extends _$FileOpenerMain {
  @override
  FileOpenerMainState build() {
    Future.microtask(reload);
    return FileOpenerMainState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true);

    final result = await _useCase(ref).loadLocalFileList();

    switch (result) {
      case FileOpenerLocalListSuccess(:final items):
        state = state.copyWith(isLoading: false, files: items);
      case FileOpenerLocalListEmpty():
        state = state.copyWith(isLoading: false, files: []);
      case FileOpenerLocalListFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          files: [],
          statusMessage: message,
        );
    }
    _applyFilters();
  }

  void _applyFilters() {
    final filtered = _applyFiltersToFiles(
      files: state.files,
      selectedFileType: state.selectedFileType,
      sortBy: state.sortBy,
      sortAscending: state.sortAscending,
    );
    state = state.copyWith(filteredFiles: filtered);
  }

  Future<FileOpenerOpenResult> openFile(FileOpenerInfo fileInfo) {
    return _useCase(ref).openFile(fileInfo);
  }

  Future<FileOpenerPickResult> pickFiles({bool allowMultiple = true}) async {
    state = state.copyWith(isLoading: true);

    final result = await _useCase(ref).pickFiles(allowMultiple: allowMultiple);

    switch (result) {
      case FileOpenerPickSuccess(:final files):
        state = state.copyWith(
          isLoading: false,
          files: [...state.files, ...files],
        );
        _applyFilters();
      case FileOpenerPickCancelled():
        state = state.copyWith(isLoading: false);
      case FileOpenerPickFailure(:final message):
        state = state.copyWith(isLoading: false, statusMessage: message);
    }

    return result;
  }

  Future<FileOpenerDeleteResult> deleteFile(FileOpenerInfo fileInfo) async {
    final result = await _useCase(ref).deleteLocalFile(fileInfo);

    if (result is FileOpenerDeleteSuccess) {
      state = state.copyWith(
        files: state.files
            .where((f) => f.filePath != fileInfo.filePath)
            .toList(),
      );
      _applyFilters();
    }

    return result;
  }
}

@riverpod
class FileOpenerList extends _$FileOpenerList {
  @override
  FileOpenerListState build() {
    Future.microtask(reload);
    return FileOpenerListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _useCase(ref).loadServerFileList();

    switch (result) {
      case FileOpenerServerListSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          serverFiles: items,
          errorMessage: '',
        );
      case FileOpenerServerListEmpty():
        state = state.copyWith(
          isLoading: false,
          serverFiles: [],
          errorMessage: '',
        );
      case FileOpenerServerListFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          serverFiles: [],
          errorMessage: message,
        );
    }
  }

  Future<FileOpenerDownloadResult> downloadServerFile(
    ServerFileInfo serverFile,
  ) async {
    state = state.copyWith(
      isDownloading: true,
      downloadingFileName: serverFile.orignlFileNm,
      downloadProgress: 0.0,
    );

    final result = await _useCase(ref).downloadServerFile(
      serverFile,
      onProgress: (progress) {
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
}

@riverpod
class FileOpenerDetail extends _$FileOpenerDetail {
  @override
  FileOpenerDetailState build() => FileOpenerDetailState.initial();

  Future<FileOpenerDownloadResult> downloadServerFile(
    ServerFileInfo serverFile,
  ) async {
    state = state.copyWith(isDownloading: true, downloadProgress: 0.0);

    final result = await _useCase(ref).downloadServerFile(
      serverFile,
      onProgress: (progress) {
        state = state.copyWith(downloadProgress: progress);
      },
    );

    state = state.copyWith(isDownloading: false, downloadProgress: 0.0);

    return result;
  }
}
