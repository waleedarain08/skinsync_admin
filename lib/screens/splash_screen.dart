import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/dashboard_screen.dart';
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
  final int _duration = 1000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() => _animate = true);
      await Future.delayed(Duration(milliseconds: _duration));
      if (!mounted) return;
      if (SecureStorageService().isLoggedIn) {
        context.go(DashboardScreen.routeName);
      } else {
        context.goNamed(SignInScreen.routeName);
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
          Container(decoration: const BoxDecoration(gradient: CustomColors.purpleWhiteStateBlueLightGradient)),
          AnimatedOpacity(
            opacity: _animate ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: Image.asset(
                PngAssets.splashLogo,
                height: 120.h,
                width: 120.w,
              ),
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            top: _animate ? screenHeight : -screenHeight,
            left: _animate ? screenWidth : -200.r,
            child: CircleAvatar(
              radius: 300.r,
              backgroundColor: CustomColors.lightPurple,
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            bottom: _animate ? screenHeight : -screenHeight,
            right: _animate ? screenWidth : -200.r,
            child: CircleAvatar(
              radius: 300.r,
              backgroundColor: CustomColors.lightPurple
            ),
          ),
        ],
      ),
    );
  }
}
