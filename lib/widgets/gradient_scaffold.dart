import 'package:flutter/material.dart';
import '../utils/theme.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? persistentFooterButtons;
  final Widget? endDrawer;
  final Key? scaffoldKey;
  final Color? backgroundColor;

  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.endDrawer,
    this.scaffoldKey,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: CustomColors.purpleWhiteStateBlueLightGradient,
      ),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor ?? Colors.transparent,
        appBar: appBar,
        body: body,
        drawer: drawer,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        persistentFooterButtons: persistentFooterButtons,
        endDrawer: endDrawer,
      ),
    );
  }
}
