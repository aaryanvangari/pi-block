import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/models/app_settings_model.dart';
import 'package:pi_block/services/settings_service.dart';
import 'package:pi_block/widgets/drawer_widget.dart';
import 'package:pi_block/widgets/navbar_widget.dart';
import 'package:pi_block/widgets/notifications_widget.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  /// This is main layout of our app after authentication.
  /// Here goes appbar, theme changer, notifications, drawer, navigation bar etc.,
  /// Nothing of content goes here like dashboard page or stats page etc.,
  /// Whenver the page changes from navigation bar the content changes but layout remains same
  const MainScaffold({super.key, required this.navigationShell});
  static const double _drawerBreakpoint = 900;
  static const double _drawerWidth = 280;


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= _drawerBreakpoint;

    final drawer = BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.failure) {
          GlobalSnackbar.error(
            context,
            state.error,
            state.errorDescription,
          );
        }
      },
      child: DrawerWidget(
        onLogout: () => context.read<AuthBloc>().add(Logout()),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        automaticallyImplyLeading: !isDesktop, // hide hamburger on desktop
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
          NotificationsWidget(),
        ],
        title: Row(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(bottom: 5),
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
      ),
      body: isDesktop
          ? Row(
              children: [
                SizedBox(width: _drawerWidth, child: drawer),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            )
          : navigationShell,

      // drawer closed only on mobile
      drawer: isDesktop ? null : drawer,
      bottomNavigationBar: NavbarWidget(navigationShell: navigationShell),
    );
  }
}
