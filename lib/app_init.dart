import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'route_generator.dart';
import 'utils/color_constant.dart';
import 'utils/screen_size.dart';
import 'utils/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppInit extends StatelessWidget {
  const AppInit({super.key});
  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = CustomColors.blackColor
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    configLoading();
    final ThemeMode themeMode = ThemeMode.light;
    return ScreenUtilInit(
      designSize: getDesignSize(context: context),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'SkinSync Admin',
          routerConfig: RouteGenerator.router,
          // home: PaymentScreen(),
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          builder: EasyLoading.init(
            builder: (context, child) {
              return ResponsiveBreakpoints.builder(
                child: child!,
                breakpoints: [
                  const Breakpoint(start: 0, end: 480, name: MOBILE),
                  const Breakpoint(start: 481, end: 1024, name: TABLET),
                  const Breakpoint(start: 1025, end: 1920, name: DESKTOP),
                  const Breakpoint(
                    start: 1921,
                    end: double.infinity,
                    name: '4K',
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
