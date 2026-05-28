import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/sign_in_screen.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/phone_widget.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up-screen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _hasLowercase = false;
  bool _hasUniqueChar = false;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    setState(() {
      _hasLowercase = _passwordController.text.contains(RegExp(r'[a-z]'));
      _hasUniqueChar = _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left Side: Modern Branding Panel
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                gradient: CustomColors.primaryGradient,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -100,
                    left: -100,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColors.secondary.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(48.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Image.asset(PngAssets.splashLogo, height: 60.w, color: Colors.white),
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            "Join the Future of\nMedSpa Management",
                            style: CustomFonts.white40w700h11,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "Scale your clinic operations with our advanced AI-powered administrative tools.",
                            style: CustomFonts.white70_16w400h15,
                          ),
                          SizedBox(height: 60.h),
                          _buildFeatureRow(Icons.check_circle_outline_rounded, "Multi-Clinic Oversight"),
                          SizedBox(height: 16.h),
                          _buildFeatureRow(Icons.check_circle_outline_rounded, "Advanced Patient Analytics"),
                          SizedBox(height: 16.h),
                          _buildFeatureRow(Icons.check_circle_outline_rounded, "Automated Payout Systems"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Side: Registration Form
          Expanded(
            flex: 5,
            child: Container(
              color: CustomColors.backgroundLight,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 48.h),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Create Admin Account", style: CustomFonts.black26w700),
                          SizedBox(height: 8.h),
                          Text("Register your MedSpa network to get started.", style: CustomFonts.grey16w400),
                          SizedBox(height: 40.h),
                          
                          _buildInputField(
                            label: "Full Name",
                            hint: "Enter your full name",
                            controller: _fullNameController,
                            icon: Icons.person_outline_rounded,
                          ),
                          SizedBox(height: 24.h),
                          _buildInputField(
                            label: "Email Address",
                            hint: "name@company.com",
                            controller: _emailController,
                            icon: Icons.alternate_email_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 24.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Phone Number", style: CustomFonts.black14w600),
                              SizedBox(height: 10.h),
                              PhoneWidget(controller: _phoneController, filled: true),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          _buildInputField(
                            label: "Password",
                            hint: "Create a strong password",
                            controller: _passwordController,
                            icon: Icons.lock_outline_rounded,
                            isPassword: true,
                            obscureText: _obscurePassword,
                            onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          SizedBox(height: 16.h),
                          _buildRequirementRow("Lowercase letter included", _hasLowercase),
                          _buildRequirementRow("Unique character included", _hasUniqueChar),
                          SizedBox(height: 32.h),
                          _buildTermsCheckbox(),
                          SizedBox(height: 40.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Register & Continue"),
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account? ", style: CustomFonts.grey13w500),
                              GestureDetector(
                                onTap: () => context.go(SignInScreen.routeName),
                                child: Text("Sign In", style: CustomFonts.primary14w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: CustomColors.secondary, size: 22.sp),
        SizedBox(width: 12.w),
        Text(text, style: CustomFonts.white90_16w600),
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
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.black14w600),
        SizedBox(height: 10.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          style: CustomFonts.grey14w400,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20.sp, color: CustomColors.textTertiary),
            hintText: hint,
            suffixIcon: isPassword ? IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                obscureText! ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20.sp,
                color: CustomColors.textTertiary,
              ),
            ) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementRow(String text, bool isValid) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 16.sp,
            color: isValid ? CustomColors.success : CustomColors.textTertiary.withValues(alpha: 0.5),
          ),
          SizedBox(width: 8.w),
          Text(text, style: isValid ? CustomFonts.success12w400 : CustomFonts.grey12w400),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Checkbox(
            value: _acceptTerms,
            onChanged: (v) => setState(() => _acceptTerms = v ?? false),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: CustomFonts.grey13w500,
              children: [
                const TextSpan(text: "I agree to the "),
                TextSpan(
                  text: "Terms of Service",
                  style: CustomFonts.primary14w700,
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: CustomFonts.primary14w700,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
