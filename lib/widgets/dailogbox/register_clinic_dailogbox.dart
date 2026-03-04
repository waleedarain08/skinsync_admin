import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';

import '../../models/requests/register_clinic_request_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../build_textfield.dart';

class RegisterClinicDailogbox extends StatefulWidget {
  const RegisterClinicDailogbox({super.key});

  @override
  State<RegisterClinicDailogbox> createState() =>
      _RegisterClinicDailogboxState();
}

class _RegisterClinicDailogboxState extends State<RegisterClinicDailogbox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _clinicNameController = TextEditingController();

  final TextEditingController _clinicEmailController = TextEditingController();

  final TextEditingController _clinicPhoneController = TextEditingController();

  final TextEditingController _clinicAddressController =
      TextEditingController();

  final TextEditingController _clinicOwnerNameController =
      TextEditingController();

  final TextEditingController _clinicOwnerEmailController =
      TextEditingController();

  @override
  void dispose() {
    _clinicNameController.dispose();
    _clinicEmailController.dispose();
    _clinicPhoneController.dispose();
    _clinicAddressController.dispose();
    _clinicOwnerNameController.dispose();
    _clinicOwnerEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text('Register Clinic', style: CustomFonts.black22w600),
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
              // SizedBox(height: 24.h),
              // Text('Treatment Details', style: CustomFonts.black22w600),
              SizedBox(height: 40.h),

              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  prefixIcon: Icon(
                    Icons.medical_information,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: Validators.empty,

                  label: 'Clinic Name',
                  controller: _clinicNameController,
                  hintText: 'Enter clinic name',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  prefixIcon: Icon(
                    Icons.email,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: Validators.email,

                  label: 'Clinic Email',
                  controller: _clinicEmailController,
                  hintText: 'Enter clinic email',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: Validators.phone,

                  label: 'Clinic Phone',
                  controller: _clinicPhoneController,
                  hintText: 'Enter clinic phone number',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: Validators.empty,

                  label: 'Clinic Address',
                  controller: _clinicAddressController,
                  hintText: 'Enter clinic address',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  prefixIcon: Icon(
                    Icons.person,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: Validators.empty,

                  label: 'Clinic Owner Name',
                  controller: _clinicOwnerNameController,
                  hintText: 'Enter clinic owner name',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  prefixIcon: Icon(
                    Icons.email,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: Validators.email,

                  label: 'Owner Email',
                  controller: _clinicOwnerEmailController,
                  hintText: 'Enter owner email',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        return ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            ref
                                .read(clinicViewModelProvider.notifier)
                                .registerClinic(
                                  RegisterClinicReqModel(
                                    clinicName: _clinicNameController.text,
                                    clinicPhone: _clinicPhoneController.text,
                                    clinicEmail: _clinicEmailController.text,
                                    clinicAddress:
                                        _clinicAddressController.text,
                                    ownerName: _clinicOwnerNameController.text,
                                    ownerEmail:
                                        _clinicOwnerEmailController.text,
                                  ),
                                )
                                .then((value) {
                                  if (value && context.mounted) {
                                    context.pop();
                                  }
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                          ),
                          child: Text(
                            ref.watch(clinicViewModelProvider).loading
                                ? 'Creating...'
                                : 'Create',
                            style: CustomFonts.white14w500,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(), // close dialog
                      child: Text('Cancel', style: CustomFonts.black18w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
