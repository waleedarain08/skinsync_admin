import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../app_init.dart';

abstract class Responsive {
  static T when<T>({
    required T defaultValue,
    ValueGetter<T>? mobile,
    ValueGetter<T>? tablet,
    ValueGetter<T>? desktop,
  }) {
    final breakpoint = ResponsiveBreakpoints.of(
      navigatorKey.currentContext!,
    ).breakpoint;
    if (breakpoint.name == MOBILE) {
      return mobile?.call() ?? defaultValue;
    } else if (breakpoint.name == TABLET) {
      return tablet?.call() ?? defaultValue;
    } else if (breakpoint.name == DESKTOP || breakpoint.name == '4K') {
      return desktop?.call() ?? defaultValue;
    } else {
      return defaultValue;
    }
  }
}

extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveBreakpoints.of(this).isMobile;

  bool get isTablet => ResponsiveBreakpoints.of(this).isTablet;

  bool get isDesktop => ResponsiveBreakpoints.of(this).breakpoint.name == DESKTOP || ResponsiveBreakpoints.of(this).breakpoint.name == '4K';

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
        if (i > 0) rowChildren.add(SizedBox(width: widthBetween ?? 20.w));
        if (expandedWidget == true) {
          rowChildren.add(Expanded(child: children[i]));
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
      if (i > 0) columnChildren.add(SizedBox(height: heightBetween ?? 20.h));
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
            ? NeverScrollableScrollPhysics()
            : null,
        scrollDirection: context.isLandscape ? Axis.horizontal : Axis.vertical,
        itemBuilder: (context, index) {
          return children[index];
        },
        separatorBuilder: (BuildContext context, int index) {
          return context.isLandscape
              ? SizedBox(width: spaceWidth ?? 20.w)
              : SizedBox(height: spaceHeight ?? 20.h);
        },
      ),
    );
  }
}
