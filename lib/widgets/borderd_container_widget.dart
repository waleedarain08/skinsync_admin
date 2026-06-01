import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';

class BorderdContainerWidget extends StatefulWidget {
  final Widget child;
  final double? borderRadius;
  final Color borderColor;
  final Color backgroundColor;
  final double? height;
  final double? width;
  final double? borderWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final bool enableHover;

  const BorderdContainerWidget({
    super.key,
    required this.child,
    this.borderRadius,
    this.borderColor = CustomColors.border,
    this.backgroundColor = CustomColors.white,
    this.height,
    this.width,
    this.borderWidth,
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
    final double effectiveRadius = widget.borderRadius ?? 12.0;
    final double effectiveBorderWidth = widget.borderWidth ?? 1.0;

    return MouseRegion(
      onEnter: widget.enableHover ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: widget.height,
        width: widget.width,
        padding: widget.padding ?? context.appEdgeInsets(all: 24),
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(effectiveRadius),
          border: Border.all(
            color: _hovered ? CustomColors.purple.withValues(alpha: 0.3) : widget.borderColor,
            width: effectiveBorderWidth,
          ),
          boxShadow: widget.boxShadow ?? (_hovered && widget.enableHover ? AppShadows.cardHover(context) : AppShadows.card(context)),
        ),
        child: widget.child,
      ),
    );
  }
}
