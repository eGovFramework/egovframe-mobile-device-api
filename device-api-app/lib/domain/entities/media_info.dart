import '../../utils/format_utils.dart';

/// 서버에서 받아온 미디어 정보를 담는 Entity 클래스
class MediaInfo {
  final int fileSn;
  final String fileName;
  final String filePath;
  final int fileSize;
  final String fileType;
  final String uploadDate;
  final String uuid;
  final int sn;
  final String mdSj;
  final String? orignlFileNm; // 원본 파일명

  MediaInfo({
    required this.fileSn,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.fileType,
    required this.uploadDate,
    required this.uuid,
    required this.sn,
    required this.mdSj,
    this.orignlFileNm,
  });

  /// JSON으로부터 객체를 생성
  factory MediaInfo.fromJson(Map<String, dynamic> json) {
    return MediaInfo(
      fileSn: json['fileSn'] ?? 0,
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      fileType: json['fileType'] ?? '',
      uploadDate: json['uploadDate'] ?? '',
      uuid: json['uuid'] ?? '',
      sn: json['sn'] ?? 0,
      mdSj: json['mdSj'] ?? '',
      orignlFileNm: json['orignlFileNm'],
    );
  }

  /// 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'fileSn': fileSn,
      'fileName': fileName,
      'filePath': filePath,
      'fileSize': fileSize,
      'fileType': fileType,
      'uploadDate': uploadDate,
      'uuid': uuid,
      'sn': sn,
      'orignlFileNm': orignlFileNm,
      'mdSj': mdSj,
    };
  }

  /// 파일 크기를 포맷된 문자열로 반환
  String get formattedSize => FormatUtils.formatFileSize(fileSize);

  /// 미디어 타입을 확인
  bool get isImage {
    final imageTypes = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageTypes.any((type) => fileType.toLowerCase().contains(type));
  }

  bool get isVideo {
    final videoTypes = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'];
    return videoTypes.any((type) => fileType.toLowerCase().contains(type));
  }

  bool get isAudio {
    final audioTypes = ['mp3', 'wav', 'aac', 'flac', 'm4a'];
    return audioTypes.any((type) => fileType.toLowerCase().contains(type));
  }

  /// 미디어 타입을 문자열로 반환
  String get typeString {
    if (isImage) return '이미지';
    if (isVideo) return '비디오';
    if (isAudio) return '오디오';
    return '알 수 없음';
  }
}

/// 미디어 파일 정보
class MediaFileInfo {
  final String name;
  final String path;
  final int size;
  final MediaType type;
  final DateTime lastModified;
  final int? serverSn;
  
  // 서버 API 필드들
  final String? sn; // 일련번호
  final String? uuid; // 기기식별코드
  final int? fileSn; // 파일 일련번호
  final String? mdCode; // 미디어구분코드
  final String? mdSj; // 미디어 제목
  final String? useyn; // 사용여부
  final String? revivCo; // 재생횟수
  final String? fileStreCours; // 파일저장경로
  final String? streFileNm; // 저장파일명
  final String? orignlFileNm; // 원파일명
  final String? fileExtsn; // 파일확장자
  final String? fileCn; // 파일내용

  MediaFileInfo({
    required this.name,
    required this.path,
    required this.size,
    required this.type,
    required this.lastModified,
    this.serverSn,
    this.sn,
    this.uuid,
    this.fileSn,
    this.mdCode,
    this.mdSj,
    this.useyn,
    this.revivCo,
    this.fileStreCours,
    this.streFileNm,
    this.orignlFileNm,
    this.fileExtsn,
    this.fileCn,
  });

  /// 파일 크기를 포맷된 문자열로 반환
  String get formattedSize => FormatUtils.formatFileSize(size);

  /// 수정 날짜를 포맷된 문자열로 반환
  String get formattedDate => FormatUtils.formatDateTime(lastModified);

  /// 미디어 타입을 문자열로 반환
  String get typeString {
    switch (type) {
      case MediaType.image:
        return '이미지';
      case MediaType.video:
        return '비디오';
      case MediaType.audio:
        return '오디오';
      case MediaType.unknown:
        return '알 수 없음';
    }
  }

  /// 파일 확장자를 반환
  String get extension {
    return name.split('.').last.toLowerCase();
  }

  bool get isServerFile => path.startsWith('server://');
  bool get isLocalFile => !isServerFile;
  String get originFileName => name;

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'size': size,
      'type': type.index,
      'lastModified': lastModified.toIso8601String(),
    };
  }

  /// JSON으로부터 MediaFileInfo를 생성
  factory MediaFileInfo.fromJson(Map<String, dynamic> json) {
    return MediaFileInfo(
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      size: json['size'] ?? 0,
      type: MediaType.values[json['type'] ?? 0],
      lastModified: DateTime.parse(json['lastModified']),
      serverSn: json['serverSn'],
    );
  }

  /// 서버 API 응답으로부터 MediaFileInfo를 생성
  factory MediaFileInfo.fromServerApi(Map<String, dynamic> json) {
    // 여러 가능한 키에서 fileVO 찾기
    final fileVO = json['mediaAndroidAPIFileVO'] ?? 
                   json['mediaAPIFileVO'] ?? 
                   json['mediaFileVO'] as Map<String, dynamic>?;

    // 값 추출 헬퍼 함수
    T? _getValue<T>(String key, {T? Function(dynamic)? converter}) {
      final value = fileVO?[key] ?? json[key];
      if (value == null) return null;
      if (converter != null) return converter(value);
      return value as T?;
    }

    // 필드 추출
    final snValue = _getValue<String>('sn', converter: (v) => v?.toString());
    final fileSnValue = _getValue<int>('fileSn');
    final uuidValue = _getValue<String>('uuid', converter: (v) => v?.toString());
    final mdCodeValue = _getValue<String>('mdCode', converter: (v) => v?.toString());
    final mdSjValue = _getValue<String>('mdSj', converter: (v) => v?.toString());
    final orignlFileNmValue = _getValue<String>('orignlFileNm', converter: (v) => v?.toString()) ?? 
                              mdSjValue;
    final streFileNmValue = _getValue<String>('streFileNm', converter: (v) => v?.toString());
    final fileStreCoursValue = _getValue<String>('fileStreCours', converter: (v) => v?.toString());
    final fileExtsnValue = _getValue<String>('fileExtsn', converter: (v) => v?.toString());
    final fileCnValue = _getValue<String>('fileCn', converter: (v) => v?.toString());
    
    // 파일 크기 파싱
    final fileSizeStr = _getValue<String>('fileSize', converter: (v) => v?.toString()) ?? '0';
    final fileSize = int.tryParse(fileSizeStr) ?? 0;

    // 업로드 날짜 파싱
    final uploadDateStr = _getValue<String>('uploadDate', converter: (v) => v?.toString());
    DateTime uploadDate = DateTime.now();
    if (uploadDateStr != null) {
      try {
        uploadDate = DateTime.parse(uploadDateStr);
      } catch (_) {
        uploadDate = DateTime.now();
      }
    }

    // 확장자 추출 및 미디어 타입 결정
    final extension = (fileExtsnValue ?? 
                      orignlFileNmValue?.split('.').last ?? 
                      streFileNmValue?.split('.').last ?? 
                      '').toLowerCase();
    
    MediaType mediaType = MediaType.unknown;
    const imageExts = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    const videoExts = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'];
    const audioExts = ['mp3', 'wav', 'aac', 'flac', 'm4a', 'ogg'];

    if (imageExts.contains(extension)) {
      mediaType = MediaType.image;
    } else if (videoExts.contains(extension)) {
      mediaType = MediaType.video;
    } else if (audioExts.contains(extension)) {
      mediaType = MediaType.audio;
    }

    final displayName = orignlFileNmValue ?? streFileNmValue ?? mdSjValue ?? '';
    final serverSnValue = int.tryParse(snValue ?? '') ?? fileSnValue;

    return MediaFileInfo(
      name: displayName,
      path: 'server://${serverSnValue ?? 0}',
      size: fileSize,
      type: mediaType,
      lastModified: uploadDate,
      serverSn: serverSnValue,
      sn: snValue,
      uuid: uuidValue,
      fileSn: fileSnValue,
      mdCode: mdCodeValue,
      mdSj: mdSjValue,
      useyn: _getValue<String>('useyn', converter: (v) => v?.toString()),
      revivCo: _getValue<String>('revivCo', converter: (v) => v?.toString()),
      fileStreCours: fileStreCoursValue,
      streFileNm: streFileNmValue,
      orignlFileNm: orignlFileNmValue,
      fileExtsn: fileExtsnValue,
      fileCn: fileCnValue,
    );
  }

  @override
  String toString() {
    return 'MediaFileInfo(name: $name, path: $path, size: $size, type: $type, lastModified: $lastModified, serverSn: $serverSn)';
  }
}

/// 미디어 파일 타입을 나타내는 열거형
enum MediaType {
  image,
  video,
  audio,
  unknown,
}

