import 'package:flutter/material.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/router/route_location_notifier.dart';

/// Handles navigation events like pop push etc.
/// Since GoRouter doesnt give whole truth when we
/// handle it purely based on route paths,
/// so we need to track navigation events as well.
/// Example: lets say we went to /home which is a navigation shell
/// then to /groups which is an independent route and press back
/// which does pop and we are in home screen
/// but the location is still in /groups as pop doesnt change the path
class RouteSignalQueue {
  final RouteLocationNotifier _notifier;
  String? _pending;
  final _log = AppLogger.get('RouteSignalQueue');

  RouteSignalQueue(this._notifier);

  void enqueue(String location) {
    if (!location.startsWith('/')) {
      location = '/$location';
    }

    _pending = location;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pending != null) {
        _log.fine('PollAgent: location: $location');
        _notifier.update(_pending!);
        _pending = null;
      }
    });
  }
}
