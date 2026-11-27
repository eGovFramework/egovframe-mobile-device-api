/// 한국 표준시(KST, UTC+9) 기준 날짜·시간 포맷
class KstDateTimeUtil {
  static const Duration _kstOffset = Duration(hours: 9);

  static DateTime toKst(DateTime dateTime) =>
      dateTime.toUtc().add(_kstOffset);

  static DateTime nowKst() => toKst(DateTime.now());

  /// yyyy-MM-dd HH:mm:ss (KST)
  static String format(DateTime dateTime) {
    final kst = toKst(dateTime);
    final y = kst.year.toString().padLeft(4, '0');
    final m = kst.month.toString().padLeft(2, '0');
    final d = kst.day.toString().padLeft(2, '0');
    final h = kst.hour.toString().padLeft(2, '0');
    final min = kst.minute.toString().padLeft(2, '0');
    final s = kst.second.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min:$s';
  }

  static String formatNow() => format(DateTime.now());
}
