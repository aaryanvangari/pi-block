import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/blocs/dashboard/metrics_bloc.dart';
import 'package:pi_block/blocs/dashboard/summary_bloc.dart';
import 'package:pi_block/blocs/dashboard/system_info_bloc.dart';
import 'package:pi_block/blocs/domains/domains_bloc.dart';
import 'package:pi_block/blocs/notifications/notifications_bloc.dart';
import 'package:pi_block/blocs/polling_coordinator.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/router/app_router.dart';
import 'package:pi_block/router/route_location_notifier.dart';
import 'package:pi_block/theme/app_typography.dart';
import 'package:pi_block/theme/theme.dart';
import 'package:provider/provider.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  late final GoRouter _router;
  late final PollingCoordinator pollingCoordinator;
  final AppRouter appRouter = AppRouter();
  final _log = AppLogger.get('AppView');
  final RouteLocationNotifier routeLocationNotifier = RouteLocationNotifier();

  @override
  void initState() {
    super.initState();
    // For observing app lifecycle states
    WidgetsBinding.instance.addObserver(this);

    // Orchestrates polling mechanism.
    // Listens to route changes and then auth changes
    // and then start/stop polling based on location
    pollingCoordinator = PollingCoordinator(
      routeLocationNotifier,
      context.read<AuthBloc>(),
    );
    // Here polling coordinator listening to route changes
    // so that it can start/stop timers
    routeLocationNotifier.addListener(() {
      pollingCoordinator.onRouteChanged();
    });

    // Initial evaluation
    pollingCoordinator.onRouteChanged();

    // Setup GoRouter
    _router = appRouter.create(context.read<AuthBloc>(), routeLocationNotifier);
    _log.finer('GoRouter: instance ${identityHashCode(_router)}');

    // Listen to route changes and do things based on route
    // Like stop/start timers
    _router.routeInformationProvider.addListener(_onRouteInfo);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App lifecycle state is monitored
    // like app is paused or active and stuff
    pollingCoordinator.onAppLifecycleChanged(state);
  }

  void _onRouteInfo() {
    final uri = _router.routeInformationProvider.value.uri.toString();
    routeLocationNotifier.update(uri);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeLocationNotifier.removeListener(pollingCoordinator.onRouteChanged);
    _router.routeInformationProvider.removeListener(_onRouteInfo);
    routeLocationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: pollingCoordinator,
      child: MultiBlocProvider(
        providers: [
          /// setting up here since this bloc provides data for 4 different widgets
          /// and I can call the event only once here and all widgets have data
          BlocProvider<MetricsBloc>(
            create: (context) =>
                MetricsBloc(context.read<PiholeRepository>())
                  ..add(LoadMetrics()),
          ),
          // domains data is being shared by querylog and domains, so initiaing here.
          // In querylog we do allow/deny domain and those changes should be reflected
          // Im not doing loadDomains here as its not necessary, I will load them in page
          BlocProvider<DomainsBloc>(
            create: (context) => DomainsBloc(context.read<PiholeRepository>()),
          ),
          // Notifications bloc is used in two places and anyways notifications is
          // app level bloc and not scoped to page level
          BlocProvider<NotificationsBloc>(
            create: (context) =>
                NotificationsBloc(context.read<PiholeRepository>())
                  ..add(LoadNotifications()),
          ),
          // Need to provide dashboard blocs here because they need to be above router
          // and layout changes, otherwise if layout changes from mobile to desktop
          // then blocs will be disposed and then when next events get added
          // from PollingCoordinator it will crash.
          // This will probably not needed in mobile or tablet layouts but if any case
          // layout changes in any device especially web then crash happens.
          // When we know that a crash happens definitely then its better to fix it.
          // Which ever blocs are being subscribed to PollingCoordinator they must be
          // placed here to run smothly. Anyways PollingCoordinator is specifically
          // designed for Dashboard kind of pages. For other pages we probably dont
          // need real time refresh or need to find out other strategies
          BlocProvider(
            create: (_) =>
                SummaryBloc(context.read<PiholeRepository>())
                  ..add(LoadSummary()),
          ),
          BlocProvider(
            create: (_) =>
                SystemInfoBloc(context.read<PiholeRepository>())
                  ..add(LoadSystemInfo()),
          ),
        ],
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: themeModeNotifier,
          builder: (context, themeMode, _) {
            return ChangeNotifierProvider<RouteLocationNotifier>.value(
              value: routeLocationNotifier,
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                theme: MaterialTheme(
                  AppTypography.lightTextTheme,
                ).theme(MaterialTheme.lightScheme()),
                darkTheme: MaterialTheme(
                  AppTypography.darkTextTheme,
                ).theme(MaterialTheme.darkScheme()),
                routerConfig: _router,
              ),
            );
          },
        ),
      ),
    );
  }
}
