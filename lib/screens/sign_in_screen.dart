import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/services/url_launcher_services.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/requests/login_request_model.dart';
import '../utils/validators.dart';
import '../view_models/auth_view_model.dart';
import 'bottom_nav_screens/user_management.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const String routeName = '/sign-in-screen';

  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String selectedValue = 'Doctor (Clinic Owner)';

  final List<String> roles = [
    'Doctor (Clinic Owner)',
    'Receptionist',
    'Assistant',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        children: [
          Image.asset(PngAssets.splashLogo, height: 100.w, width: 100.w),
          SizedBox(height: 9.h),
          Text(
            "SkinSync AI",
            style: TextStyle(
              fontSize: 33.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7BA8),
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: 40.h),
          Center(
            child: Container(
              width: 430.w,
              // height: 480.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 8.h),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Enter your details to login your account",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Full Name Field
                    _buildTextField(
                      label: "Email Address",
                      hintText: "Enter Your Email Address",
                      controller: _emailController,
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),

                    // Password Field
                    _buildPasswordField(
                      label: "Password",
                      hintText: "Enter your password",
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onToggle: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    SizedBox(height: 8.h),

                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          // handle forget password
                        },
                        child: Text(
                          "Forget Password",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFF2881F5),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    _rowWidget(),
                    SizedBox(height: 30.h),

                    // Create Account Button
                    GestureDetector(
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        if (!_acceptTerms) {
                          EasyLoading.showError(
                            "Please accept the terms & conditions",
                          );
                          return;
                        }

                        ref
                            .read(authViewModelProvider.notifier)
                            .login(
                              loginReq: LoginRequestModel(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            )
                            .then((success) {
                              if (success && context.mounted) {
                                context.goNamed(UserManagement.routeName);
                              }
                            });
                      },
                      child: Container(
                        // width: 215.w,
                        // height: 50.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        ),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14.sp,
              height: 0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: "*",
                  style: TextStyle(height: 0, color: Colors.red),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          validator: Validators.email,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              height: 0,

              fontSize: 14.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14.sp,
              height: 0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: Validators.password,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              height: 0,

              fontSize: 14.sp,
              color: Colors.grey.shade400,
            ),
            // filled: true,
            // fillColor: Colors.white,
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8.r),
            //   borderSide: BorderSide(color: Colors.grey.shade300),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8.r),
            //   borderSide: BorderSide(color: Colors.grey.shade300),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8.r),
            //   borderSide: BorderSide(color: Colors.blue, width: 1.5),
            // ),
            // contentPadding: EdgeInsets.symmetric(
            //   horizontal: 16.w,
            //   vertical: 14.h,
            // ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey.shade600,
                size: 20.sp,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  bool _acceptTerms = false;
  Widget _rowWidget() {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: SizedBox(
            width: 26.w,
            height: 26.h,
            child: Checkbox(
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () {
            UrlLauncherService.instance.launchURL(
              "https://skinsyncai.com/terms-of-service/",
            );
          },
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "I accept the  Terms & Conditions",
                style: TextStyle(
                  fontSize: 18.sp,
                  height: 0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Secured with Profile Verification API",
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 0,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
