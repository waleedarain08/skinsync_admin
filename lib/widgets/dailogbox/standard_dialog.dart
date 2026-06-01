import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../utils/theme.dart';

class StandardDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final double? width;
  final bool showCloseIcon;

  const StandardDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.width,
    this.showCloseIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: width ?? 520.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: CustomColors.border),
          boxShadow: AppShadows.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: CustomFonts.black18w600)),
                if (showCloseIcon)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, size: 20.sp, color: CustomColors.lightGrey),
                    style: IconButton.styleFrom(
                      backgroundColor: CustomColors.whiteGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.h),
            content,
            if (actions != null) ...[
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map((action) => Padding(
                          padding: EdgeInsets.only(left: 12.w),
                          child: action,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
