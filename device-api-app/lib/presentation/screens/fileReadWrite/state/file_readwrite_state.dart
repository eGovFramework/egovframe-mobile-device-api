import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_readwrite_message_keys.dart';

class FileReadWriteMainState {
  final String deviceUuid;
  final String statusMessage;
  final bool isLoading;
  final List<FileInfo> fileList;
  final Set<String> selectedFiles;
  final bool isSelectionMode;

  const FileReadWriteMainState({
    this.deviceUuid = '',
    this.statusMessage = FileReadWriteMessageKeys.initialGuide,
    this.isLoading = false,
    this.fileList = const [],
    this.selectedFiles = const {},
    this.isSelectionMode = false,
  });

  factory FileReadWriteMainState.initial() => const FileReadWriteMainState();

  FileReadWriteMainState copyWith({
    String? deviceUuid,
    String? statusMessage,
    bool? isLoading,
    List<FileInfo>? fileList,
    Set<String>? selectedFiles,
    bool? isSelectionMode,
  }) {
    return FileReadWriteMainState(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      statusMessage: statusMessage ?? this.statusMessage,
      isLoading: isLoading ?? this.isLoading,
      fileList: fileList ?? this.fileList,
      selectedFiles: selectedFiles ?? this.selectedFiles,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }
}

class FileReadWriteListState {
  final String deviceUuid;
  final List<FileInfo> serverFileList;
  final bool isLoading;
  final String errorMessage;

  const FileReadWriteListState({
    this.deviceUuid = '',
    this.serverFileList = const [],
    this.isLoading = true,
    this.errorMessage = '',
  });

  factory FileReadWriteListState.initial() => const FileReadWriteListState();

  FileReadWriteListState copyWith({
    String? deviceUuid,
    List<FileInfo>? serverFileList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FileReadWriteListState(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      serverFileList: serverFileList ?? this.serverFileList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FileReadWriteDetailState {
  final bool isDeleting;

  const FileReadWriteDetailState({this.isDeleting = false});

  factory FileReadWriteDetailState.initial() =>
      const FileReadWriteDetailState();

  FileReadWriteDetailState copyWith({bool? isDeleting}) {
    return FileReadWriteDetailState(isDeleting: isDeleting ?? this.isDeleting);
  }
}
