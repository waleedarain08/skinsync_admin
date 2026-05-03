import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';

import '../../models/requests/register_clinic_request_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/responsive.dart';
import '../../view_models/auth_view_model.dart';
import '../build_textfield.dart';
import '../phone_widget.dart';

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
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _consultationFeeController =
      TextEditingController();
  final TextEditingController _initialDepositController =
      TextEditingController();

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<TimeOfDay?> pickTime(TimeOfDay? time) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (time ?? TimeOfDay.now()),
    );

    return picked;
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "Select Time";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

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
      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.when(
          defaultValue: 120.w,
          mobile: () => 16.w,
          tablet: () => 20.w,
        ),
        vertical: 50.h,
      ),
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
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
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
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone Number", style: CustomFonts.black14w500),
                    SizedBox(height: 10.h),
                    PhoneWidget(controller: _clinicPhoneController),
                  ],
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
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
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
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
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
                    ),
                  ],
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
                  validator: Validators.empty,

                  label: 'Address',
                  controller: _addressController,
                  hintText: 'Enter Address',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: BuildTextField(
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: CustomColors.blueColor,
                            size: 20.sp,
                          ),
                          validator: Validators.empty,

                          label: 'Latitude',
                          controller: _latitudeController,
                          hintText: 'Enter Latitude',
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: BuildTextField(
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: CustomColors.blueColor,
                            size: 20.sp,
                          ),
                          validator: Validators.empty,

                          label: 'Longitude',
                          controller: _longitudeController,
                          hintText: 'Enter Longitude',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: BuildTextField(
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(
                            color: CustomColors.blueColor,
                            Icons.payment,
                            size: 20.sp,
                          ),
                          validator: Validators.empty,

                          label: 'consultation fee',
                          controller: _consultationFeeController,
                          hintText: 'Enter consultation fee',
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: BuildTextField(
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icon(
                            color: CustomColors.blueColor,
                            Icons.percent_outlined,
                            size: 20.sp,
                          ),
                          validator: Validators.empty,

                          label: 'Initial Deposit',
                          controller: _initialDepositController,
                          hintText: 'Enter initial deposit',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text("Availability", style: CustomFonts.black14w500),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start Time:",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        pickTime(startTime).then((picked) {
                          if (picked != null) {
                            setState(() {
                              startTime = picked;
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            formatTime(startTime),

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    "End Time:",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        pickTime(endTime).then((picked) {
                          if (picked != null) {
                            setState(() {
                              endTime = picked;
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            formatTime(endTime),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
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

                            final selectedCountry = ref
                                .watch(authViewModelProvider)
                                .country;

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
                                    cc: selectedCountry?.dialCode ?? '',
                                    country: selectedCountry?.name ?? '',
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

class EditClinicDailogBox extends StatefulWidget {
  const EditClinicDailogBox({super.key});

  @override
  State<EditClinicDailogBox> createState() => _EditClinicDailogBoxState();
}

class _EditClinicDailogBoxState extends State<EditClinicDailogBox> {
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
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _consultationFeeController =
      TextEditingController();
  final TextEditingController _initialDepositController =
      TextEditingController();

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<TimeOfDay?> pickTime(TimeOfDay? time) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (time ?? TimeOfDay.now()),
    );

    return picked;
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "Select Time";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

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
                  Text('Edit Clinic', style: CustomFonts.black22w600),
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
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  prefixIcon: Icon(
                    Icons.email,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: Validators.empty,

                  label: 'Address',
                  controller: _addressController,
                  hintText: 'Enter Address',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  keyboardType: TextInputType.number,
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: Validators.empty,

                  label: 'Latitude',
                  controller: _latitudeController,
                  hintText: 'Enter Latitude',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  keyboardType: TextInputType.number,
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: Validators.empty,

                  label: 'Longitude',
                  controller: _longitudeController,
                  hintText: 'Enter Longitude',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  keyboardType: TextInputType.number,
                  prefixIcon: Icon(
                    color: CustomColors.blueColor,
                    Icons.payment,
                    size: 20.sp,
                  ),
                  validator: Validators.empty,

                  label: 'consultation fee',
                  controller: _consultationFeeController,
                  hintText: 'Enter consultation fee',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    color: CustomColors.blueColor,
                    Icons.percent_outlined,
                    size: 20.sp,
                  ),
                  validator: Validators.empty,

                  label: 'Initial Deposit',
                  controller: _initialDepositController,
                  hintText: 'Enter initial deposit',
                ),
              ),
              SizedBox(height: 8.h),
              Text("Availability", style: CustomFonts.black14w500),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start Time:",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        pickTime(startTime).then((picked) {
                          if (picked != null) {
                            setState(() {
                              startTime = picked;
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            formatTime(startTime),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    "End Time:",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        pickTime(endTime).then((picked) {
                          if (picked != null) {
                            setState(() {
                              endTime = picked;
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            formatTime(endTime),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
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
