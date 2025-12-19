import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/app_bloc_observer.dart';
import 'package:pi_block/blocs/blocking_bloc.dart';
import 'package:pi_block/blocs/stats/charts/client_history_barchart_bloc.dart';
import 'package:pi_block/blocs/stats/charts/query_history_barchart_bloc.dart';
import 'package:pi_block/blocs/stats/charts/query_types_piechart_bloc.dart';
import 'package:pi_block/blocs/stats/charts/upstreams_piechart_bloc.dart';
import 'package:pi_block/blocs/stats/clients_stats/clients_blocked_bloc.dart';
import 'package:pi_block/blocs/stats/clients_stats/clients_permitted_bloc.dart';
import 'package:pi_block/blocs/dashboard/dashboard_bloc.dart';
import 'package:pi_block/blocs/domains/domains_bloc.dart';
import 'package:pi_block/blocs/stats/domains_stats/domains_blocked_bloc.dart';
import 'package:pi_block/blocs/stats/domains_stats/domains_permitted_bloc.dart';
import 'package:pi_block/blocs/lists/lists_bloc.dart';
import 'package:pi_block/blocs/notifications/notifications_bloc.dart';
import 'package:pi_block/blocs/pihole_config/pihole_config_bloc.dart';
import 'package:pi_block/blocs/querylog/querylog_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/data_provider/pihole_data_provider.dart';
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
import 'package:pi_block/data/repository/pihole_repository.dart';
// import 'package:pi_block/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MainApp(prefs: sharedPreferences),
      ),
    ),
  );
  // runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MainApp({super.key, required this.prefs});

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
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    slidePrimary.value = colorScheme.primary.withAlpha(180);
    slideError.value = colorScheme.error.withAlpha(200);
    circularLoadingOnPrimary.value = colorScheme.onPrimary.withAlpha(180);
    circularLoadingOnError.value = colorScheme.onError.withAlpha(180);
    listHeaderTitleAllow.value = isDark
        ? TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green.withAlpha(200),
          )
        : TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green.withAlpha(220),
          );
    listHeaderTitleBlock.value = isDark
        ? TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red.withAlpha(170),
          )
        : TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red.withAlpha(220),
          );
    tagBackground.value = isDark
        ? colorScheme.onInverseSurface.withAlpha(KListStyle.darkAlphaIntensity)
        : colorScheme.onSurface.withAlpha(KListStyle.lightAlphaIntensity);
    listHeaderBackground.value = isDark
        ? colorScheme.onInverseSurface.withAlpha(KListStyle.lightAlphaIntensity)
        : colorScheme.onSurface.withAlpha(KListStyle.lightAlphaIntensity);

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

  List<BlocProvider> getBlocProviders() {
    List<BlocProvider> blocProviders = [
      BlocProvider<NotificationsBloc>(
        create: (context) =>
            NotificationsBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<ListsBloc>(
        create: (context) => ListsBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<DomainsBloc>(
        create: (context) => DomainsBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<ClientsPermittedBloc>(
        create: (context) =>
            ClientsPermittedBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<ClientsBlockedBloc>(
        create: (context) =>
            ClientsBlockedBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<DomainsPermittedBloc>(
        create: (context) =>
            DomainsPermittedBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<DomainsBlockedBloc>(
        create: (context) =>
            DomainsBlockedBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<QueryTypesPiechartBloc>(
        create: (context) =>
            QueryTypesPiechartBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<UpstreamsPiechartBloc>(
        create: (context) =>
            UpstreamsPiechartBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<DashboardBloc>(
        create: (context) => DashboardBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<BlockingBloc>(
        create: (context) => BlockingBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<QuerylogBloc>(
        create: (context) => QuerylogBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<PiholeConfigBloc>(
        create: (context) => PiholeConfigBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<QueryHistoryBarchartBloc>(
        create: (context) =>
            QueryHistoryBarchartBloc(context.read<PiholeRepository>()),
      ),
      BlocProvider<ClientHistoryBarchartBloc>(
        create: (context) =>
            ClientHistoryBarchartBloc(context.read<PiholeRepository>()),
      ),
    ];
    return blocProviders;
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
          child: RepositoryProvider(
            create: (context) => PiholeRepository(PiholeDataProvider()),
            dispose: (repository) => repository.dispose(),
            child: MultiBlocProvider(
              providers: getBlocProviders(),
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                // theme: PiBlockTheme.light,
                // darkTheme: PiBlockTheme.dark,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    // seedColor: const Color.fromARGB(255, 60, 119, 228),
                    seedColor: const Color(0xFF007AFF),
                    // primary: Color(0xFF007AFF),
                    brightness: (darkMode == 'System')
                        ? MediaQuery.of(context).platformBrightness
                        : (darkMode == "Dark")
                        ? Brightness.dark
                        : Brightness.light,
                  ),
                  primarySwatch: Colors.grey,
                  // textTheme: GoogleFonts.rajdhaniTextTheme(),
                ),
                // darkTheme: ThemeData.dark(),
                // themeMode: ThemeMode.system,
                routerConfig: router,
              ),
            ),
          ),
        );
      },
    );
  }
}
