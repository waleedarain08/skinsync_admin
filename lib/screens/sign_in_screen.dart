import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_admin/utils/assets.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/sign-in-screen';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
              child: Column(
                children: [
                  Container(
                    height: 64.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        value: selectedValue,
                        items: roles
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },

                        buttonStyleData: ButtonStyleData(
                          height: 50.h,
                          padding: EdgeInsets.zero,
                        ),

                        style: TextStyle(fontSize: 14.sp, color: Colors.black),

                        // Icon
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          iconSize: 24.sp,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          offset: const Offset(0, -2),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),

                        // Menu item style
                        menuItemStyleData: MenuItemStyleData(
                          height: 45.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Container(
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
                            SvgPicture.asset(
                              SvgAssets.stethoscope,
                              height: 60.h,
                              width: 60.w,
                            ),
                            SizedBox(height: 8.h),

                            Text(
                              "Doctor (Clinic Owner)",
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Full administrative and clinical access",
                              style: TextStyle(
                                fontSize: 14.sp,
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
                              onToggle: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
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
                                      "Sign In",
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
}
