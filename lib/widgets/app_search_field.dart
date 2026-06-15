import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';

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
    final double effectiveMaxWidth = maxWidth ?? (isSmallScreen ? double.infinity : context.w(400));

    return Container(
      constraints: BoxConstraints(
        maxWidth: effectiveMaxWidth,
        minHeight: context.h(52),
        maxHeight: context.h(52),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autoFocus,
        readOnly: readOnly,
        onTap: onTap,
        style: context.fonts.black14w400,
        decoration: AppDecorations.input(
          context,
          hint: hintText,
          prefixIcon: prefixIcon ?? Icon(
            Icons.search_rounded,
            color: CustomColors.lightGrey,
            size: context.sp(20),
          ),
          suffixIcon: suffixIcon ?? (controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, size: context.sp(18), color: CustomColors.lightGrey),
                  onPressed: () {
                    controller?.clear();
                    if (onClear != null) onClear!();
                    if (onChanged != null) onChanged!('');
                  },
                )
              : null),
        ),
      ),
    );
  }
}
