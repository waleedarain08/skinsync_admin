import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/assets.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up-screen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
      _hasUniqueChar = _passwordController.text.contains(
        RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
      );
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
      // backgroundColor: Colors.red,
      body: Row(
        children: [
          // Left Side - Branding
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200.w,
                      height: 200.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF9BA7D4), Color(0xFF7DD3D3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Image.asset(
                        PngAssets.splashLogo,
                        height: 100.w,
                        width: 100.w,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      "SkinSync AI",
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7BA8),
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Vertical Divider
          Padding(
            padding: EdgeInsets.symmetric(vertical: 100.h),
            child: Container(width: 1.w, color: Colors.grey.shade300),
          ),

          // Right Side - Sign Up Form
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 140.w, right: 50, top: 50),
              child: Container(
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.w,
                    vertical: 40.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Create an account to continue",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 40.h),

                        // Full Name Field
                        _buildTextField(
                          label: "Full Name",
                          hintText: "Enter full name",
                          controller: _fullNameController,
                          isRequired: true,
                        ),
                        SizedBox(height: 20.h),
                        // Email Field
                        _buildTextField(
                          label: "Email Address",
                          hintText: "Enter Your Email Address",
                          controller: _emailController,
                          isRequired: true,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20.h),

                        // Phone Number Field
                        _buildTextField(
                          label: "Phone Number",
                          hintText: "+1 (555) 123-4567",
                          controller: _phoneController,
                          isRequired: true,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 20.h),

                        // Password Field
                        _buildPasswordField(
                          label: "Password",
                          hintText: "Enter your password",
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onToggle: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Confirm Password Field
                        _buildPasswordField(
                          label: "Confirm Password",
                          hintText: "Confirm your password",
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          onToggle: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Password Requirements
                        _buildPasswordRequirement(
                          text: "At least one lowercase letter",
                          isValid: _hasLowercase,
                        ),
                        SizedBox(height: 8.h),
                        _buildPasswordRequirement(
                          text: "At least one unique character",
                          isValid: _hasUniqueChar,
                        ),

                        SizedBox(height: 24.h),
                        _rowWidget(),
                        SizedBox(height: 30.h),

                        // Create Account Button
                        GestureDetector(
                          child: Container(
                            width: 215.w,
                            // height: 50.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Sign In Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Have an account already? ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to sign in
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Color(0xFF5B9FD8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            // hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
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

  Widget _rowWidget() {
    return Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
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
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: .center,

          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "I accept the ",
                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "Terms & Conditions",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Secured with Profile Verification API",
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordRequirement({
    required String text,
    required bool isValid,
  }) {
    return Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18.sp,
          color: isValid ? Colors.green : Colors.grey.shade400,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            height: 0,

            color: isValid ? Colors.green : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
