import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/theme.dart';
import '../utils/responsive.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final double? maxWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autoFocus;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.maxWidth,
    this.prefixIcon,
    this.suffixIcon,
    this.autoFocus = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = context.isMobile;
    
    // Responsive width logic
    final double effectiveMaxWidth = maxWidth ?? (isSmallScreen ? double.infinity : 400.w);

    return Container(
      constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autoFocus,
        readOnly: readOnly,
        onTap: onTap,
        style: CustomFonts.black14w400,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: CustomFonts.grey14w400,
          prefixIcon: prefixIcon ?? Icon(
            Icons.search_rounded,
            color: CustomColors.lightGrey,
            size: 20.sp,
          ),
          suffixIcon: suffixIcon ?? (controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, size: 18.sp, color: CustomColors.lightGrey),
                  onPressed: () {
                    controller?.clear();
                    if (onClear != null) onClear!();
                    if (onChanged != null) onChanged!('');
                  },
                )
              : null),
          filled: true,
          fillColor: CustomColors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: CustomColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: CustomColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: CustomColors.purple, width: 1.5),
          ),
        ),
      ),
    );
  }
}
