import 'package:flutter/material.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.height,
    this.width,
    this.text = 'Nothing here yet',
    this.subtitle,
    this.padding,
    this.icon = Icons.inbox_outlined,
  });

  final double? height;
  final double? width;
  final String text;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: CustomColors.palePurple,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: CustomColors.border),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.1,
                    child: Image.asset(PngAssets.splashLogo, width: 64.w, height: 64.w, color: CustomColors.purple),
                  ),
                  Icon(icon, size: 40.sp, color: CustomColors.lightGrey),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(text, style: context.fonts.black18w600, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(subtitle!, style: context.fonts.grey13w500, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
