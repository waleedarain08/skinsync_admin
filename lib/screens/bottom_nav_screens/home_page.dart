import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:skinsync_admin/utils/responsive.dart';
import 'package:skinsync_admin/widgets/app_sidebar.dart';
import 'package:skinsync_admin/widgets/custom_app_bar.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SidebarXController _sidebarController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? _isSmallScreen;

  @override
  void initState() {
    super.initState();
    _sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncSidebarIndex();
    _handleResponsiveSidebar();
  }

  void _syncSidebarIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    final index = AppSidebarRoutes.indexOf(location);
    if (index >= 0 && _sidebarController.selectedIndex != index) {
      _sidebarController.selectIndex(index);
    }
  }

  void _handleResponsiveSidebar() {
    // Determine if screen is mobile or tablet (where we use drawer)
    final isSmall = context.isMobile || context.isTablet;
    
    // Only set initial expansion once per screen-type change
    if (_isSmallScreen != isSmall) {
      _isSmallScreen = isSmall;
      // On small screens (Drawer) and Desktop, we prefer extended. 
      // Manual toggling is preserved because we only force it on screen-type transition.
      _sidebarController.setExtended(true);
    }
  }

  void _onSidebarItemTap(int index) {
    if (index < 0 || index >= AppSidebarRoutes.routes.length) return;
    
    context.go(AppSidebarRoutes.routes[index]);
    
    // Close drawer if open (Mobile/Tablet)
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = context.isMobile || context.isTablet;

        return GradientScaffold(
          scaffoldKey: _scaffoldKey,
          // Drawer used for both Mobile and Tablet as per requirements
          drawer: isSmallScreen ? Drawer(
            child: AppSidebar(
              controller: _sidebarController,
              onItemTap: _onSidebarItemTap,
              showToggleButton: false, // Drawer is always expanded
            ),
          ) : null,
          body: Row(
            children: [
              if (!isSmallScreen)
                AppSidebar(
                  controller: _sidebarController,
                  onItemTap: _onSidebarItemTap,
                  showToggleButton: true, // Allow collapse/expand on Desktop
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
      },
    );
  }
}
