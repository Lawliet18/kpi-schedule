import 'package:flutter/material.dart';

class AppTheme {
  get darkTheme => ThemeData(
        textSelectionColor: Colors.white,
        primarySwatch: Colors.indigo,
        fontFamily: 'DniproCity',
      );
  get lightTheme => ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'DniproCity',
      );
}
