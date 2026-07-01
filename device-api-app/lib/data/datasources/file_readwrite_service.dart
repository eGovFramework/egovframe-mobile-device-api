import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/file_validation_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/format_utils.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileReadWriteService {
  static Future<String> getDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  /// 텍스트 파일을 쓰는 메서드
  static Future<bool> writeTextFile(String fileName, String content) async {
    try {
      final documentsPath = await getDocumentsPath();
      final file = File('$documentsPath/$fileName');
      
      // 디렉토리가 존재하지 않으면 생성
      await file.parent.create(recursive: true);
      
      await file.writeAsString(content, encoding: utf8);
      return true;
    } catch (e) {
      AppLogger.e('오류', e);
      return false;
    }
  }

  /// 텍스트 파일을 읽는 메서드
  static Future<String?> readTextFile(String fileName) async {
    try {
      final documentsPath = await getDocumentsPath();
      final file = File('$documentsPath/$fileName');
      
      if (await file.exists()) {
        final content = await file.readAsString(encoding: utf8);
        return content;
      } else {
        return null;
      }
    } catch (e) {
      AppLogger.e('오류', e);
      return null;
    }
  }

  /// JSON 데이터를 파일에 쓰는 메서드
  static Future<bool> writeJsonFile(String fileName, Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      return await writeTextFile(fileName, jsonString);
    } catch (e) {
      AppLogger.e('오류', e);
      return false;
    }
  }

  /// JSON 파일을 읽어서 Map으로 반환하는 메서드
  static Future<Map<String, dynamic>?> readJsonFile(String fileName) async {
    try {
      final content = await readTextFile(fileName);
      if (content != null) {
        return jsonDecode(content) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      AppLogger.e('오류', e);
      return null;
    }
  }


  /// 파일이 존재하는지 확인하는 메서드
  static Future<bool> fileExists(String fileName) async {
    try {
      final documentsPath = await getDocumentsPath();
      final file = File('$documentsPath/$fileName');
      return await file.exists();
    } catch (e) {
      AppLogger.e('오류', e);
      return false;
    }
  }

  /// 파일을 삭제하는 메서드 (전체 경로에서 검색)
  static Future<bool> deleteFile(String fileName) async {
    try {
      final documentsPath = await getDocumentsPath();
      
      // 1. 기본 documents 폴더에서 찾기
      File file = File('$documentsPath/$fileName');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      
      // 2. media 폴더에서 찾기
      file = File('$documentsPath/media/$fileName');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      
      // 3. downloads 폴더에서 찾기
      file = File('$documentsPath/downloads/$fileName');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      
      return false;
    } catch (e) {
      AppLogger.e('오류', e);
      return false;
    }
  }

  /// 특정 경로의 파일을 삭제하는 메서드
  static Future<bool> deleteFileByPath(String filePath) async {
    try {
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppLogger.e('오류', e);
      return false;
    }
  }

  /// 디렉토리 내의 모든 파일 목록을 가져오는 메서드
  static Future<List<LocalFileInfo>> getFileList() async {
    try {
      final documentsPath = await getDocumentsPath();
      final directory = Directory(documentsPath);
      
      
      if (await directory.exists()) {
        final entities = await directory.list().toList();
        final files = entities.whereType<File>().toList();
        
        List<LocalFileInfo> fileInfos = [];
        for (File file in files) {
          final stat = await file.stat();
          fileInfos.add(LocalFileInfo(
            name: file.path.split('/').last,
            path: file.path,
            size: stat.size,
            lastModified: stat.modified,
          ));
        }
        
        return fileInfos;
      }
      return [];
    } catch (e) {
      AppLogger.e('오류', e);
      return [];
    }
  }

  /// 미디어 디렉토리 내의 모든 파일 목록을 가져오는 메서드
  static Future<List<LocalFileInfo>> getMediaFileList() async {
    try {
      final documentsPath = await getDocumentsPath();
      final mediaDir = Directory('$documentsPath/media');
      
      
      if (await mediaDir.exists()) {
        final entities = await mediaDir.list().toList();
        final files = entities.whereType<File>().toList();
        
        List<LocalFileInfo> fileInfos = [];
        for (File file in files) {
          final stat = await file.stat();
          fileInfos.add(LocalFileInfo(
            name: file.path.split('/').last,
            path: file.path,
            size: stat.size,
            lastModified: stat.modified,
          ));
        }
        
        return fileInfos;
      } else {
        return [];
      }
    } catch (e) {
      AppLogger.e('오류', e);
      return [];
    }
  }

  /// 다운로드 디렉토리 내의 모든 파일 목록을 가져오는 메서드
  static Future<List<LocalFileInfo>> getDownloadFileList() async {
    try {
      final documentsPath = await getDocumentsPath();
      final downloadDir = Directory('$documentsPath/downloads');
      
      
      if (await downloadDir.exists()) {
        final entities = await downloadDir.list().toList();
        final files = entities.whereType<File>().toList();
        
        List<LocalFileInfo> fileInfos = [];
        for (File file in files) {
          final stat = await file.stat();
          fileInfos.add(LocalFileInfo(
            name: file.path.split('/').last,
            path: file.path,
            size: stat.size,
            lastModified: stat.modified,
          ));
        }
        
        return fileInfos;
      } else {
        return [];
      }
    } catch (e) {
      AppLogger.e('오류', e);
      return [];
    }
  }

  /// 모든 파일 목록을 가져오는 메서드 (로컬 파일 + 다운로드 파일)
  static Future<List<LocalFileInfo>> getAllFileList([String? uuid]) async {
    try {
      List<LocalFileInfo> allFiles = [];
      
      // 로컬 파일들 가져오기
      final documentsFiles = await getFileList();
      final mediaFiles = await getMediaFileList();
      final downloadFiles = await getDownloadFileList();
      
      allFiles.addAll([...documentsFiles, ...mediaFiles, ...downloadFiles]);
      
      // 최신순으로 정렬
      allFiles.sort((a, b) => b.lastModified.compareTo(a.lastModified));
      
      return allFiles;
    } catch (e) {
      AppLogger.e('오류', e);
      return [];
    }
  }

  /// 파일 크기를 가져오는 메서드
  static Future<int?> getFileSize(String fileName) async {
    try {
      final documentsPath = await getDocumentsPath();
      final file = File('$documentsPath/$fileName');
      
      if (await file.exists()) {
        final stat = await file.stat();
        return stat.size;
      }
      return null;
    } catch (e) {
      AppLogger.e('오류', e);
      return null;
    }
  }


  /// 파일 크기를 사람이 읽기 쉬운 형태로 변환하는 메서드 (호환성 유지)
  static String formatFileSize(int bytes) => FormatUtils.formatFileSize(bytes);

  // 파일 정보 목록 조회
  static Future<List<FileReadWriteInfoServer>> getFileInfoList(String uuid) async {
    try {
      final uri = Uri.parse(AppConfig.getFileReadWriteUrl('/selectFileReaderWriterInfoList.do'))
          .replace(queryParameters: {'uuid': uuid});


      final response = await http.get(uri).timeout(const Duration(seconds: 10));


      if (response.statusCode == 500) {
        throw Exception('서버 초기화 오류가 발생했습니다. 서버 관리자에게 문의하세요.');
      }

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        final List<dynamic>? fileInfoList = jsonResponse['fileReaderWriterInfoList'];
        
        if (fileInfoList != null) {
          return fileInfoList
              .map((item) => FileReadWriteInfoServer.fromJson(item))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('서버 연결 실패: HTTP ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('네트워크 연결을 확인해주세요.');
    } on TimeoutException {
      throw Exception('서버 응답이 너무 느립니다. 잠시 후 다시 시도해주세요.');
    } on FormatException {
      throw Exception('서버 응답 형식이 올바르지 않습니다.');
    } catch (e) {
      AppLogger.e('오류', e);
      throw Exception('서버 파일 목록을 불러올 수 없습니다: $e');
    }
  }

  // 파일 정보 업로드
  static Future<Map<String, dynamic>> insertFileReaderWriteInfo({
    required String uuid,
    required String fileSn,
    required String fileNm,
    required String fileCours,
    required String fileType,
    required String fileSize,
    required String useYn,
    required String fileStreCours,
  }) async {
      final uri = Uri.parse(AppConfig.getFileReadWriteUrl('/insertFileReaderWriterInfo.do'));
      try{
        final response = await  http.post(uri, body:{
          'uuid': uuid,
          'fileSn': fileSn,
          'fileNm': fileNm,
          'fileCours': fileCours,
          'fileType': fileType,
          'fileSize': fileSize,
          'fileStreCours': fileStreCours,
          'useYn': 'Y',
        }).timeout(const Duration(seconds: 30));


        if (response.statusCode == 200) {
          try {
            final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
            return {
              'success': true,
              'resultState': jsonResponse['resultState'] ?? 'Unknown',
              'resultMessage': jsonResponse['resultMessage'] ?? '',
              'data': jsonResponse,
            };
          } catch (_) {
            return {
              'success': true,
              'resultState': 'SUCCESS',
              'resultMessage': response.body,
              'data': {'raw': response.body},
            };
          }
        } else {
          return {
            'success': false,
            'message': '서버 연결 실패 (상태 코드: ${response.statusCode})',
          };
        }

      }catch(e){
        return {
          'success': false,
          'message': '오류가 발생했습니다: $e',
        };
      }
  }

  /// 파일 업로드 (단일 또는 여러 파일 지원)
  static Future<Map<String, dynamic>> uploadFile({
    required String uuid, 
    required List<File> files,
  }) async {
    final client = http.Client();
    try {
      // 클라이언트 측 사전 검증 (UX 개선용 - 실제 보안 검증은 서버에서 수행)
      final validationResult = await FileValidationUtil.validateGeneralFiles(files);
      if (!validationResult['valid']) {
        return {
          'success': false,
          'message': validationResult['message'],
          'resultState': 'FAIL',
        };
      }
      
      final uri = Uri.parse(AppConfig.getFileReadWriteUrl('/fileupload.do'));


      var request = http.MultipartRequest('POST', uri);
      request.fields['uuid'] = uuid;
      
      // 여러 파일 추가 (단일 파일도 List로 처리)
      for (File file in files) {
        request.files.add(await http.MultipartFile.fromPath('files', file.path));
      }

      final response = await client.send(request).timeout(const Duration(minutes: 10));
      final responseBody = await response.stream.bytesToString();


      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody) as Map<String, dynamic>;
        final resultState = jsonResponse['resultState'] ?? 'UNKNOWN';
        
        // 단일 파일인 경우 기존 형식과 호환
        if (files.length == 1 && jsonResponse.containsKey('fileVO')) {
          final fileVO = jsonResponse['fileVO'] as Map<String, dynamic>?;
          
          if (fileVO == null) {
            return {
              'success': false,
              'message': '업로드 응답에 fileVO가 없습니다.',
              'data': jsonResponse,
            };
          }
          
          final fileSnValue = fileVO['fileSn']?.toString();
          final fileStreCoursValue = fileVO['fileStreCours']?.toString() ?? '';
          final fileExtsnValue = fileVO['fileExtsn']?.toString() ?? '';
          final fileSizeValue = fileVO['fileSize']?.toString() ?? '';
          final orignlFileNmValue = fileVO['orignlFileNm']?.toString() ?? files[0].path.split('/').last;

          if (fileSnValue == null || fileSnValue.isEmpty) {
            return {
              'success': false,
              'message': '업로드 응답에 fileSn이 없습니다.',
              'data': jsonResponse,
            };
          }
          

          final insertResult = await insertFileReaderWriteInfo(
            uuid: uuid,
            fileSn: fileSnValue,
            fileNm: orignlFileNmValue,
            fileCours: fileStreCoursValue,
            fileType: fileExtsnValue,
            fileSize: fileSizeValue,
            useYn: 'Y',
            fileStreCours: fileStreCoursValue,
          );

          final isInsertSuccess = insertResult['success'] == true;

          return {
            'success': isInsertSuccess,
            'resultState': jsonResponse['resultState'] ?? (isInsertSuccess ? 'SUCCESS' : 'FAIL'),
            'resultMessage': insertResult['resultMessage'] ??
                jsonResponse['resultMessage'] ??
                (isInsertSuccess ? '등록 성공' : '등록 실패'),
            'message': insertResult['message'] ??
                jsonResponse['resultMessage'] ??
                (isInsertSuccess ? '등록 성공' : '등록 실패'),
            'data': {
              'upload': jsonResponse,
              'insert': insertResult,
            },
          };
        }
        
        // 여러 파일인 경우
        final fileResults = jsonResponse['fileResults'] as List<dynamic>? ?? [];
        List<Map<String, dynamic>> processedFiles = [];
        
        for (var fileResult in fileResults) {
          final fileResultMap = fileResult as Map<String, dynamic>;
          final fileSnValue = fileResultMap['fileSn']?.toString();
          
          if (fileSnValue != null && fileSnValue.isNotEmpty) {
            final insertResult = await insertFileReaderWriteInfo(
              uuid: uuid,
              fileSn: fileSnValue,
              fileNm: fileResultMap['fileName']?.toString() ?? '',
              fileCours: '',
              fileType: fileResultMap['fileExtsn']?.toString() ?? '',
              fileSize: fileResultMap['fileSize']?.toString() ?? '',
              useYn: 'Y',
              fileStreCours: '',
            );
            
            processedFiles.add({
              'fileSn': fileSnValue,
              'fileName': fileResultMap['fileName'],
              'insertSuccess': insertResult['success'] == true,
            });
          }
        }
        
        return {
          'success': resultState == 'OK',
          'resultState': resultState,
          'totalFiles': jsonResponse['totalFiles'] ?? files.length,
          'fileResults': processedFiles,
          'resultMessage': jsonResponse['resultMessage'] ?? '업로드 완료',
          'data': jsonResponse,
        };
      } else {
        return {
          'success': false,
          'message': '서버 연결 실패 (상태 코드: ${response.statusCode})',
        };
      }
    } catch (e) {
      AppLogger.e('오류', e);
      return {
        'success': false,
        'message': '오류가 발생했습니다: $e',
      };
    } finally {
      client.close();
    }
  }

  /// 파일 다운로드
  static Future<File?> downloadFile({
    required String uuid, 
    required int fileSn, 
    required String fileName,
    required String savePath,
  }) async {
    try {
      final uri = Uri.parse(AppConfig.getFileReadWriteUrl('/fileDownload.do'))
          .replace(queryParameters: {
            'uuid': uuid,
            'fileSn': fileSn.toString(),
          });


      final response = await http.get(uri).timeout(const Duration(seconds: 30));


      if (response.statusCode == 200) {
        // 파일 저장
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        
        return file;
      } else {
        return null;
      }
    } catch (e) {
      AppLogger.e('오류', e);
      return null;
    }
  }

  /// 서버 파일 삭제
  static Future<bool> deleteServerFile({
    required int sn,
    required String uuid,
  }) async {
    try {
      final uri = Uri.parse(AppConfig.getFileReadWriteUrl('/deleteFileReaderWriterInfo.do'))
          .replace(queryParameters: {
            'sn': sn.toString(),
            'uuid': uuid,
          });


      final response = await http.delete(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        final resultState = jsonResponse['resultState'];
        
        if (resultState == 'OK') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      AppLogger.e('오류', e);
      return false;
    }
  }
}

/// 파일 정보를 담는 데이터 클래스
class LocalFileInfo {
  final String name;
  final String path;
  final int size;
  final DateTime lastModified;

  LocalFileInfo({
    required this.name,
    required this.path,
    required this.size,
    required this.lastModified,
  });

  /// 파일 크기를 사람이 읽기 쉬운 형태로 반환
  String get formattedSize => FormatUtils.formatFileSize(size);

  /// 수정 날짜를 문자열로 반환
  String get formattedDate => FormatUtils.formatDateTime(lastModified);

  /// JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'size': size,
      'lastModified': lastModified.toIso8601String(),
    };
  }

  /// JSON으로부터 LocalFileInfo를 생성하는 팩토리 메서드
  factory LocalFileInfo.fromJson(Map<String, dynamic> json) {
    return LocalFileInfo(
      name: json['name'],
      path: json['path'],
      size: json['size'],
      lastModified: DateTime.parse(json['lastModified']),
    );
  }

}
