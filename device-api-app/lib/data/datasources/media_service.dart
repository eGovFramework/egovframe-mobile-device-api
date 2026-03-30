import 'dart:convert';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/file_validation_util.dart';
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
        print('이미지 선택 성공: ${image.path}');
        return image;
      } else {
        print('이미지 선택 취소됨');
        return null;
      }
    } catch (e) {
      print('이미지 선택 실패: $e');
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
        print('비디오 선택 성공: ${video.path}');
        return video;
      } else {
        print('비디오 선택 취소됨');
        return null;
      }
    } catch (e) {
      print('비디오 선택 실패: $e');
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

      print('이미지 저장 성공: $savedPath');
      return savedPath;
    } catch (e) {
      print('이미지 저장 실패: $e');
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

      print('비디오 저장 성공: $savedPath');
      return savedPath;
    } catch (e) {
      print('비디오 저장 실패: $e');
      return null;
    }
  }

  /// 저장된 미디어 파일 목록을 가져오는 메서드
  static Future<List<MediaFileInfo>> getSavedMediaFiles() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${documentsDir.path}/media');

      print('=== 로컬 미디어 파일 경로 정보 ===');
      print('Documents Directory: ${documentsDir.path}');
      print('Media Directory: ${mediaDir.path}');
      print('Media Directory 존재 여부: ${await mediaDir.exists()}');

      if (!await mediaDir.exists()) {
        print('미디어 디렉토리가 존재하지 않습니다.');
        return [];
      }

      final entities = await mediaDir.list().toList();
      final files = entities.whereType<File>().toList();

      print('미디어 디렉토리 내 파일 개수: ${files.length}');
      for (File file in files) {
        print('발견된 파일: ${file.path}');
      }

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
        print(
          '로컬 파일 처리: $fileName (경로: ${file.path}, 크기: ${stat.size}, 타입: $type)',
        );

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

      // print('로컬 미디어 파일 ${mediaFiles.length}개 조회 완료');
      return mediaFiles;
    } catch (e) {
      print('로컬 미디어 파일 조회 실패: $e');
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
      print('미디어 정보 저장 API Request URL: $uri');
      print(
        '미디어 정보 저장 API Request Body: sn=$sn, uuid=$uuid, fileSn=$fileSn, mdSj=$mdSj',
      );

      final response = await http
          .post(
            uri,
            body: {'sn': sn, 'uuid': uuid, 'fileSn': fileSn, 'mdSj': mdSj},
          )
          .timeout(const Duration(seconds: 30));

      print('미디어 정보 저장 API Response Status: ${response.statusCode}');
      print('미디어 정보 저장 API Response Body: ${response.body}');

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
      print('미디어 정보 서버에 저장 실패: $e');
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

      print('미디어 업로드 API Request URL: $uri');
      print(
        '미디어 업로드 API Request - UUID: $uuid, StartSN: $startSn, FileCount: ${files.length}',
      );

      var request = http.MultipartRequest('POST', uri);
      request.fields['uuid'] = uuid;
      request.fields['startSn'] = startSn.toString();

      // 여러 파일 추가 (단일 파일도 List로 처리)
      for (File file in files) {
        final fileName = file.path.split('/').last;
        request.files.add(
          await http.MultipartFile.fromPath('files', file.path),
        );
        print('파일 추가: $fileName');
      }

      final response = await client
          .send(request)
          .timeout(const Duration(minutes: 10));
      final responseBody = await response.stream.bytesToString();

      print('미디어 업로드 API Response Status: ${response.statusCode}');
      print('미디어 업로드 API Response Body: $responseBody');

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
      print('미디어 업로드 API Error: $e');
      return {'success': false, 'message': '오류가 발생했습니다: $e'};
    } finally {
      client.close();
    }
  }

  /// 미디어 파일 다운로드 URL을 반환하는 메서드
  static String getMediaDownloadUrl(int fileSn) {
    return Uri.parse(AppConfig.getMediaUrl('/downloadMediaFile.do'))
        .replace(queryParameters: {'fileSn': fileSn.toString()})
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
      print('이미지 선택 및 업로드 실패: $e');
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
      print('비디오 선택 및 업로드 실패: $e');
      return {'success': false, 'message': '오류가 발생했습니다: $e'};
    }
  }

  /// 서버에서 미디어를 삭제하는 메서드
  static Future<Map<String, dynamic>> deleteMediaFromServer(int sn) async {
    try {
      final uri = Uri.parse(AppConfig.getMediaUrl('/deleteMediaInfo.do'))
          .replace(queryParameters: {'sn': sn.toString()});

      print('=== 미디어 삭제 API 요청 시작 ===');
      print('미디어 삭제 API Request URL: $uri');
      print('미디어 삭제 API Request - SN: $sn');

      final response = await http.delete(uri);

      print('미디어 삭제 API Response Status: ${response.statusCode}');
      print('미디어 삭제 API Response Body: ${response.body}');

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
      print('미디어 삭제 API Error: $e');
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
          final result = await deleteMediaFromServer(sn);
          if (result['success']) {
            print('서버 미디어 삭제 성공: SN=$sn');
            return true;
          } else {
            print('서버 미디어 삭제 실패: ${result['message']}');
            return false;
          }
        } else {
          print('잘못된 서버 파일 경로: $filePath');
          return false;
        }
      }

      // 로컬 파일인 경우 로컬에서 삭제
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print('로컬 미디어 파일 삭제 성공: $filePath');
        return true;
      } else {
        print('삭제할 파일이 존재하지 않습니다: $filePath');
        return false;
      }
    } catch (e) {
      print('미디어 파일 삭제 실패: $e');
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
      print('로컬 미디어 목록 조회 실패: $e');
      return [];
    }
  }

  /// 서버 미디어 파일 목록을 가져오는 메서드
  static Future<List<MediaFileInfo>> getServerMediaList(String uuid) async {
    try {
      final uri = Uri.parse(
        AppConfig.getMediaUrl('/selectMediaInfoList.do'),
      ).replace(queryParameters: {'uuid': uuid});

      print('서버 미디어 목록 요청: $uri');

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final resultState = jsonResponse['resultState'];

        if (resultState == 'OK') {
          final mediaListData = jsonResponse['mediaInfoList'];
          if (mediaListData == null) {
            print('서버 미디어 목록이 비어있습니다 (null)');
            return [];
          }

          if (mediaListData is! List) {
            print(
              '서버 응답 형식 오류: mediaInfoList가 List가 아닙니다. 타입: ${mediaListData.runtimeType}',
            );
            return [];
          }

          final data = mediaListData;
          final mediaFiles = <MediaFileInfo>[];

          for (final item in data) {
            try {
              print('서버 응답 데이터: $item');
              final mediaFile = MediaFileInfo.fromServerApi(
                item as Map<String, dynamic>,
              );
              print(
                '변환된 MediaFileInfo: name=${mediaFile.name}, size=${mediaFile.size}, fileExtsn=${mediaFile.fileExtsn}, formattedSize=${mediaFile.formattedSize}, fileStreCours=${mediaFile.fileStreCours}',
              );
              mediaFiles.add(mediaFile);
            } catch (e) {
              print('미디어 파일 변환 오류: $e, 데이터: $item');
              continue;
            }
          }

          print('서버 미디어 목록 조회 성공: ${mediaFiles.length}개');
          return mediaFiles;
        } else {
          print('서버 미디어 목록 조회 실패: $resultState');
          return [];
        }
      } else {
        print('서버 미디어 목록 조회 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('서버 미디어 목록 조회 오류: $e');
      return [];
    }
  }

  /// 서버에서 미디어 파일을 다운로드하는 메서드
  static Future<Map<String, dynamic>> downloadMedia(
    int fileSn,
    String fileName,
    Function(double) onProgress,
  ) async {
    try {
      final downloadUrl = getMediaDownloadUrl(fileSn);
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
      print('미디어 다운로드 오류: $e');
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
