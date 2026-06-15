import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

import '../utils/theme.dart';
import '../widgets/custom_primary_button.dart';

class StaticContentScreen extends StatefulWidget {
  const StaticContentScreen({super.key});

  @override
  State<StaticContentScreen> createState() => _StaticContentScreenState();
}

class _StaticContentScreenState extends State<StaticContentScreen> {
  int _selectedTab = 0;
  late QuillController _quillController;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  final List<String> _tabs = ['Terms & Conditions', 'Privacy Policy', 'About'];
  final List<String> _tabDescriptions = [
    'Edit the terms and conditions displayed to users',
    'Edit the privacy policy displayed to users',
    'Edit the about information displayed to users',
  ];

  // Sample content for each tab
  final Map<int, String> _lastUpdatedDates = {
    0: '11/4/2025',
    1: '10/15/2025',
    2: '09/20/2025',
  };

  @override
  void initState() {
    super.initState();
    _initQuillController();
  }

  void _initQuillController() {
    _quillController = QuillController.basic(
      config: const QuillControllerConfig(),
    );
    // Insert sample content
    _quillController.document = Document()
      ..insert(0, _getSampleContent(_selectedTab));
  }

  String _getSampleContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return '''Welcome to our platform. By using our services, you agree to comply with and be bound by the following terms and conditions...

1. Acceptance of Terms
By accessing and using this service, you accept and agree to be bound by the terms and provision of this agreement.

2. Use License
Permission is granted to temporarily download one copy of the materials on our platform for personal, non-commercial transitory viewing only.

3. Disclaimer
The materials on our platform are provided on an "as is" basis. We make no warranties, expressed or implied, and hereby disclaim and negate all other warranties.

4. Limitations
In no event shall our company or its suppliers be liable for any damages arising out of the use or inability to use the materials on our platform.
''';
      case 1:
        return '''Privacy Policy

Your privacy is important to us. This privacy policy explains how we collect, use, and protect your personal information...

1. Information We Collect
We collect information you provide directly to us when using our services.

2. How We Use Your Information
We use the information we collect to provide, maintain, and improve our services.

3. Information Sharing
We do not share your personal information with third parties except as described in this policy.
''';
      case 2:
        return '''About Us

Welcome to our platform. We are dedicated to providing the best service to our users...

Our Mission
To deliver exceptional value and service to our customers.

Our Vision
To be the leading platform in our industry.

Contact Us
For any inquiries, please reach out to our support team.
''';
      default:
        return '';
    }
  }

  void _onTabSelected(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
        _quillController.document = Document()
          ..insert(0, _getSampleContent(index));
        _quillController.updateSelection(
          const TextSelection.collapsed(offset: 0),
          ChangeSource.local,
        );
      });
    }
  }

  void _saveChanges() {
    // Handle save changes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_tabs[_selectedTab]} saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _quillController.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Static Content',
                style: context.fonts.black24w700,
              ),
              SizedBox(height: 8.h),
              // Subtitle
              Text(
                'Manage financial transactions and release payments to clinics',
                style: context.fonts.grey14w400,
              ),
              SizedBox(height: 16.h),
              // Divider
              Divider(color: Colors.grey[300], thickness: 1),
              SizedBox(height: 16.h),
              // Main Content Container
              Container(
                width: double.infinity,
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
                    // Tab Buttons Row
                    Container(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: List.generate(
                          _tabs.length,
                          (index) => Expanded(child: _buildTabButton(index)),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[200], thickness: 1, height: 1),
                    // Content Section
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Row(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 20.sp,
                                color: Colors.grey[700],
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                _tabs[_selectedTab],
                                style: context.fonts.black16w600,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _tabDescriptions[_selectedTab],
                            style: context.fonts.grey13w500,
                          ),
                          SizedBox(height: 16.h),
                          // Content Label
                          Text(
                            'Content',
                            style: context.fonts.black14w500,
                          ),
                          SizedBox(height: 12.h),
                          // Quill Editor Container
                          Container(
                            width: double.infinity,
                            height: 280.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: QuillEditor(
                                focusNode: _editorFocusNode,
                                scrollController: _editorScrollController,
                                controller: _quillController,
                                config: QuillEditorConfig(
                                  placeholder: 'Enter content here...',
                                  padding: EdgeInsets.all(12.w),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // Last Updated and Save Button Row
                          Row(
                            children: [
                              Text(
                                'Last updated: ${_lastUpdatedDates[_selectedTab]}',
                                style: context.fonts.grey13w500,
                              ),
                              const Spacer(),
                              CustomPrimaryButton(
                                onTap: _saveChanges,
                                icon: Icons.save_outlined,
                                label: 'Save Changes',
                                width: 180.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              // Important Note Widget
              _buildImportantNoteWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF8E1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? Border.all(color: const Color(0xFFFFE082), width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            _tabs[index],
            style: isSelected ? context.fonts.black13w600 : context.fonts.grey13w500,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildImportantNoteWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFE082), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD54F),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(Icons.info_outline, size: 16.sp, color: Colors.black87),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Note',
                  style: context.fonts.black14w600,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Changes to static content will be immediately reflected on both the website and mobile application. Please review carefully before saving. Consider consulting with legal counsel before making changes to Terms & Conditions or Privacy Policy.',
                  style: context.fonts.grey13w500h14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
