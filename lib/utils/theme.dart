import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constant.dart';
import 'custom_fonts.dart';

export 'color_constant.dart';
export 'custom_fonts.dart';

class AppTheme {
  // Design Standards
  static double get inputHeight => 52.h;
  static double get buttonHeight => 52.h;
  static double get borderRadius => 12.r;
  static double get borderWidth => 1.0;

  static ThemeData get calmWellnessTheme => _buildTheme();

  // Legacy Aliases
  static ThemeData get lightTheme => calmWellnessTheme;
  static ThemeData get darkTheme => calmWellnessTheme;

  static ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: CustomColors.purple,
      splashColor: CustomColors.purple.withValues(alpha: 0.05),
      
      colorScheme: const ColorScheme.light(
        primary: CustomColors.purple,
        onPrimary: CustomColors.white,
        secondary: CustomColors.green,
        onSecondary: CustomColors.white,
        surface: CustomColors.white,
        onSurface: CustomColors.black,
        error: CustomColors.red,
        outline: CustomColors.border,
        surfaceContainerHighest: CustomColors.softGrey,
      ),

      iconTheme: IconThemeData(
        color: CustomColors.grey,
        size: 20.sp,
      ),

      primaryIconTheme: IconThemeData(
        color: CustomColors.purple,
        size: 20.sp,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent, // Change to transparent to allow gradient to show
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: CustomColors.black, size: 22.sp),
        titleTextStyle: CustomFonts.black18w600,
      ),

      textTheme: TextTheme(
        headlineLarge: CustomFonts.black26w700,
        headlineMedium: CustomFonts.black20w600,
        headlineSmall: CustomFonts.black18w600,
        bodyLarge: CustomFonts.black16w400,
        bodyMedium: CustomFonts.black14w400,
        bodySmall: CustomFonts.grey13w500,
        labelMedium: CustomFonts.grey12w600,
      ),

      cardTheme: CardThemeData(
        color: CustomColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: CustomColors.border, width: borderWidth),
        ),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: CustomColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.purple,
          foregroundColor: CustomColors.white,
          elevation: 0,
          minimumSize: Size(0, buttonHeight),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          textStyle: CustomFonts.white14w600,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CustomColors.purple,
          minimumSize: Size(0, buttonHeight),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          side: BorderSide(color: CustomColors.purple, width: borderWidth),
          textStyle: CustomFonts.black14w600.copyWith(color: CustomColors.purple),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CustomColors.purple,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          textStyle: CustomFonts.black14w600.copyWith(color: CustomColors.purple),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: CustomColors.purple,
        unselectedLabelColor: CustomColors.grey,
        labelStyle: CustomFonts.black14w600,
        unselectedLabelStyle: CustomFonts.grey14w500,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: CustomColors.purple,
        dividerColor: CustomColors.border,
      ),

      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(CustomColors.softGrey),
        dataRowColor: WidgetStateProperty.all(CustomColors.white),
        headingTextStyle: CustomFonts.grey12w600,
        dataTextStyle: CustomFonts.black14w400,
        horizontalMargin: 24.0,
        dividerThickness: 1,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CustomColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        hintStyle: CustomFonts.grey12w400,
        labelStyle: CustomFonts.black14w400,
        constraints: BoxConstraints(minHeight: inputHeight, maxHeight: inputHeight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: CustomColors.border, width: borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: CustomColors.border, width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: CustomColors.purple, width: borderWidth * 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: CustomColors.red, width: borderWidth),
        ),
      ),
    );
  }
}

class AppDecorations {
  static BoxDecoration card = BoxDecoration(
    color: CustomColors.white,
    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    border: Border.all(color: CustomColors.border, width: AppTheme.borderWidth),
  );

  static Widget appBarGradient = Container(
    decoration: const BoxDecoration(
      gradient: CustomColors.purpleWhiteStateBlueLightGradient,
    ),
  );

  static BoxDecoration sidebarItem = BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
  );

  static InputDecoration input({
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
    EdgeInsets? contentPadding,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: CustomFonts.grey12w400,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor ?? CustomColors.white,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        constraints: BoxConstraints(minHeight: AppTheme.inputHeight, maxHeight: AppTheme.inputHeight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: BorderSide(color: CustomColors.border, width: AppTheme.borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: BorderSide(color: CustomColors.border, width: AppTheme.borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: BorderSide(color: CustomColors.purple, width: AppTheme.borderWidth * 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: BorderSide(color: CustomColors.red, width: AppTheme.borderWidth),
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
          color: CustomColors.black.withValues(alpha: 0.05),
          blurRadius: 10.r,
          offset: Offset(0, 4.h),
        ),
      ];

  static List<BoxShadow> get cardHover => [
        BoxShadow(
          color: CustomColors.black.withValues(alpha: 0.1),
          blurRadius: 20.r,
          offset: Offset(0, 8.h),
        ),
      ];

  static List<BoxShadow> get lg => [
    BoxShadow(color: CustomColors.black.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 10))
  ];
  static List<BoxShadow> get md => [
    BoxShadow(color: CustomColors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 5))
  ];
  static List<BoxShadow> get sm => [
    BoxShadow(color: CustomColors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))
  ];
  static List<BoxShadow> get xs => sm;
}
