import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:pinput/pinput.dart';

import '../models/requests/auth_req_models.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/enums.dart';
import '../utils/validators.dart';
import '../view_models/auth_view_model.dart';
import 'bottom_nav_screens/dashboard_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const String routeName = '/sign-in-screen';

  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  final ValueNotifier<bool> _obscureNewPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  AuthScreen _currentScreen = AuthScreen.login;
  String? _otp;
  bool _keepMeSignedIn = false;

  void setCurrentScreen(AuthScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      body: Stack(
        children: [
          // Background Gradient Element
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 400.w,
              height: 400.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CustomColors.brandCyan.withOpacity(0.2),
                    CustomColors.brandCyan.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150.h,
            left: -150.w,
            child: Container(
              width: 500.w,
              height: 500.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CustomColors.brandPurple.withOpacity(0.15),
                    CustomColors.brandPurple.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBranding(),
                  SizedBox(height: 40.h),
                  _buildAuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranding() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Image.asset(PngAssets.splashLogo, height: 80.w, width: 80.w),
        ),
        SizedBox(height: 24.h),
        Text(
          "SkinSync AI",
          style: CustomFonts.textMain32w700.copyWith(
            letterSpacing: 2,
            color: CustomColors.deepSlate,
          ),
        ),
        Text(
          "Centralized MedSpa Administration",
          style: CustomFonts.textMuted14w400.copyWith(letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
    return Container(
      width: 450.w,
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _getCurrentForm(),
        ),
      ),
    );
  }

  Widget _getCurrentForm() {
    switch (_currentScreen) {
      case AuthScreen.login: return _loginForm();
      case AuthScreen.forgetPassword: return _forgetPasswordForm();
      case AuthScreen.verifyOtp: return _verifyOtpForm();
      case AuthScreen.createNewPassword: return _createNewPasswordForm();
    }
  }

  Widget _loginForm() {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome Back", style: CustomFonts.textMain24w700),
        SizedBox(height: 8.h),
        Text("Enter your credentials to access the admin panel.", style: CustomFonts.textMuted14w400),
        SizedBox(height: 32.h),
        _buildInputField(
          label: "Email Address",
          hint: "admin@skinsync.com",
          controller: _emailController,
          validator: Validators.email,
          icon: Icons.alternate_email_rounded,
        ),
        SizedBox(height: 24.h),
        _buildInputField(
          label: "Password",
          hint: "••••••••",
          controller: _passwordController,
          isPassword: true,
          obscureText: _obscurePassword,
          onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
          validator: Validators.password,
          icon: Icons.lock_outline_rounded,
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCheckbox(),
            TextButton(
              onPressed: () => setCurrentScreen(AuthScreen.forgetPassword),
              child: Text("Forgot Password?", style: CustomFonts.textMain14w600.copyWith(color: CustomColors.brandPrimary)),
            ),
          ],
        ),
        SizedBox(height: 32.h),
        _buildSubmitButton("Sign In", _handleLogin),
      ],
    );
  }

  Widget _forgetPasswordForm() {
    return Column(
      key: const ValueKey('forgot'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => setCurrentScreen(AuthScreen.login),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          style: IconButton.styleFrom(backgroundColor: CustomColors.surfaceGhost),
        ),
        SizedBox(height: 24.h),
        Text("Reset Password", style: CustomFonts.textMain24w700),
        SizedBox(height: 8.h),
        Text("Enter your email and we'll send you an OTP code.", style: CustomFonts.textMuted14w400),
        SizedBox(height: 32.h),
        _buildInputField(
          label: "Registered Email",
          hint: "Enter your email",
          controller: _emailController,
          validator: Validators.email,
          icon: Icons.alternate_email_rounded,
        ),
        SizedBox(height: 32.h),
        _buildSubmitButton("Send Reset Code", _handleForgotPassword),
      ],
    );
  }

  Widget _verifyOtpForm() {
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Verify Identity", style: CustomFonts.textMain24w700),
        SizedBox(height: 8.h),
        Text("We've sent a 6-digit code to your email.", style: CustomFonts.textMuted14w400),
        SizedBox(height: 32.h),
        Pinput(
          controller: _otpController,
          length: 6,
          defaultPinTheme: PinTheme(
            width: 56.w,
            height: 56.w,
            textStyle: CustomFonts.textMain20w600,
            decoration: BoxDecoration(
              color: CustomColors.surfaceGhost,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.transparent),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 56.w,
            height: 56.w,
            textStyle: CustomFonts.textMain20w600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: CustomColors.brandPrimary, width: 2),
            ),
          ),
        ),
        SizedBox(height: 32.h),
        _buildSubmitButton("Verify & Continue", _handleVerifyOtp),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: _handleForgotPassword,
          child: Text("Didn't receive code? Resend", style: CustomFonts.textMain14w600.copyWith(color: CustomColors.brandPrimary)),
        ),
      ],
    );
  }

  Widget _createNewPasswordForm() {
    return Column(
      key: const ValueKey('reset'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create New Password", style: CustomFonts.textMain24w700),
        SizedBox(height: 8.h),
        Text("Your new password must be different from previous ones.", style: CustomFonts.textMuted14w400),
        SizedBox(height: 32.h),
        ValueListenableBuilder(
          valueListenable: _obscureNewPassword,
          builder: (_, val, _) => _buildInputField(
            label: "New Password",
            hint: "••••••••",
            controller: _newPasswordController,
            isPassword: true,
            obscureText: val,
            onTogglePassword: () => _obscureNewPassword.value = !val,
            icon: Icons.lock_outline_rounded,
          ),
        ),
        SizedBox(height: 24.h),
        ValueListenableBuilder(
          valueListenable: _obscureConfirmPassword,
          builder: (_, val, _) => _buildInputField(
            label: "Confirm Password",
            hint: "••••••••",
            controller: _confirmPasswordController,
            isPassword: true,
            obscureText: val,
            onTogglePassword: () => _obscureConfirmPassword.value = !val,
            icon: Icons.lock_reset_rounded,
          ),
        ),
        SizedBox(height: 32.h),
        _buildSubmitButton("Update Password", _handleResetPassword),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.textMain14w600),
        SizedBox(height: 10.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText ?? false,
          validator: validator,
          style: CustomFonts.textMain14w400,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20.sp, color: CustomColors.textMuted),
            hintText: hint,
            suffixIcon: isPassword ? IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                obscureText! ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20.sp,
                color: CustomColors.textMuted,
              ),
            ) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Checkbox(
            value: _keepMeSignedIn,
            onChanged: (v) => setState(() => _keepMeSignedIn = v ?? false),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
          ),
        ),
        SizedBox(width: 8.w),
        Text("Keep me signed in", style: CustomFonts.textMain14w400),
      ],
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18.h),
        ),
        child: Text(label),
      ),
    );
  }

  // Handlers
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authViewModelProvider.notifier).login(
      loginReq: LoginRequestModel(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
    if (success && mounted) context.go(DashboardScreen.routeName);
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authViewModelProvider.notifier).forgotPassword(email: _emailController.text.trim());
    if (success) setCurrentScreen(AuthScreen.verifyOtp);
  }

  Future<void> _handleVerifyOtp() async {
    final success = await ref.read(authViewModelProvider.notifier).verifyOtp(
      email: _emailController.text.trim(),
      otp: _otpController.text.trim(),
    );
    if (success) {
      _otp = _otpController.text.trim();
      setCurrentScreen(AuthScreen.createNewPassword);
    }
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newPasswordController.text != _confirmPasswordController.text) {
      EasyLoading.showError("Passwords do not match");
      return;
    }
    final success = await ref.read(authViewModelProvider.notifier).resetPassword(
      req: ResetPasswordReqModel(
        email: _emailController.text.trim(),
        resetToken: _otp ?? '',
        newPassword: _newPasswordController.text.trim(),
      ),
    );
    if (success) setCurrentScreen(AuthScreen.login);
  }
}
