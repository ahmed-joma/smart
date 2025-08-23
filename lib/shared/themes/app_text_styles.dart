import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Font Families - Using default fonts for now
  static const String fontFamilyInter = 'Roboto'; // Default fallback
  static const String fontFamilyPlusJakarta = 'Roboto'; // Default fallback
  static const String fontFamilyArabic = 'Roboto'; // Default fallback

  // Font Sizes
  static const double fontSizeSmall = 13.0;
  static const double fontSizeMedium = 15.0;
  static const double fontSizeLarge = 19.0;

  // Small Text Styles (13px)
  static const TextStyle small = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  static const TextStyle smallMedium = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  static const TextStyle smallSemiBold = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  static const TextStyle smallBold = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  // Medium Text Styles (15px)
  static const TextStyle medium = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  static const TextStyle mediumMedium = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  static const TextStyle mediumSemiBold = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  static const TextStyle mediumBold = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  // Large Text Styles (19px)
  static const TextStyle large = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  static const TextStyle largeMedium = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  static const TextStyle largeSemiBold = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  static const TextStyle largeBold = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyInter,
    color: AppColors.onSurface,
  );

  // Heading Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyPlusJakarta,
    color: AppColors.onSurface,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyPlusJakarta,
    color: AppColors.onSurface,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyPlusJakarta,
    color: AppColors.onSurface,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyPlusJakarta,
    color: AppColors.onSurface,
  );

  // Arabic Text Styles
  static const TextStyle arabicSmall = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyArabic,
    color: AppColors.onSurface,
  );

  static const TextStyle arabicMedium = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyArabic,
    color: AppColors.onSurface,
  );

  static const TextStyle arabicLarge = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyArabic,
    color: AppColors.onSurface,
  );

  // Custom Styles
  static TextStyle get buttonText =>
      mediumSemiBold.copyWith(color: AppColors.onPrimary);

  static TextStyle get caption =>
      small.copyWith(color: AppColors.onSurfaceVariant);

  static TextStyle get overline =>
      small.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w500);

  // Text Theme
  static TextTheme get textTheme => const TextTheme(
    displayLarge: heading1,
    displayMedium: heading2,
    displaySmall: heading3,
    headlineLarge: heading3,
    headlineMedium: heading4,
    headlineSmall: largeBold,
    titleLarge: largeMedium,
    titleMedium: mediumMedium,
    titleSmall: smallMedium,
    bodyLarge: medium,
    bodyMedium: medium,
    bodySmall: small,
    labelLarge: mediumMedium,
    labelMedium: smallMedium,
    labelSmall: small,
  );
}
