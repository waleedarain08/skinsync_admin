import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';

class StatusToggleSwitch extends StatelessWidget {
  final String? status;
  final void Function(String newStatus) onChanged;
  final double? width;
  final double? height;

  const StatusToggleSwitch({
    super.key,
    this.status,
    required this.onChanged,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final currentStatus = status ?? 'Active';
    final bool isDraft = currentStatus.toLowerCase() == 'draft';
    final bool isActive = currentStatus.toLowerCase() == 'active';
    final Color badgeColor = isDraft
        ? CustomColors.grey
        : (isActive ? CustomColors.green : CustomColors.red);

    if (isDraft) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: context.appEdgeInsets(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
          ),
          child: Text(
            'DRAFT',
            style:
                context.fonts.grey12w600.copyWith(color: CustomColors.grey),
          ),
        ),
      );
    }

    // Responsive sizing: clamp between sensible min/max values
    // so it never stretches to fill a parent but still adapts to screen size.
    final double screenW = MediaQuery.sizeOf(context).width;
    final double screenH = MediaQuery.sizeOf(context).height;

    final double computedWidth = width ??
        (screenW * 0.12).clamp(90.0, 130.0); // e.g. 90–130px across screens
    final double computedHeight = height ??
        (screenH * 0.04).clamp(28.0, 38.0); // e.g. 28–38px across screens

    final double iconSpacing = computedWidth * 0.28;

    return UnconstrainedBox( // 👈 prevents the widget from inheriting parent constraints
      child: SizedBox(
        width: computedWidth,
        height: computedHeight,
        child: AnimatedToggleSwitch<bool>.dual(
          current: isActive,
          first: false,
          second: true,
          onChanged: (val) => onChanged(val ? 'Active' : 'Inactive'),
          styleBuilder: (val) => ToggleStyle(
            indicatorColor: val ? CustomColors.green : CustomColors.red,
            backgroundColor: val
                ? CustomColors.green.withValues(alpha: 0.1)
                : CustomColors.red.withValues(alpha: 0.1),
            borderColor: val
                ? CustomColors.green.withValues(alpha: 0.3)
                : CustomColors.red.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          spacing: iconSpacing,
          iconBuilder: (val) => val
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
              : const Icon(Icons.close_rounded, color: Colors.white, size: 12),
          textBuilder: (val) => val
              ? Center(
                  child: Text(
                    'Active',
                    style: TextStyle(
                      color: CustomColors.green,
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'Inactive',
                    style: TextStyle(
                      color: CustomColors.red,
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}