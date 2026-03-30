import '../../utils/format_utils.dart';

String _mimeTypeFromExtension(String extension) {
  final ext = extension.toLowerCase();
  switch (ext) {
    case 'pdf':
      return 'application/pdf';
    case 'doc':
      return 'application/msword';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    case 'xls':
      return 'application/vnd.ms-excel';
    case 'xlsx':
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    case 'ppt':
      return 'application/vnd.ms-powerpoint';
    case 'pptx':
      return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    case 'txt':
      return 'text/plain';
    case 'rtf':
      return 'application/rtf';
    case 'odt':
      return 'application/vnd.oasis.opendocument.text';
    case 'ods':
      return 'application/vnd.oasis.opendocument.spreadsheet';
    case 'odp':
      return 'application/vnd.oasis.opendocument.presentation';
    case 'hwp':
      return 'application/x-hwp';
    default:
      return 'application/octet-stream';
  }
}

FileType _fileTypeFromExtension(String extension) {
  final ext = extension.toLowerCase();
  if (['pdf'].contains(ext)) {
    return FileType.document;
  } else if (['doc', 'docx', 'txt', 'rtf', 'odt', 'hwp'].contains(ext)) {
    return FileType.text;
  } else if (['xls', 'xlsx', 'ods'].contains(ext)) {
    return FileType.spreadsheet;
  } else if (['ppt', 'pptx', 'odp'].contains(ext)) {
    return FileType.presentation;
  } else {
    return FileType.other;
  }
}

class FileOpenerInfo {
  final String fileName;
  final String filePath;
  final String fileExtension;
  final String mimeType;
  final int fileSize;
  final DateTime lastModified;
  final bool isLocalFile;
  final String? downloadUrl;

  FileOpenerInfo({
    required this.fileName,
    required this.filePath,
    required this.fileExtension,
    required this.mimeType,
    required this.fileSize,
    required this.lastModified,
    this.isLocalFile = true,
    this.downloadUrl,
  });

  /// 파일 확장자로부터 MIME 타입을 추정
  static String getMimeTypeFromExtension(String extension) => _mimeTypeFromExtension(extension);

  /// 파일 확장자로부터 파일 타입을 분류
  static FileType getFileTypeFromExtension(String extension) => _fileTypeFromExtension(extension);

  /// 파일 타입을 반환
  FileType get fileType => getFileTypeFromExtension(fileExtension);

  /// 파일 크기를 포맷된 문자열로 반환
  String get formattedFileSize => FormatUtils.formatFileSize(fileSize);

  /// 수정 날짜를 포맷된 문자열로 반환
  String get formattedLastModified => FormatUtils.formatDateTime(lastModified);

  /// 파일이 열 수 있는지 확인하는 메서드
  bool get canOpen {
    return fileType == FileType.document ||
        fileType == FileType.text ||
        fileType == FileType.spreadsheet ||
        fileType == FileType.presentation;
  }

  /// JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'filePath': filePath,
      'fileExtension': fileExtension,
      'mimeType': mimeType,
      'fileSize': fileSize,
      'lastModified': lastModified.toIso8601String(),
      'isLocalFile': isLocalFile,
      'downloadUrl': downloadUrl,
    };
  }

  /// JSON으로부터 FileOpenerInfo를 생성하는 팩토리 메서드
  factory FileOpenerInfo.fromJson(Map<String, dynamic> json) {
    return FileOpenerInfo(
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'] ?? '',
      fileExtension: json['fileExtension'] ?? '',
      mimeType: json['mimeType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      lastModified: DateTime.parse(json['lastModified'] ?? DateTime.now().toIso8601String()),
      isLocalFile: json['isLocalFile'] ?? true,
      downloadUrl: json['downloadUrl'],
    );
  }

  @override
  String toString() {
    return 'FileOpenerInfo(fileName: $fileName, filePath: $filePath, fileExtension: $fileExtension, mimeType: $mimeType, fileSize: $fileSize, lastModified: $lastModified, isLocalFile: $isLocalFile, downloadUrl: $downloadUrl)';
  }
}

/// 파일 타입 열거형
enum FileType {
  document,    // PDF
  text,        // DOC, DOCX, TXT, RTF, ODT
  spreadsheet, // XLS, XLSX, ODS
  presentation,// PPT, PPTX, ODP
  other,       // 기타
}

/// 파일 타입별 한글 이름을 반환하는 확장 메서드
extension FileTypeExtension on FileType {
  String get displayName {
    switch (this) {
      case FileType.document:
        return '문서';
      case FileType.text:
        return '텍스트';
      case FileType.spreadsheet:
        return '스프레드시트';
      case FileType.presentation:
        return '프레젠테이션';
      case FileType.other:
        return '기타';
    }
  }

  String get iconName {
    switch (this) {
      case FileType.document:
        return 'description';
      case FileType.text:
        return 'article';
      case FileType.spreadsheet:
        return 'table_chart';
      case FileType.presentation:
        return 'slideshow';
      case FileType.other:
        return 'insert_drive_file';
    }
  }
}

/// 서버 파일 정보를 담는 데이터 클래스
class ServerFileInfo {
  final String fileSn;              // 일련번호
  final String streFileNm;      // 저장파일명
  final String orignlFileNm;    // 원파일명
  final String updDt;           // 업데이트날짜
  final String fileSize;        // 파일크기

  ServerFileInfo({
    required this.fileSn,
    required this.streFileNm,
    required this.orignlFileNm,
    required this.updDt,
    required this.fileSize,
  });

  /// JSON으로부터 ServerFileInfo를 생성
  factory ServerFileInfo.fromJson(Map<String, dynamic> json) {
    return ServerFileInfo(
      fileSn: json['fileSn']?.toString() ?? '',
      streFileNm: json['streFileNm']?.toString() ?? '',
      orignlFileNm: json['orignlFileNm']?.toString() ?? '',
      updDt: json['updDt']?.toString() ?? '',
      fileSize: json['fileSize']?.toString() ?? '0',
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'fileSn': fileSn,
      'streFileNm': streFileNm,
      'orignlFileNm': orignlFileNm,
      'updDt': updDt,
      'fileSize': fileSize,
    };
  }

  /// 파일 확장자를 반환
  String get fileExtension {
    final parts = orignlFileNm.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  /// 파일 크기를 바이트 단위로 반환
  int get fileSizeInBytes {
    try {
      return int.parse(fileSize);
    } catch (e) {
      return 0;
    }
  }

  /// 파일 크기를 포맷된 문자열로 반환
  String get formattedFileSize => FormatUtils.formatFileSize(fileSizeInBytes);

  DateTime? get updateDateTime {
    try {
      return DateTime.parse(updDt);
    } catch (e) {
      return null;
    }
  }

  /// 포맷된 업데이트 날짜 문자열 반환
  String get formattedUpdateDate {
    final dateTime = updateDateTime;
    return dateTime != null ? FormatUtils.formatDateTime(dateTime) : updDt;
  }

  /// MIME 타입을 반환
  String get mimeType {
    return _mimeTypeFromExtension(fileExtension);
  }

  /// 파일 타입을 반환
  FileType get fileType {
    return _fileTypeFromExtension(fileExtension);
  }

  

  @override
  String toString() {
    return 'ServerFileInfo(fileSn: $fileSn, streFileNm: $streFileNm, orignlFileNm: $orignlFileNm, updDt: $updDt, fileSize: $fileSize)';
  }
}

class ServerFileListResponse {
  final List<ServerFileInfo> resultSet;
  final String resultState;

  ServerFileListResponse({
    required this.resultSet,
    required this.resultState,
  });

  factory ServerFileListResponse.fromJson(Map<String, dynamic> json) {
    final resultSetData = json['resultSet'] as List<dynamic>? ?? [];
    final resultSet = resultSetData
        .map((item) => ServerFileInfo.fromJson(item as Map<String, dynamic>))
        .toList();

    return ServerFileListResponse(
      resultSet: resultSet,
      resultState: json['resultState']?.toString() ?? 'ERROR',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultSet': resultSet.map((item) => item.toJson()).toList(),
      'resultState': resultState,
    };
  }

  bool get isSuccess => resultState == 'OK';
}

