import 'package:flutter/material.dart';

Widget buildMenuOptions(
    {required BuildContext context,
    required IconData icon,
    required String text,
    required Function() onTap}) {
  final screenSize = MediaQuery.sizeOf(context);

  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: screenSize.width * 0.235,
      width: screenSize.width * 0.230,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 3),
        color: const Color.fromARGB(255, 50, 50, 50),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: screenSize.width * 0.0767,
              color: Colors.white70,
            ),
            SizedBox(
              height: screenSize.width * 0.0128,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white70,
                    fontSize: screenSize.height * 0.020,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
