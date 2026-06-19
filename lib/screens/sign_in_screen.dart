import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

import '../models/requests/auth_req_models.dart';
import '../utils/enums.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_primary_button.dart';
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
    return GradientScaffold(
      body: Stack(
        children: [
          Positioned(
            top: context.h(-100),
            right: context.w(-100),
            child: Container(
              width: context.w(400),
              height: context.w(400),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CustomColors.green.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: context.h(-150),
            left: context.w(-150),
            child: Container(
              width: context.w(500),
              height: context.w(500),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CustomColors.purple.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: context.appEdgeInsets(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBranding(context),
                  context.verticalSpace(40),
                  _buildAuthCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranding(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          PngAssets.splashLogo,
          height: context.w(100),
          width: context.w(100),
          fit: BoxFit.contain,
        ),
        context.verticalSpace(32),
        Text('SkinSync AI', style: context.fonts.black40w700),
        context.verticalSpace(2),
        Text(
          'ADMIN PANEL',
          style: TextStyle(
            fontSize: context.sp(14),
            fontWeight: FontWeight.w800,
            color: CustomColors.purple,
            letterSpacing: 3.0,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard(BuildContext context) {
    return Container(
      width: context.w(450),
      padding: context.appEdgeInsets(all: 40),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: context.borderRadius(all: 20),
        border: Border.all(color: CustomColors.border),
        boxShadow: AppShadows.lg(context),
      ),
      child: Form(
        key: _formKey,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _getCurrentForm(context),
        ),
      ),
    );
  }

  Widget _getCurrentForm(BuildContext context) {
    switch (_currentScreen) {
      case AuthScreen.login:
        return _loginForm(context);
      case AuthScreen.forgetPassword:
        return _forgetPasswordForm(context);
      case AuthScreen.verifyOtp:
        return _verifyOtpForm(context);
      case AuthScreen.createNewPassword:
        return _createNewPasswordForm(context);
    }
  }

  Widget _loginForm(BuildContext context) {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome Back', style: context.fonts.black20w600),
        context.verticalSpace(8),
        Text(
          'Enter your credentials to access the admin panel.',
          style: context.fonts.grey13w500,
        ),
        context.verticalSpace(32),
        BuildTextField(
          label: 'Email Address',
          hintText: 'admin@skinsync.com',
          controller: _emailController,
          validator: Validators.email,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.alternate_email_rounded,
            size: context.sp(20),
            color: CustomColors.lightGrey,
          ),
        ),
        context.verticalSpace(24),
        BuildTextField(
          label: 'Password',
          hintText: '••••••••',
          controller: _passwordController,
          obscureText: _obscurePassword,
          validator: Validators.password,
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            size: context.sp(20),
            color: CustomColors.lightGrey,
          ),
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: context.sp(20),
              color: CustomColors.lightGrey,
            ),
          ),
        ),
        context.verticalSpace(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCheckbox(context),
            TextButton(
              onPressed: () => setCurrentScreen(AuthScreen.forgetPassword),
              child: Text(
                'Forgot Password?',
                style: context.fonts.purple14w600,
              ),
            ),
          ],
        ),
        context.verticalSpace(32),
        _buildSubmitButton('Sign In', _handleLogin),
      ],
    );
  }

  Widget _forgetPasswordForm(BuildContext context) {
    return Column(
      key: const ValueKey('forgot'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => setCurrentScreen(AuthScreen.login),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          style: IconButton.styleFrom(backgroundColor: CustomColors.softGrey),
        ),
        context.verticalSpace(24),
        Text('Reset Password', style: context.fonts.black20w600),
        context.verticalSpace(8),
        Text(
          "Enter your email and we'll send you an OTP code.",
          style: context.fonts.grey13w500,
        ),
        context.verticalSpace(32),
        BuildTextField(
          label: 'Registered Email',
          hintText: 'Enter your email',
          controller: _emailController,
          validator: Validators.email,
          prefixIcon: Icon(
            Icons.alternate_email_rounded,
            size: context.sp(20),
            color: CustomColors.lightGrey,
          ),
        ),
        context.verticalSpace(32),
        _buildSubmitButton('Send Reset Code', _handleForgotPassword),
      ],
    );
  }

  Widget _verifyOtpForm(BuildContext context) {
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Verify Identity', style: context.fonts.black20w600),
        context.verticalSpace(8),
        Text(
          "We've sent a 6-digit code to your email.",
          style: context.fonts.grey13w500,
        ),
        context.verticalSpace(32),
        Pinput(
          controller: _otpController,
          length: 6,
          defaultPinTheme: PinTheme(
            width: context.w(56),
            height: context.w(56),
            textStyle: context.fonts.black18w600,
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: context.borderRadius(all: 12),
              border: Border.all(color: Colors.transparent),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: context.w(56),
            height: context.w(56),
            textStyle: context.fonts.black18w600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.borderRadius(all: 12),
              border: Border.all(color: CustomColors.purple, width: 2),
            ),
          ),
        ),
        context.verticalSpace(32),
        _buildSubmitButton('Verify & Continue', _handleVerifyOtp),
        context.verticalSpace(16),
        TextButton(
          onPressed: _handleForgotPassword,
          child: Text(
            "Didn't receive code? Resend",
            style: context.fonts.purple14w600,
          ),
        ),
      ],
    );
  }

  Widget _createNewPasswordForm(BuildContext context) {
    return Column(
      key: const ValueKey('reset'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create New Password', style: context.fonts.black20w600),
        context.verticalSpace(8),
        Text(
          'Your new password must be different from previous ones.',
          style: context.fonts.grey13w500,
        ),
        context.verticalSpace(32),
        ValueListenableBuilder(
          valueListenable: _obscureNewPassword,
          builder: (context, val, child) => BuildTextField(
            label: 'New Password',
            hintText: '••••••••',
            controller: _newPasswordController,
            obscureText: val,
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: context.sp(20),
              color: CustomColors.lightGrey,
            ),
            suffixIcon: IconButton(
              onPressed: () => _obscureNewPassword.value = !val,
              icon: Icon(
                val ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: context.sp(20),
                color: CustomColors.lightGrey,
              ),
            ),
          ),
        ),
        context.verticalSpace(24),
        ValueListenableBuilder(
          valueListenable: _obscureConfirmPassword,
          builder: (context, val, child) => BuildTextField(
            label: 'Confirm Password',
            hintText: '••••••••',
            controller: _confirmPasswordController,
            obscureText: val,
            prefixIcon: Icon(
              Icons.lock_reset_rounded,
              size: context.sp(20),
              color: CustomColors.lightGrey,
            ),
            suffixIcon: IconButton(
              onPressed: () => _obscureConfirmPassword.value = !val,
              icon: Icon(
                val ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: context.sp(20),
                color: CustomColors.lightGrey,
              ),
            ),
          ),
        ),
        context.verticalSpace(32),
        _buildSubmitButton('Update Password', _handleResetPassword),
      ],
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: context.w(24),
          height: context.w(24),
          child: Checkbox(
            value: _keepMeSignedIn,
            onChanged: (v) => setState(() => _keepMeSignedIn = v ?? false),
            shape: RoundedRectangleBorder(
              borderRadius: context.borderRadius(all: 6),
            ),
          ),
        ),
        context.horizontalSpace(8),
        Text('Keep me signed in', style: context.fonts.grey14w400),
      ],
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onPressed) {
    return CustomPrimaryButton(
      label: label,
      onTap: onPressed,
      width: double.infinity,
    );
  }

  // Handlers
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(authViewModelProvider.notifier)
        .login(
          loginReq: LoginRequestModel(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
    if (success && mounted) context.go(DashboardScreen.routeName);
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(authViewModelProvider.notifier)
        .forgotPassword(email: _emailController.text.trim());
    if (success) setCurrentScreen(AuthScreen.verifyOtp);
  }

  Future<void> _handleVerifyOtp() async {
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
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newPasswordController.text != _confirmPasswordController.text) {
      EasyLoading.showError('Passwords do not match');
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
    if (success) setCurrentScreen(AuthScreen.login);
  }
}
