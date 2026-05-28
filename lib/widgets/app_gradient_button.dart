import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/theme.dart';

class AppGradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const AppGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  State<AppGradientButton> createState() => _AppGradientButtonState();
}

class _AppGradientButtonState extends State<AppGradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(_hovered && enabled ? 1.015 : 1.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? widget.onPressed : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Ink(
              width: widget.width,
              height: 48.h,
              decoration: BoxDecoration(
                gradient: enabled
                    ? CustomColors.medicalGradient
                    : LinearGradient(
                        colors: [CustomColors.textTertiary.withValues(alpha: 0.5), CustomColors.textTertiary.withValues(alpha: 0.5)],
                      ),
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: enabled && _hovered 
                  ? [BoxShadow(color: CustomColors.secondary.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))] 
                  : [],
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: CustomColors.surfaceWhite,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, color: CustomColors.surfaceWhite, size: 18.sp),
                            SizedBox(width: 10.w),
                          ],
                          Text(widget.label, style: CustomFonts.white14w600),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
