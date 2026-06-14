import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
      ..backgroundColor = CustomColors.purple
      ..indicatorColor = CustomColors.white
      ..textColor = CustomColors.white
      ..maskColor = CustomColors.black.withValues(alpha: 0.4)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    configLoading();
    
    return ScreenUtilPlusInit(
      designSize: getDesignSize(context),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      autoRebuild: false,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'SkinSync Admin',
          routerConfig: RouteGenerator.router,
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: (context, child) {
            return EasyLoading.init()(context, child);
          },
        );
      },
    );
  }
}
