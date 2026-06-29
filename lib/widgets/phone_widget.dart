import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';

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
      style: context.fonts.black14w400,
      keyboardType: TextInputType.phone,
      decoration: AppDecorations.input(
        context,
        fillColor: CustomColors.white,
        hint: 'Enter phone number',
        prefixIcon: _buildPhoneNumberPicker(context: context),
      ),
      // decoration: InputDecoration(
      //   filled: filled,
      //   fillColor: CustomColors.white,
      //   hintText: 'Enter phone number',
      //   hintStyle: context.fonts.grey14w400,
      //   constraints: BoxConstraints(minHeight: context.h(65)),
      //   prefixIcon: _buildPhoneNumberPicker(context: context),
      //   // contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12.r),
      //     borderSide: const BorderSide(color: CustomColors.border, width: 1),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12.r),
      //     borderSide: const BorderSide(color: CustomColors.border, width: 1),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12.r),
      //     borderSide: const BorderSide(color: CustomColors.purple, width: 1),
      //   ),
      // ),
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
                onChanged: authNotifier.setCountry,
                dialogSize: Size(400.w, 500.h),
                textStyle: context.fonts.black14w400,
                initialSelection: authState.country.code,
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
          color: CustomColors.border,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
        ),
      ],
    );
  }
}
