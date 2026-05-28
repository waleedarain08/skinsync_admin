import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/theme.dart';

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
      height: 48.h,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: value,
        style: CustomFonts.grey14w400,
        decoration: AppDecorations.input(hint: hint),
        hint: Text(hint, style: CustomFonts.grey13w500),
        items: dropdownItems
            .map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: CustomFonts.grey14w400)))
            .toList(),
        onChanged: onChanged,
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.textTertiary, size: 22.sp),
        dropdownColor: CustomColors.surfaceWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}
