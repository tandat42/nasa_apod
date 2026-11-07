abstract final class DateUtils {
  /// Returns the APOD day of [dateTime] (defaults to now) in US Eastern time as `YYMMDD`.
  static String getApodDate([DateTime? dateTime]) {
    final utc = (dateTime ?? DateTime.now()).toUtc();
    final eastern = utc.subtract(_usEasternOffset(utc));
    return '${(eastern.year % 100).toString().padLeft(2, '0')}'
        '${eastern.month.toString().padLeft(2, '0')}'
        '${eastern.day.toString().padLeft(2, '0')}';
  }

  static Duration _usEasternOffset(DateTime utc) {
    final dstStart = _nthSunday(
      utc.year,
      DateTime.march,
      2,
    ).add(const Duration(hours: 7));
    final dstEnd = _nthSunday(
      utc.year,
      DateTime.november,
      1,
    ).add(const Duration(hours: 6));
    final isDst = !utc.isBefore(dstStart) && utc.isBefore(dstEnd);
    return Duration(hours: isDst ? 4 : 5);
  }

  static DateTime _nthSunday(int year, int month, int n) {
    final firstOfMonth = DateTime.utc(year, month, 1);
    final firstSunday = 1 + (DateTime.sunday - firstOfMonth.weekday) % 7;
    return DateTime.utc(year, month, firstSunday + 7 * (n - 1));
  }
}
