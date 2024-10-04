import 'package:intl/intl.dart';

String utcToIst(String utcTimestamp) {
  DateTime utcDateTime = DateTime.parse(utcTimestamp);

  Duration istOffset = const Duration(hours: 5, minutes: 30);
  DateTime istDateTime = utcDateTime.add(istOffset);

  DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
  String istFormatted = dateFormat.format(istDateTime);
  return istFormatted;
}

String timeFormater(String utcTimestamp) {
  DateTime utcDateTime = DateTime.parse(utcTimestamp);

  Duration istOffset = const Duration(hours: 5, minutes: 30);
  DateTime istDateTime = utcDateTime.add(istOffset);

  DateFormat dateFormat = DateFormat('dd-MMM');
  String istFormatted = dateFormat.format(istDateTime);
  return istFormatted;
}

String timeFormaterFull(String utcTimestamp) {
  DateTime utcDateTime = DateTime.parse(utcTimestamp);

  Duration istOffset = const Duration(hours: 5, minutes: 30);
  DateTime istDateTime = utcDateTime.add(istOffset);

  DateFormat dateFormat = DateFormat('dd-MMM-yyyy, hh:mm a');
  String istFormatted = dateFormat.format(istDateTime);
  return istFormatted;
}
