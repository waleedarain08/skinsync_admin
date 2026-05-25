import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constant.dart';
import 'custom_fonts.dart';

export 'color_constant.dart';
export 'custom_fonts.dart';

class AppTheme {
  static ThemeData get calmWellnessTheme => _buildTheme();

  // Legacy Aliases
  static ThemeData get lightTheme => calmWellnessTheme;
  static ThemeData get darkTheme => calmWellnessTheme;

  static ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: CustomColors.backgroundStart,
      primaryColor: CustomColors.primary,
      splashColor: CustomColors.primary.withOpacity(0.05),
      
      colorScheme: const ColorScheme.light(
        primary: CustomColors.primary,
        onPrimary: Colors.white,
        secondary: CustomColors.secondary,
        onSecondary: Colors.white,
        surface: CustomColors.backgroundStart,
        onSurface: CustomColors.textPrimary,
        error: Colors.redAccent,
        outline: CustomColors.borderLight,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: CustomColors.textPrimary, size: 22.sp),
        titleTextStyle: CustomFonts.h3,
      ),

      textTheme: TextTheme(
        headlineLarge: CustomFonts.h1,
        headlineMedium: CustomFonts.h2,
        headlineSmall: CustomFonts.h3,
        bodyLarge: CustomFonts.bodyLg,
        bodyMedium: CustomFonts.body,
        bodySmall: CustomFonts.bodySm,
      ),

      cardTheme: CardThemeData(
        color: CustomColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: CustomColors.sidebar,
        elevation: 0,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: Size(0, 48.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          textStyle: CustomFonts.button,
        ),
      ),

      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(CustomColors.sidebar),
        dataRowColor: WidgetStateProperty.all(CustomColors.card),
        headingTextStyle: CustomFonts.label.copyWith(color: CustomColors.textSecondary, fontSize: 12.sp),
        dataTextStyle: CustomFonts.body.copyWith(color: CustomColors.textPrimary),
        horizontalMargin: 24.0,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CustomColors.card,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        hintStyle: CustomFonts.caption,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: CustomColors.sidebarBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: CustomColors.sidebarBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: CustomColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class AppDecorations {
  static BoxDecoration card = BoxDecoration(
    color: CustomColors.card,
    borderRadius: BorderRadius.circular(12.r),
    border: Border.all(color: CustomColors.sidebarBorder),
  );

  static BoxDecoration sidebarItem = BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
  );

  static InputDecoration input({
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: CustomFonts.caption,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: CustomColors.card,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: CustomColors.sidebarBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: CustomColors.sidebarBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: CustomColors.primary, width: 1.5),
        ),
      );
}

class AppSpacing {
  static double get xs => 8.w;
  static double get sm => 12.w;
  static double get md => 16.w;
  static double get lg => 20.w;
  static double get xl => 24.w;
  static double get xxl => 32.w;
  static double get xxxl => 40.w;
  static double get pagePaddingH => 28.w;
  static double get pagePaddingV => 28.h;
  static double get topBarHeight => 72.h;
  static double get sidebarWidth => 280.w;
  static double get cardPadding => 24.w;
}

class AppRadius {
  static double get xs => 6.r;
  static double get sm => 8.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 20.r;
  static double get xxl => 24.r;
  static double get full => 999.r;
}

class AppShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10.r,
          offset: Offset(0, 4.h),
        ),
      ];

  static List<BoxShadow> get cardHover => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20.r,
          offset: Offset(0, 8.h),
        ),
      ];

  static List<BoxShadow> get lg => [
    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10))
  ];
  static List<BoxShadow> get md => [
    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 5))
  ];
  static List<BoxShadow> get sm => [
    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))
  ];
  static List<BoxShadow> get xs => sm;
}
