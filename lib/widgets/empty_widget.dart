import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/assets.dart';
import '../utils/custom_fonts.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.height,
    this.width,
    this.text = "Nothing Here",
    this.padding,
  });
  final double? height;
  final double? width;
  final String text;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        children: [
          Image.asset(PngAssets.empty, height: height ?? 500.h, width: width),
          Center(child: Text(text, style: CustomFonts.black22w600)),
        ],
      ),
    );
  }
}
