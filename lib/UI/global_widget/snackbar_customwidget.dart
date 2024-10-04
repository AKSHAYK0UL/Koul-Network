import 'package:flutter/material.dart';

ScaffoldFeatureController buildSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      // backgroundColor: Colors.blueGrey.shade600,
      backgroundColor: const Color.fromARGB(255, 44, 43, 43),
      behavior: SnackBarBehavior.fixed,
      elevation: 1,
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
    ),
  );
}
