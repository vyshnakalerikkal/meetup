import 'package:flutter/material.dart';

import 'colors.dart';

const intelFamily = 'Intel';
const montesserat = 'Montserrat';

TextTheme get textTheme => const TextTheme(
      displayLarge: TextStyle(
        fontSize: 99,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: AppColors.formFieldText,
        fontFamily: intelFamily,
      ),
      displayMedium: TextStyle(
        fontSize: 62,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: AppColors.formFieldText,
        fontFamily: intelFamily,
      ),
      displaySmall: TextStyle(
        fontSize: 49,
        fontWeight: FontWeight.w400,
        fontFamily: intelFamily,
        color: AppColors.formFieldText,
      ),
      headlineMedium: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.formFieldText,
        fontFamily: intelFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
        color: AppColors.white,
        fontFamily: intelFamily,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        fontFamily: intelFamily,
        color: AppColors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: AppColors.formFieldText,
        fontFamily: intelFamily,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: AppColors.white,
        fontFamily: intelFamily,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.white,
        fontFamily: intelFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.formFieldText,
        fontFamily: intelFamily,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.36,
        color: AppColors.white,
        fontFamily: intelFamily,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.formFieldText,
        fontFamily: intelFamily,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.18,
        color: AppColors.formFieldText,
        fontFamily: intelFamily,
      ),
    );

// To add custom text theme name
extension CustomStyles on TextTheme {
  TextStyle get buttonStyle {
    return const TextStyle(
      fontSize: 20,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
      fontFamily: intelFamily,
    );
  }

  TextStyle get error {
    return const TextStyle(
      fontSize: 18.0,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get success {
    return const TextStyle(
      fontSize: 18.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get phoneInput {
    return const TextStyle(
      fontSize: 13,
      color: AppColors.formFieldText,
      fontWeight: FontWeight.w500,
      fontFamily: intelFamily,
    );
  }
}
