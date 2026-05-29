import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/responsive.dart';
import 'package:skinsync_admin/widgets/app_sidebar.dart';
import 'package:skinsync_admin/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SidebarXController _sidebarController;

  @override
  void initState() {
    super.initState();
    _sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncSidebarIndex();
  }

  void _syncSidebarIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    final index = AppSidebarRoutes.indexOf(location);
    if (index >= 0 && _sidebarController.selectedIndex != index) {
      _sidebarController.selectIndex(index);
    }
  }

  void _onSidebarItemTap(int index) {
    if (index < 0 || index >= AppSidebarRoutes.routes.length) return;
    context.go(AppSidebarRoutes.routes[index]);
    if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sidebar = AppSidebar(
      controller: _sidebarController,
      onItemTap: _onSidebarItemTap,
    );

    return Scaffold(
      backgroundColor: CustomColors.whiteGrey,
      drawer: Responsive.when(
        defaultValue: null,
        mobile: () => Drawer(child: sidebar),
        tablet: () => Drawer(child: sidebar),
      ),
      body: Row(
        children: [
          Responsive.when(
            defaultValue: const SizedBox.shrink(),
            desktop: () => sidebar,
          ),
          Expanded(
            child: Column(
              children: [
                const CustomAppBar(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: KeyedSubtree(
                      key: ValueKey(GoRouterState.of(context).matchedLocation),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
