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
  final Widget? suffixIcon;
  final bool readOnly;
  final bool obscureText;
  final double? width;
  final String? tooltip;

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
    this.suffixIcon,
    this.readOnly = false,
    this.obscureText = false,
    this.width,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(label, style: context.fonts.black14w600),
              ),
              if (tooltip != null) ...[
                context.horizontalSpace(6),
                Tooltip(
                  message: tooltip!,
                  child: const Icon(Icons.info_outline_rounded, size: 16, color: CustomColors.grey),
                ),
              ],
            ],
          ),
          context.verticalSpace(8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            obscureText: obscureText,
            style: context.fonts.black14w400,
            keyboardType: keyboardType,
            validator: validator,
            readOnly: readOnly,
            inputFormatters: [
              if (keyboardType == TextInputType.phone || keyboardType == TextInputType.number)
                FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: onChanged,
            decoration: AppDecorations.input(
              context,
              hint: hintText, 
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  }
}
