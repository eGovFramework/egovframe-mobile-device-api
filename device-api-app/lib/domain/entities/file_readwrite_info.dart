import '../../utils/format_utils.dart';

/// 파일 정보를 담는 Entity 클래스 (로컬 파일)
class FileInfo {
  final int sn;
  final int fileSn;
  final String uuid;
  final String fileName;
  final String filePath;
  final int fileSize;
  final String uploadDate;
  final String useYn;

  FileInfo({
    required this.sn,
    required this.fileSn,
    required this.uuid,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.uploadDate,
    required this.useYn,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      sn: json['sn'] ?? 0,
      fileSn: json['fileSn'] ?? 0,
      uuid: json['uuid'] ?? '',
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      uploadDate: json['uploadDate'] ?? '',
      useYn: json['useYn'] ?? 'Y',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sn': sn,
      'fileSn': fileSn,
      'uuid': uuid,
      'fileName': fileName,
      'filePath': filePath,
      'fileSize': fileSize,
      'uploadDate': uploadDate,
      'useYn': useYn,
    };
  }

  /// 파일 크기를 포맷된 문자열로 반환
  String get formattedSize => FormatUtils.formatFileSize(fileSize);

  /// 수정 날짜를 포맷된 문자열로 반환
  String get formattedDate => FormatUtils.formatDateString(uploadDate);
}

/// 서버에서 받아온 파일 정보를 담기
class FileReadWriteInfoServer {
  final int sn;
  final String uuid;
  final int fileSn;
  final String fileNm;
  final String fileType;
  final String updtDt;
  final String useYn;
  final String fileStreCours;
  final String streFileNm;
  final String orignlFileNm;
  final String fileExtsn;
  final String fileCn;
  final String fileSize;

  FileReadWriteInfoServer({
    required this.sn,
    required this.uuid,
    required this.fileSn,
    required this.fileNm,
    required this.fileType,
    required this.updtDt,
    required this.useYn,
    required this.fileStreCours,
    required this.streFileNm,
    required this.orignlFileNm,
    required this.fileExtsn,
    required this.fileCn,
    required this.fileSize,
  });

  /// JSON으로부터 FileReadWriteInfoServer를 생성
  factory FileReadWriteInfoServer.fromJson(Map<String, dynamic> json) {
    return FileReadWriteInfoServer(
      sn: int.tryParse(json['sn']?.toString() ?? '0') ?? 0,
      uuid: json['uuid']?.toString() ?? '',
      fileSn: int.tryParse(json['fileSn']?.toString() ?? '0') ?? 0,
      fileNm: json['fileNm']?.toString() ?? json['orignlFileNm']?.toString() ?? '',
      fileType: json['fileType']?.toString() ?? '',
      updtDt: json['updtDt']?.toString() ?? json['updateDate']?.toString() ?? '',
      useYn: json['useYn']?.toString() ?? json['useyn']?.toString() ?? 'Y',
      fileStreCours: json['fileStreCours']?.toString() ?? json['fileCours']?.toString() ?? '',
      streFileNm: json['streFileNm']?.toString() ?? json['fileNm']?.toString() ?? '',
      orignlFileNm: json['orignlFileNm']?.toString() ?? json['fileNm']?.toString() ?? '',
      fileExtsn: json['fileExtsn']?.toString() ?? '',
      fileCn: json['fileCn']?.toString() ?? '',
      fileSize: json['fileSize']?.toString() ?? '0',
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'sn': sn,
      'uuid': uuid,
      'fileSn': fileSn,
      'fileNm': fileNm,
      'fileType': fileType,
      'updtDt': updtDt,
      'useYn': useYn,
      'fileStreCours': fileStreCours,
      'streFileNm': streFileNm,
      'orignlFileNm': orignlFileNm,
      'fileExtsn': fileExtsn,
      'fileCn': fileCn,
      'fileSize': fileSize,
    };
  }

  /// 파일 크기를 숫자로 반환
  int get fileSizeInt {
    return int.tryParse(fileSize) ?? 0;
  }

  DateTime get updtDateTime {
    try {
      return DateTime.parse(updtDt);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// 수정 날짜를 포맷된 문자열로 반환
  String get formattedUpdtDt => FormatUtils.formatDateString(updtDt);

  /// 파일 크기를 포맷된 문자열로 반환
  String get formattedFileSize => FormatUtils.formatFileSize(fileSizeInt);

  /// formattedSize 별칭 (호환성 유지)
  String get formattedSize => formattedFileSize;

  /// formattedDate 별칭 (호환성 유지)
  String get formattedDate => formattedUpdtDt;

  @override
  String toString() {
    return 'FileReadWriteInfoServer(sn: $sn, uuid: $uuid, fileSn: $fileSn, fileNm: $fileNm, fileType: $fileType, updtDt: $updtDt, useYn: $useYn, fileStreCours: $fileStreCours, streFileNm: $streFileNm, orignlFileNm: $orignlFileNm, fileExtsn: $fileExtsn, fileCn: $fileCn, fileSize: $fileSize)';
  }
}

class FileReadWriteInfoServerList {
  final List<FileReadWriteInfoServer> fileInfoList;

  FileReadWriteInfoServerList({
    required this.fileInfoList,
  });

  factory FileReadWriteInfoServerList.fromJson(Map<String, dynamic> json) {
    final List<dynamic> fileList = json['fileInfoList'] ?? [];
    return FileReadWriteInfoServerList(
      fileInfoList: fileList.map((item) => FileReadWriteInfoServer.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileInfoList': fileInfoList.map((item) => item.toJson()).toList(),
    };
  }
}
