import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pi_block/blocs/app_bloc_observer.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/services/settings_service.dart';
import 'package:pi_block/constants/hive/hive_boxes.dart';
import 'package:pi_block/data/data_provider/pihole_data_provider.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/models/app_settings_model.dart';
import 'package:pi_block/models/session_model.dart';
import 'package:pi_block/models/user_session_model.dart';
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
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/theme/app_typography.dart';
import 'package:pi_block/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(UserSessionModelAdapter());
  Hive.registerAdapter(AppSettingsModelAdapter());
  Hive.registerAdapter(ThemeModeOptionAdapter());

  // Open boxes
  await Hive.openBox<UserSessionModel>(HiveBoxes.userSessions);
  await Hive.openBox<AppSettingsModel>(HiveBoxes.settings);

  // Load environment files for preloaded credentials
  await dotenv.load(fileName: ".env");

  runApp(Directionality(textDirection: TextDirection.ltr, child: MainApp()));
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
    ThemeModeOption currentMode = SettingsService()
        .getSettings()
        .themeModeOption;
    themeModeNotifier.value = SettingsService().getThemeMode(currentMode);
  }

  List<BlocProvider> getBlocProviders() {
    List<BlocProvider> blocProviders = [
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(context.read<PiholeRepository>()),
        lazy: false,
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
        AuthState authState = context.read<AuthBloc>().state;
        bool isSessionValid = context.read<AuthBloc>().checkSessionValidity();
        if (!isSessionValid && authState.status == AuthStateStatus.loggedIn) {
          context.read<AuthBloc>().add(Logout());
          GlobalSnackbar.error(context, "Session Expired", "");
        }
        final isLoginRoute = state.matchedLocation == "/login";
        log(state.matchedLocation);
        bool isAuthenticated =
            authState.sid.isNotEmpty &&
            authState.status == AuthStateStatus.loggedIn &&
            isSessionValid;
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
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, child) {
        return AnnotatedRegion(
          // # Status bar dark color issue test
          value: SystemUiOverlayStyle.light,
          child: RepositoryProvider(
            create: (context) => PiholeRepository(PiholeDataProvider()),
            dispose: (repository) => repository.dispose(),
            child: MultiBlocProvider(
              providers: getBlocProviders(),
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: MaterialTheme(
                  AppTypography.lightTextTheme,
                ).theme(MaterialTheme.lightScheme()),
                darkTheme: MaterialTheme(
                  AppTypography.darkTextTheme,
                ).theme(MaterialTheme.darkScheme()),
                themeMode: themeModeNotifier.value,
                routerConfig: router,
              ),
            ),
          ),
        );
      },
    );
  }
}
