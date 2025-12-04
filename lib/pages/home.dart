import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/pages/domains.dart';
import 'package:pi_block/pages/lists.dart';
import 'package:pi_block/widgets/drawer_widget.dart';
import 'package:pi_block/widgets/navbar_widget.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/pages/dashboard.dart';
import 'package:pi_block/pages/querylog.dart';
import 'package:pi_block/pages/stats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pi_block/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int diagnosticsMessagesCount = 0;
  bool hasNotifications = false;
  final List<Widget> _pages = [
    const DashboardPage(),
    const StatsPage(),
    const QueryLogPage(),
    const DomainsPage(),
    const ListsPage(),
  ];
  bool loading = false;
  PiHttpClient piHttpClient = PiHttpClient();

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  Future<Map<String, dynamic>> getNotifications() async {
    try {
      var result = await piHttpClient.get(KUrls.messagesCount);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "HomePage.getNotifications",
      );
      setState(() {
        diagnosticsMessagesCount = result["count"];
      });

      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
    }
    return {};
  }

  void doLogout() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        loading = true;
      });
      await auth.logout(auth);
      setState(() {
        loading = false;
      });
      if (!mounted) return;
      context.go("/");
    } catch (e) {
      if (!mounted) return;
      PiUtils.handleGeneralException(context, e);
    }
  }

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
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  context.go("/notifications");
                },
                icon: (diagnosticsMessagesCount > 0)
                    ? Badge.count(
                        count: diagnosticsMessagesCount,
                        child: Icon(Icons.notifications_on),
                      )
                    : Icon(Icons.notifications_none),
              ),
            ),
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
        drawer: DrawerWidget(onLogout: doLogout),
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
