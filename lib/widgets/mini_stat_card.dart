import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

class MiniStatCard extends StatelessWidget {
  final String title;
  final num value;
  final IconData icon;
  final Color color;
  final String? prefix;
  final String? suffix;
  final String? growth;

  const MiniStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.prefix,
    this.suffix,
    this.growth,
  });

  String _formatNumber(double number, bool isInt) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K';
    } else {
      if (isInt) {
        return number.toInt().toString();
      }
      return number.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isInt = value is int || value == value.toInt();
    return Expanded(
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 16),
        child: Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: context.borderRadius(all: 8),
              ),
              child: Icon(icon, color: color, size: context.sp(20)),
            ),
            context.horizontalSpace(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1, end: value.toDouble()),
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.linearToEaseOut,
                    builder: (context, animatedValue, child) {
                      return Text(
                        '${prefix ?? ''}${_formatNumber(animatedValue, isInt)}${suffix ?? ''}',
                        style: context.fonts.black18w600,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  context.verticalSpace(2),
                  Text(
                    title,
                    style: context.fonts.grey11w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (growth != null) ...[
              context.horizontalSpace(8),
              AppBadge(label: growth!, variant: AppBadgeVariant.success),
            ],
          ],
        ),
      ),
    );
  }
}
