import 'package:dropdown_button2/dropdown_button2.dart';
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
    final dropdownItems = items ?? []; // fallback to empty list
    return SizedBox(
      height: 55.h,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        value: value,
        style: CustomFonts.black16w400,
        decoration: InputDecoration(
          fillColor: CustomColors.fillColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 15.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: CustomColors.fillColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: CustomColors.fillColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: CustomColors.fillColor),
          ),
        ),
        hint: Text(hint, style: CustomFonts.black16w400),
        items: dropdownItems
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: CustomFonts.black18w400),
              ),
            )
            .toList(),
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(height: 55.h, width: null),
        menuItemStyleData: MenuItemStyleData(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: Colors.white,
          ),
          maxHeight: 300.h,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down, color: Color(0xff494949)),
          iconSize: 24.sp,
        ),
      ),
    );
  }
}
