import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                color: CustomColors.primarySoft,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: CustomColors.borderLight),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.1,
                    child: Image.asset(PngAssets.splashLogo, width: 64.w, height: 64.w, color: CustomColors.primary),
                  ),
                  Icon(icon, size: 40.sp, color: CustomColors.textTertiary),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(text, style: CustomFonts.h3, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(subtitle!, style: CustomFonts.bodySm, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
