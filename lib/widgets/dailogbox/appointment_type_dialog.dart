import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/appointment_types_list_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/area_view_model.dart';
import 'package:skinsync_admin/view_models/booking_config_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';

class AppointmentTypeDialog extends ConsumerStatefulWidget {
  final AppointmentTypeModel? type;
  const AppointmentTypeDialog({super.key, this.type});

  @override
  ConsumerState<AppointmentTypeDialog> createState() => _AppointmentTypeDialogState();
}

class _AppointmentTypeDialogState extends ConsumerState<AppointmentTypeDialog> {
  final List<String> _timingOptions = [
    'Before Treatment',
    'Primary Session',
    'After Treatment',
  ];

  late TextEditingController titleController;
  late TextEditingController keyController;
  late TextEditingController descController;
  late TextEditingController durationController;
  late String currentTiming;
  late List<String> selectedModes;
  String? iconUrl;
  String? imageUrl;

  final List<String> modeOptions = ['In-Person', 'Virtual'];

  @override
  void initState() {
    super.initState();
    final type = widget.type;
    titleController = TextEditingController(text: type?.title);
    keyController = TextEditingController(text: type?.key);
    descController = TextEditingController(text: type?.description);
    durationController = TextEditingController(text: type?.maxDuration.toString() ?? '30');
    currentTiming = type?.timing ?? _timingOptions.first;
    selectedModes = type != null ? List.from(type.appointmentModes) : ['In-Person'];
    iconUrl = type?.icon;
    imageUrl = type?.image;
  }

  @override
  void dispose() {
    titleController.dispose();
    keyController.dispose();
    descController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.type != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 16)),
      title: Text(isEdit ? 'Edit Appointment Type' : 'Add Appointment Type', style: context.fonts.black18w600),
      content: SizedBox(
        width: context.w(500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title', style: context.fonts.black14w600),
              context.verticalSpace(8),
              TextFormField(
                controller: titleController,
                style: context.fonts.black14w400,
                decoration: AppDecorations.input(context, hint: 'Enter title'),
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
                        setState(() {
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
                              setState(() {
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
                  if (val != null) setState(() => currentTiming = val);
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
                          onUpload: (url) => setState(() => iconUrl = url),
                          onDelete: () => setState(() => iconUrl = null),
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
                          onUpload: (url) => setState(() => imageUrl = url),
                          onDelete: () => setState(() => imageUrl = null),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                id: widget.type!.id,
                title: titleController.text.trim(),
                description: descController.text.trim(),
                timing: currentTiming,
                maxDuration: int.tryParse(durationController.text.trim()) ?? 0,
                appointmentModes: selectedModes,
                icon: iconUrl,
                image: imageUrl,
              );
            } else {
              success = await ref.read(bookingConfigViewModelProvider.notifier).createAppointmentType(
                title: titleController.text.trim(),
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
