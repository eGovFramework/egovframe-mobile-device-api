/// 포맷팅 유틸리티 클래스
/// 파일 크기, 날짜, 정확도 등의 포맷팅을 담당
class FormatUtils {
  /// 파일 크기를 포맷된 문자열로 변환
  static String formatFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else if (sizeInBytes < 1024 * 1024 * 1024) {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// 날짜를 포맷된 문자열로 변환 (YYYY-MM-DD HH:mm)
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// 날짜 문자열을 파싱하여 포맷된 문자열로 변환
  static String formatDateString(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return formatDateTime(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  /// 정확도를 포맷된 문자열로 변환 (미터 단위)
  static String formatAccuracy(double? accuracy) {
    if (accuracy == null) return '알 수 없음';
    return '${accuracy.toStringAsFixed(2)}m';
  }

  /// 정확도를 포맷된 문자열로 변환 (N/A 표시)
  static String formatAccuracyWithNA(double? accuracy) {
    return accuracy != null ? '${accuracy.toStringAsFixed(2)}m' : 'N/A';
  }

  static String formatTimestampToDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String dateTime = formatDateTime(date);
    return dateTime;
  }
}
