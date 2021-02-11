import 'package:flutter/material.dart';

class AppTheme {
  get darkTheme => ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xffbb86fc),
          primaryVariant: Color(0xff3700b3),
          secondary: Color(0xff03dac6),
          secondaryVariant: Color(0xff03dac6),
          background: Color(0xff121212),
          surface: Color(0xff121212),
          error: Color(0xffcf6679),
          onPrimary: Color(0xff000000),
          onSecondary: Color(0xff000000),
          onBackground: Color(0xffffffff),
          onSurface: Color(0xffffffff),
          onError: Color(0xff000000),
        ),
        buttonColor: Colors.red[400],
        //scaffoldBackgroundColor: Colors.grey[900],
        //brightness: Brightness.dark,
        // primaryColor: Colors.indigo[200],
        // accentColor: Colors.teal[200],
        fontFamily: 'DniproCity',
      );
  get lightTheme => ThemeData(
        //colorScheme: ColorScheme.light(),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[200],
        primaryColor: Colors.indigo,
        accentColor: Colors.deepPurple,
        buttonColor: Colors.red[600],
        fontFamily: 'DniproCity',
        indicatorColor: Colors.white,
      );
}
