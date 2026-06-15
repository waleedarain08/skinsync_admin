import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../app_init.dart';

abstract class Responsive {
  static T when<T>(
    BuildContext context, {
    required T defaultValue,
    ValueGetter<T>? mobile,
    ValueGetter<T>? tablet,
    ValueGetter<T>? desktop,
  }) {
    // Accessing context.w(0) to register as a listener of ScreenUtil metrics if needed,
    // though MediaQuery.sizeOf(context) already registers as a listener of size changes.
    final width = MediaQuery.sizeOf(context).width;

    if (width < 480) {
      return mobile?.call() ?? defaultValue;
    } else if (width < 1024) {
      return tablet?.call() ?? defaultValue;
    } else {
      return desktop?.call() ?? defaultValue;
    }
  }

  // Legacy version using navigatorKey
  static T when_static<T>({
    required T defaultValue,
    ValueGetter<T>? mobile,
    ValueGetter<T>? tablet,
    ValueGetter<T>? desktop,
  }) {
    final context = navigatorKey.currentContext!;
    final width = MediaQuery.sizeOf(context).width;

    if (width < 480) {
      return mobile?.call() ?? defaultValue;
    } else if (width < 1024) {
      return tablet?.call() ?? defaultValue;
    } else {
      return desktop?.call() ?? defaultValue;
    }
  }
}

extension ResponsiveExtension on BuildContext {
  bool get isMobile => MediaQuery.sizeOf(this).width < 480;

  bool get isTablet => MediaQuery.sizeOf(this).width >= 481 && MediaQuery.sizeOf(this).width <= 1024;

  bool get isDesktop => MediaQuery.sizeOf(this).width > 1024;

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
}

class AdaptiveLayoutRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment? alignment;
  final double? widthBetween;
  final double? heightBetween;
  final MainAxisSize? size;
  final bool? expandedWidget;

  const AdaptiveLayoutRowColumn({
    super.key,
    required this.children,
    this.alignment,
    this.size,
    this.widthBetween,
    this.heightBetween,
    this.expandedWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isLandscape) {
      final rowChildren = <Widget>[];
      for (var i = 0; i < children.length; i++) {
        if (i > 0) rowChildren.add(context.horizontalSpace(widthBetween ?? 20));
        if (expandedWidget == true) {
          rowChildren.add(Expanded(child: children[i]));
        } else {
          rowChildren.add(children[i]);
        }
      }
      return Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.start,
        mainAxisSize: size ?? MainAxisSize.max,
        children: rowChildren,
      );
    }
    final columnChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) columnChildren.add(context.verticalSpace(heightBetween ?? 20));
      columnChildren.add(children[i]);
    }
    return Column(
      mainAxisAlignment: alignment ?? MainAxisAlignment.start,
      mainAxisSize: size ?? MainAxisSize.max,
      children: columnChildren,
    );
  }
}

class AdaptiveLayoutList extends StatelessWidget {
  final List<Widget> children;
  final double? horizontalHeight;

  final double? spaceHeight;
  final double? spaceWidth;

  final bool isScrollVertical;

  const AdaptiveLayoutList({
    super.key,
    required this.children,
    this.horizontalHeight,
    this.spaceHeight,
    this.spaceWidth,
    required this.isScrollVertical,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.isLandscape ? horizontalHeight : null,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: children.length,
        physics: context.isLandscape
            ? null
            : isScrollVertical
            ? const NeverScrollableScrollPhysics()
            : null,
        scrollDirection: context.isLandscape ? Axis.horizontal : Axis.vertical,
        itemBuilder: (context, index) {
          return children[index];
        },
        separatorBuilder: (BuildContext context, int index) {
          return context.isLandscape
              ? context.horizontalSpace(spaceWidth ?? 20)
              : context.verticalSpace(spaceHeight ?? 20);
        },
      ),
    );
  }
}
