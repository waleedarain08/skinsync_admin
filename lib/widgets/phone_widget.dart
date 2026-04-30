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

  final bool showLabel;
  final bool filled;
  final bool removeValidation;
  final bool isEditable;

  PhoneWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.isEditable = false,
    this.showLabel = true,
    this.filled = false,
    this.removeValidation = false,
  });

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.h,
      children: [
        TextFormField(
          readOnly: isEditable,
          // enabled: isEditable,
          controller: controller,
          // focusNode: _focusNode,
          onChanged: onChanged,
          autofocus: false,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            } else if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontFamily: "General Sans"),
          onTapOutside: (_) {
            _focusNode.unfocus();
          },
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            filled: filled,
            fillColor: CustomColors.blackColor,
            hintText: '921 - 2341 -99908',
            // hintStyle:
            //     Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(
            //           // color: Colors.amber
            //           fontFamily: "General Sans",
            //         ),
            hintStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            prefixIcon: _buildPhoneNumberPicker(context: context),
          ),
        ),
      ],
    );
  }

  IntrinsicHeight _buildPhoneNumberPicker({required BuildContext context}) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {},
            child: Consumer(
              builder: (context, ref, _) {
                final authState = ref.watch(authViewModelProvider);
                final authNotifier = ref.read(authViewModelProvider.notifier);
                return CountryCodePicker(
                  onChanged: (country) {
                    if (country != null) {
                      authNotifier.setCountry(country);
                    }
                  },
                  dialogSize: Size(400.w, 600.w),
                  textStyle: CustomFonts.black14w500,

                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: authState.country?.code ?? "GB",

                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.3.h),
            child: const VerticalDivider(
              color: Color(0xffE2E5E8),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
