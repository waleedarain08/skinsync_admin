import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';

class StatusToggleSwitch extends StatelessWidget {
  final String? status;
  final void Function(String newStatus) onChanged;
  final double width;
  final double height;

  const StatusToggleSwitch({
    super.key,
    this.status,
    required this.onChanged,
    required this.width,
    required this.height,
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

    return SizedBox(
      width: width,
      child: AnimatedToggleSwitch<bool>.dual(
        height: height,
        spacing: context.sp(10),
        indicatorSize: Size.fromWidth(height),
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
        iconBuilder: (val) => val
            ? Icon(Icons.check_rounded, color: Colors.white, size: context.sp(12))
            : Icon(Icons.close_rounded, color: Colors.white, size: context.sp(12)),
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
    );
  }
}