import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'utils/colored_print.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    CP.yellow('Navigating to ${settings.name} with args: $args');
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SplashScreen.routeName),
          builder: (_) => SplashScreen(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    CP.red('Error: Route not found');
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR')),
        );
      },
    );
  }
}
