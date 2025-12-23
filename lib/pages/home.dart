import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/pages/domains.dart';
import 'package:pi_block/pages/lists.dart';
import 'package:pi_block/widgets/drawer_widget.dart';
import 'package:pi_block/widgets/navbar_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/pages/dashboard.dart';
import 'package:pi_block/pages/querylog.dart';
import 'package:pi_block/pages/stats.dart';
import 'package:pi_block/widgets/notifications_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                isDarkModeNotifier.value = PiUtils.getDarkMode(context)
                    ? "Light"
                    : "Dark";
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString(
                  KConstants.themeModeKey,
                  isDarkModeNotifier.value,
                );
              },
              icon: ValueListenableBuilder(
                valueListenable: isDarkModeNotifier,
                builder: (context, darkMode, child) {
                  return PiUtils.getDarkMode(context)
                      ? Icon(Icons.light_mode)
                      : Icon(Icons.dark_mode);
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
            return DrawerWidget(
              onLogout: () => context.read<AuthBloc>().add(Logout()),
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
