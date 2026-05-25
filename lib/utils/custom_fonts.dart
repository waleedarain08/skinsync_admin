import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constant.dart';

class CustomFonts {
  static const String headingFont = 'Plus Jakarta Sans';
  static const String bodyFont = 'Inter';

  static TextStyle get h1 => TextStyle(
        fontFamily: headingFont,
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        color: CustomColors.textPrimary,
        letterSpacing: -0.3,
      );

  static TextStyle get h2 => TextStyle(
        fontFamily: headingFont,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: CustomColors.textPrimary,
      );

  static TextStyle get h3 => TextStyle(
        fontFamily: headingFont,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: CustomColors.textPrimary,
      );

  static TextStyle get h4 => TextStyle(
        fontFamily: headingFont,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: CustomColors.textPrimary,
      );

  static TextStyle get body => TextStyle(
        fontFamily: bodyFont,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: CustomColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get label => TextStyle(
        fontFamily: bodyFont,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: CustomColors.textPrimary,
      );

  static TextStyle get sidebarItem => TextStyle(
        fontFamily: bodyFont,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: CustomColors.textSecondary,
      );

  static TextStyle get sidebarItemActive => TextStyle(
        fontFamily: bodyFont,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: CustomColors.primary,
      );

  // Legacy Mappings
  static TextStyle get display => h1.copyWith(fontSize: 32.sp);
  static TextStyle get bodyLarge => body.copyWith(fontSize: 16.sp, color: CustomColors.textPrimary);
  static TextStyle get bodyLg => bodyLarge;
  static TextStyle get bodyMedium => body;
  static TextStyle get bodySmall => body.copyWith(fontSize: 13.sp);
  static TextStyle get bodySm => bodySmall;
  static TextStyle get caption => body.copyWith(fontSize: 12.sp);
  static TextStyle get button => label.copyWith(color: Colors.white);
  
  static TextStyle get textMain32w700 => h1.copyWith(fontSize: 32.sp);
  static TextStyle get textMain24w700 => h1.copyWith(fontSize: 24.sp);
  static TextStyle get textMain20w600 => h2;
  static TextStyle get textMain18w600 => h3;
  static TextStyle get textMain16w600 => h4;
  static TextStyle get textMain14w600 => label;
  static TextStyle get textMain14w400 => body.copyWith(color: CustomColors.textPrimary);
  static TextStyle get textMain12w600 => label.copyWith(fontSize: 12.sp);
  static TextStyle get textMuted13w500 => body.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w500);
  static TextStyle get textMuted12w400 => caption;
  static TextStyle get textMuted14w400 => bodySmall;
  static TextStyle get textMuted11w400 => body.copyWith(fontSize: 11.sp);
  static TextStyle get textMuted16w500 => bodyLarge.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get overline => h4.copyWith(fontSize: 10.sp, letterSpacing: 1.2);
  static TextStyle get sidebarSection => overline;

  static TextStyle get black14w600 => label.copyWith(fontSize: 14.sp);
  static TextStyle get black16w600 => h4;
  static TextStyle get black20w600 => h2;
  static TextStyle get black13w400 => bodySmall;
  static TextStyle get grey14w400 => bodySmall;
  static TextStyle get grey16w400 => body.copyWith(fontSize: 16.sp);
  static TextStyle get black16w400 => body.copyWith(fontSize: 16.sp);
  static TextStyle get black16w500 => body.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle get black18w600 => h3;
  static TextStyle get black14w400 => body;
  static TextStyle get white16w400 => body.copyWith(fontSize: 16.sp, color: Colors.white);
  static TextStyle get black30w600 => h1.copyWith(fontSize: 30.sp);
  static TextStyle get grey18w400 => body.copyWith(fontSize: 18.sp);
  static TextStyle get black20w500 => h2.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get black14w500 => label.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500);

  static TextStyle get white14w600 => label.copyWith(fontSize: 14.sp, color: Colors.white);
  static TextStyle get white14w500 => label.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white);
  static TextStyle get headlineLarge => h1;
  static TextStyle get headlineMedium => h2;
  static TextStyle get headlineSmall => h3;
}
