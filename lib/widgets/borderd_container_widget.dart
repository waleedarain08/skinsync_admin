import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/color_constant.dart';
import '../utils/theme.dart';

class BorderdContainerWidget extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final Color borderColor;
  final Color backgroundColor;
  final double? height;
  final double? width;
  final double borderWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final bool enableHover;

  const BorderdContainerWidget({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.borderColor = CustomColors.borderLight,
    this.backgroundColor = CustomColors.surfaceWhite,
    this.height,
    this.width,
    this.borderWidth = 1,
    this.padding,
    this.margin,
    this.boxShadow,
    this.enableHover = false,
  });

  @override
  State<BorderdContainerWidget> createState() => _BorderdContainerWidgetState();
}

class _BorderdContainerWidgetState extends State<BorderdContainerWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.enableHover ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: widget.height,
        width: widget.width,
        padding: widget.padding ?? EdgeInsets.all(AppSpacing.cardPadding),
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          border: Border.all(
            color: _hovered ? CustomColors.borderFocus.withValues(alpha: 0.3) : widget.borderColor,
            width: widget.borderWidth,
          ),
          boxShadow: widget.boxShadow ?? (_hovered && widget.enableHover ? AppShadows.cardHover : AppShadows.card),
        ),
        child: widget.child,
      ),
    );
  }
}
