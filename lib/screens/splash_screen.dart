import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/dashboard_screen.dart';
import 'package:skinsync_admin/screens/sign_in_screen.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/theme.dart';

import '../services/storage_service.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _animate = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() => _animate = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      if (SecureStorageService().isLoggedIn) {
        context.go(DashboardScreen.routeName);
      } else {
        context.goNamed(SignInScreen.routeName);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Stack(
        children: [
          Positioned(
            top: -120.h,
            right: -80.w,
            child: Container(
              width: 360.w,
              height: 360.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [CustomColors.green.withValues(alpha: 0.1), Colors.transparent],
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.03),
                  child: child,
                );
              },
              child: AnimatedOpacity(
                opacity: _animate ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 600),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        gradient: CustomColors.purpleToLightPurpleGradient,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.purple.withValues(alpha: 0.25),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Image.asset(PngAssets.splashLogo, height: 80.w, width: 80.w, color: CustomColors.white),
                    ),
                    SizedBox(height: AppSpacing.xxl),
                    Text(
                      'SKINSYNC',
                      style: CustomFonts.black32w700ls2,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'PREMIUM MEDSPA SaaS',
                      style: CustomFonts.green9w600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
