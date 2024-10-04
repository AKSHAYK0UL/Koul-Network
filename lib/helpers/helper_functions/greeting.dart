import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget greeting(BuildContext context) {
  final currentTime = int.parse(DateFormat('HH').format(DateTime.now()));

  if (currentTime >= 5 && currentTime <= 11) {
    return Text(
      'Good Morning',
      style: Theme.of(context).textTheme.titleLarge,
    );
  } else if (currentTime >= 12 && currentTime < 18) {
    return Text(
      'Good Afternoon',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
  return Text(
    'Good Evening',
    style: Theme.of(context).textTheme.titleLarge,
  );
}
