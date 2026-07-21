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
                        onAdd: () => _showBookingMethodDialog(context),
                      ),
                      context.verticalSpace(16),
                      _buildBookingMethodsList(state.config?.bookingMethods ?? []),
                      context.verticalSpace(32),
                      _buildSectionHeader(
                        'Appointment Types',
                        'Set timing rules and maximum durations for different clinical sessions.',
                        onAdd: () => _showAppointmentTypeDialog(context),
                      ),
                      context.verticalSpace(16),
                      _buildAppointmentTypesList(state.config?.appointmentTypes ?? []),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionHeader(String title, String description, {VoidCallback? onAdd}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: context.fonts.black18w600),
            if (onAdd != null)
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline_rounded, color: CustomColors.purple),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
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
            trailing: IconButton(
              onPressed: () => _showBookingMethodDialog(context, method: method),
              icon: const Icon(Icons.edit_outlined, color: CustomColors.purple, size: 20),
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
                      onPressed: () => _showAppointmentTypeDialog(context, type: type),
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

  void _showBookingMethodDialog(BuildContext context, {BookingMethodModel? method}) {
    final bool isEdit = method != null;
    final titleController = TextEditingController(text: method?.title);
    final keyController = TextEditingController(text: method?.key);
    final descController = TextEditingController(text: method?.description);
    String? iconUrl = method?.icon;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 16)),
            title: Text(isEdit ? 'Edit Booking Method' : 'Add Booking Method', style: context.fonts.black18w600),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  TextFormField(
                    controller: titleController,
                    style: context.fonts.black14w400,
                    decoration: AppDecorations.input(context, hint: 'Enter method title'),
                  ),
                  context.verticalSpace(20),
                  
                  if (!isEdit) ...[
                    Text('Key', style: context.fonts.black14w600),
                    context.verticalSpace(8),
                    TextFormField(
                      controller: keyController,
                      style: context.fonts.black14w400,
                      decoration: AppDecorations.input(context, hint: 'e.g. online, walk_in'),
                    ),
                    context.verticalSpace(20),
                  ],

                  Text('Description', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    style: context.fonts.black14w400,
                    decoration: AppDecorations.input(context, hint: 'Provide details...'),
                  ),
                  context.verticalSpace(20),

                  Text('Icon', style: context.fonts.black14w600),
                  context.verticalSpace(12),
                  _buildAssetUploader(
                    url: iconUrl,
                    label: 'Icon',
                    isIcon: true,
                    onUpload: (url) => setDialogState(() => iconUrl = url),
                    onDelete: () => setDialogState(() => iconUrl = null),
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
                  bool success;
                  if (isEdit) {
                    success = await ref.read(bookingConfigViewModelProvider.notifier).updateBookingMethod(
                      id: method.id,
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                      icon: iconUrl,
                    );
                  } else {
                    success = await ref.read(bookingConfigViewModelProvider.notifier).createBookingMethod(
                      title: titleController.text.trim(),
                      key: keyController.text.trim(),
                      description: descController.text.trim(),
                      icon: iconUrl,
                    );
                  }
                  if (success && context.mounted) Navigator.pop(context);
                },
                label: 'Save Changes',
                width: context.w(140),
                height: context.h(40),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAppointmentTypeDialog(BuildContext context, {AppointmentTypeModel? type}) {
    final bool isEdit = type != null;
    final titleController = TextEditingController(text: type?.internalTitle);
    final keyController = TextEditingController(text: type?.key);
    final descController = TextEditingController(text: type?.description);
    final durationController = TextEditingController(text: type?.maxDuration.toString() ?? '30');
    String currentTiming = type?.timing ?? _timingOptions.first;
    final List<String> selectedModes = type != null ? List.from(type.appointmentModes) : ['In-Person'];
    
    String? iconUrl = type?.icon;
    String? imageUrl = type?.image;

    final List<String> modeOptions = ['In-Person', 'Virtual'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 16)),
            title: Text(isEdit ? 'Edit Appointment Type' : 'Add Appointment Type', style: context.fonts.black18w600),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Internal Title', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  TextFormField(
                    controller: titleController,
                    style: context.fonts.black14w400,
                    decoration: AppDecorations.input(context, hint: 'Enter internal title'),
                  ),
                  context.verticalSpace(20),

                  if (!isEdit) ...[
                    Text('Key', style: context.fonts.black14w600),
                    context.verticalSpace(8),
                    TextFormField(
                      controller: keyController,
                      style: context.fonts.black14w400,
                      decoration: AppDecorations.input(context, hint: 'e.g. consultation, treatment'),
                    ),
                    context.verticalSpace(20),
                  ],

                  Text('Description', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    style: context.fonts.black14w400,
                    decoration: AppDecorations.input(context, hint: 'Provide details...'),
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
                                if (selectedModes.length > 1) selectedModes.remove(mode);
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
                                      if (selectedModes.length > 1) selectedModes.remove(mode);
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
                    items: _timingOptions.map((option) => DropdownMenuItem<String>(value: option, child: Text(option))).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => currentTiming = val);
                    },
                  ),
                  context.verticalSpace(20),

                  Text('Maximum Duration', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  TextFormField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    style: context.fonts.black14w400,
                    decoration: AppDecorations.input(context, hint: 'Enter minutes').copyWith(
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
                            _buildAssetUploader(
                              url: iconUrl,
                              label: 'Icon',
                              isIcon: true,
                              onUpload: (url) => setDialogState(() => iconUrl = url),
                              onDelete: () => setDialogState(() => iconUrl = null),
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
                            _buildAssetUploader(
                              url: imageUrl,
                              label: 'Image',
                              isIcon: false,
                              onUpload: (url) => setDialogState(() => imageUrl = url),
                              onDelete: () => setDialogState(() => imageUrl = null),
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
                  bool success;
                  if (isEdit) {
                    success = await ref.read(bookingConfigViewModelProvider.notifier).updateAppointmentType(
                      id: type.id,
                      internalTitle: titleController.text.trim(),
                      description: descController.text.trim(),
                      timing: currentTiming,
                      maxDuration: int.tryParse(durationController.text.trim()) ?? 0,
                      appointmentModes: selectedModes,
                      icon: iconUrl,
                      image: imageUrl,
                    );
                  } else {
                    success = await ref.read(bookingConfigViewModelProvider.notifier).createAppointmentType(
                      internalTitle: titleController.text.trim(),
                      key: keyController.text.trim(),
                      description: descController.text.trim(),
                      timing: currentTiming,
                      maxDuration: int.tryParse(durationController.text.trim()) ?? 0,
                      appointmentModes: selectedModes,
                      icon: iconUrl,
                      image: imageUrl,
                    );
                  }
                  if (success && context.mounted) Navigator.pop(context);
                },
                label: 'Save Changes',
                width: context.w(140),
                height: context.h(40),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAssetUploader({
    required String? url,
    required String label,
    required bool isIcon,
    required void Function(String) onUpload,
    required VoidCallback onDelete,
  }) {
    return url == null || url.isEmpty
        ? InkWell(
            onTap: () async {
              await ref.read(areaViewModelProvider.notifier).pickImage(isIcon);
              final uploaded = isIcon ? ref.read(areaViewModelProvider).areaIconUrl : ref.read(areaViewModelProvider).areaImageUrl;
              if (uploaded != null) onUpload(uploaded);
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
                  const Icon(Icons.add_photo_alternate_outlined, color: CustomColors.lightGrey, size: 24),
                  context.verticalSpace(4),
                  Text('Upload $label', style: context.fonts.grey11w400),
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
                  AppNetworkImage(imageUrl: url, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: InkWell(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.delete_outline_rounded, color: CustomColors.red, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
