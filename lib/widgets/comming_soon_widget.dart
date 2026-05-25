import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/theme.dart';

class ComingSoonWidget extends StatefulWidget {
  const ComingSoonWidget({super.key});

  @override
  State<ComingSoonWidget> createState() => _ComingSoonWidgetState();
}

class _ComingSoonWidgetState extends State<ComingSoonWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: CustomColors.backgroundLight,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(_controller.value * 2 * math.pi) * 8),
              child: child,
            );
          },
          child: Container(
            padding: EdgeInsets.all(40.w),
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: CustomColors.surfaceWhite,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: CustomColors.borderLight),
              boxShadow: AppShadows.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: CustomColors.medicalGradient,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(Icons.auto_awesome_rounded, size: 48.sp, color: CustomColors.surfaceWhite),
                ),
                SizedBox(height: 32.h),
                Text('Coming Soon', style: CustomFonts.h1),
                SizedBox(height: 12.h),
                Text(
                  "We're crafting an elegant experience for this module.\nStay tuned for the unveiling.",
                  textAlign: TextAlign.center,
                  style: CustomFonts.bodyLg.copyWith(color: CustomColors.textSecondary),
                ),
                SizedBox(height: 32.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: CustomColors.primarySoft,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: CustomColors.secondary.withValues(alpha: 0.1)),
                  ),
                  child: Text('PREMIUM ACCESS', style: CustomFonts.label.copyWith(color: CustomColors.secondary, fontSize: 11.sp)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
