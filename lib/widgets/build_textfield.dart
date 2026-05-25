import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';

class BuildTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String?)? onChanged;
  final Widget? prefixIcon;
  final bool readOnly;

  const BuildTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.prefixIcon,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.label),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: CustomFonts.body,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          inputFormatters: [
            if (keyboardType == TextInputType.phone || keyboardType == TextInputType.number)
              FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: onChanged,
          decoration: AppDecorations.input(hint: hintText, prefixIcon: prefixIcon),
        ),
      ],
    );
  }
}
