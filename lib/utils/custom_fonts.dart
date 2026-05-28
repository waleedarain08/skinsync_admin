import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constant.dart';

class CustomFonts {
  static const String _fontFamily = 'Degular';

  // --- Semantic Aliases (Unified Typography System) ---
  static TextStyle get headingLarge => black26w700;
  static TextStyle get headingMedium => black20w600;
  static TextStyle get headingSmall => black18w600;
  static TextStyle get bodyLarge => black16w400;
  static TextStyle get bodyMedium => black14w400;
  static TextStyle get bodySmall => grey13w500;
  static TextStyle get captionText => grey12w400;
  static TextStyle get sidebarText => grey14w600; // Stronger for visibility
  static TextStyle get sidebarTextSelected => primary14w600;
  static TextStyle get tabText => black14w600;
  static TextStyle get labelMedium => grey12w600;

  static TextStyle grey11w600ls12 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
    letterSpacing: 1.2,
  );

  // --- Black Styles (textPrimary) ---
  static TextStyle black50w600 = TextStyle(
    fontSize: 50.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black40w900 = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w900,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black40w900ls2 = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w900,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
    letterSpacing: 2.0,
  );

  static TextStyle black36w900 = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w900,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black32w900ls2 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w900,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
    letterSpacing: 2.0,
  );

  static TextStyle black32w700 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black32w700ls2 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
    letterSpacing: 2.0,
  );

  static TextStyle black30w600 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black28w600 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black26w700 = TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black26w600 = TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black24w700 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black24w600 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black22w900 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w900,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black22w500 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black20w600 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black20w500 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black20w400 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black18w600 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black18w600lsNeg04 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
    letterSpacing: -0.4,
  );

  static TextStyle black18w500 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black18w400 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black16w700 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black16w600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black16w500 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black16w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black15w600 = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black14w700 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black14w500 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey14w500 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle black14w400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black14w400italic = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
    fontStyle: FontStyle.italic,
  );

  static TextStyle black13w600 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black13w500 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black13w400 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black12w700 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black12w600 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black12w500 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black12w400 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black12w400h14 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
    height: 1.4,
  );

  static TextStyle black11w600 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black11w400 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black10w800ls1 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w800,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
    letterSpacing: 1.0,
  );

  static TextStyle black10w700 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle black10w600 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  // --- White Styles ---
  static TextStyle white50w600 = TextStyle(
    fontSize: 50.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white40w700h11 = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: _fontFamily,
    height: 1.1,
  );

  static TextStyle white22w600 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white20w700 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white20w400 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white18w600 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white17w500 = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white16w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white70_16w400h15 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white.withValues(alpha: 0.7),
    fontFamily: _fontFamily,
    height: 1.5,
  );

  static TextStyle white90_16w600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white.withValues(alpha: 0.9),
    fontFamily: _fontFamily,
  );

  static TextStyle white14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white14w500 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white13w600 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white13w500 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white12w700 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white12w600 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white12w400 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  static TextStyle white10w600 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: _fontFamily,
  );

  // --- Grey Styles (textSecondary) ---
  static TextStyle grey20w500 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey18w400 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey16w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey14w700 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey14w600ls03 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
    letterSpacing: 0.3,
  );

  static TextStyle grey14w700ls03 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
    letterSpacing: 0.3,
  );

  static TextStyle grey14w400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey14w400h16 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
    height: 1.6,
  );

  static TextStyle grey13w600 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey13w500 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey13w500h14 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
    height: 1.4,
  );

  static TextStyle grey13w500h15 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
    height: 1.5,
  );

  static TextStyle grey13w400 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey12w700 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey12w600 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey12w400 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey11w700ls08 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
    letterSpacing: 0.8,
  );

  static TextStyle grey11w600 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey11w400 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey11w400ls05 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
    letterSpacing: 0.5,
  );

  static TextStyle grey10w700ls1 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
    letterSpacing: 1.0,
  );

  static TextStyle grey10w700 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle grey10w400 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  // --- Primary Styles ---
  static TextStyle primary32w700 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary20w600 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary18w600 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary16w600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary14w800ls3 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w800,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
    letterSpacing: 3.0,
  );

  static TextStyle primary14w700 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary14w400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary13w700 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary13w600 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary12w700 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary11w600 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary10w700 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
  );

  static TextStyle primary9w800ls1 = TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w800,
    color: CustomColors.primary,
    fontFamily: _fontFamily,
    letterSpacing: 1.0,
  );

  // --- Secondary Styles (Mint Green) ---
  static TextStyle secondary11w600 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.secondary,
    fontFamily: _fontFamily,
  );

  static TextStyle secondary10w700 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.secondary,
    fontFamily: _fontFamily,
  );

  static TextStyle secondary9w600 = TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.secondary,
    fontFamily: _fontFamily,
  );

  // --- Purple Styles (brandPurple) ---
  static TextStyle purple14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.brandPurple,
    fontFamily: _fontFamily,
  );

  static TextStyle purple13w600 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.brandPurple,
    fontFamily: _fontFamily,
  );

  // --- Cyan Styles (brandCyan) ---
  static TextStyle cyan10w700 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.brandCyan,
    fontFamily: _fontFamily,
  );

  // --- Success Styles ---
  static TextStyle success20w600 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.success,
    fontFamily: _fontFamily,
  );

  static TextStyle success14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.success,
    fontFamily: _fontFamily,
  );

  static TextStyle success13w600 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.success,
    fontFamily: _fontFamily,
  );

  static TextStyle success13w500 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.success,
    fontFamily: _fontFamily,
  );

  static TextStyle success12w400 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.success,
    fontFamily: _fontFamily,
  );

  static TextStyle success11w600 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.success,
    fontFamily: _fontFamily,
  );

  static TextStyle success10w700 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.success,
    fontFamily: _fontFamily,
  );

  static TextStyle success10w600 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.success,
    fontFamily: _fontFamily,
  );

  // --- Warning Styles ---
  static TextStyle warning14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.warning,
    fontFamily: _fontFamily,
  );

  static TextStyle warning11w600 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.warning,
    fontFamily: _fontFamily,
  );

  static TextStyle warning10w800ls1 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w800,
    color: CustomColors.warning,
    fontFamily: _fontFamily,
    letterSpacing: 1.0,
  );

  // --- Error/Red Styles ---
  static TextStyle red20w700 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.error,
    fontFamily: _fontFamily,
  );

  static TextStyle red14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.error,
    fontFamily: _fontFamily,
  );

  static TextStyle red10w600 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.error,
    fontFamily: _fontFamily,
  );

  static TextStyle error13w500 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.error,
    fontFamily: _fontFamily,
  );

  static TextStyle error11w600 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.error,
    fontFamily: _fontFamily,
  );

  static TextStyle error10w700 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.error,
    fontFamily: _fontFamily,
  );

  // --- Gold Styles (primaryGold) ---
  static TextStyle gold10w600 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.primaryGold,
    fontFamily: _fontFamily,
  );
}
