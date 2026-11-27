import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';

/// faceGroupId 기준으로 묶은 얼굴 메시 세션 요약
class FaceMeshGroupSummary {
  final String faceGroupId;
  final String? imagePath;
  final int faceCount;
  final String? timestamp;
  final String? source;
  final List<FaceMeshRecord> records;

  const FaceMeshGroupSummary({
    required this.faceGroupId,
    required this.imagePath,
    required this.faceCount,
    required this.timestamp,
    required this.source,
    required this.records,
  });

  bool get hasLocalImage {
    final path = imagePath?.trim();
    if (path == null || path.isEmpty) return false;
    return File(path).existsSync();
  }

  /// 동일 faceGroupId끼리 묶고, 최신 timestamp 순으로 정렬
  static List<FaceMeshGroupSummary> fromRecords(
    List<FaceMeshRecord> records,
  ) {
    final byGroup = <String, List<FaceMeshRecord>>{};
    for (final record in records) {
      byGroup.putIfAbsent(record.faceGroupId, () => []).add(record);
    }

    final groups = byGroup.entries.map((entry) {
      final items = List<FaceMeshRecord>.from(entry.value)
        ..sort((a, b) {
          final byIndex = _faceIndex(a).compareTo(_faceIndex(b));
          if (byIndex != 0) return byIndex;
          return a.sn.compareTo(b.sn);
        });

      final representative = items.first;
      final imagePath = items
          .map((e) => e.imagePath?.trim())
          .firstWhere(
            (path) => path != null && path.isNotEmpty,
            orElse: () => null,
          );

      final storedCount = int.tryParse(representative.faceCount ?? '');
      final faceCount =
          (storedCount != null && storedCount > 0) ? storedCount : items.length;

      String? latestTimestamp;
      for (final item in items) {
        if (item.timestamp.isEmpty) continue;
        if (latestTimestamp == null ||
            item.timestamp.compareTo(latestTimestamp) > 0) {
          latestTimestamp = item.timestamp;
        }
      }

      return FaceMeshGroupSummary(
        faceGroupId: entry.key,
        imagePath: imagePath,
        faceCount: faceCount,
        timestamp: latestTimestamp ?? representative.timestamp,
        source: representative.source,
        records: items,
      );
    }).toList();

    groups.sort((a, b) {
      final aTs = a.timestamp ?? '';
      final bTs = b.timestamp ?? '';
      final byTime = bTs.compareTo(aTs);
      if (byTime != 0) return byTime;
      return b.faceGroupId.compareTo(a.faceGroupId);
    });

    return groups;
  }

  static int _faceIndex(FaceMeshRecord record) {
    return int.tryParse(record.faceIndex ?? '') ?? record.sn;
  }
}
