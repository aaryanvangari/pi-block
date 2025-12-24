import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/services/settings_service.dart';
import 'package:pi_block/models/app_settings_model.dart';
import 'package:pi_block/pages/domains.dart';
import 'package:pi_block/pages/lists.dart';
import 'package:pi_block/widgets/drawer_widget.dart';
import 'package:pi_block/widgets/navbar_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/pages/dashboard.dart';
import 'package:pi_block/pages/querylog.dart';
import 'package:pi_block/pages/stats.dart';
import 'package:pi_block/widgets/notifications_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  bool hasNotifications = false;
  final List<Widget> _pages = [
    const DashboardPage(),
    const StatsPage(),
    const QueryLogPage(),
    const DomainsPage(),
    const ListsPage(),
  ];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
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
        drawer: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStateStatus.loggedOut) {
              context.go("/");
            }
          },
          builder: (context, state) {
            return BlocListener<AuthBloc, AuthState>(
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
          },
        ),
        bottomNavigationBar: NavbarWidget(),
        body: ValueListenableBuilder(
          valueListenable: selectedPageNotifier,
          builder: (context, selectedPage, child) {
            return _pages[selectedPage];
          },
        ),
      ),
    );
  }
}
