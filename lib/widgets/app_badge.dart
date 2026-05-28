import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        return (CustomColors.successBg, CustomColors.success, CustomFonts.success11w600);
      case AppBadgeVariant.error:
        return (CustomColors.errorBg, CustomColors.error, CustomFonts.error11w600);
      case AppBadgeVariant.warning:
        return (CustomColors.warningBg, CustomColors.warning, CustomFonts.warning11w600);
      case AppBadgeVariant.info:
        return (CustomColors.infoBg, CustomColors.info, CustomFonts.primary11w600);
      case AppBadgeVariant.brand:
        return (CustomColors.selected, CustomColors.primary, CustomFonts.primary11w600);
      case AppBadgeVariant.secondary:
        return (CustomColors.primarySoft, CustomColors.secondary, CustomFonts.secondary11w600);
      case AppBadgeVariant.neutral:
        return (CustomColors.surfaceMuted, CustomColors.textSecondary, CustomFonts.grey11w600);
    }
  }
}
