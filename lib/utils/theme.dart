import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'color_constant.dart';
import 'custom_fonts.dart';

export 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
export 'color_constant.dart';
export 'custom_fonts.dart';

class AppTheme {
  // Design Standards (Static getters using singleton)
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
        backgroundColor: Colors.transparent,
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

extension AppScreenUtilContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  EdgeInsets appEdgeInsets({double? horizontal, double? vertical, double? all, double? left, double? top, double? right, double? bottom}) {
    if (all != null) return EdgeInsets.all(r(all));
    return EdgeInsets.only(
      left: w(left ?? horizontal ?? 0),
      top: h(top ?? vertical ?? 0),
      right: w(right ?? horizontal ?? 0),
      bottom: h(bottom ?? vertical ?? 0),
    );
  }

  BorderRadius appBorderRadius({double? all, double? topLeft, double? topRight, double? bottomLeft, double? bottomRight}) {
    if (all != null) return BorderRadius.circular(r(all));
    return BorderRadius.only(
      topLeft: Radius.circular(r(topLeft ?? 0)),
      topRight: Radius.circular(r(topRight ?? 0)),
      bottomLeft: Radius.circular(r(bottomLeft ?? 0)),
      bottomRight: Radius.circular(r(bottomRight ?? 0)),
    );
  }
}

class AppDecorations {
  static BoxDecoration card(BuildContext context) => BoxDecoration(
    color: CustomColors.white,
    borderRadius: context.appBorderRadius(all: 12),
    border: Border.all(color: CustomColors.border, width: 1),
  );

  static Widget appBarGradient = Container(
    decoration: const BoxDecoration(
      gradient: CustomColors.purpleWhiteStateBlueLightGradient,
    ),
  );

  static BoxDecoration sidebarItem(BuildContext context) => BoxDecoration(
    borderRadius: context.appBorderRadius(all: 8),
  );

  static InputDecoration input(
    BuildContext context, {
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
    EdgeInsets? contentPadding,
    int maxLines = 1,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: context.fonts.grey12w400,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor ?? CustomColors.white,
        contentPadding: contentPadding ?? context.appEdgeInsets(horizontal: 16, vertical: 14),
        constraints: BoxConstraints(
          minHeight: context.h(52), 
          maxHeight: maxLines > 1 ? double.infinity : context.h(52)
        ),
        border: OutlineInputBorder(
          borderRadius: context.appBorderRadius(all: 12),
          borderSide: const BorderSide(color: CustomColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.appBorderRadius(all: 12),
          borderSide: const BorderSide(color: CustomColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.appBorderRadius(all: 12),
          borderSide: const BorderSide(color: CustomColors.purple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: context.appBorderRadius(all: 12),
          borderSide: const BorderSide(color: CustomColors.red, width: 1),
        ),
      );
}

class AppSpacing {
  static double xs(BuildContext context) => context.w(8);
  static double sm(BuildContext context) => context.w(12);
  static double md(BuildContext context) => context.w(16);
  static double lg(BuildContext context) => context.w(20);
  static double xl(BuildContext context) => context.w(24);
  static double xxl(BuildContext context) => context.w(32);
  static double xxxl(BuildContext context) => context.w(40);
  
  static double pagePaddingH(BuildContext context) => context.w(28);
  static double pagePaddingV(BuildContext context) => context.h(28);
  static double topBarHeight(BuildContext context) => context.h(72);
  static double cardPadding(BuildContext context) => context.w(24);

  // Legacy static getters
  static double get pagePaddingH_static => 28.w;
  static double get pagePaddingV_static => 28.h;
}

class AppRadius {
  static double xs(BuildContext context) => context.r(6);
  static double sm(BuildContext context) => context.r(8);
  static double md(BuildContext context) => context.r(12);
  static double lg(BuildContext context) => context.r(16);
  static double xl(BuildContext context) => context.r(20);
  static double xxl(BuildContext context) => context.r(24);
  static double full(BuildContext context) => context.r(999);
}

class AppShadows {
  static List<BoxShadow> card(BuildContext context) => [
        BoxShadow(
          color: CustomColors.black.withValues(alpha: 0.05),
          blurRadius: context.r(10),
          offset: Offset(0, context.h(4)),
        ),
      ];

  static List<BoxShadow> cardHover(BuildContext context) => [
        BoxShadow(
          color: CustomColors.black.withValues(alpha: 0.1),
          blurRadius: context.r(20),
          offset: Offset(0, context.h(8)),
        ),
      ];

  static List<BoxShadow> lg(BuildContext context) => [
    BoxShadow(color: CustomColors.black.withValues(alpha: 0.1), blurRadius: context.r(30), offset: Offset(0, context.h(10)))
  ];
  
  static List<BoxShadow> xs(BuildContext context) => [
    BoxShadow(color: CustomColors.black.withValues(alpha: 0.05), blurRadius: 10.r, offset: const Offset(0, 2))
  ];
}
