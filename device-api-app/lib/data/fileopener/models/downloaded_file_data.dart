/// 서버 파일 다운로드 후 Data 레이어에서 전달하는 원시 파일 메타데이터
class DownloadedFileData {
  final String fileName;
  final String filePath;
  final String fileExtension;
  final String mimeType;
  final int fileSize;
  final DateTime lastModified;
  final String? downloadUrl;

  const DownloadedFileData({
    required this.fileName,
    required this.filePath,
    required this.fileExtension,
    required this.mimeType,
    required this.fileSize,
    required this.lastModified,
    this.downloadUrl,
  });
}
