import 'package:flutter/material.dart';

ThemeData themeDATA(BuildContext context) {
  final screenSize = MediaQuery.sizeOf(context);
  return ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 44, 43, 43),
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    useMaterial3: true,
    canvasColor: Colors.grey.shade900,
    primaryColor: Colors.blue,
    hintColor: const Color.fromRGBO(255, 255, 255, 1),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        // fontSize: 23,
        fontSize: screenSize.height * 0.031,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        // fontSize: 20,
        fontSize: screenSize.height * 0.027,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        // fontSize: 18,
        fontSize: screenSize.height * 0.024,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        // fontSize: 23,
        fontSize: screenSize.height * 0.031,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        // fontSize: 20,
        fontSize: screenSize.height * 0.027,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        // fontSize: 17.5,
        fontSize: screenSize.height * 0.023,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        // fontSize: 18,
        fontSize: screenSize.height * 0.024,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        color: Colors.white,
        // fontSize: 14,
        fontSize: screenSize.height * 0.019,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        color: Colors.white,
        // fontSize: 13,
        fontSize: screenSize.height * 0.017,
        fontWeight: FontWeight.normal,
      ),
      displayLarge: TextStyle(
        color: Colors.white,
        //fontSize: 25,
        fontSize: screenSize.height * 0.033,
        fontWeight: FontWeight.w900,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: screenSize.height * 0.022, //16.5
        fontWeight: FontWeight.w500,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontSize: screenSize.height * 0.018, //13.5
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: screenSize.height * 0.034,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: screenSize.height * 0.037,
        fontWeight: FontWeight.normal,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        disabledBackgroundColor: Colors.blueGrey,
        disabledForegroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 56, 56, 56),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: TextStyle(
          fontSize: screenSize.height * 0.023,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.blueGrey,
        disabledForegroundColor: Colors.white,
        backgroundColor: Colors.grey.shade700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: TextStyle(
          fontSize: screenSize.height * 0.023,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blueGrey.shade200,
      selectionColor: Colors.blueGrey.shade400,
      selectionHandleColor: Colors.blueGrey.shade400,
    ),
  );
}
