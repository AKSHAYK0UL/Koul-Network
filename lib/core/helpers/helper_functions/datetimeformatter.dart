import 'package:intl/intl.dart';

String dateTimeFormated(DateTime date) {
  final sdate = DateFormat("dd-MMM-yyyy").format(date);
  return sdate;
}
