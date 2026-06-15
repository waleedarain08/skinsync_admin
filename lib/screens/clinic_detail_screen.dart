import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/utils/responsive.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/auth_view_model.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/phone_widget.dart';

class ClinicDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = '/clinic-detail';
  const ClinicDetailScreen({super.key});

  @override
  ConsumerState<ClinicDetailScreen> createState() => _ClinicDetailScreenState();
}

class _ClinicDetailScreenState extends ConsumerState<ClinicDetailScreen> {
  bool _isEditMode = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _clinicNameController;
  late final TextEditingController _clinicEmailController;
  late final TextEditingController _clinicPhoneController;
  late final TextEditingController _clinicAddressController;
  late final TextEditingController _websiteController;
  late final TextEditingController _descriptionController;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedLogo;

  @override
  void initState() {
    super.initState();
    final clinic = ref.read(clinicViewModelProvider).selectedClinic;
    _clinicNameController = TextEditingController(text: clinic?.name);
    _clinicEmailController = TextEditingController(text: clinic?.email);
    _clinicPhoneController = TextEditingController(text: clinic?.phone);
    _clinicAddressController = TextEditingController(text: clinic?.address);
    _websiteController = TextEditingController(text: ''); // Added in ReqModel but not yet in ClinicModel
    _descriptionController = TextEditingController(text: clinic?.description);
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    _clinicEmailController.dispose();
    _clinicPhoneController.dispose();
    _clinicAddressController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    if (!_isEditMode) return;
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _selectedLogo = image);
  }

  Future<void> _updateClinic() async {
    if (!_formKey.currentState!.validate()) return;
    final clinic = ref.read(clinicViewModelProvider).selectedClinic;
    if (clinic == null) return;

    final selectedCountry = ref.read(authViewModelProvider).country;

    final req = RegisterClinicReqModel(
      clinicName: _clinicNameController.text.trim(),
      clinicEmail: _clinicEmailController.text.trim(),
      clinicPhone: _clinicPhoneController.text.trim(),
      clinicAddress: _clinicAddressController.text.trim(),
      cc: selectedCountry?.dialCode ?? '+1',
      country: selectedCountry?.code ?? 'US',
      clinicLogo: _selectedLogo?.path ?? clinic.logo ?? 'https://example.com/logo.png',
      website: _websiteController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    final success = await ref.read(clinicViewModelProvider.notifier).updateClinic(clinic.id!, req);
    if (success && mounted) {
      setState(() => _isEditMode = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Clinic updated successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinic = ref.watch(clinicViewModelProvider).selectedClinic;

    if (clinic == null) {
      return GradientScaffold(body: Center(child: Text('No Clinic Data Found', style: context.fonts.black16w400)));
    }

    final bool isMobile = context.isMobile;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text('Clinic Detail', style: context.fonts.black18w600),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.close : Icons.edit_outlined, color: CustomColors.black),
            onPressed: () {
              setState(() {
                if (_isEditMode) {
                  _clinicNameController.text = clinic.name ?? '';
                  _clinicEmailController.text = clinic.email ?? '';
                  _clinicPhoneController.text = clinic.phone ?? '';
                  _clinicAddressController.text = clinic.address ?? '';
                  _descriptionController.text = clinic.description ?? '';
                  _selectedLogo = null;
                }
                _isEditMode = !_isEditMode;
              });
            },
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildHeaderSection(clinic),
                  SizedBox(height: 32.h),
                  if (isMobile) ...[
                    _buildMainContent(clinic),
                    SizedBox(height: 24.h),
                    _buildStatsSidebar(clinic),
                  ] else ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildMainContent(clinic)),
                        SizedBox(width: 32.w),
                        Expanded(flex: 2, child: _buildStatsSidebar(clinic)),
                      ],
                    ),
                  ],
                  if (_isEditMode) ...[
                    SizedBox(height: 48.h),
                    SizedBox(
                      width: isMobile ? double.infinity : 240.w,
                      child: CustomPrimaryButton(
                        onTap: _updateClinic,
                        label: 'Save Changes',
                        height: 56.h,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ClinicModel clinic) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _pickLogo,
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: BorderRadius.circular(20.r),
                    border: _isEditMode ? Border.all(color: CustomColors.purple, width: 2) : null,
                    image: _selectedLogo != null
                        ? DecorationImage(
                            image: kIsWeb ? NetworkImage(_selectedLogo!.path) : FileImage(File(_selectedLogo!.path)) as ImageProvider,
                            fit: BoxFit.cover)
                        : (clinic.logo != null && clinic.logo!.isNotEmpty)
                            ? DecorationImage(image: NetworkImage(clinic.logo!), fit: BoxFit.cover)
                            : null,
                  ),
                  child: (_selectedLogo == null && (clinic.logo == null || clinic.logo!.isEmpty))
                      ? Icon(Icons.business_outlined, size: 40.sp, color: CustomColors.black)
                      : _isEditMode
                          ? DecoratedBox(
                              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20.r)),
                              child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                            )
                          : null,
                ),
              ),
              SizedBox(width: 32.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(clinic.name ?? 'N/A', style: context.fonts.black26w700, overflow: TextOverflow.ellipsis)),
                        SizedBox(width: 16.w),
                        _statusBadge(clinic.status ?? 'Active'),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(clinic.address ?? 'N/A', style: context.fonts.grey16w400),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: [
                        _infoChip(Icons.calendar_today_outlined, "Joined: ${clinic.createdAt ?? 'N/A'}"),
                        _infoChip(Icons.star_outline_rounded, "Rating: ${clinic.rating ?? '0.0'}"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(ClinicModel clinic) {
    return Column(
      children: [
        _infoSection('General Information', [
          BuildTextField(
            label: 'Clinic Name',
            controller: _clinicNameController,
            hintText: 'Enter clinic name',
            validator: Validators.empty,
            readOnly: !_isEditMode,
          ),
          SizedBox(height: 24.h),
          BuildTextField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Enter description',
            maxLines: 3,
            readOnly: !_isEditMode,
          ),
        ]),
        SizedBox(height: 24.h),
        _infoSection('Contact & Location', [
          AdaptiveLayoutRowColumn(
            heightBetween: 24.h,
            widthBetween: 16.w,
            expandedWidget: true,
            children: [
              BuildTextField(
                label: 'Email Address',
                controller: _clinicEmailController,
                hintText: 'clinic@example.com',
                validator: Validators.email,
                readOnly: !_isEditMode,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone Number', style: context.fonts.black14w600),
                  SizedBox(height: 10.h),
                  PhoneWidget(controller: _clinicPhoneController, readOnly: !_isEditMode),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          BuildTextField(
            label: 'Full Address',
            controller: _clinicAddressController,
            hintText: 'Enter address',
            validator: Validators.empty,
            readOnly: !_isEditMode,
          ),
          SizedBox(height: 24.h),
          AdaptiveLayoutRowColumn(
            heightBetween: 24.h,
            widthBetween: 16.w,
            expandedWidget: true,
            children: [
              BuildTextField(label: 'Website', controller: _websiteController, hintText: 'https://example.com', readOnly: !_isEditMode),
              BuildTextField(label: 'Plan', controller: TextEditingController(text: clinic.subscriptionPlan), hintText: 'Plan', readOnly: true),
            ],
          ),
        ]),
      ],
    );
  }

  Widget _buildStatsSidebar(ClinicModel clinic) {
    return Column(
      children: [
        _infoSection('Performance Overview', [
          _statRow(Icons.people_outline, 'Total Appointments', clinic.totalAppointments?.toString() ?? '0'),
          _statRow(Icons.medical_services_outlined, 'Total Treatments', clinic.totalTreatments?.toString() ?? '0'),
          _statRow(Icons.payments_outlined, 'Total Revenue', "\$${clinic.totalRevenue?.toStringAsFixed(0) ?? "0"}"),
        ]),
        SizedBox(height: 24.h),
        _infoSection('Subscription Info', [
          _statRow(Icons.card_membership_outlined, 'Current Plan', clinic.subscriptionPlan ?? 'Standard'),
          _statRow(Icons.access_time_rounded, 'Working Hours', clinic.workingHours ?? '09:00 - 17:00'),
          _statRow(Icons.update_rounded, 'Last Updated', clinic.updatedAt ?? 'N/A'),
        ]),
      ],
    );
  }

  Widget _infoSection(String title, List<Widget> children) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black16w700),
          SizedBox(height: 24.h),
          ...children,
        ],
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: CustomColors.grey),
              SizedBox(width: 12.w),
              Text(label, style: context.fonts.grey13w500),
            ],
          ),
          Flexible(child: Text(value, style: context.fonts.grey14w600, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive ? CustomColors.green.withValues(alpha: 0.1) : CustomColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: isActive ? context.fonts.green10w700 : context.fonts.red10w700,
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: CustomColors.grey),
          SizedBox(width: 8.w),
          Text(label, style: context.fonts.grey13w500),
        ],
      ),
    );
  }
}
