import 'package:flutter/material.dart';

Widget buildTiles({
  required BuildContext context,
  required String text,
  required IconData icon,
  required Function() onTap,
}) {
  final screenSize = MediaQuery.sizeOf(context);
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: screenSize.height * 0.008,
        vertical: screenSize.height * 0.004),
    child: ListTile(
      onTap: () {
        onTap();
      },
      selectedColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      splashColor: Colors.transparent,
      minTileHeight: screenSize.height * 0.105,
      tileColor: const Color.fromARGB(255, 48, 47, 47),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
  );
}
