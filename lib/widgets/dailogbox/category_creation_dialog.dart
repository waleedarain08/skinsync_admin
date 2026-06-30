import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/requests/create_category_request.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/notification_entry.dart';
import '../../models/responses/category_detail_response.dart';
import '../../utils/theme.dart';
import '../../view_models/category_view_model.dart';
import '../build_textfield.dart';
import '../custom_dropdown_widget.dart';
import '../custom_primary_button.dart';
import '../app_network_image.dart';
import 'standard_dialog.dart';

class CategoryCreationDialog extends ConsumerStatefulWidget {
  const CategoryCreationDialog({
    super.key,
    this.parentName,
    this.initialName,
    this.initialIcon,
    this.initialImage,
    this.initialConsentName,
    this.initialConsentFormUrl,
    this.initialSessions,
    this.initialTotalSessions,
    this.initialPreNotifications,
    this.initialPostNotifications,
    this.initialDowntimePresets,
    this.initialDefaultRoles,
    this.categoryId,
    this.isViewMode = false,
  });

  final String? parentName;
  final String? initialName;
  final String? initialIcon;
  final String? initialImage;
  final String? initialConsentName;
  final String? initialConsentFormUrl;
  final List<CategorySessionModel>? initialSessions;
  final int? initialTotalSessions;
  final List<CategoryNotificationModel>? initialPreNotifications;
  final List<CategoryNotificationModel>? initialPostNotifications;
  final CategoryDowntimePresetModel? initialDowntimePresets;
  final List<String>? initialDefaultRoles;
  final int? categoryId;
  final bool isViewMode;

  @override
  ConsumerState<CategoryCreationDialog> createState() =>
      _CategoryCreationDialogState();
}

class _CategoryCreationDialogState
    extends ConsumerState<CategoryCreationDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _totalSessionsController;
  final List<TextEditingController> _sessionFollowUpsCountControllers = [];
  late String _selectedIcon;
  late String _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  String? _existingConsentName;
  String? _consentFormUrl;
  List<CategorySessionModel> _sessions = [];
  bool _isLoadingDetail = false;
  bool _isSubmitting = false;

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
    _selectedImage = widget.initialImage ?? '';
    _existingConsentName = widget.initialConsentName;
    _consentFormUrl = widget.initialConsentFormUrl;

    if (widget.initialSessions != null && widget.initialSessions!.isNotEmpty) {
      _sessions = List.from(
        widget.initialSessions!.map(
          (s) => CategorySessionModel(
            sessionNumber: s.sessionNumber,
            followUps: List.from(s.followUps),
          ),
        ),
      );
    } else {
      _sessions = List.generate(initialTotalSessions, (index) {
        return CategorySessionModel(sessionNumber: index + 1, followUps: []);
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

    if (widget.categoryId != null) {
      _isLoadingDetail = true;
      _fetchCategoryDetail();
    }
  }

  void _fetchCategoryDetail() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final detail = await ref
            .read(categoryViewModelProvider.notifier)
            .getCategoryDetail(widget.categoryId!);
        if (detail != null && mounted) {
          _populateFromCategory(detail);
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load category details.')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingDetail = false;
          });
        }
      }
    });
  }

  void _populateFromCategory(CategoryDetailDto cat) {
    _nameController.text = cat.name ?? '' ;
    _totalSessionsController.text = cat.totalSessions.toString();
    _selectedIcon = cat.icon ?? '';
    _selectedImage = cat.image ?? '';
    _existingConsentName = cat.consentFormName;
    _consentFormUrl = cat.consentFormUrl;

  _sessions = List.from(
  cat.defaultSessions?.map(
        (s) => CategorySessionModel(
          sessionNumber: s.sessionNumber,
          followUps: List.from(
            s.followUps?.map(
                  (f) => CategoryFollowUpModel(
                    type: f.type ?? '',
                    durationValue: f.durationValue ?? 0,
                    durationUnit:
                        unitValues.reverse[f.durationUnit] ?? 'minutes',
                    intervalValue: f.intervalValue ?? 0,
                    intervalUnit: f.intervalUnit ?? '',
                    isImageRequired: f.isImageRequired ?? false,
                    notes: f.notes ?? '',
                  ),
                ) ??
                [],
          ),
        ),
      ) ??
      [],
); _syncFollowUpsCountControllers();

    _preNotificationEntries = List.from(
      cat.preNotifications?.map(
        (config) => NotificationEntry(
          titleController: TextEditingController(text: config.title),
          messageController: TextEditingController(text: config.message),
          timingValueController: TextEditingController(
            text: config.timing.toString(),
          ),
          timingUnit: unitValues.reverse[config.timingUnit] ?? 'hours',
          type: typeValues.reverse[config.type] ?? 'reminder',
        ),
      ) ?? [],
    );

    _postNotificationEntries = List.from(
      cat.postNotifications?.map(
        (config) => NotificationEntry(
          titleController: TextEditingController(text: config.title),
          messageController: TextEditingController(text: config.message),
          timingValueController: TextEditingController(
            text: config.timing.toString(),
          ),
          timingUnit: unitValues.reverse[config.timingUnit] ?? 'hours',
          type: typeValues.reverse[config.type] ?? 'care',
        ),
      ) ?? [],
    );

    _downtimeLowController.text = cat.downtimePresets?.low.toString() ?? "";
    _downtimeModerateController.text = cat.downtimePresets?.moderate.toString() ?? "";
    _downtimeHighController.text = cat.downtimePresets?.high.toString() ?? "";

    _selectedRoles = List.from(
      cat.defaultRoles?.map((r) => defaultRoleValues.reverse[r] ?? '') ?? [],
    );
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
    if (widget.isViewMode) return;
    final count = int.tryParse(val) ?? 1;
    if (count < 1) return;
    setState(() {
      if (count > _sessions.length) {
        for (int i = _sessions.length; i < count; i++) {
          _sessions.add(
            CategorySessionModel(sessionNumber: i + 1, followUps: []),
          );
        }
      } else if (count < _sessions.length) {
        _sessions = _sessions.sublist(0, count);
      }
      _syncFollowUpsCountControllers();
    });
  }

  void _updateSessionFollowUpCount(int sIdx, String val) {
    if (widget.isViewMode) return;
    final count = int.tryParse(val) ?? 0;
    if (count < 0) return;
    setState(() {
      final session = _sessions[sIdx];
      final currentFus = List<CategoryFollowUpModel>.from(session.followUps);
      if (count > currentFus.length) {
        for (int i = currentFus.length; i < count; i++) {
          currentFus.add(CategoryFollowUpModel(type: 'virtual'));
        }
      } else if (count < currentFus.length) {
        currentFus.removeRange(count, currentFus.length);
      }
      _sessions[sIdx] = CategorySessionModel(
        sessionNumber: session.sessionNumber,
        followUps: currentFus,
      );
    });
  }

  Future<void> _pickConsent() async {
    if (widget.isViewMode) {
      _viewConsentPdf();
      return;
    }
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty || !mounted) return;

    final file = result.files.first;
    final url = await _uploadWithLoading(
      loadingMessage: 'Uploading consent form...',
      errorMessage: 'Failed to upload consent form',
      logLabel: 'Category consent form',
      upload: () => ref
          .read(categoryViewModelProvider.notifier)
          .uploadConsentFile(file, showLoading: false, showError: false),
    );
    if (url == null || !mounted) return;

    setState(() {
      _consentFormUrl = url;
      _existingConsentName = file.name;
    });
  }

  void _viewConsentPdf() async {
    final pdfUrl = _consentFormUrl ?? widget.initialConsentFormUrl;
    if (pdfUrl == null || pdfUrl.isEmpty) {
      _showPdfError();
    } else {
      try {
        final uri = Uri.parse(pdfUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          _showPdfError();
        }
      } catch (_) {
        _showPdfError();
      }
    }
  }

  void _showPdfError() {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Consent Form Preview",
        width: context.w(400),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.picture_as_pdf_outlined,
              color: CustomColors.red,
              size: 48,
            ),
            context.verticalSpace(12),
            Text("PDF Not Available", style: context.fonts.black14w600),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<String?> _uploadWithLoading({
    required String loadingMessage,
    required String errorMessage,
    required String logLabel,
    required Future<String?> Function() upload,
  }) async {
    EasyLoading.show(status: loadingMessage);
    final url = await upload();
    if (url == null || url.isEmpty) {
      EasyLoading.showError(errorMessage);
      return null;
    }
    EasyLoading.dismiss();
    log('$logLabel uploaded URL: $url');
    return url;
  }

  Future<void> _submitCategory() async {
    if (_nameController.text.isEmpty || _isSubmitting) {
      EasyLoading.showError('Please Enter The Name');
      return;
    }
    final selectedCategoryName = ref
        .read(categoryViewModelProvider)
        .selectedCategoryDetail
        ?.name;
    if (selectedCategoryName == _nameController.text) {
      EasyLoading.showError('Parent Name Can\'t Be sub Category Name ');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (!mounted) return;
      final request = CreateCategoryRequest(
        name: _nameController.text,
        icon: _selectedIcon,
        image: _selectedImage,
        parentId: widget.categoryId,
        totalSessions: int.tryParse(_totalSessionsController.text) ?? 1,
        consentFormUrl: _consentFormUrl,
        consentFormName: _existingConsentName,
        defaultSessions: _sessions,
        preNotifications: _preNotificationEntries
            .map((e) => e.toConfig())
            .toList(),
        postNotifications: _postNotificationEntries
            .map((e) => e.toConfig())
            .toList(),
        downtimePresets: CategoryDowntimePresetModel(
          none: 0,
          low: int.tryParse(_downtimeLowController.text) ?? 2,
          moderate: int.tryParse(_downtimeModerateController.text) ?? 5,
          high: int.tryParse(_downtimeHighController.text) ?? 10,
        ),
        defaultRoles: _selectedRoles,
      );

      ref
          .read(categoryViewModelProvider.notifier)
          .createCategory(request: request)
          .then((value) {
            if (value == true) {
              Navigator.pop(context);
            }
          });

      // Navigator.pop(context, {
      //   'name': _nameController.text,
      //   'totalSessions': int.tryParse(_totalSessionsController.text) ?? 1,
      //   'icon': _selectedIcon,
      //   'image': _selectedImage,
      //   'consentFormUrl': _consentFormUrl,
      //   'consentFormName': _existingConsentName,
      //   'sessions': _sessions,
      //   'preNotifications': _preNotificationEntries
      //       .map((e) => e.toConfig())
      //       .toList(),
      //   'postNotifications': _postNotificationEntries
      //       .map((e) => e.toConfig())
      //       .toList(),
      //   'downtimePresets': CategoryDowntimePresetModel(
      //     none: 0,
      //     low: int.tryParse(_downtimeLowController.text) ?? 2,
      //     moderate: int.tryParse(_downtimeModerateController.text) ?? 5,
      //     high: int.tryParse(_downtimeHighController.text) ?? 10,
      //   ),
      //   'defaultRoles': _selectedRoles,
      // });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _pickIcon() async {
    if (widget.isViewMode) return;
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null || !mounted) return;

    final url = await _uploadWithLoading(
      loadingMessage: 'Uploading icon...',
      errorMessage: 'Failed to upload icon',
      logLabel: 'Category icon',
      upload: () => ref
          .read(categoryViewModelProvider.notifier)
          .uploadCategoryIcon(image, showLoading: false, showError: false),
    );
    if (url == null || !mounted) return;

    setState(() {
      _selectedIcon = url;
    });
  }

  Future<void> _pickImage() async {
    if (widget.isViewMode) return;
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null || !mounted) return;

    final url = await _uploadWithLoading(
      loadingMessage: 'Uploading image...',
      errorMessage: 'Failed to upload image',
      logLabel: 'Category image',
      upload: () => ref
          .read(categoryViewModelProvider.notifier)
          .uploadCategoryImage(image, showLoading: false, showError: false),
    );
    if (url == null || !mounted) return;

    setState(() {
      _selectedImage = url;
    });
  }

  Widget _buildIconPreview() {
    if (_selectedIcon.isNotEmpty && _selectedIcon.startsWith('http')) {
      return AppNetworkImage(
        imageUrl: _selectedIcon,
        fit: BoxFit.cover,
        errorIcon: Icons.broken_image,
        errorIconSize: 32.sp,
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            size: 32.sp,
            color: CustomColors.purple,
          ),
          context.verticalSpace(8),
          Text(
            widget.isViewMode ? 'No icon uploaded' : 'Tap to upload',
            style: context.fonts.purple12w700,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage.isNotEmpty && _selectedImage.startsWith('http')) {
      return AppNetworkImage(
        imageUrl: _selectedImage,
        fit: BoxFit.cover,
        errorIcon: Icons.broken_image,
        errorIconSize: 32.sp,
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            size: 32.sp,
            color: CustomColors.purple,
          ),
          context.verticalSpace(8),
          Text(
            widget.isViewMode ? 'No image uploaded' : 'Tap to upload',
            style: context.fonts.purple12w700,
          ),
        ],
      ),
    );
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
            if (!widget.isViewMode)
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
                        if (!widget.isViewMode)
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
                      readOnly: widget.isViewMode,
                    ),
                    context.verticalSpace(12),
                    BuildTextField(
                      label: 'Message Content',
                      controller: entry.messageController,
                      hintText: 'Enter notification message...',
                      maxLines: 2,
                      readOnly: widget.isViewMode,
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
                            readOnly: widget.isViewMode,
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
                                    onChanged: widget.isViewMode
                                        ? null
                                        : (v) {
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
                              onChanged: widget.isViewMode
                                  ? null
                                  : (v) {
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
                  onChanged: widget.isViewMode
                      ? null
                      : (val) {
                          if (val != null) {
                            setState(() {
                              final newFus = List<CategoryFollowUpModel>.from(
                                _sessions[sIdx].followUps,
                              );
                              newFus[fuIdx] = newFus[fuIdx].copyWith(type: val);
                              _sessions[sIdx] = _sessions[sIdx].copyWith(
                                followUps: newFus,
                              );
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
                            readOnly: widget.isViewMode,
                            decoration: AppDecorations.input(
                              context,
                              hint: '30',
                            ),
                            onChanged: (v) {
                              final value = int.tryParse(v);
                              setState(() {
                                final newFus = List<CategoryFollowUpModel>.from(
                                  _sessions[sIdx].followUps,
                                );
                                newFus[fuIdx] = newFus[fuIdx].copyWith(
                                  durationValue: value,
                                );
                                _sessions[sIdx] = _sessions[sIdx].copyWith(
                                  followUps: newFus,
                                );
                              });
                            },
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
                              onChanged: widget.isViewMode
                                  ? null
                                  : (v) {
                                      if (v != null) {
                                        setState(() {
                                          final newFus =
                                              List<CategoryFollowUpModel>.from(
                                                _sessions[sIdx].followUps,
                                              );
                                          newFus[fuIdx] = newFus[fuIdx]
                                              .copyWith(durationUnit: v);
                                          _sessions[sIdx] = _sessions[sIdx]
                                              .copyWith(followUps: newFus);
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
                  readOnly: widget.isViewMode,
                  decoration: AppDecorations.input(context, hint: '1'),
                  onChanged: (v) {
                    final value = int.tryParse(v);
                    setState(() {
                      final newFus = List<CategoryFollowUpModel>.from(
                        _sessions[sIdx].followUps,
                      );
                      newFus[fuIdx] = newFus[fuIdx].copyWith(
                        intervalValue: value,
                      );
                      _sessions[sIdx] = _sessions[sIdx].copyWith(
                        followUps: newFus,
                      );
                    });
                  },
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
                    onChanged: widget.isViewMode
                        ? null
                        : (v) {
                            if (v != null) {
                              setState(() {
                                final newFus = List<CategoryFollowUpModel>.from(
                                  _sessions[sIdx].followUps,
                                );
                                newFus[fuIdx] = newFus[fuIdx].copyWith(
                                  intervalUnit: v,
                                );
                                _sessions[sIdx] = _sessions[sIdx].copyWith(
                                  followUps: newFus,
                                );
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
    if (widget.categoryId != null && _isLoadingDetail) {
      return StandardDialog(
        title: 'Category Details',
        width: context.w(700),
        content: SizedBox(
          height: context.h(300),
          child: const Center(
            child: CircularProgressIndicator(color: CustomColors.purple),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    }

    return StandardDialog(
      title: widget.isViewMode
          ? 'Category Configuration'
          : (widget.initialName != null
                ? 'Edit Category'
                : (widget.parentName == null
                      ? 'Create New Category'
                      : 'Add Subcategory to ${widget.parentName}')),
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
            readOnly: widget.isViewMode,
          ),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Category Icon',
                      style: context.fonts.black14w600,
                    ),
                    context.verticalSpace(12),
                    GestureDetector(
                      onTap: _pickIcon,
                      child: Container(
                        width: double.infinity,
                        height: 120.w,
                        decoration: BoxDecoration(
                          color: CustomColors.whiteGrey,
                          borderRadius: context.appBorderRadius(all: 12),
                          border: Border.all(color: CustomColors.border),
                        ),
                        child: ClipRRect(
                          borderRadius: context.appBorderRadius(all: 12),
                          child: _buildIconPreview(),
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
                    Text(
                      'Select Category Image',
                      style: context.fonts.black14w600,
                    ),
                    context.verticalSpace(12),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 120.w,
                        decoration: BoxDecoration(
                          color: CustomColors.whiteGrey,
                          borderRadius: context.appBorderRadius(all: 12),
                          border: Border.all(color: CustomColors.border),
                        ),
                        child: ClipRRect(
                          borderRadius: context.appBorderRadius(all: 12),
                          child: _buildImagePreview(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            readOnly: widget.isViewMode,
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
                            readOnly: widget.isViewMode,
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
                  readOnly: widget.isViewMode,
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: BuildTextField(
                  label: 'Moderate',
                  controller: _downtimeModerateController,
                  hintText: '5',
                  keyboardType: TextInputType.number,
                  readOnly: widget.isViewMode,
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: BuildTextField(
                  label: 'High',
                  controller: _downtimeHighController,
                  hintText: '10',
                  keyboardType: TextInputType.number,
                  readOnly: widget.isViewMode,
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
                onSelected: widget.isViewMode
                    ? null
                    : (selected) {
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
                      _existingConsentName ??
                          (widget.isViewMode
                              ? 'PDF Not Available'
                              : 'Upload Default PDF'),
                      style: _existingConsentName != null
                          ? context.fonts.black14w600
                          : context.fonts.grey14w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    widget.isViewMode
                        ? Icons.open_in_new_rounded
                        : Icons.cloud_upload_outlined,
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
      actions: widget.isViewMode
          ? [
              CustomPrimaryButton(
                onTap: () => Navigator.pop(context),
                label: 'Close',
                width: context.w(120),
              ),
            ]
          : [
              TextButton(
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              SizedBox(
                width: context.w(120),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitCategory,
                  child: _isSubmitting
                      ? SizedBox(
                          width: context.w(20),
                          height: context.h(20),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(widget.initialName != null ? 'Update' : 'Create'),
                ),
              ),
            ],
    );
  }
}
