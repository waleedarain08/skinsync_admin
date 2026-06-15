import 'package:flutter/material.dart';

import '../utils/theme.dart';
import 'app_loader.dart';

class CustomOutlinedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? color;
  final Color? textColor;

  const CustomOutlinedButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
    this.color,
    this.textColor,
  });

  @override
  State<CustomOutlinedButton> createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onTap != null && !widget.isLoading;
    final Color baseColor = widget.color ?? CustomColors.purple;
    final Color labelColor = widget.textColor ?? baseColor;

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
                color: _hovered && enabled
                    ? baseColor.withValues(alpha: 0.05)
                    : Colors.transparent,
                borderRadius: context.borderRadius(all: 12),
                border: Border.all(color: CustomColors.purple, width: 1.5),
              ),
              child: Padding(
                padding:
                    widget.padding ?? context.appEdgeInsets(horizontal: 16),
                child: Center(
                  child: widget.isLoading
                      ? AppLoader(size: context.w(20), color: baseColor)
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: enabled
                                    ? labelColor
                                    : CustomColors.lightGrey,
                                size: context.sp(18),
                              ),
                              context.horizontalSpace(10),
                            ],
                            Flexible(
                              child: Text(
                                widget.label,
                                style: context.fonts.black14w600.copyWith(
                                  color: enabled
                                      ? labelColor
                                      : CustomColors.lightGrey,
                                ),
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
