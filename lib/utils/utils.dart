import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

String formatWithTimeZone(dynamic dateInput, {String targetTimeZone = "Asia/Jakarta"}) {
  final utcDate = (dateInput is String)
      ? DateTime.parse(dateInput).toUtc()
      : (dateInput as DateTime).toUtc();

  final tzDate = tz.TZDateTime.from(utcDate, tz.getLocation(targetTimeZone));

  final formatter = DateFormat('dd MMM yyyy | HH:mm');
  return formatter.format(tzDate);
}