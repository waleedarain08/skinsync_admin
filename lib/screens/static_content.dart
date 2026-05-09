import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/custom_fonts.dart';
import '../utils/color_constant.dart';

class StaticContentScreen extends StatefulWidget {
  const StaticContentScreen({super.key});

  @override
  State<StaticContentScreen> createState() => _StaticContentScreenState();
}

class _StaticContentScreenState extends State<StaticContentScreen> {
  String _aboutContent =
      'Welcome to our premier healthcare and wellness platform connecting patients...';

  String _termsContent = 'These terms govern your use of our platform...';

  String _privacyContent = 'Your privacy is important to us...';
  int selectedIndex = 2;

  final List<String> tabs = ['Terms & Conditions', 'Privacy Policy', 'About'];

  final Map<int, String> titles = {
    0: 'Terms & Conditions',
    1: 'Privacy Policy',
    2: 'About',
  };

  late final TextEditingController contentController = TextEditingController(
    text: _aboutContent,
  );

  void _onTabChanged(int index) {
    setState(() {
      selectedIndex = index;
      contentController.text = index == 0
          ? _termsContent
          : index == 1
          ? _privacyContent
          : _aboutContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Screen Title
            Text(
              'Static Content',
              style: CustomFonts.textMain24w700,
            ),

            SizedBox(height: 12.h),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 20.h),

            /// Main Container
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Segmented Buttons
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F3),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final isActive = selectedIndex == index;
                        return Expanded(
                          child: InkWell(
                            onTap: () => _onTabChanged(index),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Text(
                                tabs[index],
                                textAlign: TextAlign.center,
                                style: isActive ? CustomFonts.textMain14w600 : CustomFonts.textMuted14w400,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  /// Section Title
                  Text(
                    titles[selectedIndex]!,
                    style: CustomFonts.textMain16w600,
                  ),

                  SizedBox(height: 12.h),

                  /// Content Field
                  TextFormField(
                    controller: contentController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF7F7F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(16.w),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// Footer Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last updated: 11/4/2025',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        icon: const Icon(Icons.save, size: 16),
                        label: Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// Important Note
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFFFE2A8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Changes to static content will be immediately reflected on both the website and mobile application. '
                      'Please review carefully before saving.',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
