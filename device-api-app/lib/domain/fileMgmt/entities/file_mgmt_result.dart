import 'dart:io';

sealed class FileMgmtInitResult {
  const FileMgmtInitResult();
}

class FileMgmtInitSuccess extends FileMgmtInitResult {
  final String rootPath;
  final String currentPath;
  final List<FileSystemEntity> contents;

  const FileMgmtInitSuccess({
    required this.rootPath,
    required this.currentPath,
    required this.contents,
  });
}

class FileMgmtInitPermissionDenied extends FileMgmtInitResult {
  const FileMgmtInitPermissionDenied();
}

class FileMgmtInitFailure extends FileMgmtInitResult {
  final String message;

  const FileMgmtInitFailure(this.message);
}

sealed class FileMgmtDirectoryResult {
  const FileMgmtDirectoryResult();
}

class FileMgmtDirectorySuccess extends FileMgmtDirectoryResult {
  final List<FileSystemEntity> contents;

  const FileMgmtDirectorySuccess(this.contents);
}

class FileMgmtDirectoryFailure extends FileMgmtDirectoryResult {
  final String message;

  const FileMgmtDirectoryFailure(this.message);
}

sealed class FileMgmtOperationResult {
  const FileMgmtOperationResult();
}

class FileMgmtOperationSuccess extends FileMgmtOperationResult {
  final String message;

  const FileMgmtOperationSuccess(this.message);
}

class FileMgmtOperationFailure extends FileMgmtOperationResult {
  final String message;

  const FileMgmtOperationFailure(this.message);
}
