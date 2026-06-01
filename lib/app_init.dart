import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart' hide Breakpoint;
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:skinsync_admin/route_generator.dart';
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
      ..indicatorSize = 40.0
      ..radius = 12.0
      ..progressColor = CustomColors.white
      ..backgroundColor = CustomColors.white
      ..indicatorColor = CustomColors.green
      ..textColor = CustomColors.white
      ..maskColor = CustomColors.black.withValues(alpha: 0.4)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    configLoading();
    return ScreenUtilPlusInit(
      designSize: getDesignSize(context: context),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'SkinSync Admin',
          routerConfig: RouteGenerator.router,
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: (context, child) {
            final easyLoadingBuilder = EasyLoading.init();
            final responsiveBuilder = rf.ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const rf.Breakpoint(start: 0, end: 480, name: rf.MOBILE),
                const rf.Breakpoint(start: 481, end: 1024, name: rf.TABLET),
                const rf.Breakpoint(start: 482, end: 1920, name: rf.DESKTOP),
                const rf.Breakpoint(
                  start: 1921,
                  end: double.infinity,
                  name: '4K',
                ),
              ],
            );
            
            return easyLoadingBuilder(context, responsiveBuilder);
          },
        );
      },
    );
  }
}
