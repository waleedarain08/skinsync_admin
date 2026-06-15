import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class StaticContentScreen extends StatefulWidget {
  const StaticContentScreen({super.key});

  @override
  State<StaticContentScreen> createState() => _StaticContentScreenState();
}

class _StaticContentScreenState extends State<StaticContentScreen> {
  final String _aboutContent =
      'Welcome to our premier healthcare and wellness platform connecting patients...';

  final String _termsContent = 'These terms govern your use of our platform...';

  final String _privacyContent = 'Your privacy is important to us...';
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
    return GradientScaffold(
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Screen Title
            Text(
              'Static Content',
              style: context.fonts.black24w700,
            ),

            SizedBox(height: 12.h),
            const Divider(color: CustomColors.border),
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
                      color: CustomColors.whiteGrey,
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
                                style: isActive ? context.fonts.black14w600 : context.fonts.grey14w400,
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
                    style: context.fonts.black16w600,
                  ),

                  SizedBox(height: 12.h),

                  /// Content Field
                  TextFormField(
                    controller: contentController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: CustomColors.whiteGrey,
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
                        style: context.fonts.grey12w400,
                      ),
                      CustomPrimaryButton(
                        onTap: () {},
                        icon: Icons.save,
                        label: 'Save Changes',
                        width: 180.w,
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
                color: CustomColors.paleAmber,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: CustomColors.amber),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: CustomColors.amber),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Changes to static content will be immediately reflected on both the website and mobile application. '
                      'Please review carefully before saving.',
                      style: context.fonts.black13w400,
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
