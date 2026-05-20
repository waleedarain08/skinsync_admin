import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constant.dart';
import 'custom_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: CustomColors.deepSlate,
      
      colorScheme: const ColorScheme.light(
        primary: CustomColors.deepSlate,
        onPrimary: CustomColors.surfaceWhite,
        secondary: CustomColors.brandPurple,
        onSecondary: CustomColors.deepSlate,
        tertiary: CustomColors.brandCyan,
        onTertiary: CustomColors.deepSlate,
        surface: CustomColors.surfaceWhite,
        onSurface: CustomColors.deepSlate,
        error: CustomColors.error,
        onError: CustomColors.surfaceWhite,
        outline: CustomColors.borderLight,
      ),

      scaffoldBackgroundColor: CustomColors.backgroundLight,
      fontFamily: 'Degular',
      
      appBarTheme: AppBarTheme(
        backgroundColor: CustomColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: CustomColors.deepSlate, size: 24.sp),
        titleTextStyle: CustomFonts.headlineSmall,
        shape: Border(
          bottom: BorderSide(color: CustomColors.borderLight, width: 1),
        ),
      ),
      
      textTheme: TextTheme(
        headlineLarge: CustomFonts.headlineLarge,
        headlineMedium: CustomFonts.headlineMedium,
        headlineSmall: CustomFonts.headlineSmall,
        titleLarge: CustomFonts.bodyLarge,
        titleMedium: CustomFonts.bodyMedium,
        bodyLarge: CustomFonts.bodyLarge,
        bodyMedium: CustomFonts.bodyMedium,
        bodySmall: CustomFonts.bodySmall,
        labelLarge: CustomFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.deepSlate,
          foregroundColor: CustomColors.surfaceWhite,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          textStyle: CustomFonts.bodyLarge.copyWith(color: CustomColors.surfaceWhite),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CustomColors.deepSlate,
          side: const BorderSide(color: CustomColors.deepSlate),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          textStyle: CustomFonts.bodyLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CustomColors.deepSlate,
          textStyle: CustomFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CustomColors.surfaceWhite,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: CustomColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: CustomColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: CustomColors.brandCyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: CustomColors.error),
        ),
        hintStyle: CustomFonts.bodyMedium.copyWith(color: CustomColors.textSecondary),
        labelStyle: CustomFonts.bodyMedium.copyWith(color: CustomColors.textSecondary),
      ),
      
      cardTheme: CardThemeData(
        color: CustomColors.surfaceWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: CustomColors.borderLight),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: CustomColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        titleTextStyle: CustomFonts.headlineMedium,
        contentTextStyle: CustomFonts.bodyMedium,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: CustomColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: CustomColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: CustomColors.deepSlate,
        selectedIconTheme: const IconThemeData(color: CustomColors.brandCyan),
        unselectedIconTheme: const IconThemeData(color: Colors.white60),
        selectedLabelTextStyle: CustomFonts.bodySmall.copyWith(color: CustomColors.brandCyan),
        unselectedLabelTextStyle: CustomFonts.bodySmall.copyWith(color: Colors.white60),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: CustomColors.deepSlate,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme; // For this project, we prioritize the redesigned light theme as the main admin style
}
