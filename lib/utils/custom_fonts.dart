import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constant.dart';

class CustomFonts {
  static const String _fontFamily = 'Degular';

  // Heading Styles
  static TextStyle headlineLarge = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle headlineMedium = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle headlineSmall = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  // Body Styles
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  // Legacy compatibility styles
  static TextStyle textMain32w700 = headlineLarge;
  static TextStyle textMain24w700 = headlineMedium;
  static TextStyle textMain20w600 = headlineSmall;
  static TextStyle textMain16w600 = bodyLarge;
  static TextStyle textMain16w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );
  static TextStyle textMain14w400 = bodyMedium;
  static TextStyle textMain14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );
  static TextStyle textMuted12w400 = bodySmall;
  static TextStyle textMuted13w500 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );
  static TextStyle textMuted14w400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );
  static TextStyle textMain18w600 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );
  
  static TextStyle textMain12w600 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle textMain18w400 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textPrimary,
    fontFamily: _fontFamily,
  );

  static TextStyle textMuted11w400 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle textMuted16w500 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  // Full legacy support
  static TextStyle white50w600 = TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: _fontFamily);
  static TextStyle grey20w500 = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500, color: CustomColors.textSecondary, fontFamily: _fontFamily);
  static TextStyle white22w600 = TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: _fontFamily);
  static TextStyle white20w400 = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400, color: Colors.white, fontFamily: _fontFamily);
  static TextStyle white20w700 = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: _fontFamily);
  static TextStyle white18w600 = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: _fontFamily);
  static TextStyle white12w600 = TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: _fontFamily);
  static TextStyle white17w500 = TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500, color: Colors.white, fontFamily: _fontFamily);
  static TextStyle black18w400 = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle black18w500 = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle black10w600 = TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle black12w400 = TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle black20w400 = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle black20w600Underlined = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: CustomColors.deepSlate, fontFamily: _fontFamily, decoration: TextDecoration.underline);
  static TextStyle black26w600 = TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle black24w600 = TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle black22w500 = TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle black17w500 = TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle black28w600 = TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600, color: CustomColors.deepSlate, fontFamily: _fontFamily);
  static TextStyle pinkunderlined20w600 = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: CustomColors.brandPurple, fontFamily: _fontFamily, decoration: TextDecoration.underline);
  static TextStyle green16w400 = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.success, fontFamily: _fontFamily);
  static TextStyle textMain48w700 = TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w700, color: CustomColors.textPrimary, fontFamily: _fontFamily);

  // Generic color-based styles
  static TextStyle black18w600 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );
  static TextStyle white14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.surfaceWhite,
    fontFamily: _fontFamily,
  );
  
  static TextStyle white14w500 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.surfaceWhite,
    fontFamily: _fontFamily,
  );

  static TextStyle grey14w400 = TextStyle(
    fontSize: 14.sp,
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

  static TextStyle grey18w400 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.textSecondary,
    fontFamily: _fontFamily,
  );

  static TextStyle white16w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.surfaceWhite,
    fontFamily: _fontFamily,
  );
  
  static TextStyle black14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black16w600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );
  
  static TextStyle black12w600 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black14w500 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black14w400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black16w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black16w500 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black20w600 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black20w500 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black22w600 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black30w600 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w600,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );

  static TextStyle black13w400 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: CustomColors.deepSlate,
    fontFamily: _fontFamily,
  );
}
