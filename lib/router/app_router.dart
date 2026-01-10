import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/pages/actions.dart';
import 'package:pi_block/pages/clients.dart';
import 'package:pi_block/pages/dashboard.dart';
import 'package:pi_block/pages/domains.dart';
import 'package:pi_block/pages/groups.dart';
import 'package:pi_block/pages/lists.dart';
import 'package:pi_block/pages/local_dns.dart';
import 'package:pi_block/pages/login.dart';
import 'package:pi_block/pages/logs.dart';
import 'package:pi_block/pages/main_scaffold.dart';
import 'package:pi_block/pages/notifications.dart';
import 'package:pi_block/pages/pi_hole_configuration.dart';
import 'package:pi_block/pages/querylog.dart';
import 'package:pi_block/pages/settings.dart';
import 'package:pi_block/pages/stats.dart';
import 'package:pi_block/pages/welcome.dart';
import 'package:pi_block/router/gorouter_refresh_stream.dart';
import 'package:pi_block/router/route_location_notifier.dart';
import 'package:pi_block/router/gorouter_pop_observer.dart';
import 'package:pi_block/router/route_signal_queue.dart';
import 'package:pi_block/router/router_refresh_notifier.dart';

import 'app_routes.dart';

class AppRouter {
  late final GoRouter router;
  late final RouteSignalQueue routeSignalQueue;
  final _log = AppLogger.get('AppRouter');
  GoRouter create(
    AuthBloc authBloc,
    RouteLocationNotifier routeLocationNotifier,
  ) {
    final routerRefresh = RouterRefreshNotifier([
      /// Re-run redirect whenever auth state changes
      GoRouterRefreshStream(authBloc.stream),
      // Listen to regular route changes which has path
      routeLocationNotifier,
    ]);
    routeSignalQueue = RouteSignalQueue(routeLocationNotifier);
    router = GoRouter(
      initialLocation: AppRoutes.welcomePath,
      debugLogDiagnostics: true,
      refreshListenable: routerRefresh,
      observers: [
        // observe only pop events
        GoRouterPopObserver(_emitCurrentRoute),
      ],
      redirect: (context, state) {
        final authState = authBloc.state;

        final isLoggedIn =
            authState.status == AuthStateStatus.loggedIn &&
            authState.sid.isNotEmpty &&
            authBloc.checkSessionValidity(); // typically 30 mins session

        final location = state.matchedLocation;

        const publicRoutes = {AppRoutes.welcomePath, AppRoutes.loginPath};

        // Not logged in → block everything except public routes
        if (!isLoggedIn && !publicRoutes.contains(location)) {
          return AppRoutes.welcomePath;
        }

        // Logged in → block ONLY public routes
        if (isLoggedIn && publicRoutes.contains(location)) {
          return AppRoutes.homePath;
        }

        // Allow shell routes & standalone authenticated routes
        return null;
      },

      routes: [
        /// Public routes
        GoRoute(
          name: AppRoutes.welcome,
          path: AppRoutes.welcomePath,
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          name: AppRoutes.login,
          path: AppRoutes.loginPath,
          builder: (context, state) => const LoginPage(),
        ),

        /// -------- Authenticated shell --------
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainScaffold(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRoutes.home,
                  path: AppRoutes.homePath,
                  builder: (_, __) => const DashboardPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRoutes.stats,
                  path: AppRoutes.statsPath,
                  builder: (_, __) => const StatsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRoutes.queryLog,
                  path: AppRoutes.queryLogPath,
                  builder: (_, __) => const QueryLogPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRoutes.domains,
                  path: AppRoutes.domainsPath,
                  builder: (_, __) => const DomainsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRoutes.lists,
                  path: AppRoutes.listsPath,
                  builder: (_, __) => const ListsPage(),
                ),
              ],
            ),
          ],
        ),

        // other authenticated pages
        // pages which dont need main scaffold
        GoRoute(
          name: AppRoutes.settings,
          path: AppRoutes.settingsPath,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          name: AppRoutes.notifications,
          path: AppRoutes.notificationsPath,
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          name: AppRoutes.localDns,
          path: AppRoutes.localDnsPath,
          builder: (context, state) => const LocalDnsPage(),
        ),
        GoRoute(
          name: AppRoutes.groups,
          path: AppRoutes.groupsPath,
          builder: (context, state) => const GroupsPage(),
        ),
        GoRoute(
          name: AppRoutes.clients,
          path: AppRoutes.clientsPath,
          builder: (context, state) => const ClientsPage(),
        ),
        GoRoute(
          name: AppRoutes.logs,
          path: AppRoutes.logsPath,
          builder: (context, state) => const LogsPage(),
        ),
        GoRoute(
          name: AppRoutes.actions,
          path: AppRoutes.actionsPath,
          builder: (context, state) => const ActionsPage(),
        ),
        GoRoute(
          name: AppRoutes.piholeConfiguration,
          path: AppRoutes.piholeConfigurationPath,
          builder: (context, state) => const PiholeConfigurationPage(),
        ),
      ],
    );
    return router;
  }

  void _emitCurrentRoute() {
    final uri = router.routeInformationProvider.value.uri.toString();
    _log.fine('PollAgent: _emitCurrentRoute: uri $uri');
    // this will eventually update RouteLocationNotifier
    routeSignalQueue.enqueue(uri);
  }
}
