import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/category_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/nested_category_selector.dart';

import 'business_info_screen.dart';

class CreateStaffScreen extends ConsumerStatefulWidget {
  const CreateStaffScreen({super.key});

  @override
  ConsumerState<CreateStaffScreen> createState() => _CreateStaffScreenState();
}

class _CreateStaffScreenState extends ConsumerState<CreateStaffScreen> {
  final TextEditingController _treatmentNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  // Selected category data
  String? _categoryId;
  String? _categoryPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(categoryViewModelProvider.notifier).fetchCategories();
    });
  }


  @override
  void dispose() {
    _treatmentNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.r(16))),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: context.appEdgeInsets(all: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image',
                style: context.fonts.black20w600,
              ),
              context.verticalSpace(20),
              ListTile(
                leading: Container(
                  padding: context.appEdgeInsets(all: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: context.borderRadius(all: 8),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: Colors.blue,
                    size: context.sp(24),
                  ),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: context.fonts.black14w600,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              context.verticalSpace(8),
              ListTile(
                leading: Container(
                  padding: context.appEdgeInsets(all: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: context.borderRadius(all: 8),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.green,
                    size: context.sp(24),
                  ),
                ),
                title: Text(
                  'Take a Photo',
                  style: context.fonts.black14w600,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              if (_selectedImage != null) ...[
                context.verticalSpace(8),
                ListTile(
                  leading: Container(
                    padding: context.appEdgeInsets(all: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: context.borderRadius(all: 8),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: context.sp(24),
                    ),
                  ),
                  title: Text(
                    'Remove Photo',
                    style: context.fonts.black14w600.copyWith(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
              ],
              context.verticalSpace(16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.appEdgeInsets(vertical: 20, horizontal: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              _buildHeader(context),
              context.verticalSpace(24),
              // Main Form Container
              _buildFormContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: context.sp(24), color: Colors.black),
        ),
        context.horizontalSpace(12),
        Text(
          'Create Staff',
          style: context.fonts.black18w600,
        ),
      ],
    );
  }

  Widget _buildFormContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.appEdgeInsets(all: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.borderRadius(all: 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture Section
          _buildProfilePictureSection(context),
          context.verticalSpace(24),
          // Treatment Name
          BuildTextField(
            label: 'Treatment Name',
            controller: _treatmentNameController,
            hintText: 'e.g., Botox, Dermal Fillers',
          ),
          context.verticalSpace(20),
          // Category Selection
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category Hierarchy', style: context.fonts.black14w600),
              context.verticalSpace(8),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => NestedCategorySelector(
                      categories: ref.watch(categoryViewModelProvider).categories,
                      initialCategoryId: _categoryId,
                      onSelected: (cat, path) {
                        setState(() {
                          _categoryId = cat.id.toString();
                          _categoryPath = path;
                        });
                      },
                    ),
                  );
                },
                child: Container(
                  padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: context.borderRadius(all: 12),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _categoryPath ?? 'Select category',
                          style: _categoryPath == null 
                              ? context.fonts.grey14w400 
                              : context.fonts.black14w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          // Description
          BuildTextField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Describe the treatment and its benefits',
            maxLines: 5,
          ),
          context.verticalSpace(32),
          // Buttons Row
          _buildButtonsRow(context),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection(BuildContext context) {
    return Row(
      children: [
        // Profile Picture Circle with Dotted Border
        GestureDetector(
          onTap: _pickImage,
          child: CustomPaint(
            painter: DottedCircleBorderPainter(
              color: Colors.black87,
              strokeWidth: 1.5,
              dashLength: 6,
              gapLength: 4,
            ),
            child: Container(
              width: context.w(68),
              height: context.w(68),
              padding: context.appEdgeInsets(all: 2),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: kIsWeb
                            ? Image.network(
                                _selectedImage!.path,
                                width: context.w(64),
                                height: context.w(64),
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_selectedImage!.path),
                                width: context.w(64),
                                height: context.w(64),
                                fit: BoxFit.cover,
                              ),
                      )
                    : Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: context.sp(24),
                          color: Colors.black87,
                        ),
                      ),
              ),
            ),
          ),
        ),
        context.horizontalSpace(16),
        // Text Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Picture',
              style: context.fonts.black14w600,
            ),
            context.verticalSpace(4),
            Text(
              'Upload your profile picture',
              style: context.fonts.grey12w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomPrimaryButton(
            onTap: () {
              // Handle create staff
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Staff created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            label: 'Create Staff',
          ),
        ),
        context.horizontalSpace(16),
        // Cancel Button
        Expanded(
          child: CustomOutlinedButton(
            onTap: () {
              // Handle cancel
              Navigator.pop(context);
            },
            label: 'Cancel',
            color: Colors.grey[300],
            textColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
