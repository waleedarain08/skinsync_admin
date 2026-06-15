import 'dart:math' as math;
import 'package:flutter/material.dart';
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
      color: CustomColors.whiteGrey,
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
            padding: context.appEdgeInsets(all: 40),
            margin: context.appEdgeInsets(horizontal: 24),
            decoration: BoxDecoration(
              color: CustomColors.white,
              borderRadius: context.appBorderRadius(all: 24),
              border: Border.all(color: CustomColors.border),
              boxShadow: AppShadows.lg(context),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 24),
                  decoration: BoxDecoration(
                    gradient: CustomColors.purpleWhiteStateBlueLightGradient,
                    borderRadius: context.appBorderRadius(all: 16),
                  ),
                  child: Icon(Icons.auto_awesome_rounded, size: context.sp(48), color: CustomColors.white),
                ),
                context.verticalSpace(32),
                Text('Coming Soon', style: context.fonts.black26w700),
                context.verticalSpace(12),
                Text(
                  "We're crafting an elegant experience for this module.\nStay tuned for the unveiling.",
                  textAlign: TextAlign.center,
                  style: context.fonts.grey16w400,
                ),
                context.verticalSpace(32),
                Container(
                  padding: context.appEdgeInsets(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: CustomColors.palePurple,
                    borderRadius: BorderRadius.circular(AppRadius.full(context)),
                    border: Border.all(color: CustomColors.purple.withValues(alpha: 0.1)),
                  ),
                  child: Text('PREMIUM ACCESS', style: context.fonts.purple11w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
