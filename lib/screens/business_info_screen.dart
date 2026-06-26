import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';

class BusinessInformationScreen extends StatefulWidget {
  const BusinessInformationScreen({super.key});

  @override
  State<BusinessInformationScreen> createState() =>
      _BusinessInformationScreenState();
}

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _operatingHoursController =
      TextEditingController();
  final TextEditingController _clinicDescriptionController =
      TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  @override
  void dispose() {
    _clinicNameController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneNumberController.dispose();
    _emailAddressController.dispose();
    _operatingHoursController.dispose();
    _clinicDescriptionController.dispose();
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
                style: context.fonts.black18w600,
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
                  style: context.fonts.black14w600,
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
                  style: context.fonts.black14w600,
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
    return GradientScaffold(
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
          'Business Information',
          style: context.fonts.black18w600,
        ),
      ],
    );
  }

  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.05),
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
          // Clinic Name
          BuildTextField(
            label: 'Clinic Name',
            controller: _clinicNameController,
            hintText: 'Skin Sync Aesthetics',
          ),
          SizedBox(height: 20.h),
          // Street Address
          BuildTextField(
            label: 'Street Address',
            controller: _streetAddressController,
            hintText: '123 Medical Plaza, Suite 100',
          ),
          SizedBox(height: 20.h),
          // City, State, ZIP Code Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: BuildTextField(
                  label: 'City',
                  controller: _cityController,
                  hintText: 'Los Angeles',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                flex: 2,
                child: BuildTextField(
                  label: 'State',
                  controller: _stateController,
                  hintText: 'CA',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                flex: 2,
                child: BuildTextField(
                  label: 'ZIP Code',
                  controller: _zipCodeController,
                  hintText: '90001',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Phone Number, Email Address Row
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Phone Number',
                  controller: _phoneNumberController,
                  hintText: '+1 (555) 123-4567',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: BuildTextField(
                  label: 'Email Address',
                  controller: _emailAddressController,
                  hintText: 'info@skinsyncclinic.com',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Operating Hours
          BuildTextField(
            label: 'Operating Hours',
            controller: _operatingHoursController,
            hintText: 'Mon-Fri: 9AM-6PM, Sat: 10AM-4PM',
          ),
          SizedBox(height: 20.h),
          // Clinic Description
          BuildTextField(
            label: 'Clinic Description',
            controller: _clinicDescriptionController,
            hintText:
                'Premier aesthetic clinic specializing in non-surgical facial treatments',
            maxLines: 4,
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
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: kIsWeb
                            ? AppNetworkImage(
                                imageUrl: _selectedImage!.path,
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
              style: context.fonts.black14w600,
            ),
            SizedBox(height: 4.h),
            Text(
              'Upload your profile picture',
              style: context.fonts.grey12w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        Expanded(
          child: CustomPrimaryButton(
            onTap: () {
              // Handle save changes
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Changes saved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            label: 'Save Changes',
          ),
        ),
        SizedBox(width: 16.w),
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

// Custom Painter for Dotted Circle Border
class DottedCircleBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  DottedCircleBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final circumference = 2 * pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashLength + gapLength)) / radius;
      final sweepAngle = dashLength / radius;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
