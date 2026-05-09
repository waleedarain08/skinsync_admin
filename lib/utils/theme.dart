import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constant.dart';

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
        background: CustomColors.backgroundLight,
      ),
      scaffoldBackgroundColor: CustomColors.backgroundLight,
      fontFamily: 'Degular',
      
      appBarTheme: AppBarTheme(
        backgroundColor: CustomColors.surfaceWhite,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: CustomColors.textMain, size: 24.sp),
        titleTextStyle: TextStyle(
          fontFamily: 'Degular',
          color: CustomColors.textMain,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CustomColors.brandPrimary,
          side: BorderSide(color: CustomColors.brandPrimary.withValues(alpha: 0.5)),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: CustomColors.textMuted.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: CustomColors.textMuted.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: CustomColors.brandPrimary, width: 1.5),
        ),
        hintStyle: TextStyle(color: CustomColors.textMuted, fontSize: 14.sp),
      ),
      
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: CustomColors.textMuted.withValues(alpha: 0.1)),
        ),
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
