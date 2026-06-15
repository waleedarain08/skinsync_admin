import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/auth_view_model.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';

import '../build_textfield.dart';
import '../phone_widget.dart';
import 'standard_dialog.dart';

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
    return StandardDialog(
      title: 'Register New Clinic',
      width: 700.w,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('General Information'),
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
                        Text('Phone Number', style: context.fonts.black14w600),
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
              _buildSectionTitle('Owner Details'),
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
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          height: 48.h,
          child: TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.grey,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            child: const Text('Cancel'),
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(clinicViewModelProvider);
            return CustomPrimaryButton(
              onTap: () {
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
              label: 'Register Clinic',
              isLoading: state.loading,
              width: 220.w,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.fonts.black16w600.copyWith(color: CustomColors.purple)),
        const Divider(),
      ],
    );
  }
}

class EditClinicDialogBox extends StatefulWidget {
  final dynamic clinic;
  const EditClinicDialogBox({super.key, this.clinic});

  @override
  State<EditClinicDialogBox> createState() => _EditClinicDialogBoxState();
}

class _EditClinicDialogBoxState extends State<EditClinicDialogBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _clinicNameController;
  late final TextEditingController _clinicEmailController;
  late final TextEditingController _clinicPhoneController;
  late final TextEditingController _clinicAddressController;

  @override
  void initState() {
    super.initState();
    _clinicNameController = TextEditingController(text: widget.clinic?.name);
    _clinicEmailController = TextEditingController(text: widget.clinic?.email);
    _clinicPhoneController = TextEditingController(text: widget.clinic?.phone);
    _clinicAddressController = TextEditingController(text: widget.clinic?.address);
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    _clinicEmailController.dispose();
    _clinicPhoneController.dispose();
    _clinicAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Edit Clinic Details',
      width: 700.w,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('General Information'),
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
                        Text('Phone Number', style: context.fonts.black14w600),
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
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          height: 48.h,
          child: TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.grey,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            child: const Text('Cancel'),
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(clinicViewModelProvider);
            return CustomPrimaryButton(
              onTap: () {
                if (!_formKey.currentState!.validate() || state.loading) return;
                // Update clinic logic here
                context.pop();
              },
              label: 'Save Changes',
              isLoading: state.loading,
              width: 200.w,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.fonts.black16w600.copyWith(color: CustomColors.purple)),
        const Divider(),
      ],
    );
  }
}
