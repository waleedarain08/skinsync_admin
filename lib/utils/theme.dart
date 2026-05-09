import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constant.dart';
import 'custom_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: CustomColors.brandPrimary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CustomColors.brandPrimary,
        primary: CustomColors.brandPrimary,
        secondary: CustomColors.brandCyan,
        tertiary: CustomColors.brandPurple,
        surface: CustomColors.surfaceWhite,
        error: CustomColors.error,
        background: CustomColors.backgroundLight,
      ),
      scaffoldBackgroundColor: CustomColors.backgroundLight,
      fontFamily: 'Degular',
      
      appBarTheme: AppBarTheme(
        backgroundColor: CustomColors.surfaceWhite,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: CustomColors.textMain, size: 24.sp),
        titleTextStyle: CustomFonts.textMain20w600,
      ),
      
      textTheme: TextTheme(
        headlineLarge: CustomFonts.textMain32w700,
        headlineMedium: CustomFonts.textMain24w700,
        headlineSmall: CustomFonts.textMain20w600,
        titleMedium: CustomFonts.textMain16w600,
        bodyLarge: CustomFonts.textMain16w400,
        bodyMedium: CustomFonts.textMain14w400,
        bodySmall: CustomFonts.textMuted12w400,
        labelLarge: CustomFonts.textMain14w600,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          textStyle: CustomFonts.textMain14w600.copyWith(color: Colors.white),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CustomColors.brandPrimary,
          side: BorderSide(color: CustomColors.brandPrimary.withOpacity(0.5)),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          textStyle: CustomFonts.textMain14w600.copyWith(color: CustomColors.brandPrimary),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: CustomColors.textMuted.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: CustomColors.textMuted.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: CustomColors.brandPrimary, width: 1.5),
        ),
        hintStyle: CustomFonts.textMain14w400.copyWith(color: CustomColors.textMuted),
        labelStyle: CustomFonts.textMuted13w500,
      ),
      
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: CustomColors.textMuted.withOpacity(0.1)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        titleTextStyle: CustomFonts.textMain24w700,
        contentTextStyle: CustomFonts.textMain14w400,
      ),

      dividerTheme: DividerThemeData(
        color: CustomColors.textMuted.withOpacity(0.1),
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: CustomColors.brandCyan,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CustomColors.brandCyan,
        brightness: Brightness.dark,
        primary: CustomColors.brandCyan,
        surface: CustomColors.deepSlate,
      ),
      fontFamily: 'Degular',
    );
  }
}
