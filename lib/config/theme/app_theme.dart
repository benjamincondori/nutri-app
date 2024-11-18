import 'package:flutter/material.dart';
import 'package:nutrition_ai_app/config/theme/my_colors.dart';


class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: MyColors.primaryColor,
        // primarySwatch: MyColors.primarySwatch,
        appBarTheme: const AppBarTheme(centerTitle: false),
        fontFamily: 'Roboto',
      );
}

