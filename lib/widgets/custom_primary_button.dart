import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/theme.dart';

class CustomPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const CustomPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<CustomPrimaryButton> createState() => _CustomPrimaryButtonState();
}

class _CustomPrimaryButtonState extends State<CustomPrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onTap != null && !widget.isLoading;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _hovered && enabled ? 1.015 : 1.0,
          _hovered && enabled ? 1.015 : 1.0,
          1.0,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? widget.onTap : null,
            borderRadius: context.borderRadius(all: 12),
            child: Ink(
              width: widget.width,
              height: widget.height ?? context.h(52),
              decoration: BoxDecoration(
                color: enabled 
                    ? CustomColors.purple 
                    : CustomColors.lightGrey.withValues(alpha: 0.5),
                borderRadius: context.borderRadius(all: 12),
                boxShadow: enabled && _hovered 
                  ? [BoxShadow(color: CustomColors.purple.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))]
                  : [],
              ),
              child: Padding(
                padding: widget.padding ?? context.appEdgeInsets(horizontal: 16),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: context.w(20),
                          height: context.w(20),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: CustomColors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: CustomColors.white, size: context.sp(18)),
                              context.horizontalSpace(10),
                            ],
                            Flexible(
                              child: Text(
                                widget.label, 
                                style: context.fonts.white14w600,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
