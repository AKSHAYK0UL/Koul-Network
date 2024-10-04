import 'package:flutter/material.dart';

Widget googleButton(
    {required BuildContext context,
    required String text,
    required IconData icon,
    required Function() func}) {
  final screenSize = MediaQuery.sizeOf(context);

  return SizedBox(
    width: double.infinity,
    height: screenSize.height * 0.077,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: func,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            size: screenSize.height * 0.035,
            // size: 26,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Text(""),
        ],
      ),
    ),
  );
}
