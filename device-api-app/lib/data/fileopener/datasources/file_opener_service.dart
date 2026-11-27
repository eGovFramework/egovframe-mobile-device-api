import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'dart:async';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileopener/models/downloaded_file_data.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_result.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart' as platform_open;
import 'package:path_provider/path_provider.dart';

import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/datasources/file_readwrite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class FileOpenerService {
  static Future<FileOpenerPlatformResult> openFile(FileOpenerInfo fileInfo) async {
    try {
      if (fileInfo.isLocalFile) {
        final file = File(fileInfo.filePath);
        if (!await file.exists()) {
          return FileOpenerPlatformResult(
            success: false,
            message: '파일을 찾을 수 없습니다: ${fileInfo.fileName}',
          );
        }
      }

      final result = await platform_open.OpenFile.open(
        fileInfo.filePath,
        type: _shouldUseMimeType(fileInfo.fileExtension) ? fileInfo.mimeType : null,
      );

      if (result.type == platform_open.ResultType.done) {
        return FileOpenerPlatformResult(
          success: true,
          message: '파일이 성공적으로 열렸습니다: ${fileInfo.fileName}',
        );
      }

      return FileOpenerPlatformResult(
        success: false,
        message: result.message.isNotEmpty ? result.message : '파일을 열 수 없습니다',
      );
    } catch (e) {
      return FileOpenerPlatformResult(
        success: false,
        message: '파일 열기 중 오류가 발생했습니다: $e',
      );
    }
  }


  /// 파일 선택기를 통해 파일 선택
  static Future<List<FileOpenerInfo>?> pickFiles({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
    FileType fileType = FileType.other,
  }) async {
    try {
      final effectiveAllowed = _defaultAllowedExtensions(fileType, allowedExtensions);
      
      file_picker.FilePickerResult? result = await file_picker.FilePicker.pickFiles(
        type: _convertFileType(fileType),
        allowedExtensions: effectiveAllowed,
        allowMultiple: allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        List<FileOpenerInfo> fileInfos = [];
        
        for (file_picker.PlatformFile file in result.files) {
          final fileInfo = await _createFileInfoFromPlatformFile(file);
          if (fileInfo != null) {
            // 파일을 앱 내부 저장소로 복사
            final copiedFileInfo = await _copyFileToAppStorage(fileInfo);
            if (copiedFileInfo != null) {
              fileInfos.add(copiedFileInfo);
            }
          }
        }
        
        return fileInfos;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 파일을 앱 내부 저장소로 복사하는 메서드
  static Future<FileOpenerInfo?> _copyFileToAppStorage(FileOpenerInfo originalFile) async {
    try {
      final documentsPath = await getApplicationDocumentsDirectory();
      final copiedFilesDir = Directory('${documentsPath.path}/copied_files');
      
      if (!await copiedFilesDir.exists()) {
        await copiedFilesDir.create(recursive: true);
      }
      
      final originalFileObj = File(originalFile.filePath);
      final fileName = originalFile.fileName;
      final targetPath = '${copiedFilesDir.path}/$fileName';
      final targetFile = File(targetPath);
      
      // 파일 복사
      await originalFileObj.copy(targetPath);
      
      // 복사된 파일 정보 생성
      final stat = await targetFile.stat();
      final copiedFileInfo = FileOpenerInfo(
        fileName: fileName,
        filePath: targetPath,
        fileExtension: originalFile.fileExtension,
        mimeType: originalFile.mimeType,
        fileSize: stat.size,
        lastModified: stat.modified,
        isLocalFile: true,
      );
      
      return copiedFileInfo;
    } catch (e) {
      return originalFile; // 복사 실패 시 원본 파일 정보 반환
    }
  }

  /// 로컬 파일 목록에서 FileOpenerInfo 목록 생성
  static Future<List<FileOpenerInfo>> getLocalFileList() async {
    try {
      
      final fileInfos = await FileReadWriteService.getAllFileList();
      List<FileOpenerInfo> openerInfos = [];
      
      for (final fileInfo in fileInfos) {
        final extension = fileInfo.name.split('.').last.toLowerCase();
        final mimeType = FileOpenerInfo.getMimeTypeFromExtension(extension);
        
        // 문서 관련 확장자만 추가
        if (getDocumentExtensions().contains(extension)) {
          final openerInfo = FileOpenerInfo(
            fileName: fileInfo.name,
            filePath: fileInfo.path,
            fileExtension: extension,
            mimeType: mimeType,
            fileSize: fileInfo.size,
            lastModified: fileInfo.lastModified,
            isLocalFile: true,
          );
          
          openerInfos.add(openerInfo);
        }
      }
      
      // 복사된 파일들 추가
      final copiedFiles = await _getCopiedFiles();
      openerInfos.addAll(
        copiedFiles.where((f) => getDocumentExtensions().contains(f.fileExtension)).toList(),
      );
      
      // 시스템 다운로드 폴더 파일들 추가
      final downloadFiles = await getSystemDownloadFiles();
      openerInfos.addAll(
        downloadFiles.where((f) => getDocumentExtensions().contains(f.fileExtension)).toList(),
      );
      
      // 서버에서 다운로드된 파일들 추가
      final serverDownloadFiles = await _getServerDownloadFiles();
      openerInfos.addAll(
        serverDownloadFiles.where((f) => getDocumentExtensions().contains(f.fileExtension)).toList(),
      );
      
      return openerInfos;
    } catch (e) {
      return [];
    }
  }

  /// 복사된 파일들을 가져오는 메서드
  static Future<List<FileOpenerInfo>> _getCopiedFiles() async {
    try {
      List<FileOpenerInfo> copiedFiles = [];
      
      final documentsPath = await getApplicationDocumentsDirectory();
      final copiedFilesDir = Directory('${documentsPath.path}/copied_files');
      
      if (await copiedFilesDir.exists()) {
        final files = await copiedFilesDir.list().toList();
        final fileEntities = files.whereType<File>().toList();
        
        for (final file in fileEntities) {
          final fileName = file.path.split('/').last;
          final extension = fileName.split('.').last.toLowerCase();
          final mimeType = FileOpenerInfo.getMimeTypeFromExtension(extension);
          final stat = await file.stat();
          
          copiedFiles.add(FileOpenerInfo(
            fileName: fileName,
            filePath: file.path,
            fileExtension: extension,
            mimeType: mimeType,
            fileSize: stat.size,
            lastModified: stat.modified,
            isLocalFile: true,
          ));
        }
        
      }
      
      return copiedFiles;
    } catch (e) {
      return [];
    }
  }

  /// 서버에서 다운로드된 파일들을 가져오는 메서드
  static Future<List<FileOpenerInfo>> _getServerDownloadFiles() async {
    try {
      List<FileOpenerInfo> serverFiles = [];
      
      final documentsPath = await getApplicationDocumentsDirectory();
      final serverDownloadDir = Directory('${documentsPath.path}/server_downloads');
      
      if (await serverDownloadDir.exists()) {
        final files = await serverDownloadDir.list().toList();
        final fileEntities = files.whereType<File>().toList();
        
        for (final file in fileEntities) {
          try {
            final fileName = file.path.split('/').last;
            final extension = fileName.split('.').last.toLowerCase();
            final mimeType = FileOpenerInfo.getMimeTypeFromExtension(extension);
            
            // 파일이 존재하고 읽을 수 있는지 확인
            if (await file.exists()) {
              final stat = await file.stat();
              
              // 파일 크기가 0보다 큰 경우에만 추가
              if (stat.size > 0) {
                serverFiles.add(FileOpenerInfo(
                  fileName: fileName,
                  filePath: file.path,
                  fileExtension: extension,
                  mimeType: mimeType,
                  fileSize: stat.size,
                  lastModified: stat.modified,
                  isLocalFile: true,
                ));
              } else {
              }
            }
          } catch (e) {
            appLogError('Failed to read server download file: ${file.path}', e);
          }
        }
        
      }
      
      return serverFiles;
    } catch (e) {
      return [];
    }
  }

  /// 파일 타입별 대표 뷰어 앱 정보를 반환하는 메서드
  static ViewerApp getViewerAppForFileType(FileType fileType) {
    switch (fileType) {
      case FileType.document:
        return ViewerApp(
          name: 'Adobe Acrobat Reader',
          packageName: 'com.adobe.reader',
          storeUrl: 'https://play.google.com/store/apps/details?id=com.adobe.reader',
          iconUrl: 'https://play-lh.googleusercontent.com/9XKD5S7rwQ6FiPXSyp9SzLXfI122UlvGJZJbf1c7Ue9Kvcxjh2vo5eJ5l42Xa6O2Vg',
          description: 'PDF 파일을 읽고 편집할 수 있는 가장 인기 있는 앱입니다.',
          priority: 1,
        );
      case FileType.text:
        return ViewerApp(
          name: 'Microsoft Word',
          packageName: 'com.microsoft.office.word',
          storeUrl: 'https://play.google.com/store/apps/details?id=com.microsoft.office.word',
          iconUrl: 'https://play-lh.googleusercontent.com/9XKD5S7rwQ6FiPXSyp9SzLXfI122UlvGJZJbf1c7Ue9Kvcxjh2vo5eJ5l42Xa6O2Vg',
          description: 'Word 문서를 읽고 편집할 수 있는 가장 인기 있는 앱입니다.',
          priority: 1,
        );
      case FileType.spreadsheet:
        return ViewerApp(
          name: 'Microsoft Excel',
          packageName: 'com.microsoft.office.excel',
          storeUrl: 'https://play.google.com/store/apps/details?id=com.microsoft.office.excel',
          iconUrl: 'https://play-lh.googleusercontent.com/9XKD5S7rwQ6FiPXSyp9SzLXfI122UlvGJZJbf1c7Ue9Kvcxjh2vo5eJ5l42Xa6O2Vg',
          description: 'Excel 스프레드시트를 읽고 편집할 수 있는 가장 인기 있는 앱입니다.',
          priority: 1,
        );
      case FileType.presentation:
        return ViewerApp(
          name: 'Microsoft PowerPoint',
          packageName: 'com.microsoft.office.powerpoint',
          storeUrl: 'https://play.google.com/store/apps/details?id=com.microsoft.office.powerpoint',
          iconUrl: 'https://play-lh.googleusercontent.com/9XKD5S7rwQ6FiPXSyp9SzLXfI122UlvGJZJbf1c7Ue9Kvcxjh2vo5eJ5l42Xa6O2Vg',
          description: 'PowerPoint 프레젠테이션을 읽고 편집할 수 있는 가장 인기 있는 앱입니다.',
          priority: 1,
        );
      case FileType.other:
        return ViewerApp(
          name: 'ES File Explorer',
          packageName: 'com.estrongs.android.pop',
          storeUrl: 'https://play.google.com/store/apps/details?id=com.estrongs.android.pop',
          iconUrl: 'https://play-lh.googleusercontent.com/9XKD5S7rwQ6FiPXSyp9SzLXfI122UlvGJZJbf1c7Ue9Kvcxjh2vo5eJ5l42Xa6O2Vg',
          description: '다양한 파일 형식을 관리할 수 있는 가장 인기 있는 앱입니다.',
          priority: 1,
        );
    }
  }

  /// HWP 파일용 대표 뷰어 앱
  static ViewerApp getHwpViewerApp() {
    return ViewerApp(
      name: '한글과컴퓨터 한글 뷰어',
      packageName: 'com.hancom.office.viewer',
      storeUrl: 'https://play.google.com/store/apps/details?id=com.hancom.office.viewer',
      iconUrl: 'https://play-lh.googleusercontent.com/9XKD5S7rwQ6FiPXSyp9SzLXfI122UlvGJZJbf1c7Ue9Kvcxjh2vo5eJ5l42Xa6O2Vg',
      description: 'HWP 파일을 읽을 수 있는 한글과컴퓨터 공식 뷰어 앱입니다.',
      priority: 1,
    );
  }

  /// 파일 확장자에 따른 대표 뷰어 앱 반환
  static ViewerApp getViewerAppForExtension(String extension) {
    final ext = extension.toLowerCase();
    
    // HWP 파일 특별 처리
    if (ext == 'hwp') {
      return getHwpViewerApp();
    }
    
    // 일반 파일 타입별 처리
    final fileType = FileOpenerInfo.getFileTypeFromExtension(extension);
    return getViewerAppForFileType(fileType);
  }

  /// 서버에서 파일 다운로드 후 열기
  static Future<FileOpenerPlatformResult> downloadAndOpenFile({
    required String downloadUrl,
    required String fileName,
    String? targetPath,
  }) async {
    try {
      
      // 다운로드 경로 설정
      final documentsPath = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${documentsPath.path}/downloads');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      
      final filePath = targetPath ?? '${downloadDir.path}/$fileName';
      
      // HTTP 요청으로 파일 다운로드
      final response = await DeviceApiClient.get(
        Uri.parse(downloadUrl),
        timeout: AppConfig.fileDownloadTimeout,
      );
      
      if (response.statusCode == 200) {
        // 파일 저장
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        
        // 파일 정보 생성
        final extension = fileName.split('.').last.toLowerCase();
        final mimeType = FileOpenerInfo.getMimeTypeFromExtension(extension);
        final fileStat = await file.stat();
        
        final fileInfo = FileOpenerInfo(
          fileName: fileName,
          filePath: filePath,
          fileExtension: extension,
          mimeType: mimeType,
          fileSize: fileStat.size,
          lastModified: fileStat.modified,
          isLocalFile: true,
          downloadUrl: downloadUrl,
        );
        
        // 파일 열기
        return await openFile(fileInfo);
      } else {
        return FileOpenerPlatformResult(
          success: false,
          message: '파일 다운로드 실패: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      return FileOpenerPlatformResult(
        success: false,
        message: '파일 다운로드 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 파일 타입별로 필터링된 파일 목록 조회
  static Future<List<FileOpenerInfo>> getFilesByType(FileType fileType) async {
    try {
      final allFiles = await getLocalFileList();
      return allFiles.where((file) => file.fileType == fileType).toList();
    } catch (e) {
      return [];
    }
  }

  /// 파일 검색
  static Future<List<FileOpenerInfo>> searchFiles(String query) async {
    try {
      final allFiles = await getLocalFileList();
      return allFiles.where((file) => 
        file.fileName.toLowerCase().contains(query.toLowerCase()) ||
        file.fileExtension.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      return [];
    }
  }

  /// 파일 삭제
  static Future<bool> deleteFile(FileOpenerInfo fileInfo) async {
    try {
      if (fileInfo.isLocalFile) {
        final file = File(fileInfo.filePath);
        if (await file.exists()) {
          await file.delete();
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 파일 복사
  static Future<bool> copyFile(FileOpenerInfo sourceFile, String newFileName) async {
    try {
      if (sourceFile.isLocalFile) {
        final documentsPath = await getApplicationDocumentsDirectory();
        final targetPath = '${documentsPath.path}/$newFileName';
        
        final source = File(sourceFile.filePath);
        final target = File(targetPath);
        
        if (await source.exists()) {
          await source.copy(target.path);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 시스템 다운로드 폴더에서 파일 목록을 가져오는 메서드
  static Future<List<FileOpenerInfo>> getSystemDownloadFiles() async {
    try {
      
      List<FileOpenerInfo> downloadFiles = [];
      
      // Android 시스템 다운로드 폴더 경로들 (더 많은 경로 시도)
      final possiblePaths = [
        '/storage/emulated/0/Download',
        '/storage/emulated/0/Downloads',
        '/sdcard/Download',
        '/sdcard/Downloads',
        '/storage/emulated/0/DCIM',
        '/storage/emulated/0/Pictures',
        '/storage/emulated/0/Documents',
        '/storage/emulated/0/Android/data',
      ];
      
      for (final path in possiblePaths) {
        try {
          final downloadDir = Directory(path);
          
          if (await downloadDir.exists()) {
            
            // 권한 확인을 위해 간단한 접근 시도
            try {
              final entities = await downloadDir.list().toList();
              final files = entities.whereType<File>().toList();
              
              
              for (final file in files) {
                try {
                  final fileName = file.path.split('/').last;
                  final extension = fileName.split('.').last.toLowerCase();
                  
                  
                  // 문서 관련 확장자만 필터링
                  if (getDocumentExtensions().contains(extension)) {
                    final stat = await file.stat();
                    final mimeType = FileOpenerInfo.getMimeTypeFromExtension(extension);
                    
                    downloadFiles.add(FileOpenerInfo(
                      fileName: fileName,
                      filePath: file.path,
                      fileExtension: extension,
                      mimeType: mimeType,
                      fileSize: stat.size,
                      lastModified: stat.modified,
                      isLocalFile: true,
                    ));
                    
                  }
                } catch (e) {
                  appLogError('Failed to read system download file: ${file.path}', e);
                }
              }
              
              // 파일이 있는 폴더를 찾으면 중단
              if (files.isNotEmpty) {
                break;
              }
            } catch (e) {
              appLogError('Failed to list system download directory: $path', e);
            }
          } else {
          }
        } catch (e) {
          appLogError('Failed to access system download path: $path', e);
        }
      }
      
      return downloadFiles;
    } catch (e) {
      return [];
    }
  }

  /// 지원되는 파일 확장자 목록 반환
  static List<String> getSupportedExtensions() {
    // 문서뷰어 맥락에서 지원되는 확장자만 반환
    return getDocumentExtensions();
  }

  /// 문서 관련 확장자 목록 반환 (hwp, pdf, 엑셀, 워드, 파워포인트 등)
  static List<String> getDocumentExtensions() {
    return [
      'pdf', 'hwp',
      'doc', 'docx', 'rtf', 'odt', 'txt',
      'xls', 'xlsx', 'ods',
      'ppt', 'pptx', 'odp',
    ];
  }

  /// 특정 확장자에 대해 MIME 타입을 사용할지 결정
  static bool _shouldUseMimeType(String extension) {
    // txt 파일과 일부 기본 파일들은 MIME 타입을 지정하지 않는 것이 더 나을 수 있음
    final noMimeTypeExtensions = ['txt', 'log', 'md'];
    return !noMimeTypeExtensions.contains(extension.toLowerCase());
  }

  /// FileType을 FilePicker의 FileType으로 변환
  static file_picker.FileType _convertFileType(FileType fileType) {
    switch (fileType) {
      case FileType.document:
        return file_picker.FileType.custom;
      case FileType.text:
        return file_picker.FileType.custom;
      case FileType.spreadsheet:
        return file_picker.FileType.custom;
      case FileType.presentation:
        return file_picker.FileType.custom;
      case FileType.other:
        return file_picker.FileType.custom;
    }
  }

  /// 파일 선택 시 fileType에 맞는 기본 확장자 제공
  static List<String>? _defaultAllowedExtensions(FileType fileType, List<String>? allowedExtensions) {
    if (allowedExtensions != null && allowedExtensions.isNotEmpty) return allowedExtensions;
    switch (fileType) {
      case FileType.document:
        return getDocumentExtensions();
      case FileType.text:
        return ['doc', 'docx', 'rtf', 'odt', 'txt', 'hwp', 'pdf'];
      case FileType.spreadsheet:
        return ['xls', 'xlsx', 'ods'];
      case FileType.presentation:
        return ['ppt', 'pptx', 'odp'];
      case FileType.other:
        return getDocumentExtensions(); // file opener 맥락에서는 문서만 허용
    }
  }

  /// PlatformFile로부터 FileOpenerInfo 생성
  static Future<FileOpenerInfo?> _createFileInfoFromPlatformFile(file_picker.PlatformFile file) async {
    try {
      if (file.path == null) return null;
      
      final extension = file.name.split('.').last.toLowerCase();
      final mimeType = FileOpenerInfo.getMimeTypeFromExtension(extension);
      
      final fileStat = await File(file.path!).stat();
      
      return FileOpenerInfo(
        fileName: file.name,
        filePath: file.path!,
        fileExtension: extension,
        mimeType: mimeType,
        fileSize: file.size,
        lastModified: fileStat.modified,
        isLocalFile: true,
      );
    } catch (e) {
      return null;
    }
  }

  /// 서버 파일 목록 조회 (원시 JSON 응답)
  static Future<Map<String, dynamic>> fetchServerFileList() async {
    final isServerAvailable = await checkServerConnection();
    if (!isServerAvailable) {
      throw Exception('서버에 연결할 수 없습니다. 서버가 실행 중인지 확인해주세요.');
    }

    final uuid = await DeviceUuidUtil.getDeviceUuid();
    final uri = Uri.parse(AppConfig.getFileOpenerUrl('/selectFileOpenerList.do'))
        .replace(queryParameters: {'uuid': uuid});
    final response = await DeviceApiClient.get(uri);

    if (response.statusCode == 500) {
      throw Exception(
        '서버 초기화 오류가 발생했습니다. 서버 관리자에게 문의하세요.\n오류: ${response.body}',
      );
    }

    if (response.statusCode != 200) {
      throw Exception('서버 연결 실패: HTTP ${response.statusCode}');
    }

    final json = response.json;
    if (json == null) {
      throw const FormatException('서버 응답 형식이 올바르지 않습니다.');
    }
    return json;
  }

  /// 서버에서 파일 다운로드 (파일 I/O만, Entity 미사용)
  static Future<DownloadedFileData?> downloadServerFileBySn({
    required String fileSn,
    required String orignlFileNm,
    required String fileExtension,
    required String mimeType,
  }) async {
    try {
      final uuid = await DeviceUuidUtil.getDeviceUuid();
      if (uuid.isEmpty) {
        throw Exception('기기 UUID가 없어 파일을 다운로드할 수 없습니다.');
      }
      final uri = Uri.parse(AppConfig.getFileOpenerUrl('/fileDownload.do'))
          .replace(queryParameters: {'fileSn': fileSn, 'uuid': uuid});

      final response = await DeviceApiClient.get(uri, timeout: const Duration(seconds: 30));

      if (response.statusCode == 500) {
        throw Exception('서버 오류 (500): ${response.body}');
      }

      if (response.statusCode != 200) {
        throw Exception('파일 다운로드 실패: HTTP ${response.statusCode}');
      }

      final documentsPath = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${documentsPath.path}/server_downloads');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final filePath = '${downloadDir.path}/$orignlFileNm';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      final fileStat = await file.stat();
      return DownloadedFileData(
        fileName: orignlFileNm,
        filePath: filePath,
        fileExtension: fileExtension,
        mimeType: mimeType,
        fileSize: fileStat.size,
        lastModified: fileStat.modified,
        downloadUrl: uri.toString(),
      );
    } catch (e) {
      throw Exception('파일 다운로드 중 오류가 발생했습니다: $e');
    }
  }

  /// 서버에서 파일 다운로드 (진행률 표시)
  static Future<DownloadedFileData?> downloadServerFileBySnWithProgress({
    required String fileSn,
    required String orignlFileNm,
    required String fileExtension,
    required String mimeType,
    Function(double progress)? onProgress,
  }) async {
    final client = DeviceApiClient.openClient();
    IOSink? sink;

    try {
      final uuid = await DeviceUuidUtil.getDeviceUuid();
      if (uuid.isEmpty) {
        throw Exception('기기 UUID가 없어 파일을 다운로드할 수 없습니다.');
      }
      final uri = Uri.parse(AppConfig.getFileOpenerUrl('/fileDownload.do'))
          .replace(queryParameters: {'fileSn': fileSn, 'uuid': uuid});

      final request = http.Request('GET', uri);
      final streamedResponse =
          await DeviceApiClient.send(client, request, timeout: const Duration(seconds: 30));

      if (streamedResponse.statusCode == 500) {
        final responseBody = await streamedResponse.stream.bytesToString();
        throw Exception('서버 오류 (500): $responseBody');
      }

      if (streamedResponse.statusCode != 200) {
        throw Exception('파일 다운로드 실패: HTTP ${streamedResponse.statusCode}');
      }

      final documentsPath = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${documentsPath.path}/server_downloads');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final filePath = '${downloadDir.path}/$orignlFileNm';
      final file = File(filePath);
      final contentLength = streamedResponse.contentLength ?? 0;
      int downloadedBytes = 0;
      sink = file.openWrite();

      await for (final chunk in streamedResponse.stream) {
        sink.add(chunk);
        downloadedBytes += chunk.length;

        if (contentLength > 0 && onProgress != null) {
          onProgress(downloadedBytes / contentLength);
        } else if (onProgress != null && downloadedBytes > 0) {
          onProgress(0.5);
        }
      }

      await sink.close();
      sink = null;
      await Future.delayed(const Duration(milliseconds: 200));

      final fileStat = await file.stat();
      return DownloadedFileData(
        fileName: orignlFileNm,
        filePath: filePath,
        fileExtension: fileExtension,
        mimeType: mimeType,
        fileSize: fileStat.size,
        lastModified: fileStat.modified,
        downloadUrl: uri.toString(),
      );
    } catch (e) {
      throw Exception('파일 다운로드 중 오류가 발생했습니다: $e');
    } finally {
      await sink?.close();
      client.close();
    }
  }

  /// 다운로드된 서버 파일 목록을 가져오는 메서드
  static Future<List<FileOpenerInfo>> getDownloadedServerFiles() async {
    try {
      
      final documentsPath = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${documentsPath.path}/server_downloads');
      
      if (!await downloadDir.exists()) {
        return [];
      }
      
      final files = await downloadDir.list().toList();
      final fileEntities = files.whereType<File>().toList();
      
      List<FileOpenerInfo> downloadedFiles = [];
      
      for (final file in fileEntities) {
        try {
          // 파일이 존재하고 읽을 수 있는지 확인
          if (await file.exists()) {
            final fileName = file.path.split('/').last;
            final extension = fileName.split('.').last.toLowerCase();
            final mimeType = FileOpenerInfo.getMimeTypeFromExtension(extension);
            final stat = await file.stat();
            
            // 파일 크기가 0보다 큰 경우에만 추가
            if (stat.size > 0) {
              downloadedFiles.add(FileOpenerInfo(
                fileName: fileName,
                filePath: file.path,
                fileExtension: extension,
                mimeType: mimeType,
                fileSize: stat.size,
                lastModified: stat.modified,
                isLocalFile: true,
              ));
            } else {
            }
          }
        } catch (e) {
          appLogError('Failed to read downloaded server file: ${file.path}', e);
        }
      }
      
      return downloadedFiles;
    } catch (e) {
      return [];
    }
  }

  /// 서버 파일을 삭제하는 메서드
  static Future<bool> deleteDownloadedServerFile(FileOpenerInfo fileInfo) async {
    try {
      if (fileInfo.isLocalFile) {
        final file = File(fileInfo.filePath);
        if (await file.exists()) {
          await file.delete();
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 서버 연결 상태를 확인하는 메서드
  static Future<bool> checkServerConnection() async {
    try {
      final uuid = await DeviceUuidUtil.getDeviceUuid();
      final uri = Uri.parse(AppConfig.getFileOpenerUrl('/selectFileOpenerList.do'))
          .replace(queryParameters: {'uuid': uuid});
      final response = await DeviceApiClient.get(uri, timeout: const Duration(seconds: 5));
      
      
      // 500 오류는 서버가 실행 중이지만 초기화에 실패한 경우
      if (response.statusCode == 500) {
        return false;
      }
      
      return response.statusCode == 200;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (e) {
      return false;
    }
  }
}

/// 뷰어 앱 정보를 담는 클래스
class ViewerApp {
  final String name;
  final String packageName;
  final String storeUrl;
  final String iconUrl;
  final String description;
  final int priority; // 우선순위 (낮을수록 우선)

  ViewerApp({
    required this.name,
    required this.packageName,
    required this.storeUrl,
    required this.iconUrl,
    required this.description,
    this.priority = 1,
  });
}
