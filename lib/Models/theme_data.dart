import 'package:flutter/material.dart';

class AppTheme {
  get darkTheme => ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade300,
        textSelectionColor: Colors.white,
        primarySwatch: Colors.indigo,
        fontFamily: 'DniproCity',
      );
  get lightTheme => ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade300,
        primarySwatch: Colors.deepPurple,
        fontFamily: 'DniproCity',
      );
}
