import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/booking_configuration_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/area_view_model.dart';
import 'package:skinsync_admin/view_models/booking_config_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class BookingConfigScreen extends ConsumerStatefulWidget {
  static const String routeName = '/booking-config';
  const BookingConfigScreen({super.key});

  @override
  ConsumerState<BookingConfigScreen> createState() => _BookingConfigScreenState();
}

class _BookingConfigScreenState extends ConsumerState<BookingConfigScreen> {
  final List<String> _timingOptions = [
    'Before Treatment',
    'Primary Session',
    'After Treatment',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingConfigViewModelProvider.notifier).fetchBookingConfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingConfigViewModelProvider);

    return GradientScaffold(
      appBar: AppBar(
        title: Text('Booking Configuration', style: context.fonts.black18w600),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: state.loading && state.config == null
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(child: Text(state.errorMessage!))
              : SingleChildScrollView(
                  padding: context.appEdgeInsets(all: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        'Booking Methods',
                        'Manage and configure descriptions for your available booking channels.',
                      ),
                      context.verticalSpace(16),
                      _buildBookingMethodsList(state.config?.bookingMethods ?? []),
                      context.verticalSpace(32),
                      _buildSectionHeader(
                        'Appointment Types',
                        'Set timing rules and maximum durations for different clinical sessions.',
                      ),
                      context.verticalSpace(16),
                      _buildAppointmentTypesList(state.config?.appointmentTypes ?? []),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionHeader(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.fonts.black18w600),
        context.verticalSpace(4),
        Text(description, style: context.fonts.grey13w500),
      ],
    );
  }

  Widget _buildBookingMethodsList(List<BookingMethodModel> methods) {
    if (methods.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No booking methods found'),
      ));
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: methods.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final method = methods[index];
          return ListTile(
            contentPadding: context.appEdgeInsets(horizontal: 20, vertical: 12),
            leading: Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: CustomColors.palePurple,
                borderRadius: context.appBorderRadius(all: 10),
              ),
              child: method.icon != null && method.icon!.isNotEmpty
                  ? AppNetworkImage(imageUrl: method.icon!, width: 20, height: 20)
                  : const Icon(Icons.language_rounded, color: CustomColors.purple, size: 20),
            ),
            title: Text(method.title, style: context.fonts.black14w600),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(method.description, style: context.fonts.grey12w400),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentTypesList(List<AppointmentTypeModel> types) {
    if (types.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No appointment types found'),
      ));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: types.length,
      separatorBuilder: (context, index) => context.verticalSpace(16),
      itemBuilder: (context, index) {
        final type = types[index];

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: context.appBorderRadius(all: 16),
            border: Border.all(color: CustomColors.border),
          ),
          child: Stack(
            children: [
              if (type.image != null && type.image!.isNotEmpty)
                Positioned.fill(
                  child: AppNetworkImage(
                    imageUrl: type.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.5, 1.0],
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.9),
                        Colors.white.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: context.appEdgeInsets(all: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: context.appEdgeInsets(all: 12),
                      decoration: BoxDecoration(
                        color: CustomColors.palePurple,
                        borderRadius: context.appBorderRadius(all: 12),
                      ),
                      child: type.icon != null && type.icon!.isNotEmpty
                          ? AppNetworkImage(imageUrl: type.icon!, width: 24, height: 24)
                          : const Icon(Icons.medical_services_outlined, color: CustomColors.purple, size: 24),
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(type.internalTitle, style: context.fonts.black16w700),
                              context.horizontalSpace(12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: CustomColors.softGrey,
                                  borderRadius: context.appBorderRadius(all: 6),
                                  border: Border.all(color: CustomColors.border.withValues(alpha: 0.1)),
                                ),
                                child: Text(
                                  type.timing,
                                  style: context.fonts.grey10w700.copyWith(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          context.verticalSpace(4),
                          Text(
                            type.patientDisplayName,
                            style: context.fonts.purple14w600,
                          ),
                          context.verticalSpace(8),
                          Text(
                            type.description,
                            style: context.fonts.grey14w400,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          context.verticalSpace(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Duration: ${type.maxDuration} mins',
                                style: context.fonts.black13w600,
                              ),
                              Row(
                                children: type.appointmentModes.map((mode) {
                                  return Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: CustomColors.palePurple,
                                      borderRadius: context.appBorderRadius(all: 4),
                                      border: Border.all(color: CustomColors.purple.withValues(alpha: 0.2)),
                                    ),
                                    child: Text(
                                      mode,
                                      style: context.fonts.purple11w600.copyWith(fontSize: 9),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showDurationEditDialog(context, type),
                      icon: const Icon(Icons.edit_outlined, color: CustomColors.purple, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDurationEditDialog(BuildContext context, AppointmentTypeModel type) {
    String currentTiming = type.timing;
    final nameController = TextEditingController(text: type.patientDisplayName);
    final descController = TextEditingController(text: type.description);
    final durationController = TextEditingController(text: type.maxDuration.toString());
    final List<String> selectedModes = List.from(type.appointmentModes);
    
    String? iconUrl = type.icon;
    String? imageUrl = type.image;

    final List<String> modeOptions = ['In-Person', 'Virtual'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 16)),
            title: Text('Edit Appointment Type', style: context.fonts.black18w600),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Internal Title: ${type.internalTitle}', style: context.fonts.grey13w500),
                  context.verticalSpace(20),
                  
                  Text('Patient Display Name', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  TextFormField(
                    controller: nameController,
                    style: context.fonts.black14w400,
                    decoration: AppDecorations.input(
                      context,
                      hint: 'Enter public name for patients',
                    ),
                  ),
                  context.verticalSpace(20),

                  Text('Description', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    style: context.fonts.black14w400,
                    decoration: AppDecorations.input(
                      context,
                      hint: 'Provide details about this appointment type...',
                    ),
                  ),
                  context.verticalSpace(20),

                  Text('Appointment Modes', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  Row(
                    children: modeOptions.map((mode) {
                      final isSelected = selectedModes.contains(mode);
                      return Expanded(
                        child: InkWell(
                          onTap: () {
                            setDialogState(() {
                              if (isSelected) {
                                if (selectedModes.length > 1) {
                                  selectedModes.remove(mode);
                                }
                              } else {
                                selectedModes.add(mode);
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                activeColor: CustomColors.purple,
                                onChanged: (val) {
                                  setDialogState(() {
                                    if (val == true) {
                                      selectedModes.add(mode);
                                    } else {
                                      if (selectedModes.length > 1) {
                                        selectedModes.remove(mode);
                                      }
                                    }
                                  });
                                },
                              ),
                              Text(mode, style: context.fonts.black14w400),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  context.verticalSpace(20),

                  CustomDropdown<String>(
                    label: 'Timing Selection',
                    hintText: 'Select timing',
                    value: _timingOptions.contains(currentTiming) ? currentTiming : _timingOptions.first,
                    items: _timingOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          currentTiming = val;
                        });
                      }
                    },
                  ),
                  context.verticalSpace(20),

                  Text('Maximum Duration', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  TextFormField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    style: context.fonts.black14w400,
                    decoration: AppDecorations.input(
                      context,
                      hint: 'Enter maximum minutes',
                    ).copyWith(
                      suffixText: 'mins',
                      suffixStyle: context.fonts.grey12w600,
                    ),
                  ),
                  context.verticalSpace(24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Icon', style: context.fonts.black14w600),
                            context.verticalSpace(12),
                            iconUrl == null || iconUrl!.isEmpty
                                ? InkWell(
                                    onTap: () async {
                                      await ref.read(areaViewModelProvider.notifier).pickImage(true);
                                      final uploaded = ref.read(areaViewModelProvider).areaIconUrl;
                                      if (uploaded != null) {
                                        setDialogState(() {
                                          iconUrl = uploaded;
                                        });
                                      }
                                    },
                                    borderRadius: context.appBorderRadius(all: 12),
                                    child: Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: CustomColors.whiteGrey,
                                        borderRadius: context.appBorderRadius(all: 12),
                                        border: Border.all(color: CustomColors.border),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add_photo_alternate_outlined,
                                            color: CustomColors.lightGrey,
                                            size: 24,
                                          ),
                                          context.verticalSpace(4),
                                          Text(
                                            'Upload Icon',
                                            style: context.fonts.grey11w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 100,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: context.appBorderRadius(all: 12),
                                      border: Border.all(color: CustomColors.border),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: context.appBorderRadius(all: 12),
                                      child: Stack(
                                        children: [
                                          AppNetworkImage(
                                            imageUrl: iconUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: InkWell(
                                              onTap: () {
                                                setDialogState(() {
                                                  iconUrl = null;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      context.horizontalSpace(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Banner Image', style: context.fonts.black14w600),
                            context.verticalSpace(12),
                            imageUrl == null || imageUrl!.isEmpty
                                ? InkWell(
                                    onTap: () async {
                                      await ref.read(areaViewModelProvider.notifier).pickImage(false);
                                      final uploaded = ref.read(areaViewModelProvider).areaImageUrl;
                                      if (uploaded != null) {
                                        setDialogState(() {
                                          imageUrl = uploaded;
                                        });
                                      }
                                    },
                                    borderRadius: context.appBorderRadius(all: 12),
                                    child: Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: CustomColors.whiteGrey,
                                        borderRadius: context.appBorderRadius(all: 12),
                                        border: Border.all(color: CustomColors.border),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add_photo_alternate_outlined,
                                            color: CustomColors.lightGrey,
                                            size: 24,
                                          ),
                                          context.verticalSpace(4),
                                          Text(
                                            'Upload Image',
                                            style: context.fonts.grey11w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 100,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: context.appBorderRadius(all: 12),
                                      border: Border.all(color: CustomColors.border),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: context.appBorderRadius(all: 12),
                                      child: Stack(
                                        children: [
                                          AppNetworkImage(
                                            imageUrl: imageUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: InkWell(
                                              onTap: () {
                                                setDialogState(() {
                                                  imageUrl = null;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: context.fonts.grey14w600),
              ),
              CustomPrimaryButton(
                onTap: () async {
                  final success = await ref.read(bookingConfigViewModelProvider.notifier).updateAppointmentType(
                    id: type.id,
                    patientDisplayName: nameController.text.trim(),
                    description: descController.text.trim(),
                    timing: currentTiming,
                    maxDuration: int.tryParse(durationController.text.trim()) ?? 0,
                    appointmentModes: selectedModes,
                    icon: iconUrl,
                    image: imageUrl,
                  );
                  if (success && context.mounted) {
                    Navigator.pop(context);
                  }
                },
                label: 'Save Changes',
                width: context.w(140),
                height: context.h(40),
              ),
            ],
          );
        }
      ),
    );
  }
}
