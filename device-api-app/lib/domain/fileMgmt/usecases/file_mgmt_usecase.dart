import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/entities/file_mgmt_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/repositories/file_mgmt_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/file_mgmt_message_keys.dart';

class FileMgmtUseCase {
  final FileMgmtRepository repository;

  FileMgmtUseCase(this.repository);

  Future<bool> requestPermissions() => repository.requestPermissions();

  Future<void> openPermissionSettings() => repository.openPermissionSettings();

  Future<String> getDocumentsRoot() => repository.getDocumentsRoot();

  Future<FileMgmtDirectoryResult> listDirectory(String path) async {
    try {
      final contents = await repository.listDirectory(path);
      return FileMgmtDirectorySuccess(contents);
    } catch (e) {
      return FileMgmtDirectoryFailure(
        '${FileMgmtMessageKeys.directoryLoadErrorPrefix}$e',
      );
    }
  }

  Future<Map<String, dynamic>> getFileInfo(String path) =>
      repository.getFileInfo(path);

  Future<FileMgmtOperationResult> createDirectory({
    required String parentPath,
    required String name,
  }) async {
    try {
      await repository.createDirectory(parentPath, name);
      return FileMgmtOperationSuccess(
        '${FileMgmtMessageKeys.folderCreatedPrefix}$name',
      );
    } catch (e) {
      return FileMgmtOperationFailure(
        '${FileMgmtMessageKeys.folderCreateErrorPrefix}$e',
      );
    }
  }

  Future<FileMgmtOperationResult> createSampleFile({
    required String parentPath,
    required String fileName,
    required String content,
  }) async {
    try {
      await repository.createSampleFile(parentPath, fileName, content);
      return FileMgmtOperationSuccess(
        '${FileMgmtMessageKeys.sampleFileCreatedPrefix}$fileName',
      );
    } catch (e) {
      return FileMgmtOperationFailure(
        '${FileMgmtMessageKeys.sampleFileCreateErrorPrefix}$e',
      );
    }
  }

  Future<FileMgmtOperationResult> deletePaths(Set<String> paths) async {
    if (paths.isEmpty) {
      return const FileMgmtOperationFailure(FileMgmtMessageKeys.noItemsToDelete);
    }
    try {
      for (final path in paths) {
        await repository.deletePath(path);
      }
      return FileMgmtOperationSuccess(
        '${FileMgmtMessageKeys.deletedCountPrefix}${paths.length}',
      );
    } catch (e) {
      return FileMgmtOperationFailure(
        '${FileMgmtMessageKeys.deleteErrorPrefix}$e',
      );
    }
  }

  Future<FileMgmtOperationResult> copyPaths({
    required Set<String> sourcePaths,
    required String destinationDir,
    required String copySuffix,
  }) async {
    if (sourcePaths.isEmpty) {
      return const FileMgmtOperationFailure(FileMgmtMessageKeys.noItemsToCopy);
    }
    try {
      for (final sourcePath in sourcePaths) {
        final sourceParent = _parentPath(sourcePath);
        if (sourceParent == destinationDir) {
          await repository.copyPathWithNewName(
            sourcePath: sourcePath,
            destinationDir: destinationDir,
            copySuffix: copySuffix,
          );
        } else {
          await repository.copyPath(sourcePath, destinationDir);
        }
      }
      return FileMgmtOperationSuccess(
        '${FileMgmtMessageKeys.copiedCountPrefix}${sourcePaths.length}',
      );
    } catch (e) {
      return FileMgmtOperationFailure(
        '${FileMgmtMessageKeys.copyErrorPrefix}$e',
      );
    }
  }

  Future<FileMgmtOperationResult> movePaths({
    required Set<String> sourcePaths,
    required String destinationDir,
  }) async {
    if (sourcePaths.isEmpty) {
      return const FileMgmtOperationFailure(FileMgmtMessageKeys.noItemsToMove);
    }
    try {
      for (final sourcePath in sourcePaths) {
        final sourceParent = _parentPath(sourcePath);
        if (sourceParent == destinationDir) {
          final result = await renameItem(
            sourcePath: sourcePath,
            directoryPath: destinationDir,
            newName: sourcePath.split('/').last,
          );
          if (result is FileMgmtOperationFailure) return result;
        } else {
          await repository.movePath(sourcePath, destinationDir);
        }
      }
      return FileMgmtOperationSuccess(
        '${FileMgmtMessageKeys.movedCountPrefix}${sourcePaths.length}',
      );
    } catch (e) {
      return FileMgmtOperationFailure(
        '${FileMgmtMessageKeys.moveErrorPrefix}$e',
      );
    }
  }

  Future<FileMgmtOperationResult> renameItem({
    required String sourcePath,
    required String directoryPath,
    required String newName,
  }) async {
    final sourceName = sourcePath.split('/').last;
    if (newName.isEmpty || newName == sourceName) {
      return const FileMgmtOperationSuccess('');
    }

    try {
      await repository.renamePath(sourcePath, '$directoryPath/$newName');
      return const FileMgmtOperationSuccess(FileMgmtMessageKeys.renameSuccess);
    } catch (e) {
      return FileMgmtOperationFailure(
        '${FileMgmtMessageKeys.renameErrorPrefix}$e',
      );
    }
  }

  String _parentPath(String path) {
    final index = path.lastIndexOf('/');
    if (index <= 0) return path;
    return path.substring(0, index);
  }
}
