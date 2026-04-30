import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/models/requests/app_version_request_model.dart';
import 'package:skinsync_admin/view_models/setting_view_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';

class SettingScreen extends ConsumerStatefulWidget {
  static const String routeName = '/setting-screen';
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  final TextEditingController _customerAndroidVersionCtrl =
      TextEditingController();
  final TextEditingController _customerAndroidBuildCtrl =
      TextEditingController();
  final TextEditingController _customerIosVersionCtrl = TextEditingController();
  final TextEditingController _customerIosBuildCtrl = TextEditingController();

  final TextEditingController _clinicAndroidVersionCtrl =
      TextEditingController();
  final TextEditingController _clinicAndroidBuildCtrl = TextEditingController();
  final TextEditingController _clinicIosVersionCtrl = TextEditingController();
  final TextEditingController _clinicIosBuildCtrl = TextEditingController();

  final GlobalKey<FormState> _customerAndroidFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _customerIosFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _clinicAndroidFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _clinicIosFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _customerAndroidVersionCtrl.dispose();
    _customerAndroidBuildCtrl.dispose();
    _customerIosVersionCtrl.dispose();
    _customerIosBuildCtrl.dispose();
    _clinicAndroidVersionCtrl.dispose();
    _clinicAndroidBuildCtrl.dispose();
    _clinicIosVersionCtrl.dispose();
    _clinicIosBuildCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text("Settings", style: CustomFonts.black30w600),
          SizedBox(height: 10.h),
          Text(
            "Manage application versions for Customer and Clinic apps.",
            style: CustomFonts.grey18w400,
          ),
          SizedBox(height: 30.h),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text("Customer App", style: CustomFonts.black20w500),
              childrenPadding: EdgeInsets.all(15.w),
              collapsedBackgroundColor: CustomColors.whiteColor,
              backgroundColor: CustomColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(color: CustomColors.borderColor),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(color: CustomColors.borderColor),
              ),
              children: [
                _buildVersionSection(
                  title: "Android",
                  formKey: _customerAndroidFormKey,
                  versionController: _customerAndroidVersionCtrl,
                  buildController: _customerAndroidBuildCtrl,
                  type: "android",
                  isCustomer: true,
                ),
                SizedBox(height: 20.h),
                _buildVersionSection(
                  title: "IOS",
                  formKey: _customerIosFormKey,
                  versionController: _customerIosVersionCtrl,
                  buildController: _customerIosBuildCtrl,
                  type: "ios",
                  isCustomer: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text("Clinic App", style: CustomFonts.black20w500),
              childrenPadding: EdgeInsets.all(15.w),
              collapsedBackgroundColor: CustomColors.whiteColor,
              backgroundColor: CustomColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(color: CustomColors.borderColor),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(color: CustomColors.borderColor),
              ),
              children: [
                _buildVersionSection(
                  title: "Android",
                  formKey: _clinicAndroidFormKey,
                  versionController: _clinicAndroidVersionCtrl,
                  buildController: _clinicAndroidBuildCtrl,
                  type: "android",
                  isCustomer: false,
                ),
                SizedBox(height: 20.h),
                _buildVersionSection(
                  title: "IOS",
                  formKey: _clinicIosFormKey,
                  versionController: _clinicIosVersionCtrl,
                  buildController: _clinicIosBuildCtrl,
                  type: "ios",
                  isCustomer: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionSection({
    required String title,
    required GlobalKey<FormState> formKey,
    required TextEditingController versionController,
    required TextEditingController buildController,
    required String type,
    required bool isCustomer,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: CustomColors.dashboardBackgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: CustomColors.borderColor),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: CustomFonts.black18w600),
            SizedBox(height: 15.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Version Number", style: CustomFonts.black14w500),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: versionController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: CustomColors.whiteColor,
                          hintText: "e.g. 1.2.0",
                          hintStyle: CustomFonts.grey14w400,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: CustomColors.textFeildBoaderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: CustomColors.borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: CustomColors.blueColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Build Number", style: CustomFonts.black14w500),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: buildController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: CustomColors.whiteColor,
                          hintText: "e.g. 5",
                          hintStyle: CustomFonts.grey14w400,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: CustomColors.textFeildBoaderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: CustomColors.borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: CustomColors.blueColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _submitUpdate(
                    formKey: formKey,
                    versionController: versionController,
                    buildController: buildController,
                    type: type,
                    isCustomer: isCustomer,
                  );
                },
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: CustomColors.blackColor,
                //   padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(30.r),
                //   ),
                // ),
                child: Text("Submit", style: CustomFonts.white16w400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitUpdate({
    required GlobalKey<FormState> formKey,
    required TextEditingController versionController,
    required TextEditingController buildController,
    required String type,
    required bool isCustomer,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final req = AppVersionRequestModel(
      type: type,
      version: versionController.text.trim(),
      buildNumber: buildController.text.trim(),
    );

    bool success = false;
    if (isCustomer) {
      success = await ref
          .read(settingViewModelProvider.notifier)
          .updateCustomerAppVersion(req);
    } else {
      success = await ref
          .read(settingViewModelProvider.notifier)
          .updateClinicAppVersion(req);
    }
    if (success) {
      versionController.clear();
      buildController.clear();
    }
  }
}
