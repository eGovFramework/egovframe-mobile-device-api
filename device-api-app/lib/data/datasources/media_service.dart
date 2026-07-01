import 'dart:convert';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/file_validation_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  static final ImagePicker _picker = ImagePicker();

  /// 이미지를 선택하고 저장하는 메서드
  static Future<XFile?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return image;
      } else {
        return null;
      }
    } catch (e) {
      AppLogger.e('오류', e);
      // 일반 예외도 다시 throw
      rethrow;
    }
  }

  /// 비디오를 선택하는 메서드
  static Future<XFile?> pickVideo(ImageSource source) async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        return video;
      } else {
        return null;
      }
    } catch (e) {
      AppLogger.e('오류', e);
      // 일반 예외도 다시 throw
      rethrow;
    }
  }

  /// 이미지 파일을 저장하는 메서드
  static Future<String?> saveImageFile(XFile imageFile, String fileName) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${documentsDir.path}/media');

      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }

      final savedPath = '${mediaDir.path}/$fileName';
      await imageFile.saveTo(savedPath);

      return savedPath;
    } catch (e) {
      AppLogger.e('오류', e);
      return null;
    }
  }

  /// 비디오 파일을 저장하는 메서드
  static Future<String?> saveVideoFile(XFile videoFile, String fileName) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${documentsDir.path}/media');

      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }

      final savedPath = '${mediaDir.path}/$fileName';
      await videoFile.saveTo(savedPath);

      return savedPath;
    } catch (e) {
      AppLogger.e('오류', e);
      return null;
    }
  }

  /// 저장된 미디어 파일 목록을 가져오는 메서드
  static Future<List<MediaFileInfo>> getSavedMediaFiles() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${documentsDir.path}/media');


      if (!await mediaDir.exists()) {
        return [];
      }

      final entities = await mediaDir.list().toList();
      final files = entities.whereType<File>().toList();

      List<MediaFileInfo> mediaFiles = [];
      for (File file in files) {
        final stat = await file.stat();
        final extension = file.path.split('.').last.toLowerCase();

        MediaType type = MediaType.unknown;
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
          type = MediaType.image;
        } else if ([
          'mp4',
          'avi',
          'mov',
          'wmv',
          'flv',
          'webm',
        ].contains(extension)) {
          type = MediaType.video;
        } else if (['mp3', 'wav', 'aac', 'ogg', 'm4a'].contains(extension)) {
          type = MediaType.audio;
        }

        final fileName = file.path.split('/').last;

        mediaFiles.add(
          MediaFileInfo(
            name: fileName,
            path: file.path,
            size: stat.size,
            type: type,
            lastModified: stat.modified,
            serverSn: null,
            orignlFileNm: fileName,
            fileStreCours: file.path,
          ),
        );
      }

      // 최신순으로 정렬
      mediaFiles.sort((a, b) => b.lastModified.compareTo(a.lastModified));

      return mediaFiles;
    } catch (e) {
      AppLogger.e('오류', e);
      return [];
    }
  }

  // 미디어 파일을 서버에 저장하는 메서드
  // 서버 API: POST  /mda/insertMediaInfo.do
  static Future<Map<String, dynamic>> insertMediaInfo({
    required String sn,
    required String uuid,
    required String fileSn,
    required String mdSj,
  }) async {
    final uri = Uri.parse(AppConfig.getMediaUrl('/insertMediaInfo.do'));
    try {

      final response = await http
          .post(
            uri,
            body: {'sn': sn, 'uuid': uuid, 'fileSn': fileSn, 'mdSj': mdSj},
          )
          .timeout(const Duration(seconds: 30));


      if (response.statusCode == 200) {
        try {
          final jsonResponse =
              json.decode(response.body) as Map<String, dynamic>;
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
    } catch (e) {
      AppLogger.e('오류', e);
      return {'success': false, 'message': '오류가 발생했습니다: $e'};
    }
  }

  /// 미디어 파일을 서버에 업로드하는 메서드 
  static Future<Map<String, dynamic>> uploadMediaToServer({
    required List<File> files,
    required String uuid,
    required int startSn,
  }) async {
    final client = http.Client();
    try {
      // 미디어 파일 확장자 검증
      final validationResult = await FileValidationUtil.validateMediaFiles(
        files,
      );
      if (!validationResult['valid']) {
        return {
          'success': false,
          'message': validationResult['message'],
          'resultState': 'FAIL',
        };
      }

      final uri = Uri.parse(AppConfig.getMediaUrl('/uploadMediaFile.do'));


      var request = http.MultipartRequest('POST', uri);
      request.fields['uuid'] = uuid;
      request.fields['startSn'] = startSn.toString();

      // 여러 파일 추가 (단일 파일도 List로 처리)
      for (File file in files) {
        request.files.add(
          await http.MultipartFile.fromPath('files', file.path),
        );
      }

      final response = await client
          .send(request)
          .timeout(const Duration(minutes: 10));
      final responseBody = await response.stream.bytesToString();


      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody) as Map<String, dynamic>;
        final resultState = jsonResponse['resultState'] ?? 'UNKNOWN';

        // 단일 파일인 경우
        if (files.length == 1 && jsonResponse.containsKey('fileSn')) {
          String? fileSn = jsonResponse['fileSn']?.toString();
          return {
            'success': resultState == 'OK',
            'resultState': resultState,
            'resultMessage': jsonResponse['resultMessage'] ?? '업로드 성공',
            'fileSn': fileSn != null ? int.tryParse(fileSn) : null,
            'totalFiles': 1,
            'successCount': resultState == 'OK' ? 1 : 0,
            'failCount': resultState == 'OK' ? 0 : 1,
            'data': jsonResponse,
          };
        }

        // 여러 파일인 경우
        return {
          'success': resultState == 'OK' || resultState == 'PARTIAL',
          'resultState': resultState,
          'totalFiles': jsonResponse['totalFiles'] ?? files.length,
          'successCount': jsonResponse['successCount'] ?? 0,
          'failCount': jsonResponse['failCount'] ?? 0,
          'fileResults': jsonResponse['fileResults'] ?? [],
          'resultMessage':
              jsonResponse['resultMessage'] ??
              (resultState == 'OK'
                  ? '모든 파일 업로드 성공'
                  : resultState == 'PARTIAL'
                  ? '일부 파일 업로드 성공'
                  : '업로드 실패'),
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
      return {'success': false, 'message': '오류가 발생했습니다: $e'};
    } finally {
      client.close();
    }
  }

  /// 미디어 파일 다운로드 URL을 반환하는 메서드
  static String getMediaDownloadUrl(int fileSn, String uuid) {
    return Uri.parse(AppConfig.getMediaUrl('/downloadMediaFile.do'))
        .replace(queryParameters: {
          'fileSn': fileSn.toString(),
          'uuid': uuid,
        })
        .toString();
  }

  /// 이미지를 선택하고 서버에 업로드하는 통합 메서드
  static Future<Map<String, dynamic>> pickAndUploadImage({
    required String uuid,
    required int sn,
    required ImageSource source,
  }) async {
    try {
      final XFile? imageFile = await pickImage(source);
      if (imageFile == null) {
        return {'success': false, 'message': '이미지 선택이 취소되었습니다.'};
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = await saveImageFile(imageFile, fileName);
      if (savedPath == null) {
        return {'success': false, 'message': '이미지 저장에 실패했습니다.'};
      }

      final uploadResult = await uploadMediaToServer(
        files: [File(savedPath)],
        uuid: uuid,
        startSn: sn,
      );

      return uploadResult;
    } catch (e) {
      AppLogger.e('오류', e);
      return {'success': false, 'message': '오류가 발생했습니다: $e'};
    }
  }

  /// 비디오를 선택하고 서버에 업로드하는 통합 메서드
  static Future<Map<String, dynamic>> pickAndUploadVideo({
    required String uuid,
    required int sn,
    required ImageSource source,
  }) async {
    try {
      final XFile? videoFile = await pickVideo(source);
      if (videoFile == null) {
        return {'success': false, 'message': '비디오 선택이 취소되었습니다.'};
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      final savedPath = await saveVideoFile(videoFile, fileName);
      if (savedPath == null) {
        return {'success': false, 'message': '비디오 저장에 실패했습니다.'};
      }

      final uploadResult = await uploadMediaToServer(
        files: [File(savedPath)],
        uuid: uuid,
        startSn: sn,
      );

      return uploadResult;
    } catch (e) {
      AppLogger.e('오류', e);
      return {'success': false, 'message': '오류가 발생했습니다: $e'};
    }
  }

  /// 서버에서 미디어를 삭제하는 메서드
  static Future<Map<String, dynamic>> deleteMediaFromServer(int sn, String uuid) async {
    try {
      final uri = Uri.parse(AppConfig.getMediaUrl('/deleteMediaInfo.do'))
          .replace(queryParameters: {
            'sn': sn.toString(),
            'uuid': uuid,
          });


      final response = await http.delete(uri);


      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return {
          'success': true,
          'resultState': jsonResponse['resultState'] ?? 'SUCCESS',
          'resultMessage': jsonResponse['resultMessage'] ?? '삭제 성공',
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
      return {'success': false, 'message': '오류가 발생했습니다: $e'};
    }
  }

  // 미디어 파일을 삭제하는 메서드
  static Future<bool> deleteMediaFile(String filePath) async {
    try {
      // 서버 파일인 경우 서버에서 삭제 처리
      if (filePath.startsWith('server://')) {
        final sn = int.tryParse(filePath.replaceFirst('server://', ''));
        if (sn != null) {
          final uuid = await DeviceIdService.getDeviceId();
          final result = await deleteMediaFromServer(sn, uuid);
          if (result['success']) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }

      // 로컬 파일인 경우 로컬에서 삭제
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

  /// 로컬 미디어 파일 목록을 가져오는 메서드
  static Future<List<MediaFileInfo>> getLocalMediaList(String uuid) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${documentsDir.path}/media');

      if (!await mediaDir.exists()) {
        return [];
      }

      final files = await mediaDir.list().toList();
      final mediaFiles = <MediaFileInfo>[];

      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          final fileName = file.path.split('/').last;
          final fileExtension = fileName.split('.').last.toLowerCase();
          final mediaType = _getMediaTypeFromString(fileExtension);

          mediaFiles.add(
            MediaFileInfo(
              name: fileName,
              path: file.path,
              type: mediaType,
              size: stat.size,
              lastModified: stat.modified,
              serverSn: null, // 로컬 파일이므로 서버 SN 없음
            ),
          );
        }
      }

      return mediaFiles;
    } catch (e) {
      AppLogger.e('오류', e);
      return [];
    }
  }

  /// 서버 미디어 파일 목록을 가져오는 메서드
  static Future<List<MediaFileInfo>> getServerMediaList(String uuid) async {
    try {
      final uri = Uri.parse(
        AppConfig.getMediaUrl('/selectMediaInfoList.do'),
      ).replace(queryParameters: {'uuid': uuid});


      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final resultState = jsonResponse['resultState'];

        if (resultState == 'OK') {
          final mediaListData = jsonResponse['mediaInfoList'];
          if (mediaListData == null) {
            return [];
          }

          if (mediaListData is! List) {
            return [];
          }

          final data = mediaListData;
          final mediaFiles = <MediaFileInfo>[];

          for (final item in data) {
            try {
              final mediaFile = MediaFileInfo.fromServerApi(
                item as Map<String, dynamic>,
              );
              mediaFiles.add(mediaFile);
            } catch (e) {
              AppLogger.e('오류', e);
              continue;
            }
          }

          return mediaFiles;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      AppLogger.e('오류', e);
      return [];
    }
  }

  /// 서버에서 미디어 파일을 다운로드하는 메서드
  static Future<Map<String, dynamic>> downloadMedia(
    int fileSn,
    String fileName,
    String uuid,
    Function(double) onProgress,
  ) async {
    try {
      final downloadUrl = getMediaDownloadUrl(fileSn, uuid);
      final uri = Uri.parse(downloadUrl);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        onProgress(0.5);

        // 파일 저장
        final documentsDir = await getApplicationDocumentsDirectory();
        final mediaDir = Directory('${documentsDir.path}/media');

        if (!await mediaDir.exists()) {
          await mediaDir.create(recursive: true);
        }

        final file = File('${mediaDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        onProgress(1.0);

        return {'success': true, 'message': '다운로드 성공', 'filePath': file.path};
      } else {
        return {
          'success': false,
          'message': '다운로드 실패 (상태 코드: ${response.statusCode})',
        };
      }
    } catch (e) {
      AppLogger.e('오류', e);
      return {'success': false, 'message': '다운로드 중 오류가 발생했습니다: $e'};
    }
  }

  /// 파일 타입 문자열을 MediaType으로 변환하는 헬퍼 메서드
  static MediaType _getMediaTypeFromString(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return MediaType.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
      case 'flv':
      case 'webm':
        return MediaType.video;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'ogg':
      case 'm4a':
        return MediaType.audio;
      default:
        return MediaType.image; // 기본값
    }
  }
}
