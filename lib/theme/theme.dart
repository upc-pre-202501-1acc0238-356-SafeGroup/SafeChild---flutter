import 'package:flutter/material.dart';
import 'color.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: const TextTheme(
      bodyLarge: AppTypography.body,
      headlineSmall: AppTypography.heading,
    ),
  );
}
