import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/area_view_model.dart';
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
  late Map<String, TextEditingController> _durationControllers;
  late Map<String, TextEditingController> _displayNameControllers;
  late Map<String, TextEditingController> _descriptionControllers;
  late Map<String, String> _appointmentTimings;
  late Map<String, String?> _iconUrls;
  late Map<String, String?> _imageUrls;

  final List<String> _timingOptions = [
    'Before Treatment',
    'Primary Session',
    'After Treatment',
  ];

  @override
  void initState() {
    super.initState();
    _durationControllers = {
      'Consultation': TextEditingController(text: '0'),
      'Treatment': TextEditingController(text: '0'),
      'Follow-up': TextEditingController(text: '0'),
    };
    _displayNameControllers = {
      'Consultation': TextEditingController(text: 'Initial Consultation'),
      'Treatment': TextEditingController(text: 'Clinical Treatment'),
      'Follow-up': TextEditingController(text: 'Post-Care Follow-up'),
    };
    _descriptionControllers = {
      'Consultation': TextEditingController(text: 'Discussion of clinical needs and treatment planning.'),
      'Treatment': TextEditingController(text: 'The primary session for the selected treatment procedure.'),
      'Follow-up': TextEditingController(text: 'Evaluation of results and post-treatment progress.'),
    };
    _appointmentTimings = {
      'Consultation': 'Before Treatment',
      'Treatment': 'Primary Session',
      'Follow-up': 'After Treatment',
    };
    _iconUrls = {
      'Consultation': null,
      'Treatment': null,
      'Follow-up': null,
    };
    _imageUrls = {
      'Consultation': null,
      'Treatment': null,
      'Follow-up': null,
    };
  }

  @override
  void dispose() {
    for (final controller in _durationControllers.values) {
      controller.dispose();
    }
    for (final controller in _displayNameControllers.values) {
      controller.dispose();
    }
    for (final controller in _descriptionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text('Booking Configuration', style: context.fonts.black18w600),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(all: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Booking Methods',
              'Manage and configure descriptions for your available booking channels.',
            ),
            context.verticalSpace(16),
            _buildBookingMethodsList(),
            context.verticalSpace(32),
            _buildSectionHeader(
              'Appointment Types',
              'Set timing rules and maximum durations for different clinical sessions.',
            ),
            context.verticalSpace(16),
            _buildAppointmentTypesList(),
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

  Widget _buildBookingMethodsList() {
    final methods = [
      {
        'title': 'Online',
        'desc': 'Allows customers to browse available time slots and book their own appointments directly through the Skinsync mobile application.',
        'icon': Icons.language_rounded,
      },
      {
        'title': 'Walk-in',
        'desc': 'Enables clinic administrators and front-desk staff to manually register and schedule appointments for customers who visit the clinic in person.',
        'icon': Icons.person_pin_circle_rounded,
      },
      {
        'title': 'Personal',
        'desc': 'Provides a private scheduling channel for clinic staff to manage internal administrative tasks, professional blocks, or private clinical sessions.',
        'icon': Icons.lock_outline_rounded,
      },
    ];

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
              child: Icon(method['icon'] as IconData, color: CustomColors.purple, size: 20),
            ),
            title: Text(method['title'] as String, style: context.fonts.black14w600),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(method['desc'] as String, style: context.fonts.grey12w400),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentTypesList() {
    final types = [
      {'title': 'Consultation', 'icon': Icons.chat_bubble_outline_rounded},
      {'title': 'Treatment', 'icon': Icons.medical_services_outlined},
      {'title': 'Follow-up', 'icon': Icons.event_available_outlined},
    ];

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: types.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final type = types[index];
          final title = type['title']! as String;
          final icon = type['icon']! as IconData;
          final controller = _durationControllers[title];
          final timing = _appointmentTimings[title];

          return ListTile(
            contentPadding: context.appEdgeInsets(horizontal: 20, vertical: 12),
            leading: Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: CustomColors.palePurple,
                borderRadius: context.appBorderRadius(all: 10),
              ),
              child: Icon(icon, color: CustomColors.purple, size: 20),
            ),
            title: Row(
              children: [
                Text(title, style: context.fonts.black14w600),
                context.horizontalSpace(12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.softGrey,
                    borderRadius: context.appBorderRadius(all: 6),
                    border: Border.all(color: CustomColors.border.withValues(alpha: 0.1)),
                  ),
                  child: Text(
                    timing!,
                    style: context.fonts.grey10w700.copyWith(fontSize: 10),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient Name: ${_displayNameControllers[title]!.text}',
                    style: context.fonts.grey13w500,
                  ),
                  context.verticalSpace(2),
                  Text(
                    'Max Duration: ${controller!.text} mins',
                    style: context.fonts.grey13w500,
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              onPressed: () => _showDurationEditDialog(context, title),
              icon: const Icon(Icons.edit_outlined, color: CustomColors.purple, size: 20),
            ),
          );
        },
      ),
    );
  }

  void _showDurationEditDialog(BuildContext context, String title) {
    String currentTiming = _appointmentTimings[title]!;
    final nameController = _displayNameControllers[title]!;
    final descController = _descriptionControllers[title]!;
    final durationController = _durationControllers[title]!;
    
    String? iconUrl;
    String? imageUrl;

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
                  Text('Internal Title: $title', style: context.fonts.grey13w500),
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

                  CustomDropdown<String>(
                    label: 'Timing Selection',
                    hintText: 'Select timing',
                    value: currentTiming,
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
                onTap: () {
                  setState(() {
                    _appointmentTimings[title] = currentTiming;
                  });
                  Navigator.pop(context);
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
