import 'package:flutter/material.dart';
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
          Text(label, style: context.fonts.black14w600),
          context.verticalSpace(8),
          DropdownButtonFormField<T>(
            initialValue: value,
            isExpanded: true,
            items: items,
            onChanged: onChanged,
            validator: validator,
            style: context.fonts.black14w400,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.lightGrey, size: context.sp(20)),
            decoration: AppDecorations.input(context, hint: hintText),
            dropdownColor: CustomColors.white,
            borderRadius: context.appBorderRadius(all: 12),
          ),
        ],
      ),
    );
  }
}
