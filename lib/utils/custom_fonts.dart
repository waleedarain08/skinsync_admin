import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'color_constant.dart';

extension CustomFontsExtension on BuildContext {
  CustomFontsGetter get fonts => CustomFontsGetter(this);
}

class CustomFontsGetter {
  final BuildContext context;
  CustomFontsGetter(this.context);

  static const String _fontFamily = 'Geist';

  TextStyle get grey11w600ls12 => TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily, letterSpacing: 1.2);
  TextStyle get black50w600 => TextStyle(fontSize: context.sp(50), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black40w700 => TextStyle(fontSize: context.sp(40), fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black36w900 => TextStyle(fontSize: context.sp(36), fontWeight: FontWeight.w900, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black32w700 => TextStyle(fontSize: context.sp(32), fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black30w600 => TextStyle(fontSize: context.sp(30), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black26w700 => TextStyle(fontSize: context.sp(26), fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black20w600 => TextStyle(fontSize: context.sp(20), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black18w600 => TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black16w700 => TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black16w600 => TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black16w400 => TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black14w700 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black14w600 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black14w400 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black12w400 => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black13w600 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black13w500 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black12w600 => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black13w400 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black16w500 => TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w500, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black20w500 => TextStyle(fontSize: context.sp(20), fontWeight: FontWeight.w500, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black14w500 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w500, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black10w600 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black24w700 => TextStyle(fontSize: context.sp(24), fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black11w400 => TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  TextStyle get black12w400h14 => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily, height: 1.4);
  TextStyle get black18w600lsNeg04 => TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily, letterSpacing: -0.4);

  TextStyle get white12w700 => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w700, color: CustomColors.white, fontFamily: _fontFamily);
  TextStyle get white14w600 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600, color: CustomColors.white, fontFamily: _fontFamily);
  TextStyle get white12w400 => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w400, color: CustomColors.white, fontFamily: _fontFamily);
  TextStyle get white16w400 => TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w400, color: CustomColors.white, fontFamily: _fontFamily);
  TextStyle get white10w600 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w600, color: CustomColors.white, fontFamily: _fontFamily);
  TextStyle get white10w700 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w700, color: CustomColors.white, fontFamily: _fontFamily);

  TextStyle get grey16w400 => TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey14w400 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey14w400h16 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily, height: 1.6);
  TextStyle get grey14w600 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey14w600ls03 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily, letterSpacing: 0.3);
  TextStyle get grey13w500 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey13w500h15 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500, color: CustomColors.grey, fontFamily: _fontFamily, height: 1.5);
  TextStyle get grey12w400 => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey11w600 => TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey10w700 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w700, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey10w400 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey13w600 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey12w600 => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey14w500 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w500, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey12w700 => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w700, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey18w400 => TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey13w500h14 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500, color: CustomColors.grey, fontFamily: _fontFamily, height: 1.4);
  TextStyle get grey11w400 => TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  TextStyle get grey10w700ls1 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w700, color: CustomColors.grey, fontFamily: _fontFamily, letterSpacing: 1.0);

  TextStyle get purple14w600 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600, color: CustomColors.purple, fontFamily: _fontFamily);
  TextStyle get purple14w700 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w700, color: CustomColors.purple, fontFamily: _fontFamily);
  TextStyle get purple11w600 => TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w600, color: CustomColors.purple, fontFamily: _fontFamily);
  TextStyle get purple9w800ls1 => TextStyle(fontSize: context.sp(9), fontWeight: FontWeight.w800, color: CustomColors.purple, fontFamily: _fontFamily, letterSpacing: 1.0);
  TextStyle get purple16w600 => TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w600, color: CustomColors.purple, fontFamily: _fontFamily);
  TextStyle get purple16w700 => TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w700, color: CustomColors.purple, fontFamily: _fontFamily);
  TextStyle get purple13w700 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w700, color: CustomColors.purple, fontFamily: _fontFamily);
  TextStyle get purple12w700 => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w700, color: CustomColors.purple, fontFamily: _fontFamily);
  TextStyle get purple13w600 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w600, color: CustomColors.purple, fontFamily: _fontFamily);

  TextStyle get green11w600 => TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  TextStyle get green10w700 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w700, color: CustomColors.green, fontFamily: _fontFamily);
  TextStyle get green9w600 => TextStyle(fontSize: context.sp(9), fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  TextStyle get green20w600 => TextStyle(fontSize: context.sp(20), fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  TextStyle get green14w600 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  TextStyle get green13w600 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  TextStyle get green10w600 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  TextStyle get green13w500 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500, color: CustomColors.green, fontFamily: _fontFamily);

  TextStyle get amber11w600 => TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w600, color: CustomColors.amber, fontFamily: _fontFamily);
  TextStyle get amber14w600 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600, color: CustomColors.amber, fontFamily: _fontFamily);
  TextStyle get amber10w800ls1 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w800, color: CustomColors.amber, fontFamily: _fontFamily, letterSpacing: 1.0);

  TextStyle get red11w600 => TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w600, color: CustomColors.red, fontFamily: _fontFamily);
  TextStyle get red10w700 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w700, color: CustomColors.red, fontFamily: _fontFamily);
  TextStyle get red13w500 => TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500, color: CustomColors.red, fontFamily: _fontFamily);
  TextStyle get red14w600 => TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600, color: CustomColors.red, fontFamily: _fontFamily);
  TextStyle get red10w600 => TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w600, color: CustomColors.red, fontFamily: _fontFamily);
}

class CustomFonts {
  static const String _fontFamily = 'Geist';

  // --- BACKWARD COMPATIBILITY ---
  static TextStyle get grey11w600ls12 => TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily, letterSpacing: 1.2);
  static TextStyle get black50w600 => TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black40w700 => TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black36w900 => TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w900, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black32w700 => TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black30w600 => TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black26w700 => TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black20w600 => TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black18w600 => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black16w700 => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black16w600 => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black16w400 => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black14w700 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black14w600 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black14w400 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black12w400 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black13w600 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black13w500 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black12w600 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black24w700 => TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black11w400 => TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black13w400 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black16w500 => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black20w500 => TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black14w500 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black10w600 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily);
  static TextStyle get black12w400h14 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.black, fontFamily: _fontFamily, height: 1.4);
  static TextStyle get black18w600lsNeg04 => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: CustomColors.black, fontFamily: _fontFamily, letterSpacing: -0.4);

  static TextStyle get white12w700 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: CustomColors.white, fontFamily: _fontFamily);
  static TextStyle get white14w600 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: CustomColors.white, fontFamily: _fontFamily);
  static TextStyle get white12w400 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.white, fontFamily: _fontFamily);
  static TextStyle get white16w400 => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.white, fontFamily: _fontFamily);
  static TextStyle get white10w600 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: CustomColors.white, fontFamily: _fontFamily);
  static TextStyle get white10w700 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: CustomColors.white, fontFamily: _fontFamily);

  static TextStyle get grey16w400 => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey14w400 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey14w400h16 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily, height: 1.6);
  static TextStyle get grey14w600 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey14w600ls03 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily, letterSpacing: 0.3);
  static TextStyle get grey13w500 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey13w500h15 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: CustomColors.grey, fontFamily: _fontFamily, height: 1.5);
  static TextStyle get grey12w400 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey11w600 => TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey10w700 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey10w400 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey13w600 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey12w600 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey14w500 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey12w700 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey18w400 => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey13w500h14 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: CustomColors.grey, fontFamily: _fontFamily, height: 1.4);
  static TextStyle get grey11w400 => TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: CustomColors.grey, fontFamily: _fontFamily);
  static TextStyle get grey10w700ls1 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: CustomColors.grey, fontFamily: _fontFamily, letterSpacing: 1.0);

  static TextStyle get purple14w600 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: CustomColors.purple, fontFamily: _fontFamily);
  static TextStyle get purple14w700 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: CustomColors.purple, fontFamily: _fontFamily);
  static TextStyle get purple11w600 => TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: CustomColors.purple, fontFamily: _fontFamily);
  static TextStyle get purple9w800ls1 => TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w800, color: CustomColors.purple, fontFamily: _fontFamily, letterSpacing: 1.0);
  static TextStyle get purple16w600 => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: CustomColors.purple, fontFamily: _fontFamily);
  static TextStyle get purple16w700 => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: CustomColors.purple, fontFamily: _fontFamily);
  static TextStyle get purple13w700 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: CustomColors.purple, fontFamily: _fontFamily);
  static TextStyle get purple12w700 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: CustomColors.purple, fontFamily: _fontFamily);
  static TextStyle get purple13w600 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: CustomColors.purple, fontFamily: _fontFamily);

  static TextStyle get green11w600 => TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  static TextStyle get green10w700 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: CustomColors.green, fontFamily: _fontFamily);
  static TextStyle get green9w600 => TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  static TextStyle get green20w600 => TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  static TextStyle get green14w600 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  static TextStyle get green13w600 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  static TextStyle get green10w600 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: CustomColors.green, fontFamily: _fontFamily);
  static TextStyle get green13w500 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: CustomColors.green, fontFamily: _fontFamily);

  static TextStyle get amber11w600 => TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: CustomColors.amber, fontFamily: _fontFamily);
  static TextStyle get amber14w600 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: CustomColors.amber, fontFamily: _fontFamily);
  static TextStyle get amber10w800ls1 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: CustomColors.amber, fontFamily: _fontFamily, letterSpacing: 1.0);

  static TextStyle get red11w600 => TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: CustomColors.red, fontFamily: _fontFamily);
  static TextStyle get red10w700 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: CustomColors.red, fontFamily: _fontFamily);
  static TextStyle get red13w500 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: CustomColors.red, fontFamily: _fontFamily);
  static TextStyle get red14w600 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: CustomColors.red, fontFamily: _fontFamily);
  static TextStyle get red10w600 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: CustomColors.red, fontFamily: _fontFamily);
}
