import 'package:flutter/material.dart';
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
    final (bg, fg, textStyle) = _badgeStyle(context);
    return Container(
      padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full(context)),
        border: Border.all(color: fg.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: context.sp(12), color: fg),
            context.horizontalSpace(4),
          ],
          Text(
            label,
            style: textStyle,
          ),
        ],
      ),
    );
  }

  (Color, Color, TextStyle) _badgeStyle(BuildContext context) {
    switch (variant) {
      case AppBadgeVariant.success:
        return (CustomColors.successBg, CustomColors.green, context.fonts.green11w600);
      case AppBadgeVariant.error:
        return (CustomColors.errorBg, CustomColors.red, context.fonts.red11w600);
      case AppBadgeVariant.warning:
        return (CustomColors.warningBg, CustomColors.amber, context.fonts.amber11w600);
      case AppBadgeVariant.info:
        return (CustomColors.infoBg, CustomColors.blue, context.fonts.purple11w600);
      case AppBadgeVariant.brand:
        return (CustomColors.palePurple, CustomColors.purple, context.fonts.purple11w600);
      case AppBadgeVariant.secondary:
        return (CustomColors.palePurple, CustomColors.green, context.fonts.green11w600);
      case AppBadgeVariant.neutral:
        return (CustomColors.softGrey, CustomColors.grey, context.fonts.grey11w600);
    }
  }
}
