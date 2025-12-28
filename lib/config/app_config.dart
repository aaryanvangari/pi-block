class AppConfig {
  static const env = String.fromEnvironment('ENV', defaultValue: 'prod');

  static const serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: '',
  );

  static const apiToken = String.fromEnvironment('API_TOKEN', defaultValue: '');

  static bool get isDev => env == 'dev';
}
