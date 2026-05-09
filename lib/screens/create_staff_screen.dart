import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/custom_fonts.dart';
import 'business_info_screen.dart';

class CreateStaffScreen extends StatefulWidget {
  const CreateStaffScreen({super.key});

  @override
  State<CreateStaffScreen> createState() => _CreateStaffScreenState();
}

class _CreateStaffScreenState extends State<CreateStaffScreen> {
  final TextEditingController _treatmentNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  // Dropdown values
  String? _selectedCategory;
  String? _selectedSubcategory;

  // Dropdown lists
  final List<String> _categories = [
    'Facial Treatments',
    'Body Treatments',
    'Skin Care',
    'Hair Treatments',
    'Massage Therapy',
    'Wellness',
  ];

  final List<String> _subcategories = [
    'Anti-Aging',
    'Hydration',
    'Acne Treatment',
    'Brightening',
    'Relaxation',
    'Deep Tissue',
  ];

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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image',
                style: CustomFonts.textMain20w600,
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: Colors.blue,
                    size: 24.sp,
                  ),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: CustomFonts.textMain14w600,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
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
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.green,
                    size: 24.sp,
                  ),
                ),
                title: Text(
                  'Take a Photo',
                  style: CustomFonts.textMain14w600,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              if (_selectedImage != null) ...[
                SizedBox(height: 8.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 24.sp,
                    ),
                  ),
                  title: Text(
                    'Remove Photo',
                    style: CustomFonts.textMain14w600.copyWith(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
              ],
              SizedBox(height: 16.h),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 250.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              _buildHeader(),
              SizedBox(height: 24.h),
              // Main Form Container
              _buildFormContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
        ),
        SizedBox(width: 12.w),
        Text(
          'Create Staff',
          style: CustomFonts.textMain18w600,
        ),
      ],
    );
  }

  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
          _buildProfilePictureSection(),
          SizedBox(height: 24.h),
          // Treatment Name
          _buildTextField(
            label: 'Treatment Name',
            controller: _treatmentNameController,
            hintText: 'e.g., Botox, Dermal Fillers',
          ),
          SizedBox(height: 20.h),
          // Category Dropdown
          _buildDropdownField(
            label: 'Category',
            hintText: 'Select category',
            value: _selectedCategory,
            items: _categories,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          SizedBox(height: 20.h),
          // Subcategory Dropdown
          _buildDropdownField(
            label: 'Subcategory',
            hintText: 'Select subcategory',
            value: _selectedSubcategory,
            items: _subcategories,
            onChanged: (value) {
              setState(() {
                _selectedSubcategory = value;
              });
            },
          ),
          SizedBox(height: 20.h),
          // Description
          _buildTextField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Describe the treatment and its benefits',
            maxLines: 5,
          ),
          SizedBox(height: 32.h),
          // Buttons Row
          _buildButtonsRow(),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection() {
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
              width: 68.w,
              height: 68.w,
              padding: EdgeInsets.all(2.w),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: kIsWeb
                            ? Image.network(
                                _selectedImage!.path,
                                width: 64.w,
                                height: 64.w,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_selectedImage!.path),
                                width: 64.w,
                                height: 64.w,
                                fit: BoxFit.cover,
                              ),
                      )
                    : Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 24.sp,
                          color: Colors.black87,
                        ),
                      ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        // Text Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Picture',
              style: CustomFonts.textMain14w600,
            ),
            SizedBox(height: 4.h),
            Text(
              'Upload your profile picture',
              style: CustomFonts.textMuted12w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CustomFonts.textMain14w600,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: CustomFonts.textMain14w400,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: CustomFonts.textMuted14w400,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CustomFonts.textMain14w600,
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          isExpanded: true,
          hint: Text(
            hintText,
            style: CustomFonts.textMuted14w400,
          ),
          initialValue: value,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: CustomFonts.textMain14w400,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey[500],
            size: 24.sp,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        // Create Staff Button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Handle create staff
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Staff created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Create Staff',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        // Cancel Button
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Handle cancel
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              side: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
