import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/pages/domains.dart';
import 'package:pi_block/pages/lists.dart';
import 'package:pi_block/pages/home.dart';
import 'package:pi_block/pages/local_dns.dart';
import 'package:pi_block/pages/login.dart';
import 'package:pi_block/pages/notifications.dart';
import 'package:pi_block/pages/pi_hole_configuration.dart';
import 'package:pi_block/pages/querylog.dart';
import 'package:pi_block/pages/settings.dart';
import 'package:pi_block/pages/stats.dart';
import 'package:pi_block/pages/welcome.dart';
import 'package:pi_block/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MainApp(),
    ),
  );
  // runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    initTheme();
    super.initState();
  }

  void initTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? themeMode = prefs.getString(KConstants.themeModeKey);
    isDarkModeNotifier.value = themeMode ?? "System";
  }

  void setGlobalVariables(BuildContext context, String darkMode) {
    bool isDark = PiUtils.getDarkMode(context);

    listHeaderBackground.value = isDark
        ? Theme.of(context).colorScheme.onInverseSurface.withAlpha(
            KListStyle.lightAlphaIntensity,
          )
        : Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(KListStyle.lightAlphaIntensity);

    listHeaderRedBackground.value = (isDark
        ? KListStyle.listHeaderBackgroundColors["red"]?.withAlpha(
            KListStyle.darkAlphaIntensity,
          )
        : KListStyle.listHeaderBackgroundColors["red"]?.withAlpha(
            KListStyle.lightAlphaIntensity,
          ))!;
    listHeaderGreenBackground.value = (isDark
        ? KListStyle.listHeaderBackgroundColors["green"]?.withAlpha(
            KListStyle.darkAlphaIntensity,
          )
        : KListStyle.listHeaderBackgroundColors["green"]?.withAlpha(
            KListStyle.lightAlphaIntensity,
          ))!;
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: "/",
      routes: [
        GoRoute(
          name: "welcome",
          path: "/",
          builder: (context, state) => WelcomePage(),
        ),
        GoRoute(
          name: "home",
          path: "/home",
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          name: "login",
          path: "/login",
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          name: "queryLog",
          path: "/querylog",
          builder: (context, state) => QueryLogPage(),
        ),
        GoRoute(
          name: "stats",
          path: "/stats",
          builder: (context, state) => StatsPage(),
        ),
        GoRoute(
          name: "settings",
          path: "/settings",
          builder: (context, state) => SettingsPage(),
        ),
        GoRoute(
          name: "notifications",
          path: "/notifications",
          builder: (context, state) => NotificationsPage(),
        ),
        GoRoute(
          name: "localDns",
          path: "/localDns",
          builder: (context, state) => LocalDnsPage(),
        ),
        GoRoute(
          name: "domains",
          path: "/domains",
          builder: (context, state) => DomainsPage(),
        ),
        GoRoute(
          name: "lists",
          path: "/lists",
          builder: (context, state) => ListsPage(),
        ),
        GoRoute(
          name: "piholeConfiguration",
          path: "/piholeConfiguration",
          builder: (context, state) => PiholeConfigurationPage(),
        ),
      ],
      redirect: (context, state) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        final isLoginRoute = state.matchedLocation == "/login";
        log(state.matchedLocation);
        bool isAuthenticated = auth.isAuthenticated;
        if (!isAuthenticated && isLoginRoute) {
          return state.namedLocation("login");
        } else if (isAuthenticated && isLoginRoute) {
          return state.namedLocation("home");
        } else if (!isAuthenticated && !isLoginRoute) {
          return state.namedLocation("welcome");
        }
        return null;
      },
    );

    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, darkMode, child) {
        setGlobalVariables(context, darkMode);
        return AnnotatedRegion(
          value:
              SystemUiOverlayStyle.light, // # Status bar dark color issue test
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: (darkMode == 'System')
                    ? MediaQuery.of(context).platformBrightness
                    : (darkMode == "Dark")
                    ? Brightness.dark
                    : Brightness.light,
              ),
              primarySwatch: Colors.grey,
              // brightness: (darkMode == 'System')
              //     ? MediaQuery.of(context).platformBrightness
              //     : (darkMode == "Light")
              //     ? Brightness.light
              //     : Brightness.dark,
            ),
            // darkTheme: ThemeData.dark(),
            // themeMode: ThemeMode.system,
            routerConfig: router,
          ),
        );
      },
    );
  }
}
