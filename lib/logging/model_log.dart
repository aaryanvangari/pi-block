import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class ModelLog {
  static final Logger _log = Logger('Model');

  static void fromJson(
    Type modelType,
    Object? json,
  ) {
    _log.level = kReleaseMode ? Level.OFF : Level.FINEST;
    _log.finest(() => '[$modelType.fromJson] $json');
  }
}
