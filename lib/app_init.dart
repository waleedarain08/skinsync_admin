import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'route_generator.dart';
import 'utils/screen_size.dart';
import 'utils/theme.dart';
import 'widgets/app_loader.dart';

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
      ..indicatorColor = CustomColors.purple
      ..textColor = CustomColors.black
      ..maskColor = CustomColors.black.withValues(alpha: 0.4)
      ..indicatorWidget = const AppLoader(size: 50)
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
