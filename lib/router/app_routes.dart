abstract class AppRoutes {
  // Route names
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String home = 'home';
  static const String queryLog = 'queryLog';
  static const String stats = 'stats';
  static const String settings = 'settings';
  static const String notifications = 'notifications';
  static const String localDns = 'localDns';
  static const String domains = 'domains';
  static const String lists = 'lists';
  static const String groups = 'groups';
  static const String clients = 'clients';
  static const String logs = 'logs';
  static const String actions = 'actions';
  static const String piholeConfiguration = 'piholeConfiguration';

  // Route paths
  static const String welcomePath = '/';
  static const String loginPath = '/login';
  static const String homePath = '/home';
  static const String queryLogPath = '/query-log';
  static const String statsPath = '/stats';
  static const String settingsPath = '/settings';
  static const String notificationsPath = '/notifications';
  static const String localDnsPath = '/local-dns';
  static const String domainsPath = '/domains';
  static const String listsPath = '/lists';
  static const String groupsPath = '/groups';
  static const String clientsPath = '/clients';
  static const String logsPath = '/logs';
  static const String actionsPath = '/actions';
  static const String piholeConfigurationPath = '/pihole-configuration';

  const AppRoutes._(); // Prevent instantiation

  static const Map<String, String> routeTitles = {
    '/groups': 'Groups',
    '/clients': 'Clients',
    '/logs': 'Logs',
    '/pihole-configuration': 'Pi-Hole Configuration',
    '/actions': 'Actions',
    '/settings': 'Settings',
    '/notifications': 'Notifications',
    '/local-dns': 'Local DNS',
  };
}

enum AppDestination {
  dashboard,
  stats,
  querylog,
  domains,
  lists,
  groups,
  clients,
  logs,
  actions,
  notifications,
  piholeConfiguration,
  settings,
  localDns,
}

extension AppDestinationExtension on AppDestination {
  int get branchIndex {
    switch (this) {
      case AppDestination.dashboard:
        return 0;
      case AppDestination.stats:
        return 1;
      case AppDestination.querylog:
        return 2;
      case AppDestination.domains:
        return 3;
      case AppDestination.lists:
        return 4;
      case AppDestination.settings:
        return 5;
      case AppDestination.notifications:
        return 6;
      case AppDestination.localDns:
        return 7;
      case AppDestination.groups:
        return 8;
      case AppDestination.clients:
        return 9;
      case AppDestination.logs:
        return 10;
      case AppDestination.actions:
        return 11;
      case AppDestination.piholeConfiguration:
        return 12;
    }
  }
}

