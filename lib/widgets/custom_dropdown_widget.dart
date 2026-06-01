import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/theme.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final double? width;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: CustomFonts.black14w600),
          SizedBox(height: 8.h),
          DropdownButtonFormField<T>(
            initialValue: value,
            items: items,
            onChanged: onChanged,
            validator: validator,
            style: CustomFonts.black14w400,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.lightGrey, size: 20.sp),
            decoration: AppDecorations.input(hint: hintText),
            dropdownColor: CustomColors.white,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
        ],
      ),
    );
  }
}
