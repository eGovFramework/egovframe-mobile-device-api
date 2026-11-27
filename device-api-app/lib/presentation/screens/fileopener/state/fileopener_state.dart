import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';

class FileOpenerMainState {
  final List<FileOpenerInfo> files;
  final List<FileOpenerInfo> filteredFiles;
  final bool isLoading;
  final String statusMessage;
  final FileType? selectedFileType;
  final String sortBy;
  final bool sortAscending;

  const FileOpenerMainState({
    this.files = const [],
    this.filteredFiles = const [],
    this.isLoading = true,
    this.statusMessage = '',
    this.selectedFileType,
    this.sortBy = 'name',
    this.sortAscending = true,
  });

  factory FileOpenerMainState.initial() => const FileOpenerMainState();

  FileOpenerMainState copyWith({
    List<FileOpenerInfo>? files,
    List<FileOpenerInfo>? filteredFiles,
    bool? isLoading,
    String? statusMessage,
    FileType? selectedFileType,
    bool clearFileType = false,
    String? sortBy,
    bool? sortAscending,
  }) {
    return FileOpenerMainState(
      files: files ?? this.files,
      filteredFiles: filteredFiles ?? this.filteredFiles,
      isLoading: isLoading ?? this.isLoading,
      statusMessage: statusMessage ?? this.statusMessage,
      selectedFileType: clearFileType
          ? null
          : (selectedFileType ?? this.selectedFileType),
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}

class FileOpenerListState {
  final List<ServerFileInfo> serverFiles;
  final bool isLoading;
  final String errorMessage;
  final bool isDownloading;
  final String? downloadingFileName;
  final double downloadProgress;

  const FileOpenerListState({
    this.serverFiles = const [],
    this.isLoading = true,
    this.errorMessage = '',
    this.isDownloading = false,
    this.downloadingFileName,
    this.downloadProgress = 0.0,
  });

  factory FileOpenerListState.initial() => const FileOpenerListState();

  FileOpenerListState copyWith({
    List<ServerFileInfo>? serverFiles,
    bool? isLoading,
    String? errorMessage,
    bool? isDownloading,
    String? downloadingFileName,
    bool clearDownloadingFileName = false,
    double? downloadProgress,
  }) {
    return FileOpenerListState(
      serverFiles: serverFiles ?? this.serverFiles,
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

class FileOpenerDetailState {
  final bool isDownloading;
  final double downloadProgress;

  const FileOpenerDetailState({
    this.isDownloading = false,
    this.downloadProgress = 0.0,
  });

  factory FileOpenerDetailState.initial() => const FileOpenerDetailState();

  FileOpenerDetailState copyWith({
    bool? isDownloading,
    double? downloadProgress,
  }) {
    return FileOpenerDetailState(
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}
