import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String>? items;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dropdownItems = items ?? [];
    return SizedBox(
      height: 55.h,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: value,
        style: CustomFonts.textMain14w400,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: CustomColors.textMuted.withValues(alpha: 0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: CustomColors.textMuted.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: CustomColors.brandPrimary, width: 1.5),
          ),
        ),
        hint: Text(hint, style: CustomFonts.textMain14w400.copyWith(color: CustomColors.textMuted)),
        items: dropdownItems
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: CustomFonts.textMain14w400),
              ),
            )
            .toList(),
        onChanged: onChanged,
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.textMuted, size: 24.sp),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}
