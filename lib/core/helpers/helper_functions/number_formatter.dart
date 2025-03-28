import 'package:intl/intl.dart';

String numberFormatter(String number) {
  final formatter = NumberFormat("00.00");
  final numericValue = double.parse(number);
  return formatter.format(numericValue);
}
