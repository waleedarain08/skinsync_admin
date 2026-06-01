import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/theme.dart';

enum AppBadgeVariant { success, error, warning, info, neutral, brand, secondary }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg, textStyle) = _badgeStyle();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: fg.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: fg),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: textStyle,
          ),
        ],
      ),
    );
  }

  (Color, Color, TextStyle) _badgeStyle() {
    switch (variant) {
      case AppBadgeVariant.success:
        return (CustomColors.paleGreen, CustomColors.green, CustomFonts.green11w600);
      case AppBadgeVariant.error:
        return (CustomColors.paleRed, CustomColors.red, CustomFonts.red11w600);
      case AppBadgeVariant.warning:
        return (CustomColors.paleAmber, CustomColors.amber, CustomFonts.amber11w600);
      case AppBadgeVariant.info:
        return (CustomColors.paleBlue, CustomColors.blue, CustomFonts.purple11w600);
      case AppBadgeVariant.brand:
        return (CustomColors.palePurple, CustomColors.purple, CustomFonts.purple11w600);
      case AppBadgeVariant.secondary:
        return (CustomColors.palePurple, CustomColors.green, CustomFonts.green11w600);
      case AppBadgeVariant.neutral:
        return (CustomColors.softGrey, CustomColors.grey, CustomFonts.grey11w600);
    }
  }
}
