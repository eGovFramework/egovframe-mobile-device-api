import 'dart:io';

class FileMgmtMainState {
  final String currentPath;
  final String rootPath;
  final List<FileSystemEntity> currentContents;
  final List<String> pathHistory;
  final Set<String> selectedItems;
  final bool isLoading;
  final bool isSelectionMode;

  const FileMgmtMainState({
    this.currentPath = '',
    this.rootPath = '',
    this.currentContents = const [],
    this.pathHistory = const [],
    this.selectedItems = const {},
    this.isLoading = false,
    this.isSelectionMode = false,
  });

  factory FileMgmtMainState.initial() => const FileMgmtMainState();

  FileMgmtMainState copyWith({
    String? currentPath,
    String? rootPath,
    List<FileSystemEntity>? currentContents,
    List<String>? pathHistory,
    Set<String>? selectedItems,
    bool? isLoading,
    bool? isSelectionMode,
  }) {
    return FileMgmtMainState(
      currentPath: currentPath ?? this.currentPath,
      rootPath: rootPath ?? this.rootPath,
      currentContents: currentContents ?? this.currentContents,
      pathHistory: pathHistory ?? this.pathHistory,
      selectedItems: selectedItems ?? this.selectedItems,
      isLoading: isLoading ?? this.isLoading,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }
}
