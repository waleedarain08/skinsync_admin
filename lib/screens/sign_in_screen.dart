import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/services/url_launcher_services.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:pinput/pinput.dart';

import '../models/requests/auth_req_models.dart';
import '../utils/color_constant.dart';
import '../utils/enums.dart';
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
  // 🔑 FORM
  final _formKey = GlobalKey<FormState>();

  // 📩 Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _otpController = TextEditingController();

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // 👁️ Visibility
  bool _obscurePassword = true;
  final ValueNotifier<bool> _obscureNewPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  // 🔁 Flow
  AuthScreen _currentScreen = AuthScreen.login;
  String? _otp;

  void setCurrentScreen(AuthScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  bool _acceptTerms = false;
  Widget _rowWidget() {
    return Row(
      mainAxisAlignment: .center,
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    _obscureNewPassword.dispose();
    _obscureConfirmPassword.dispose();

    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(PngAssets.splashLogo, height: 100.w),

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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: _buildForm(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: switch (_currentScreen) {
        AuthScreen.login => _loginForm(),
        AuthScreen.forgetPassword => _forgetPasswordForm(),
        AuthScreen.verifyOtp => _verifyOtp(),
        AuthScreen.createNewPassword => _createNewPassword(),
      },
    );
  }

  // ================= LOGIN =================

  Widget _loginForm() {
    return Column(
      children: [
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
        _buildTextField(
          label: "Email",
          hintText: "Enter email",
          controller: _emailController,
        ),
        SizedBox(height: 20.h),

        _buildPasswordField(
          label: "Password",
          hintText: "Enter password",
          controller: _passwordController,
          obscureText: _obscurePassword,
          onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
        ),

        SizedBox(height: 20.h),
        _rowWidget(),
        SizedBox(height: 20.h),

        TextButton(
          onPressed: () => setCurrentScreen(AuthScreen.forgetPassword),
          child: const Text("Forgot Password"),
        ),

        GestureDetector(
          onTap: () async {
            if (!_formKey.currentState!.validate()) return;

            final success = await ref
                .read(authViewModelProvider.notifier)
                .login(
                  loginReq: LoginRequestModel(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                );

            if (success && context.mounted) {
              context.goNamed(UserManagement.routeName);
            }
          },
          child: _button("Login"),
        ),
      ],
    );
  }

  // ================= FORGOT =================

  Widget _forgetPasswordForm() {
    return Column(
      children: [
        _back(AuthScreen.login),
        SizedBox(height: 8.h),
        Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Enter your Email to receive OTP for password reset",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40.h),
        _buildTextField(
          label: "Email",
          hintText: "Enter email",
          controller: _emailController,
        ),
        SizedBox(height: 20.h),

        GestureDetector(
          onTap: () async {
            if (!_formKey.currentState!.validate()) return;

            final success = await ref
                .read(authViewModelProvider.notifier)
                .forgotPassword(email: _emailController.text.trim());

            if (success) {
              setCurrentScreen(AuthScreen.verifyOtp);
            }
          },
          child: _button("Send Code"),
        ),
      ],
    );
  }

  // ================= OTP =================

  Widget _verifyOtp() {
    return Column(
      children: [
        _back(AuthScreen.login),
        SizedBox(height: 8.h),
        Text(
          "Verify OTP",
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Enter your Email to receive OTP for password reset",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40.h),

        Pinput(controller: _otpController, length: 6),
        SizedBox(height: 10.h),

        GestureDetector(
          onTap: () async {
            final success = await ref
                .read(authViewModelProvider.notifier)
                .verifyOtp(
                  email: _emailController.text.trim(),
                  otp: _otpController.text.trim(),
                );

            if (success) {
              _otp = _otpController.text.trim();
              setCurrentScreen(AuthScreen.createNewPassword);
            }
          },
          child: _button("Verify OTP"),
        ),
      ],
    );
  }

  // ================= RESET =================

  Widget _createNewPassword() {
    return Column(
      children: [
        _back(AuthScreen.verifyOtp),

        ValueListenableBuilder(
          valueListenable: _obscureNewPassword,
          builder: (_, value, __) {
            return _buildPasswordField(
              label: "New Password",
              hintText: "Enter password",
              controller: _newPasswordController,
              obscureText: value,
              onToggle: () => _obscureNewPassword.value = !value,
            );
          },
        ),

        ValueListenableBuilder(
          valueListenable: _obscureConfirmPassword,
          builder: (_, value, __) {
            return _buildPasswordField(
              label: "Confirm Password",
              hintText: "Confirm password",
              controller: _confirmPasswordController,
              obscureText: value,
              onToggle: () => _obscureConfirmPassword.value = !value,
            );
          },
        ),

        GestureDetector(
          onTap: () async {
            if (!_formKey.currentState!.validate()) return;

            if (_newPasswordController.text !=
                _confirmPasswordController.text) {
              EasyLoading.showError("Passwords do not match");
              return;
            }

            final success = await ref
                .read(authViewModelProvider.notifier)
                .resetPassword(
                  req: ResetPasswordReqModel(
                    email: _emailController.text.trim(),
                    resetToken: _otp ?? '',
                    newPassword: _newPasswordController.text.trim(),
                  ),
                );

            if (success) {
              setCurrentScreen(AuthScreen.login);
            }
          },
          child: _button("Reset Password"),
        ),
      ],
    );
  }

  // ================= COMMON =================
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

  Widget _button(String text) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _back(AuthScreen screen) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => setCurrentScreen(screen),
      ),
    );
  }
}
