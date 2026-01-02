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
  static const String piholeConfigurationPath = '/pihole-configuration';

  const AppRoutes._(); // Prevent instantiation
}
