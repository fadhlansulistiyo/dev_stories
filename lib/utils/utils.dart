import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String toFormattedString() {
    final DateFormat formatter = DateFormat('dd MMM yyyy | HH:mm');
    return formatter.format(this);
  }
}

