import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/utils/responsive.dart';
import 'package:skinsync_admin/view_models/auth_view_model.dart';
import '../build_textfield.dart';
import '../phone_widget.dart';

class RegisterClinicDialogBox extends StatefulWidget {
  const RegisterClinicDialogBox({super.key});

  @override
  State<RegisterClinicDialogBox> createState() => _RegisterClinicDialogBoxState();
}

class _RegisterClinicDialogBoxState extends State<RegisterClinicDialogBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _clinicEmailController = TextEditingController();
  final TextEditingController _clinicPhoneController = TextEditingController();
  final TextEditingController _clinicAddressController = TextEditingController();
  final TextEditingController _clinicOwnerNameController = TextEditingController();
  final TextEditingController _clinicOwnerEmailController = TextEditingController();
  final TextEditingController _consultationFeeController = TextEditingController();
  final TextEditingController _initialDepositController = TextEditingController();

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void dispose() {
    _clinicNameController.dispose();
    _clinicEmailController.dispose();
    _clinicPhoneController.dispose();
    _clinicAddressController.dispose();
    _clinicOwnerNameController.dispose();
    _clinicOwnerEmailController.dispose();
    _consultationFeeController.dispose();
    _initialDepositController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.whiteColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.when(defaultValue: 120.w, mobile: () => 16.w, tablet: () => 20.w),
        vertical: 50.h,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Register New Clinic', style: CustomFonts.textMain24w700),
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
                ],
              ),
              SizedBox(height: 32.h),
              _buildSectionTitle("General Information"),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Clinic Name',
                      controller: _clinicNameController,
                      hintText: 'e.g. Glow MedSpa NY',
                      validator: Validators.empty,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Clinic Email',
                      controller: _clinicEmailController,
                      hintText: 'contact@clinic.com',
                      validator: Validators.email,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone Number", style: CustomFonts.textMain14w600),
                        SizedBox(height: 8.h),
                        PhoneWidget(controller: _clinicPhoneController),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Full Address',
                      controller: _clinicAddressController,
                      hintText: '123 Luxury St, New York, NY',
                      validator: Validators.empty,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              _buildSectionTitle("Owner Details"),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Owner Name',
                      controller: _clinicOwnerNameController,
                      hintText: 'John Doe',
                      validator: Validators.empty,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Owner Email',
                      controller: _clinicOwnerEmailController,
                      hintText: 'owner@example.com',
                      validator: Validators.email,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h)),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 16.w),
                  Consumer(
                    builder: (context, ref, _) {
                      final state = ref.watch(clinicViewModelProvider);
                      return ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate() || state.loading) return;
                          
                          final selectedCountry = ref.read(authViewModelProvider).country;
                          
                          ref.read(clinicViewModelProvider.notifier).registerClinic(
                            RegisterClinicReqModel(
                              clinicName: _clinicNameController.text,
                              clinicPhone: _clinicPhoneController.text,
                              clinicEmail: _clinicEmailController.text,
                              clinicAddress: _clinicAddressController.text,
                              ownerName: _clinicOwnerNameController.text,
                              ownerEmail: _clinicOwnerEmailController.text,
                              cc: selectedCountry?.dialCode ?? '',
                              country: selectedCountry?.name ?? '',
                            ),
                          ).then((success) {
                            if (success && context.mounted) context.pop();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.deepNavy,
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                        ),
                        child: Text(state.loading ? 'Registering...' : 'Register Clinic'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomFonts.black16w600.copyWith(color: CustomColors.primaryGold)),
        const Divider(),
      ],
    );
  }
}

class EditClinicDialogBox extends StatefulWidget {
  const EditClinicDialogBox({super.key});

  @override
  State<EditClinicDialogBox> createState() => _EditClinicDialogBoxState();
}

class _EditClinicDialogBoxState extends State<EditClinicDialogBox> {
  @override
  Widget build(BuildContext context) {
    // Similar implementation to RegisterClinicDialogBox but for editing
    return const SizedBox.shrink();
  }
}
