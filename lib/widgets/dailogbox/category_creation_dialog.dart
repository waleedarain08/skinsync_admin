import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/common_models.dart';
import '../../models/notification_entry.dart';
import '../../models/treatment_data_models.dart';
import '../../utils/theme.dart';
import '../build_textfield.dart';
import '../custom_dropdown_widget.dart';
import 'standard_dialog.dart';

class CategoryCreationDialog extends StatefulWidget {
  const CategoryCreationDialog({
    super.key,
    this.parentName,
    this.initialName,
    this.initialIcon,
    this.initialConsentName,
    this.initialFollowUps,
    this.initialSessions,
    this.initialTotalSessions,
    this.initialPreNotifications,
    this.initialPostNotifications,
    this.initialDowntimePresets,
    this.initialDefaultRoles,
  });
  final String? parentName;
  final String? initialName;
  final String? initialIcon;
  final String? initialConsentName;
  final List<FollowUpConfig>? initialFollowUps;
  final List<SessionConfig>? initialSessions;
  final int? initialTotalSessions;
  final List<NotificationConfig>? initialPreNotifications;
  final List<NotificationConfig>? initialPostNotifications;
  final DowntimePresets? initialDowntimePresets;
  final List<String>? initialDefaultRoles;

  @override
  State<CategoryCreationDialog> createState() => _CategoryCreationDialogState();
}

class _CategoryCreationDialogState extends State<CategoryCreationDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _totalSessionsController;
  final List<TextEditingController> _sessionFollowUpsCountControllers = [];
  late String _selectedIcon;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedIconFile;
  PlatformFile? _consentFile;
  String? _existingConsentName;
  List<SessionConfig> _sessions = [];

  List<NotificationEntry> _preNotificationEntries = [];
  List<NotificationEntry> _postNotificationEntries = [];

  late final TextEditingController _downtimeLowController;
  late final TextEditingController _downtimeModerateController;
  late final TextEditingController _downtimeHighController;

  List<String> _selectedRoles = [];
  final List<String> _availableRoles = [
    'Injector',
    'Aesthetician',
    'MD',
    'Nurse',
    'Specialist',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);

    final int initialTotalSessions = widget.initialTotalSessions ?? 1;
    _totalSessionsController = TextEditingController(
      text: initialTotalSessions.toString(),
    );
    _selectedIcon = widget.initialIcon ?? 'category';
    _existingConsentName = widget.initialConsentName;

    if (widget.initialSessions != null && widget.initialSessions!.isNotEmpty) {
      _sessions = List.from(
        widget.initialSessions!.map(
          (s) => SessionConfig(
            sessionNumber: s.sessionNumber,
            followUps: List.from(s.followUps),
          ),
        ),
      );
    } else {
      _sessions = List.generate(initialTotalSessions, (index) {
        return SessionConfig(
          sessionNumber: index + 1,
          followUps: index == 0 && widget.initialFollowUps != null
              ? List.from(widget.initialFollowUps!)
              : [],
        );
      });
    }
    _syncFollowUpsCountControllers();

    _preNotificationEntries = widget.initialPreNotifications != null
        ? List.from(
            widget.initialPreNotifications!.map(
              (config) => NotificationEntry(
                titleController: TextEditingController(text: config.title),
                messageController: TextEditingController(text: config.message),
                timingValueController: TextEditingController(
                  text: config.timing?.toString(),
                ),
                timingUnit: config.timingUnit ?? 'hours',
                type: config.type ?? 'reminder',
              ),
            ),
          )
        : [];

    _postNotificationEntries = widget.initialPostNotifications != null
        ? List.from(
            widget.initialPostNotifications!.map(
              (config) => NotificationEntry(
                titleController: TextEditingController(text: config.title),
                messageController: TextEditingController(text: config.message),
                timingValueController: TextEditingController(
                  text: config.timing?.toString(),
                ),
                timingUnit: config.timingUnit ?? 'hours',
                type: config.type ?? 'care',
              ),
            ),
          )
        : [];

    _downtimeLowController = TextEditingController(
      text: (widget.initialDowntimePresets?.low ?? 2).toString(),
    );
    _downtimeModerateController = TextEditingController(
      text: (widget.initialDowntimePresets?.moderate ?? 5).toString(),
    );
    _downtimeHighController = TextEditingController(
      text: (widget.initialDowntimePresets?.high ?? 10).toString(),
    );

    _selectedRoles = widget.initialDefaultRoles != null
        ? List.from(widget.initialDefaultRoles!)
        : [];
  }

  void _syncFollowUpsCountControllers() {
    while (_sessionFollowUpsCountControllers.length < _sessions.length) {
      final sIdx = _sessionFollowUpsCountControllers.length;
      final initialCount = _sessions[sIdx].followUps.length;
      _sessionFollowUpsCountControllers.add(
        TextEditingController(
          text: initialCount == 0 ? '0' : initialCount.toString(),
        ),
      );
    }
    while (_sessionFollowUpsCountControllers.length > _sessions.length) {
      _sessionFollowUpsCountControllers.last.dispose();
      _sessionFollowUpsCountControllers.removeLast();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _totalSessionsController.dispose();
    for (final controller in _sessionFollowUpsCountControllers) {
      controller.dispose();
    }
    for (final entry in _preNotificationEntries) {
      entry.dispose();
    }
    for (final entry in _postNotificationEntries) {
      entry.dispose();
    }
    _downtimeLowController.dispose();
    _downtimeModerateController.dispose();
    _downtimeHighController.dispose();
    super.dispose();
  }

  void _updateSessionsCount(String val) {
    final count = int.tryParse(val) ?? 1;
    if (count < 1) return;
    setState(() {
      if (count > _sessions.length) {
        for (int i = _sessions.length; i < count; i++) {
          _sessions.add(SessionConfig(sessionNumber: i + 1, followUps: []));
        }
      } else if (count < _sessions.length) {
        _sessions = _sessions.sublist(0, count);
      }
      _syncFollowUpsCountControllers();
    });
  }

  void _updateSessionFollowUpCount(int sIdx, String val) {
    final count = int.tryParse(val) ?? 0;
    if (count < 0) return;
    setState(() {
      final session = _sessions[sIdx];
      final currentFus = List<FollowUpConfig>.from(session.followUps);
      if (count > currentFus.length) {
        for (int i = currentFus.length; i < count; i++) {
          currentFus.add(FollowUpConfig(type: 'virtual'));
        }
      } else if (count < currentFus.length) {
        currentFus.removeRange(count, currentFus.length);
      }
      _sessions[sIdx] = SessionConfig(
        sessionNumber: session.sessionNumber,
        followUps: currentFus,
      );
    });
  }

  Future<void> _pickConsent() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _consentFile = result.files.first;
        _existingConsentName = null;
      });
    }
  }

  Future<void> _pickIcon() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _selectedIconFile = image;
        _selectedIcon = image.path;
      });
    }
  }

  Widget _buildNotificationsBuilder(bool isPre) {
    final entries = isPre ? _preNotificationEntries : _postNotificationEntries;
    final titleLabel = isPre
        ? 'Pre-Treatment Notifications'
        : 'Post-Treatment Notifications';
    final defaultType = isPre ? 'reminder' : 'care';
    final types = isPre
        ? ['reminder', 'warning', 'instruction']
        : ['recovery', 'care', 'follow-up reminder'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleLabel, style: context.fonts.black16w600),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  entries.add(
                    NotificationEntry(
                      titleController: TextEditingController(),
                      messageController: TextEditingController(),
                      timingValueController: TextEditingController(),
                      timingUnit: 'hours',
                      type: defaultType,
                    ),
                  );
                });
              },
              icon: const Icon(
                Icons.add_circle_outline,
                color: CustomColors.purple,
              ),
              label: const Text('Add Notification'),
            ),
          ],
        ),
        context.verticalSpace(12),
        if (entries.isEmpty)
          Container(
            width: double.infinity,
            padding: context.appEdgeInsets(all: 16),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 8),
              border: Border.all(color: CustomColors.border),
            ),
            child: Text(
              'No default notifications defined.',
              style: context.fonts.grey13w500,
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            separatorBuilder: (_, _) => context.verticalSpace(16),
            itemBuilder: (context, idx) {
              final entry = entries[idx];
              return Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notification #${idx + 1}',
                          style: context.fonts.purple14w700,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: CustomColors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              final removed = entries.removeAt(idx);
                              removed.dispose();
                            });
                          },
                        ),
                      ],
                    ),
                    context.verticalSpace(12),
                    BuildTextField(
                      label: 'Title',
                      controller: entry.titleController,
                      hintText: 'e.g. Stop blood thinners',
                    ),
                    context.verticalSpace(12),
                    BuildTextField(
                      label: 'Message Content',
                      controller: entry.messageController,
                      hintText: 'Enter notification message...',
                      maxLines: 2,
                    ),
                    context.verticalSpace(12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: BuildTextField(
                            label: 'Timing Value',
                            controller: entry.timingValueController,
                            hintText: 'e.g. 24',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Timing Unit',
                                style: context.fonts.black14w600,
                              ),
                              context.verticalSpace(8),
                              DropdownButtonHideUnderline(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: CustomColors.border,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: entry.timingUnit,
                                    isExpanded: true,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'minutes',
                                        child: Text('Minutes'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'hours',
                                        child: Text('Hours'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'days',
                                        child: Text('Days'),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() {
                                          entry.timingUnit = v;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type (Optional)',
                          style: context.fonts.black14w600,
                        ),
                        context.verticalSpace(8),
                        DropdownButtonHideUnderline(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: CustomColors.border),
                            ),
                            child: DropdownButton<String>(
                              value: entry.type,
                              isExpanded: true,
                              items: types
                                  .map(
                                    (t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(
                                        t[0].toUpperCase() + t.substring(1),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() {
                                    entry.type = v;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildSessionFollowUpCard(int sIdx, int fuIdx) {
    final config = _sessions[sIdx].followUps[fuIdx];
    final intervalController = TextEditingController(
      text: config.intervalValue?.toString() ?? '',
    );
    final durationController = TextEditingController(
      text: config.durationValue?.toString() ?? '',
    );

    return Container(
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Follow-Up ${fuIdx + 1}', style: context.fonts.purple12w700),
          context.verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  label: 'Type',
                  hintText: 'Select',
                  value: config.type,
                  items: const [
                    DropdownMenuItem(value: 'virtual', child: Text('Virtual')),
                    DropdownMenuItem(
                      value: 'in_person',
                      child: Text('In-Person'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        config.type = val;
                      });
                    }
                  },
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Duration', style: context.fonts.black14w600),
                    context.verticalSpace(8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            decoration: AppDecorations.input(
                              context,
                              hint: '30',
                            ),
                            onChanged: (v) =>
                                config.durationValue = int.tryParse(v),
                          ),
                        ),
                        context.horizontalSpace(4),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: config.durationUnit,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                  value: 'minutes',
                                  child: Text('m'),
                                ),
                                DropdownMenuItem(
                                  value: 'hours',
                                  child: Text('h'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() {
                                    config.durationUnit = v;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(12),
          Text('Interval (After Procedure)', style: context.fonts.black14w600),
          context.verticalSpace(8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: intervalController,
                  keyboardType: TextInputType.number,
                  decoration: AppDecorations.input(context, hint: '1'),
                  onChanged: (v) => config.intervalValue = int.tryParse(v),
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: config.intervalUnit,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'days', child: Text('Days')),
                      DropdownMenuItem(value: 'weeks', child: Text('Weeks')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          config.intervalUnit = v;
                        });
                      }
                    },
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: widget.initialName != null
          ? 'Edit Category'
          : (widget.parentName == null
                ? 'Create New Category'
                : 'Add Subcategory to ${widget.parentName}'),
      width: context.w(700),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('General Information', style: context.fonts.purple14w700),
          context.verticalSpace(16),
          BuildTextField(
            label: 'Category Name',
            controller: _nameController,
            hintText: 'e.g. Skin Rejuvenation',
          ),
          context.verticalSpace(24),
          Text('Select Category Icon', style: context.fonts.black14w600),
          context.verticalSpace(12),
          GestureDetector(
            onTap: _pickIcon,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border),
                image: _selectedIconFile != null
                    ? DecorationImage(
                        image: kIsWeb
                            ? NetworkImage(_selectedIconFile!.path)
                            : FileImage(File(_selectedIconFile!.path))
                                as ImageProvider,
                        fit: BoxFit.cover,
                      )
                    : (_selectedIcon.isNotEmpty &&
                            (_selectedIcon.startsWith('http') ||
                                _selectedIcon.contains('/')))
                        ? DecorationImage(
                            image: _selectedIcon.startsWith('http')
                                ? NetworkImage(_selectedIcon)
                                : FileImage(File(_selectedIcon))
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              child: (_selectedIconFile == null &&
                      !_selectedIcon.startsWith('http') &&
                      !_selectedIcon.contains('/'))
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 32.sp,
                          color: CustomColors.purple,
                        ),
                        context.verticalSpace(8),
                        Text(
                          'Tap to upload',
                          style: context.fonts.purple12w700,
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          Text('Sessions Configuration', style: context.fonts.black16w600),
          context.verticalSpace(8),
          Text(
            'Configure sessions and their respective follow-ups for this category.',
            style: context.fonts.grey12w400,
          ),
          context.verticalSpace(20),
          BuildTextField(
            label: 'Total Sessions',
            controller: _totalSessionsController,
            hintText: '1',
            keyboardType: TextInputType.number,
            onChanged: (val) => _updateSessionsCount(val ?? ''),
          ),
          if (_sessions.isNotEmpty) ...[
            context.verticalSpace(24),
            ...List.generate(_sessions.length, (sIdx) {
              final session = _sessions[sIdx];
              return Container(
                margin: context.appEdgeInsets(bottom: 24),
                padding: context.appEdgeInsets(all: 20),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.02),
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.event_note_rounded,
                          color: CustomColors.purple,
                        ),
                        context.horizontalSpace(12),
                        Text(
                          'SESSION ${session.sessionNumber}',
                          style: context.fonts.purple14w700,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: context.w(150),
                          child: BuildTextField(
                            label: 'Total Follow-Ups',
                            controller: _sessionFollowUpsCountControllers[sIdx],
                            hintText: '0',
                            keyboardType: TextInputType.number,
                            onChanged: (val) =>
                                _updateSessionFollowUpCount(sIdx, val ?? ''),
                          ),
                        ),
                      ],
                    ),
                    if (session.followUps.isNotEmpty) ...[
                      context.verticalSpace(20),
                      ...List.generate(session.followUps.length, (fuIdx) {
                        return Padding(
                          padding: context.appEdgeInsets(bottom: 16),
                          child: _buildSessionFollowUpCard(sIdx, fuIdx),
                        );
                      }),
                    ],
                  ],
                ),
              );
            }),
          ],
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          Text('Operational Defaults', style: context.fonts.purple14w700),
          context.verticalSpace(20),
          Text(
            'Default Patient Notifications',
            style: context.fonts.black16w600,
          ),
          context.verticalSpace(16),
          _buildNotificationsBuilder(true),
          context.verticalSpace(24),
          _buildNotificationsBuilder(false),
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          Text(
            'Programmable Downtime Levels (Days)',
            style: context.fonts.black16w600,
          ),
          context.verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Low',
                  controller: _downtimeLowController,
                  hintText: '2',
                  keyboardType: TextInputType.number,
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: BuildTextField(
                  label: 'Moderate',
                  controller: _downtimeModerateController,
                  hintText: '5',
                  keyboardType: TextInputType.number,
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: BuildTextField(
                  label: 'High',
                  controller: _downtimeHighController,
                  hintText: '10',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          Text(
            'Default Allowed Provider Roles',
            style: context.fonts.black16w600,
          ),
          context.verticalSpace(16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _availableRoles.map((role) {
              final isSelected = _selectedRoles.contains(role);
              return FilterChip(
                label: Text(role),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedRoles.add(role);
                    } else {
                      _selectedRoles.remove(role);
                    }
                  });
                },
                selectedColor: CustomColors.purple.withValues(alpha: 0.2),
                checkmarkColor: CustomColors.purple,
                labelStyle: isSelected
                    ? context.fonts.purple14w600
                    : context.fonts.black14w400,
              );
            }).toList(),
          ),
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          Text(
            'Default Patient Consent Form (Optional)',
            style: context.fonts.black16w600,
          ),
          context.verticalSpace(12),
          InkWell(
            onTap: _pickConsent,
            child: Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(
                  color: CustomColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: CustomColors.red,
                    size: 24,
                  ),
                  context.horizontalSpace(16),
                  Expanded(
                    child: Text(
                      _consentFile?.name ??
                          _existingConsentName ??
                          'Upload Default PDF',
                      style:
                          (_consentFile != null || _existingConsentName != null)
                          ? context.fonts.black14w600
                          : context.fonts.grey14w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: CustomColors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          context.verticalSpace(32),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        SizedBox(
          width: context.w(120),
          child: ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'totalSessions':
                      int.tryParse(_totalSessionsController.text) ?? 1,
                  'icon': _selectedIcon,
                  'consentFile': _consentFile,
                  'sessions': _sessions,
                  'followUps': _sessions.isNotEmpty
                      ? _sessions.first.followUps
                      : <FollowUpConfig>[],
                  'preNotifications': _preNotificationEntries
                      .map((e) => e.toConfig())
                      .toList(),
                  'postNotifications': _postNotificationEntries
                      .map((e) => e.toConfig())
                      .toList(),
                  'downtimePresets': DowntimePresets(
                    none: 0,
                    low: int.tryParse(_downtimeLowController.text) ?? 2,
                    moderate:
                        int.tryParse(_downtimeModerateController.text) ?? 5,
                    high: int.tryParse(_downtimeHighController.text) ?? 10,
                  ),
                  'defaultRoles': _selectedRoles,
                });
              }
            },
            child: Text(widget.initialName != null ? 'Update' : 'Create'),
          ),
        ),
      ],
    );
  }
}
