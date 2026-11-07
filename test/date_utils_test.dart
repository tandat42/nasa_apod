import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/core/utils/date_utils.dart';

void main() {
  test('formats as YYMMDD', () {
    expect(DateUtils.getApodDate(DateTime.utc(2026, 1, 5, 12)), '260105');
  });

  test('uses EST (UTC-5) in winter', () {
    expect(DateUtils.getApodDate(DateTime.utc(2026, 11, 7, 4, 59)), '261106');
    expect(DateUtils.getApodDate(DateTime.utc(2026, 11, 7, 5)), '261107');
  });

  test('uses EDT (UTC-4) in summer', () {
    expect(DateUtils.getApodDate(DateTime.utc(2026, 7, 1, 3, 59)), '260630');
    expect(DateUtils.getApodDate(DateTime.utc(2026, 7, 1, 4)), '260701');
  });

  test('switches to EDT on the 2nd Sunday of March at 07:00 UTC', () {
    expect(DateUtils.getApodDate(DateTime.utc(2026, 3, 8, 4, 30)), '260307');
    expect(DateUtils.getApodDate(DateTime.utc(2026, 3, 9, 4, 30)), '260309');
  });

  test('switches back to EST on the 1st Sunday of November at 06:00 UTC', () {
    expect(DateUtils.getApodDate(DateTime.utc(2026, 11, 1, 4, 30)), '261101');
    expect(DateUtils.getApodDate(DateTime.utc(2026, 11, 2, 4, 30)), '261101');
  });

  test('converts local times through UTC', () {
    final utc = DateTime.utc(2026, 11, 7, 3);
    expect(DateUtils.getApodDate(utc.toLocal()), DateUtils.getApodDate(utc));
  });
}
