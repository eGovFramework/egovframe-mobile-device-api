
import 'dart:io';

import '../entities/file_readwrite_info.dart';

abstract class FileRepository {
  Future<List<FileInfo>> getFileInfoList(String uuid);
  Future<Map<String, dynamic>> uploadFile({required String uuid, required List<File> files});
  Future<File?> downloadFile({
    required String uuid,
    required int fileSn,
    required String fileName,
    required String savePath,
  });
  Future<bool> deleteServerFile({
    required int sn,
  });
}
