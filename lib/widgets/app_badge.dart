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
    final (bg, fg) = _colors();
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
            style: CustomFonts.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _colors() {
    switch (variant) {
      case AppBadgeVariant.success:
        return (CustomColors.successBg, CustomColors.success);
      case AppBadgeVariant.error:
        return (CustomColors.errorBg, CustomColors.error);
      case AppBadgeVariant.warning:
        return (CustomColors.warningBg, CustomColors.warning);
      case AppBadgeVariant.info:
        return (CustomColors.infoBg, CustomColors.info);
      case AppBadgeVariant.brand:
        return (CustomColors.selected, CustomColors.primary);
      case AppBadgeVariant.secondary:
        return (CustomColors.primarySoft, CustomColors.secondary);
      case AppBadgeVariant.neutral:
        return (CustomColors.surfaceMuted, CustomColors.textSecondary);
    }
  }
}
