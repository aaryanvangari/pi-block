import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/models/app_settings_model.dart';
import 'package:pi_block/router/app_routes.dart';
import 'package:pi_block/services/settings_service.dart';
import 'package:pi_block/widgets/drawer_widget.dart';
import 'package:pi_block/widgets/navbar_widget.dart';
import 'package:pi_block/widgets/notifications_widget.dart';

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell? navigationShell;
  final Widget? child;

  /// This is main layout of our app after authentication.
  /// Here goes appbar, theme changer, notifications, drawer, navigation bar etc.,
  /// Nothing of content goes here like dashboard page or stats page etc.,
  /// Whenver the page changes from navigation bar the content changes but layout remains same
  // const MainScaffold({super.key, required this.navigationShell});
  const MainScaffold({super.key, this.child, this.navigationShell});
  static const double _drawerBreakpoint = 900;
  static const double _drawerWidth = 280;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with WidgetsBindingObserver {
  bool _isLocked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    final shortestSize = mediaQuery.size.shortestSide;
    final isPhone = shortestSize < 600;

    if (isPhone && !_isLocked) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      _isLocked = true;
    }
    if (!isPhone && _isLocked) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      _isLocked = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= MainScaffold._drawerBreakpoint;

    final drawer = BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.failure) {
          GlobalBanner.error(context, state.error, state.errorDescription);
        }
      },
      child: DrawerWidget(
        navigationShell: widget.navigationShell!,
        onLogout: () => context.read<AuthBloc>().add(Logout()),
        isDesktop: isDesktop,
      ),
    );

    // Detect if current route is an independent route
    final location = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.toString();
    final isIndependent = widget.navigationShell!.currentIndex > 4;

    // Define appBar conditionally
    final appBar = (!isDesktop && isIndependent)
        ? AppBar(
            title: Text(AppRoutes.routeTitles[location] ?? 'Page'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => widget.navigationShell!.goBranch(
                AppDestination.dashboard.branchIndex,
              ),
            ),
          )
        : AppBar(
            elevation: 3,
            automaticallyImplyLeading: !isDesktop,
            actions: [
              IconButton(
                onPressed: () async {
                  final newMode =
                      themeModeOptionNotifier.value == ThemeModeOption.dark
                      ? ThemeModeOption.light
                      : ThemeModeOption.dark;
                  await SettingsService().updateSettings(
                    (settings) => settings.copyWith(themeModeOption: newMode),
                  );
                  themeModeOptionNotifier.value = newMode;
                  themeModeNotifier.value =
                      themeModeOptionNotifier.value == ThemeModeOption.dark
                      ? ThemeMode.dark
                      : ThemeMode.light;
                },
                icon: ValueListenableBuilder(
                  valueListenable: themeModeOptionNotifier,
                  builder: (context, themeModeOption, child) {
                    return PiUtils.getDarkMode(context)
                        ? const Icon(Icons.light_mode)
                        : const Icon(Icons.dark_mode);
                  },
                ),
              ),
              // Enabling notifications for all routes in desktop
              NotificationsWidget(navigationShell: widget.navigationShell!),
            ],
            titleSpacing: isDesktop ? null : 0,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    "π",
                    style: GoogleFonts.roboto(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "Block",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
    // Conditionally render full page for independent routes
    if (!isDesktop && isIndependent) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppRoutes.routeTitles[location] ?? 'Page'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => widget.navigationShell!.goBranch(
              AppDestination.dashboard.branchIndex,
            ),
          ),
        ),
        body: widget.navigationShell,
      );
    } else {
      // Main scaffold with conditional properties
      return Scaffold(
        appBar: appBar,
        body: isDesktop
            ? Row(
                children: [
                  SizedBox(width: MainScaffold._drawerWidth, child: drawer),
                  const VerticalDivider(width: 1),
                  Expanded(child: widget.navigationShell!),
                ],
              )
            : widget.navigationShell!,
        // Hide drawer for independent routes on mobile
        drawer: !isDesktop && !isIndependent ? drawer : null,
        // Hide bottom bar for independent routes on mobile
        bottomNavigationBar: !isDesktop && !isIndependent
            ? NavbarWidget(navigationShell: widget.navigationShell!)
            : null,
      );
    }
  }
}
