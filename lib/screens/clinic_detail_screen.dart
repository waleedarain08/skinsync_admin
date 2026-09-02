import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/requests/update_clinic_request.dart';
import 'package:skinsync_admin/models/responses/clinic_detail_response.dart';
import 'package:skinsync_admin/screens/shared_treatment_request_screen.dart';
import 'package:skinsync_admin/utils/responsive.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/auth_view_model.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/phone_widget.dart';
import 'package:skinsync_admin/utils/string_utils.dart';

class ClinicDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = '/clinic-detail';
  const ClinicDetailScreen({super.key});

  @override
  ConsumerState<ClinicDetailScreen> createState() => _ClinicDetailScreenState();
}

class _ClinicDetailScreenState extends ConsumerState<ClinicDetailScreen> {
  bool _isEditMode = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Timer? _addressTimer;
  late TextEditingController _latController = TextEditingController();
  late TextEditingController _longController = TextEditingController();
  late final TextEditingController _clinicNameController;
  late final TextEditingController _clinicEmailController;
  late final TextEditingController _clinicPhoneController;
  late final TextEditingController _clinicAddressController;
  late final TextEditingController _websiteController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final clinic = ref.read(clinicViewModelProvider).selectedClinicDetail;
    _clinicNameController = TextEditingController(text: clinic?.name);
    _clinicEmailController = TextEditingController(text: clinic?.email);
    _clinicPhoneController = TextEditingController(text: clinic?.phone);
    _clinicAddressController = TextEditingController(text: clinic?.address);
    _websiteController = TextEditingController(text: clinic?.website ?? '');
    _descriptionController = TextEditingController(text: clinic?.description);
    _latController = TextEditingController(text: clinic?.latitude?.toString());
    _longController = TextEditingController(
      text: clinic?.longitude?.toString(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(authViewModelProvider.notifier)
          .setCountry(CountryCode.fromCountryCode(clinic?.country ?? 'US'));
      ref
          .read(clinicViewModelProvider.notifier)
          .initClinicImages(banner: clinic?.banner, logo: clinic?.logo);
    });
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    _clinicEmailController.dispose();
    _clinicPhoneController.dispose();
    _clinicAddressController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _latController.dispose();
    _longController.dispose();
    _addressTimer?.cancel();
    super.dispose();
  }

  Future<void> _updateClinic() async {
    if (!_formKey.currentState!.validate()) return;
    final clinic = ref.read(clinicViewModelProvider).selectedClinicDetail;
    if (clinic == null) return;

    final vmState = ref.read(clinicViewModelProvider);
    final selectedCountry = ref.read(authViewModelProvider).country;

    final req = UpdateClinicRequest(
      clinicId: clinic.clinicId,
      clinicName: _clinicNameController.text.trim(),
      clinicEmail: _clinicEmailController.text.trim(),
      clinicPhone: _clinicPhoneController.text.trim(),
      clinicAddress: _clinicAddressController.text.trim(),
      cc: selectedCountry.dialCode ?? '+1',
      country: selectedCountry.code ?? 'US',
      clinicLogo: vmState.clinicImage ?? clinic.logo,
      website: _websiteController.text.trim(),
      description: _descriptionController.text.trim(),
      clinicLatitude: double.tryParse(_latController.text),
      clinicLongitude: double.tryParse(_longController.text),
      banner: vmState.bannerImage ?? clinic.banner,
    );

    final success = await ref
        .read(clinicViewModelProvider.notifier)
        .updateClinic(clinic.clinicId!, req);
    if (success && mounted) {
      setState(() => _isEditMode = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clinic updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinic = ref.watch(clinicViewModelProvider).selectedClinicDetail;

    if (clinic == null) {
      return GradientScaffold(
        body: Center(
          child: Text('No Clinic Data Found', style: context.fonts.black16w400),
        ),
      );
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
            icon: Icon(
              _isEditMode ? Icons.close : Icons.edit_outlined,
              color: CustomColors.black,
            ),
            onPressed: () {
              if (_isEditMode) {
                _clinicNameController.text = clinic.name ?? '';
                _clinicEmailController.text = clinic.email ?? '';
                _clinicPhoneController.text = clinic.phone ?? '';
                _clinicAddressController.text = clinic.address ?? '';
                _descriptionController.text = clinic.description ?? '';
                _websiteController.text = clinic.website ?? '';
                _latController.text = clinic.latitude?.toString() ?? '';
                _longController.text = clinic.longitude?.toString() ?? '';
                ref
                    .read(clinicViewModelProvider.notifier)
                    .initClinicImages(banner: clinic.banner, logo: clinic.logo);
              }
              setState(() => _isEditMode = !_isEditMode);
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

  Widget _buildHeaderSection(ClinicDetailData clinic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBannerAndLogoCard(),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            (clinic.name ?? 'N/A').capitalize,
                            style: context.fonts.level2Heading,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        _statusBadge(clinic.status ?? 'Active'),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      clinic.address ?? 'N/A',
                      style: context.fonts.grey14w400,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              OutlinedButton.icon(
                onPressed: () {
                  context.pushNamed(
                    SharedTreatmentRequestScreen.routeName,
                    queryParameters: {
                      'clinicId': clinic.clinicId.toString(),
                      'showBackButton': 'true',
                    },
                  );
                },
                icon: const Icon(
                  Icons.list_alt_rounded,
                  color: CustomColors.purple,
                ),
                label: Text(
                  'View Requested Treatments',
                  style: context.fonts.purple14w600,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(0, 52.h),
                  side: const BorderSide(color: CustomColors.purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerAndLogoCard() {
    final state = ref.watch(clinicViewModelProvider);
    final viewModel = ref.read(clinicViewModelProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        image: state.bannerImage != null && state.bannerImage != ''
            ? DecorationImage(
                image: NetworkImage(state.bannerImage ?? ''),
                fit: BoxFit.cover,
              )
            : null,
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
            children: [
              Expanded(
                child: Text(
                  'Clinic Logo',
                  style: context.fonts.black20w600.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
              if (_isEditMode)
                InkWell(
                  borderRadius: BorderRadius.circular(50.r),
                  onTap: () {
                    if (state.bannerImage != null && state.bannerImage != '') {
                      viewModel.removeBanner();
                    } else {
                      viewModel.pickImage(false);
                    }
                  },
                  child: Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      state.bannerImage == null || state.bannerImage == ''
                          ? Icons.add_a_photo_outlined
                          : Icons.close,
                      color: Colors.blue,
                    ),
                  ),
                ),
            ],
          ),
          Center(
            child: InkWell(
              onTap: _isEditMode ? () => viewModel.pickImage(true) : null,
              borderRadius: BorderRadius.circular(100.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isEditMode ? Colors.teal : CustomColors.border,
                        width: 2,
                      ),
                    ),
                    child: state.clinicImage != null && state.clinicImage != ''
                        ? AppNetworkImage(
                            imageUrl: state.clinicImage ?? '',
                            width: 140.w,
                            height: 140.w,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(12),
                            errorIcon: Icons.broken_image_outlined,
                            errorIconSize: 40,
                          )
                        : Center(
                            child: Icon(
                              _isEditMode
                                  ? Icons.add_a_photo_outlined
                                  : Icons.business_outlined,
                              size: 36.sp,
                              color: _isEditMode
                                  ? Colors.deepPurple
                                  : CustomColors.black,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(ClinicDetailData clinic) {
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
                  PhoneWidget(
                    controller: _clinicPhoneController,
                    readOnly: !_isEditMode,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          BuildTextField(
            readOnly: !_isEditMode,
            label: 'Full Address',
            controller: _clinicAddressController,
            hintText: '123 Main Street, New York, NY 10001',
            validator: Validators.empty,
            onChanged: (value) {
              _addressTimer?.cancel();
              _addressTimer = Timer(const Duration(milliseconds: 300), () {
                ref.read(clinicViewModelProvider.notifier).searchPlaces(value);
              });
            },
          ),
          Consumer(
            builder: (_, ref, _) {
              final places = ref.watch(
                clinicViewModelProvider.select((s) => s.searchedPlaces),
              );
              if (places.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: .start,
                spacing: context.h(10),
                children: [
                  Text('Suggestions', style: context.fonts.black14w600),
                  ...List.generate(places.length, (index) {
                    final place = places[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          _latController.text =
                              '${place.location?.latitude ?? ''}';
                          _longController.text =
                              '${place.location?.longitude ?? ''}';
                          _clinicAddressController.text =
                              place.shortFormattedAddress ?? '';
                          ref
                              .read(clinicViewModelProvider.notifier)
                              .clearSearchedPlaces();
                        },
                        title: Text(place.displayName?.text ?? 'N/A'),
                        subtitle: Text(place.shortFormattedAddress ?? 'N/A'),
                      ),
                    );
                  }),
                ],
              );
            },
          ),

          SizedBox(height: 24.h),
          BuildTextField(
            label: 'Website',
            controller: _websiteController,
            hintText: 'https://example.com',
            readOnly: !_isEditMode,
          ),
        ]),
        SizedBox(height: 24.h),
        _infoSection('Treatments Available', [
          if (clinic.treatments == null || clinic.treatments!.isEmpty)
            _buildTreatmentsEmptyState()
          else
            Column(
              children: clinic.treatments!.map(_buildTreatmentRow).toList(),
            ),
        ]),
      ],
    );
  }

  Widget _buildTreatmentsEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 40.sp,
              color: CustomColors.grey,
            ),
            SizedBox(height: 12.h),
            Text(
              'No treatments registered currently',
              style: context.fonts.grey14w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentRow(dynamic treatment) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: CustomColors.green,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            treatment.toString().capitalize,
            style: context.fonts.black14w500,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSidebar(ClinicDetailData clinic) {
    return Column(
      children: [
        _infoSection('Availability & Working Hours', [
          if (clinic.availability == null || clinic.availability!.isEmpty)
            Text(
              'No working hours registered.',
              style: context.fonts.grey14w400,
            )
          else
            ...clinic.availability!.map(_buildAvailabilityCard),
        ]),
        SizedBox(height: 24.h),
        _infoSection('Subscription Info', [
          _statRow(
            Icons.card_membership_outlined,
            'Current Status',
            clinic.status?.toUpperCase() ?? 'ACTIVE',
          ),
          _statRow(
            Icons.map_outlined,
            'Latitude',
            clinic.latitude?.toStringAsFixed(4) ?? 'N/A',
          ),
          _statRow(
            Icons.explore_outlined,
            'Longitude',
            clinic.longitude?.toStringAsFixed(4) ?? 'N/A',
          ),
        ]),
      ],
    );
  }

  Widget _buildAvailabilityCard(ClinicAvailability availability) {
    final String daysStr = availability.days?.join(', ') ?? 'N/A';
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Working Hours', style: context.fonts.black13w600),
              Text(
                '${availability.openTime ?? "09:00"} - ${availability.closeTime ?? "17:00"}',
                style: context.fonts.purple13w600,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            daysStr,
            style: context.fonts.grey12w400,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _infoSection(String title, List<Widget> children) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.capitalize, style: context.fonts.black16w700),
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
          Flexible(
            child: Text(
              value,
              style: context.fonts.grey14w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive
            ? CustomColors.green.withValues(alpha: 0.1)
            : CustomColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: isActive ? context.fonts.green10w700 : context.fonts.red10w700,
      ),
    );
  }
}
