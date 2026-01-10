import 'package:flutter/material.dart';
import 'package:pi_block/logging/app_logger.dart';

/// Handles proper route locations /home /login etc
class RouteLocationNotifier extends ValueNotifier<String> {
  RouteLocationNotifier() : super('/');
  final _log = AppLogger.get('RouteLocationNotifier');

  void update(String location) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!location.startsWith('/')) {
        location = '/$location';
      }

      if (value != location) {
        value = location;
        _log.fine('PollAgent: location: $location');
      }
    });
  }
}
