import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/auth_view_model.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/phone_widget.dart';

class AddNewClinicScreen extends ConsumerStatefulWidget {
  static const String routeName = '/add-new-clinic';
  final InviteClinicModel? invitedClinic;
  const AddNewClinicScreen({super.key, this.invitedClinic});

  @override
  ConsumerState<AddNewClinicScreen> createState() => _AddNewClinicScreenState();
}

class _AddNewClinicScreenState extends ConsumerState<AddNewClinicScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _clinicEmailController = TextEditingController();
  final TextEditingController _clinicPhoneController = TextEditingController();
  final TextEditingController _clinicAddressController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedLogo;

  final List<AvailabilityEntry> _availabilityEntries = [
    AvailabilityEntry(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.invitedClinic != null) {
      _prefillData(widget.invitedClinic!);
    }
  }

  void _prefillData(InviteClinicModel clinic) {
    _clinicNameController.text = clinic.name;
    _clinicEmailController.text = clinic.email;
    _clinicPhoneController.text = clinic.phone;
    _clinicAddressController.text = clinic.address;
    _latController.text = clinic.lat ?? '';
    _longController.text = clinic.long ?? '';
    _ownerNameController.text = clinic.ownerName ?? '';
    _ownerEmailController.text = clinic.ownerEmail ?? '';
    _websiteController.text = clinic.website ?? '';
    _descriptionController.text = clinic.description ?? clinic.notes ?? '';
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    _clinicEmailController.dispose();
    _clinicPhoneController.dispose();
    _clinicAddressController.dispose();
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _latController.dispose();
    _longController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Clinic Logo', style: context.fonts.black20w600),
              SizedBox(height: 20.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(Icons.photo_library_outlined, color: Colors.blue),
                ),
                title: Text('Choose from Gallery', style: context.fonts.black14w600),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (image != null) setState(() => _selectedLogo = image);
                },
              ),
              SizedBox(height: 8.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.green),
                ),
                title: Text('Take a Photo', style: context.fonts.black14w600),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
                  if (image != null) setState(() => _selectedLogo = image);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addAvailability() {
    setState(() {
      _availabilityEntries.add(AvailabilityEntry());
    });
  }

  void _removeAvailability(int index) {
    if (_availabilityEntries.length > 1) {
      setState(() {
        _availabilityEntries.removeAt(index);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final selectedCountry = ref.read(authViewModelProvider).country;
    if (selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a country in the phone field')),
      );
      return;
    }

    final List<AvailabilityModel> availability = _availabilityEntries.map((e) {
      String formatTimeOfDay(TimeOfDay? tod) {
        if (tod == null) return '00:00';
        final hour = tod.hour.toString().padLeft(2, '0');
        final minute = tod.minute.toString().padLeft(2, '0');
        return '$hour:$minute';
      }

      return AvailabilityModel(
        openTime: formatTimeOfDay(e.openTime),
        closeTime: formatTimeOfDay(e.closeTime),
        days: e.selectedDays.toList(),
      );
    }).toList();

    final req = RegisterClinicReqModel(
      clinicName: _clinicNameController.text.trim(),
      clinicEmail: _clinicEmailController.text.trim(),
      clinicPhone: _clinicPhoneController.text.trim(),
      clinicAddress: _clinicAddressController.text.trim(),
      clinicLogo: _selectedLogo?.path ?? widget.invitedClinic?.logo ?? 'https://example.com/logo.png', // Use prefilled logo if no new one selected
      ownerName: _ownerNameController.text.trim(),
      ownerEmail: _ownerEmailController.text.trim(),
      cc: selectedCountry.dialCode ?? '+1',
      country: selectedCountry.code ?? 'US',
      lat: _latController.text.trim(),
      long: _longController.text.trim(),
      website: _websiteController.text.trim(),
      description: _descriptionController.text.trim(),
      availability: availability,
    );

    final success = await ref.read(clinicViewModelProvider.notifier).registerClinic(req);
    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text('Add New Clinic', style: context.fonts.black20w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    title: 'Clinic Logo',
                    children: [
                      _buildLogoPicker(),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  _buildSectionCard(
                    title: 'Clinic Details',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Clinic Name',
                              controller: _clinicNameController,
                              hintText: 'e.g. ABC Skin Clinic',
                              validator: Validators.empty,
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: BuildTextField(
                              label: 'Clinic Email',
                              controller: _clinicEmailController,
                              hintText: 'clinic@example.com',
                              validator: Validators.email,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Phone Number (Selection sets Country & CC)', style: context.fonts.black14w600),
                                SizedBox(height: 10.h),
                                PhoneWidget(
                                  controller: _clinicPhoneController,
                                  filled: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 24.w),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      BuildTextField(
                        label: 'Clinic Address',
                        controller: _clinicAddressController,
                        hintText: '123 Main Street, New York, NY 10001',
                        validator: Validators.empty,
                      ),
                      SizedBox(height: 24.h),
                      BuildTextField(
                        label: 'Website',
                        controller: _websiteController,
                        hintText: 'https://example.com',
                      ),
                      SizedBox(height: 24.h),
                      BuildTextField(
                        label: 'Description',
                        controller: _descriptionController,
                        hintText: 'Brief description of the clinic',
                        maxLines: 3,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Latitude',
                              controller: _latController,
                              hintText: 'e.g. 40.7128',
                              validator: Validators.empty,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              prefixIcon: const Icon(Icons.location_on_outlined, color: CustomColors.grey),
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: BuildTextField(
                              label: 'Longitude',
                              controller: _longController,
                              hintText: 'e.g. -74.0060',
                              validator: Validators.empty,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              prefixIcon: const Icon(Icons.location_on_outlined, color: CustomColors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  _buildSectionCard(
                    title: 'Owner Information',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Owner Name',
                              controller: _ownerNameController,
                              hintText: 'e.g. Waleed Ahmed',
                              validator: Validators.empty,
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: BuildTextField(
                              label: 'Owner Email',
                              controller: _ownerEmailController,
                              hintText: 'owner@example.com',
                              validator: Validators.email,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  _buildAvailabilitySection(),
                  SizedBox(height: 48.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomOutlinedButton(
                        onTap: () => context.pop(),
                        label: 'Cancel',
                        width: context.w(160),
                        height: context.h(56),
                        textColor: CustomColors.grey,
                        color: CustomColors.border,
                      ),
                      context.horizontalSpace(24),
                      SizedBox(
                        width: context.w(240),
                        child: CustomPrimaryButton(
                          onTap: _submit,
                          label: 'Register Clinic',
                          height: context.h(56),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoPicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickLogo,
        child: Column(
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                shape: BoxShape.circle,
                border: Border.all(color: CustomColors.green.withValues(alpha: 0.5), width: 2),
                image: _selectedLogo != null
                    ? DecorationImage(
                        image: kIsWeb 
                          ? NetworkImage(_selectedLogo!.path) 
                          : FileImage(File(_selectedLogo!.path)) as ImageProvider,
                        fit: BoxFit.cover,
                      )
                    : (widget.invitedClinic?.logo != null && widget.invitedClinic!.logo!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(widget.invitedClinic!.logo!),
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              child: (_selectedLogo == null && (widget.invitedClinic?.logo == null || widget.invitedClinic!.logo!.isEmpty))
                  ? Icon(Icons.add_a_photo_outlined, size: 40.sp, color: CustomColors.purple)
                  : null,
            ),
            SizedBox(height: 12.h),
            Text(
              _selectedLogo == null ? 'Tap to upload logo' : 'Change Logo',
              style: context.fonts.grey13w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black20w600),
          SizedBox(height: 32.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Clinic Availability', style: context.fonts.black20w600),
              CustomPrimaryButton(
                onTap: _addAvailability,
                icon: Icons.add_circle_outline,
                label: 'Add Timing Slot',
                width: 220.w,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _availabilityEntries.length,
            separatorBuilder: (_, _) => Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(color: CustomColors.grey.withValues(alpha: 0.1)),
            ),
            itemBuilder: (context, index) {
              return _buildAvailabilityRow(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityRow(int index) {
    final entry = _availabilityEntries[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Timing Slot ${index + 1}', style: context.fonts.purple16w600),
            if (_availabilityEntries.length > 1)
              TextButton.icon(
                onPressed: () => _removeAvailability(index),
                icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                label: const Text('Remove'),
                style: TextButton.styleFrom(foregroundColor: CustomColors.red),
              ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildTimePicker(
                label: 'Open Time',
                time: entry.openTime,
                onChanged: (time) => setState(() => entry.openTime = time),
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: _buildTimePicker(
                label: 'Close Time',
                time: entry.closeTime,
                onChanged: (time) => setState(() => entry.closeTime = time),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Text('Active Days', style: context.fonts.black14w600),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
          ].map((day) {
            final isSelected = entry.selectedDays.contains(day);
            return FilterChip(
              label: Text(day),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    entry.selectedDays.add(day);
                  } else {
                    entry.selectedDays.remove(day);
                  }
                });
              },
              backgroundColor: Colors.white,
              selectedColor: CustomColors.purple.withValues(alpha: 0.1),
              checkmarkColor: CustomColors.purple,
              labelStyle: isSelected ? context.fonts.purple13w700 : context.fonts.grey13w500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(
                  color: isSelected ? CustomColors.purple : CustomColors.grey.withValues(alpha: 0.3),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? time,
    required Function(TimeOfDay) onChanged,
  }) {
    final controller = TextEditingController(text: time?.format(context) ?? '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.grey13w500),
        SizedBox(height: 10.h),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time ?? const TimeOfDay(hour: 9, minute: 0),
            );
            if (picked != null) {
              onChanged(picked);
              controller.text = picked.format(context);
            }
          },
          child: IgnorePointer(
            child: BuildTextField(
              label: '', // Label handled by parent column
              controller: controller,
              hintText: 'Select Time',
              readOnly: true,
              suffixIcon: const Icon(Icons.access_time_rounded, size: 20, color: CustomColors.purple),
            ),
          ),
        ),
      ],
    );
  }
}

class AvailabilityEntry {
  TimeOfDay? openTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay? closeTime = const TimeOfDay(hour: 17, minute: 0);
  Set<String> selectedDays = {};
}
