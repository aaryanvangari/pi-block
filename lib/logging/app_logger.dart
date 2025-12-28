import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class AppLogger {
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;

     /// prevent log propagation duplicates
    hierarchicalLoggingEnabled = true;

    /// print info and above in release mode and all in debug mode
    Logger.root.level = kReleaseMode ? Level.INFO : Level.ALL;

    Logger.root.onRecord.listen((record) {
      if (kReleaseMode) {
        // sendToServer(record);
      } else if (kDebugMode){
        print(
          '${record.time.toIso8601String()} '
          '[${record.level.name}] '
          '${record.loggerName}: '
          '${record.message}',
        );
      }
    });
  }

  static Logger get(String name) => Logger(name);

  /// Setup in class like 
  /// final _log = AppLogger.get('PiholeDataProvider');
  /// in methods use like (login is method name and remaining is message)
  /// _log.fine(() => 'login: ${result.toString()}');
  /// _log.info('login: Test message');
}
