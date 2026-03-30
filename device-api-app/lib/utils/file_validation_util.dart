import 'dart:io';

/// 파일 검증 유틸리티 클래스
/// 클라이언트 측 사전 검증을 위한 유틸리티 (UX 개선용)
/// 실제 보안 검증은 서버에서 수행되므로, 클라이언트 검증은 선택사항입니다.
class FileValidationUtil {
  // 파일 크기 제한 (20MB - 서버 설정과 동일)
  static const int maxFileSize = 20 * 1024 * 1024;

  // 위험한 파일 확장자 목록
  static const List<String> dangerousExtensions = [
    '.exe', '.bat', '.cmd', '.com', '.pif', '.scr', '.vbs', '.js',
    '.jsp', '.jspx', '.php', '.php3', '.php4', '.php5', '.phtml',
    '.asp', '.aspx', '.ashx', '.asmx', '.sh', '.bash', '.csh', '.ksh',
    '.pl', '.py', '.rb', '.jar', '.war', '.ear', '.dll', '.so',
    '.dylib', '.class', '.action', '.do', '.htaccess', '.htpasswd'
  ];

  // 허용된 미디어 파일 확장자 목록
  static const List<String> allowedMediaExtensions = [
    '.mp3', '.wav', '.aac', '.mp4', '.avi', '.mov',
    '.wmv', '.flv', '.mkv', '.jpg', '.jpeg', '.png'
  ];

  /// 파일 확장자 추출
  static String getFileExtension(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');
    return lastDotIndex >= 0
        ? fileName.substring(lastDotIndex).toLowerCase()
        : '';
  }

  /// 위험한 파일 확장자 검증
  static bool isDangerousFile(String fileName) {
    final extension = getFileExtension(fileName);
    return dangerousExtensions.contains(extension);
  }

  /// 미디어 파일 확장자 검증
  static bool isValidMediaFile(String fileName) {
    final extension = getFileExtension(fileName);
    return allowedMediaExtensions.contains(extension);
  }

  /// 파일 크기 검증
  static Future<bool> isValidFileSize(File file) async {
    final fileSize = await file.length();
    return fileSize <= maxFileSize;
  }

  /// 미디어 파일 업로드 전 검증
  /// 
  /// [fileName] 파일명
  /// [file] 파일 객체
  /// 
  /// Returns: 검증 결과 Map
  /// - 'valid': bool - 검증 통과 여부
  /// - 'message': String? - 오류 메시지 (검증 실패 시)
  static Future<Map<String, dynamic>> validateMediaFile(
    String fileName,
    File file,
  ) async {
    // 위험한 확장자 차단
    if (isDangerousFile(fileName)) {
      return {
        'valid': false,
        'message': '위험한 파일 확장자는 업로드할 수 없습니다: $fileName',
      };
    }

    // 파일 크기 검증
    if (!await isValidFileSize(file)) {
      final fileSize = await file.length();
      return {
        'valid': false,
        'message': '파일 크기는 20MB를 초과할 수 없습니다: $fileName '
            '(${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB)',
      };
    }

    // 미디어 파일 확장자 검증
    if (!isValidMediaFile(fileName)) {
      return {
        'valid': false,
        'message': '미디어 파일만 업로드 가능합니다: $fileName '
            '(허용 확장자: ${allowedMediaExtensions.join(', ')})',
      };
    }

    return {'valid': true};
  }

  /// 일반 파일 업로드 전 검증 (미디어 확장자 제한 없음)
  /// 
  /// [fileName] 파일명
  /// [file] 파일 객체
  /// 
  /// Returns: 검증 결과 Map
  /// - 'valid': bool - 검증 통과 여부
  /// - 'message': String? - 오류 메시지 (검증 실패 시)
  static Future<Map<String, dynamic>> validateGeneralFile(
    String fileName,
    File file,
  ) async {
    // 위험한 확장자 차단
    if (isDangerousFile(fileName)) {
      return {
        'valid': false,
        'message': '위험한 파일 확장자는 업로드할 수 없습니다: $fileName',
      };
    }

    // 파일 크기 검증
    if (!await isValidFileSize(file)) {
      final fileSize = await file.length();
      return {
        'valid': false,
        'message': '파일 크기는 20MB를 초과할 수 없습니다: $fileName '
            '(${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB)',
      };
    }

    return {'valid': true};
  }

  /// 여러 파일 일괄 검증 (미디어 파일)
  static Future<Map<String, dynamic>> validateMediaFiles(
    List<File> files,
  ) async {
    for (File file in files) {
      final fileName = file.path.split('/').last;
      final result = await validateMediaFile(fileName, file);
      if (!result['valid']) {
        return {
          'valid': false,
          'message': result['message'],
        };
      }
    }
    return {'valid': true};
  }

  /// 여러 파일 일괄 검증 (일반 파일)
  static Future<Map<String, dynamic>> validateGeneralFiles(
    List<File> files,
  ) async {
    for (File file in files) {
      final fileName = file.path.split('/').last;
      final result = await validateGeneralFile(fileName, file);
      if (!result['valid']) {
        return {
          'valid': false,
          'message': result['message'],
        };
      }
    }
    return {'valid': true};
  }
}
