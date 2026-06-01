import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/user_management.dart';
import 'package:skinsync_admin/screens/sign_in_screen.dart';

import '../services/storage_service.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _animate = false;
  final int _duration = 1000; // animation duration

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: _duration));
      setState(() {
        _animate = true;
      });

      await Future.delayed(Duration(milliseconds: _duration - 800));

      if (mounted) {
        if (SecureStorageService().isLoggedIn) {
          context.go(UserManagement.routeName);
        } else {
          context.goNamed(SignInScreen.routeName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: CustomColors.purpleToLightPurpleGradient,
            ),
          ),

          AnimatedOpacity(
            opacity: _animate ? 0.0 : 1.0,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: Center(
              child: Image.asset(
                PngAssets.splashLogo,
                height: 169.h,
                width: 169.w,
              ),
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            top: _animate ? screenHeight : -screenHeight,
            left: _animate ? screenWidth : -362.r,
            child: CircleAvatar(
              radius: 362.r,
              backgroundColor: CustomColors.purple,
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            bottom: _animate ? screenHeight : -screenHeight,
            right: _animate ? screenWidth : -362.r,
            child: CircleAvatar(
              radius: 362.r,
              backgroundColor: CustomColors.slateBlue,
            ),
          ),
        ],
      ),
    );
  }
}
