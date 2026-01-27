import 'package:flutter/cupertino.dart';
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
    } else {
      return desktop?.call() ?? defaultValue;
    }
  }
}
