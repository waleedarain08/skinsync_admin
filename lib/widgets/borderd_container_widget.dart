import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';

class BorderdContainerWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color borderColor;
  final Color backgroundColor;
  final double? height;
  final double? width;
  final double borderWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const BorderdContainerWidget({
    super.key,
    required this.child,
    this.borderRadius = 10,
    this.borderColor = CustomColors.borderColor,
    this.backgroundColor = CustomColors.whiteColor,
    this.height,
    this.width,
    this.borderWidth = 1,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? EdgeInsets.all(20.w),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: child,
    );
  }
}
