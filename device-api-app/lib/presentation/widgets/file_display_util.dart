import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:flutter/material.dart';

/// 파일 목록·상세 UI에서 공통으로 쓰는 확장자 판별·아이콘·색상 유틸
class FileDisplayUtil {
  FileDisplayUtil._();

  static bool isMediaFile(String fileName) {
    final extension = _extension(fileName);
    return [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'mp4',
      'avi',
      'mov',
      'wmv',
      'flv',
      'webm',
      'mp3',
      'wav',
      'aac',
      'ogg',
      'm4a',
      'flac',
    ].contains(extension);
  }

  static bool isImageFile(String fileName) {
    final extension = _extension(fileName);
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  static bool isVideoFile(String fileName) {
    final extension = _extension(fileName);
    return ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].contains(extension);
  }

  /// 점(.)이 없거나, 맨 앞·맨 끝만 있는 이름은 확장자 없음으로 본다.
  static bool hasFileExtension(String fileName) {
    final name = _baseName(fileName);
    final dot = name.lastIndexOf('.');
    return dot > 0 && dot < name.length - 1;
  }

  /// 상세 화면에서 UTF-8 텍스트로 미리볼 수 있는 파일.
  /// 확장자가 없으면 txt와 같이 취급한다. PDF·Office·압축은 제외한다.
  static bool isTextPreviewFile(String fileName) {
    if (!hasFileExtension(fileName)) return true;
    final extension = _extension(fileName);
    return [
      'txt',
      'json',
      'md',
      'csv',
      'xml',
      'html',
      'htm',
      'log',
      'yaml',
      'yml',
      'properties',
    ].contains(extension);
  }

  static MediaType getMediaTypeFromExtension(String fileName) {
    final extension = _extension(fileName);
    switch (extension) {
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
      case 'flac':
        return MediaType.audio;
      default:
        return MediaType.unknown;
    }
  }

  static IconData getFileIcon(String fileName) {
    final extension = _extension(fileName);
    if (extension.isEmpty) return Icons.text_snippet;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
      case 'flv':
      case 'webm':
        return Icons.videocam;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'ogg':
      case 'm4a':
      case 'flac':
        return Icons.audiotrack;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
      case 'rtf':
      case 'odt':
      case 'hwp':
        return Icons.description;
      case 'xls':
      case 'xlsx':
      case 'ods':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
      case 'odp':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      case 'json':
        return Icons.data_object;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  static Color getFileIconColor(String fileName) {
    final extension = _extension(fileName);
    if (extension.isEmpty) return EgovColor.success50;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return EgovColor.point50;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
      case 'flv':
      case 'webm':
        return EgovColor.secondary50;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'ogg':
      case 'm4a':
      case 'flac':
        return EgovColor.warning50;
      case 'txt':
        return EgovColor.success50;
      case 'json':
        return EgovColor.information50;
      case 'pdf':
        return EgovColor.danger50;
      case 'doc':
      case 'docx':
      case 'rtf':
      case 'odt':
      case 'hwp':
        return EgovColor.danger50;
      case 'xls':
      case 'xlsx':
      case 'ods':
        return EgovColor.success50;
      case 'ppt':
      case 'pptx':
      case 'odp':
        return EgovColor.warning50;
      case 'zip':
      case 'rar':
      case '7z':
        return EgovColor.gray50;
      default:
        return EgovColor.gray50;
    }
  }

  static MediaFileInfo toMediaFileInfo(FileInfo fileInfo) {
    return MediaFileInfo(
      name: fileInfo.fileName,
      path: fileInfo.filePath,
      size: fileInfo.fileSize,
      type: getMediaTypeFromExtension(fileInfo.fileName),
      lastModified: DateTime.tryParse(fileInfo.uploadDate) ?? DateTime.now(),
      serverSn: 0,
    );
  }

  static String _baseName(String fileName) {
    return fileName.replaceAll('\\', '/').split('/').last;
  }

  static String _extension(String fileName) {
    final name = _baseName(fileName);
    if (!hasFileExtension(name)) return '';
    return name.substring(name.lastIndexOf('.') + 1).toLowerCase();
  }
}
