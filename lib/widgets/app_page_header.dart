import 'package:flutter/material.dart';
import '../utils/theme.dart';

class AppPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.fonts.black26w700),
              if (subtitle != null) ...[
                SizedBox(height: 6.h),
                Text(subtitle!, style: context.fonts.grey13w500),
              ],
            ],
          ),
        ),
        if (actions != null) ...actions!,
      ],
    );
  }
}
