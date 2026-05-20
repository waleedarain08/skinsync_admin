import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import '../utils/color_constant.dart';
import '../view_models/auth_view_model.dart';

class PhoneWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueSetter<String>? onChanged;
  final bool filled;
  final bool readOnly;

  const PhoneWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.readOnly = false,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      onChanged: onChanged,
      inputFormatters: [
        LengthLimitingTextInputFormatter(11),
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter phone number';
        } else if (value.length < 7) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
      style: CustomFonts.textMain14w400,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        filled: filled,
        fillColor: Colors.white,
        hintText: 'Enter phone number',
        hintStyle: CustomFonts.textMuted14w400,
        prefixIcon: _buildPhoneNumberPicker(context: context),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberPicker({required BuildContext context}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer(
          builder: (context, ref, _) {
            final authState = ref.watch(authViewModelProvider);
            final authNotifier = ref.read(authViewModelProvider.notifier);
            return AbsorbPointer(
              absorbing: readOnly,
              child: CountryCodePicker(
                onChanged: (country) {
                  if (country != null) {
                    authNotifier.setCountry(country);
                  }
                },
                dialogSize: Size(400.w, 500.h),
                textStyle: CustomFonts.textMain14w400,
                initialSelection: authState.country?.code ?? "US",
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                padding: EdgeInsets.zero,
              ),
            );
          },
        ),
        Container(
          height: 24.h,
          width: 1.w,
          color: Colors.grey[300],
          margin: EdgeInsets.symmetric(horizontal: 8.w),
        ),
      ],
    );
  }
}
