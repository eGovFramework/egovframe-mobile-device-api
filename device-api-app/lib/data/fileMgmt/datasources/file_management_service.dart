import 'dart:async';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/utils/format_utils.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManagementService {
  static final FileManagementService _instance =
      FileManagementService._internal();
  factory FileManagementService() => _instance;
  FileManagementService._internal();

  String? _cachedDocumentsPath;

  static const Duration _pathTimeout = Duration(seconds: 5);
  static const Duration _listTimeout = Duration(seconds: 10);

  /// 앱 샌드박스 Documents 디렉토리 접근 가능 여부
  ///
  /// FileMgmt는 [getApplicationDocumentsPath]만 사용하므로
  /// 외부 저장소·미디어 권한 요청(manageExternalStorage 등)은 하지 않습니다.
  /// 해당 요청은 설정 화면 이동 후 완료되지 않아 초기화가 멈출 수 있습니다.
  Future<bool> requestPermissions() async {
    try {
      return Platform.isAndroid ||
          Platform.isIOS ||
          Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS;
    } catch (e) {
      appLog('권한 요청 오류: $e');
      return false;
    }
  }

  /// MANAGE_EXTERNAL_STORAGE 권한을 설정 화면에서 허용하도록 안내
  Future<bool> openPermissionSettings() async {
    try {
      appLog('앱 설정 화면 열기 시도');
      return await openAppSettings();
    } catch (e) {
      appLog('앱 설정 화면 열기 실패: $e');
      return false;
    }
  }

  /// 애플리케이션 문서 디렉토리 경로 가져오기
  Future<String> getApplicationDocumentsPath() async {
    if (_cachedDocumentsPath != null) {
      return _cachedDocumentsPath!;
    }

    try {
      final directory = await getApplicationDocumentsDirectory().timeout(
        _pathTimeout,
        onTimeout: () => throw TimeoutException('문서 폴더 경로 조회 시간이 초과되었습니다.'),
      );

      // iOS에서 Documents 폴더가 존재하는지 확인하고 없으면 생성
      if (Platform.isIOS) {
        final documentsDir = Directory(directory.path);
        if (!await documentsDir.exists()) {
          await documentsDir.create(recursive: true);
          appLog('iOS Documents 디렉토리 생성');
        }
      }

      _cachedDocumentsPath = directory.path;
      return directory.path;
    } catch (e) {
      appLog('문서 디렉토리 경로 가져오기 오류: $e');
      rethrow;
    }
  }

  /// 디렉토리 및 파일 목록 조회
  Future<List<FileSystemEntity>> listDirectoryContents(String path) async {
    try {
      final directory = Directory(path);
      if (!await directory.exists()) {
        throw Exception('디렉토리가 존재하지 않습니다: $path');
      }

      final contents = await directory
          .list(followLinks: false)
          .toList()
          .timeout(_listTimeout);
      // 이름순으로 정렬 (디렉토리 먼저, 그 다음 파일)
      contents.sort((a, b) {
        if (a is Directory && b is File) return -1;
        if (a is File && b is Directory) return 1;
        return a.path
            .split('/')
            .last
            .toLowerCase()
            .compareTo(b.path.split('/').last.toLowerCase());
      });

      return contents;
    } catch (e) {
      appLog('디렉토리 목록 조회 오류: $e');
      rethrow;
    }
  }

  /// 디렉토리 생성
  Future<bool> createDirectory(String parentPath, String directoryName) async {
    try {
      final newDirectoryPath = '$parentPath/$directoryName';
      final directory = Directory(newDirectoryPath);

      if (await directory.exists()) {
        throw Exception('이미 존재하는 디렉토리입니다: $directoryName');
      }

      await directory.create(recursive: true);
      appLog('디렉토리 생성 완료');
      return true;
    } catch (e) {
      appLog('디렉토리 생성 오류: $e');
      rethrow;
    }
  }

  /// 파일 또는 디렉토리 삭제
  Future<bool> deleteFileOrDirectory(String path) async {
    try {
      final entity = FileSystemEntity.typeSync(path);

      if (entity == FileSystemEntityType.directory) {
        final directory = Directory(path);
        await directory.delete(recursive: true);
        appLog('디렉토리 삭제 완료');
      } else if (entity == FileSystemEntityType.file) {
        final file = File(path);
        await file.delete();
        appLog('파일 삭제 완료');
      } else {
        throw Exception('삭제할 수 없는 항목입니다: $path');
      }

      return true;
    } catch (e) {
      appLog('삭제 오류: $e');
      rethrow;
    }
  }

  /// 파일 또는 디렉토리 복사
  Future<bool> copyFileOrDirectory(
    String sourcePath,
    String destinationPath,
  ) async {
    try {
      // 먼저 소스 파일/디렉토리가 존재하는지 확인
      if (!await FileSystemEntity.isFile(sourcePath) &&
          !await FileSystemEntity.isDirectory(sourcePath)) {
        throw Exception('존재하지 않는 파일입니다: ${sourcePath.split('/').last}');
      }

      final entity = FileSystemEntity.typeSync(sourcePath);
      final sourceName = sourcePath.split('/').last;
      final newPath = '$destinationPath/$sourceName';

      // 대상 경로가 존재하는지 확인
      final destinationDir = Directory(destinationPath);
      if (!await destinationDir.exists()) {
        throw Exception('대상 디렉토리가 존재하지 않습니다: $destinationPath');
      }

      if (entity == FileSystemEntityType.file) {
        final sourceFile = File(sourcePath);
        final destinationFile = File(newPath);

        // 소스 파일 존재 여부 재확인
        if (!await sourceFile.exists()) {
          throw Exception('존재하지 않는 파일입니다: $sourceName');
        }

        if (await destinationFile.exists()) {
          throw Exception('이미 존재하는 파일입니다: $sourceName');
        }

        await sourceFile.copy(newPath);
        appLog('파일 복사 완료');
      } else if (entity == FileSystemEntityType.directory) {
        final sourceDir = Directory(sourcePath);

        // 소스 디렉토리 존재 여부 재확인
        if (!await sourceDir.exists()) {
          throw Exception('존재하지 않는 디렉토리입니다: $sourceName');
        }

        await _copyDirectory(sourcePath, newPath);
        appLog('디렉토리 복사 완료');
      } else {
        throw Exception('존재하지 않는 파일입니다: $sourceName');
      }

      return true;
    } catch (e) {
      appLog('복사 오류: $e');
      rethrow;
    }
  }

  /// 파일 또는 디렉토리 이동
  Future<bool> moveFileOrDirectory(
    String sourcePath,
    String destinationPath,
  ) async {
    try {
      // 먼저 소스 파일/디렉토리가 존재하는지 확인
      if (!await FileSystemEntity.isFile(sourcePath) &&
          !await FileSystemEntity.isDirectory(sourcePath)) {
        throw Exception('존재하지 않는 파일입니다: ${sourcePath.split('/').last}');
      }

      final entity = FileSystemEntity.typeSync(sourcePath);
      final sourceName = sourcePath.split('/').last;
      final newPath = '$destinationPath/$sourceName';

      // 대상 경로가 존재하는지 확인
      final destinationDir = Directory(destinationPath);
      if (!await destinationDir.exists()) {
        throw Exception('대상 디렉토리가 존재하지 않습니다: $destinationPath');
      }

      if (entity == FileSystemEntityType.file) {
        final sourceFile = File(sourcePath);
        final destinationFile = File(newPath);

        // 소스 파일 존재 여부 재확인
        if (!await sourceFile.exists()) {
          throw Exception('존재하지 않는 파일입니다: $sourceName');
        }

        if (await destinationFile.exists()) {
          throw Exception('이미 존재하는 파일입니다: $sourceName');
        }

        await sourceFile.rename(newPath);
        appLog('파일 이동 완료');
      } else if (entity == FileSystemEntityType.directory) {
        final sourceDirectory = Directory(sourcePath);

        // 소스 디렉토리 존재 여부 재확인
        if (!await sourceDirectory.exists()) {
          throw Exception('존재하지 않는 디렉토리입니다: $sourceName');
        }

        // 대상에 같은 이름의 디렉토리가 있는지 확인
        final destinationDirectory = Directory(newPath);
        if (await destinationDirectory.exists()) {
          throw Exception('이미 존재하는 디렉토리입니다: $sourceName');
        }

        await sourceDirectory.rename(newPath);
        appLog('디렉토리 이동 완료');
      } else {
        throw Exception('존재하지 않는 파일입니다: $sourceName');
      }

      return true;
    } catch (e) {
      appLog('이동 오류: $e');
      rethrow;
    }
  }

  /// 디렉토리 재귀적 복사 (내부 메서드)
  Future<void> _copyDirectory(String sourcePath, String destinationPath) async {
    final sourceDirectory = Directory(sourcePath);
    final destinationDirectory = Directory(destinationPath);

    // 소스 디렉토리 존재 여부 확인
    if (!await sourceDirectory.exists()) {
      throw Exception('존재하지 않는 디렉토리입니다: ${sourcePath.split('/').last}');
    }

    if (await destinationDirectory.exists()) {
      throw Exception('이미 존재하는 디렉토리입니다: ${destinationPath.split('/').last}');
    }

    await destinationDirectory.create(recursive: true);

    try {
      await for (final entity in sourceDirectory.list()) {
        final entityName = entity.path.split('/').last;
        final newPath = '$destinationPath/$entityName';

        if (entity is File) {
          if (await entity.exists()) {
            await entity.copy(newPath);
          }
        } else if (entity is Directory) {
          if (await entity.exists()) {
            await _copyDirectory(entity.path, newPath);
          }
        }
      }
    } catch (e) {
      appLog('디렉토리 복사 중 오류: $e');
      // 부분적으로 생성된 대상 디렉토리 정리
      try {
        if (await destinationDirectory.exists()) {
          await destinationDirectory.delete(recursive: true);
        }
      } catch (cleanupError) {
        appLog('정리 중 오류: $cleanupError');
      }
      rethrow;
    }
  }

  /// 테스트용 샘플 파일 생성
  Future<bool> createSampleFile(
    String parentPath,
    String fileName,
    String content,
  ) async {
    try {
      final filePath = '$parentPath/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        throw Exception('이미 존재하는 파일입니다: $fileName');
      }

      await file.writeAsString(content);
      appLog('샘플 파일 생성 완료');
      return true;
    } catch (e) {
      appLog('샘플 파일 생성 오류: $e');
      rethrow;
    }
  }

  Future<bool> exists(String path) async {
    return await FileSystemEntity.isFile(path) ||
        await FileSystemEntity.isDirectory(path);
  }

  Future<void> renamePath(String sourcePath, String newPath) async {
    if (await FileSystemEntity.isFile(sourcePath)) {
      await File(sourcePath).rename(newPath);
      return;
    }
    if (await FileSystemEntity.isDirectory(sourcePath)) {
      await Directory(sourcePath).rename(newPath);
      return;
    }
    throw Exception('존재하지 않는 파일입니다: ${sourcePath.split('/').last}');
  }

  Future<void> copyWithGeneratedName({
    required String sourcePath,
    required String destinationDir,
    required String copySuffix,
  }) async {
    final sourceName = sourcePath.split('/').last;
    final extension = sourceName.contains('.')
        ? '.${sourceName.split('.').last}'
        : '';
    final nameWithoutExt = sourceName.contains('.')
        ? sourceName.substring(0, sourceName.lastIndexOf('.'))
        : sourceName;

    var newName = '$nameWithoutExt$copySuffix$extension';
    var counter = 1;
    while (await exists('$destinationDir/$newName')) {
      newName = '$nameWithoutExt$copySuffix$counter$extension';
      counter++;
    }

    final newPath = '$destinationDir/$newName';
    if (await FileSystemEntity.isFile(sourcePath)) {
      await File(sourcePath).copy(newPath);
      return;
    }
    if (await FileSystemEntity.isDirectory(sourcePath)) {
      await _copyDirectory(sourcePath, newPath);
    }
  }

  /// 파일 정보 가져오기
  Future<Map<String, dynamic>> getFileInfo(String path) async {
    try {
      final entity = FileSystemEntity.typeSync(path);
      final name = path.split('/').last;

      if (entity == FileSystemEntityType.file) {
        final file = File(path);
        final stat = await file.stat();
        final size = stat.size;
        final modified = stat.modified;

        return {
          'name': name,
          'type': 'file',
          'size': size,
          'sizeFormatted': FormatUtils.formatFileSize(size),
          'modified': modified,
          'path': path,
        };
      } else if (entity == FileSystemEntityType.directory) {
        final directory = Directory(path);
        final stat = await directory.stat();
        final modified = stat.modified;
        final itemCount = await directory.list(followLinks: false).length;

        return {
          'name': name,
          'type': 'directory',
          'itemCount': itemCount,
          'modified': modified,
          'path': path,
        };
      } else {
        throw Exception('알 수 없는 파일 형식: $path');
      }
    } catch (e) {
      appLog('파일 정보 가져오기 오류: $e');
      rethrow;
    }
  }
}
