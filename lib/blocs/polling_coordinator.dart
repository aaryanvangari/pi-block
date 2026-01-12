import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/logging/app_logger.dart';

class PollingCoordinator {
  PollingCoordinator(this._routeNotifier, this._authBloc) {
    _log.finer('PollAgent: hash=${identityHashCode(this)}');
    // Listen to route changes
    _routeNotifier.addListener(onRouteChanged);

    // Listen to authentication changes
    _authBloc.stream.listen(onAuthChanged);

    // Initiate for the first time
    _emit('initial');
  }

  final _log = AppLogger.get('PollingCoordinator');
  final ValueNotifier<String> _routeNotifier;
  final AuthBloc _authBloc;
  Timer? _debounce;
  bool _isForeground = true;
  bool _lastAuthValid = false;
  bool get _isAuthenticated {
    final state = _authBloc.state;
    return state.status == AuthStateStatus.loggedIn &&
        state.sid.isNotEmpty &&
        _authBloc.checkSessionValidity();
  }

  bool get shouldPoll {
    final location = _routeNotifier.value;

    // currently targetting only dashboard page which has route /home
    // It can be scaled in future but tweaks needs to be applied
    // Even before that the question we need to ask is why do we need
    // realtime data in other pages?
    final isRoot = location == '/';
    final isHome = location.startsWith('/home');

    // considering if app is in foreground, location is valid and then is user authenticated
    // when all these meets criteria then poll is enabled, then data is retrieved from blocs
    // which are subscribed to this data
    return _isForeground && (isRoot || isHome) && _isAuthenticated;
  }

  /// Listen to authbloc stream and reacts to changes
  /// For now dealing with login and logout to check whether
  /// we need to start or stop timers.
  /// We dont want polling to happen after logout
  void onAuthChanged(AuthState state) {
    final isValidNow = _isAuthenticated;

    _log.fine('PollAgent: AuthBloc stream: ${state.status}');

    // tracking only proper state transitions like
    // login -> logout and logout -> login
    // gives protection against trasient states
    // valid only on proper state transitions

    // Logged out → hard stop
    if (!isValidNow && _lastAuthValid) {
      _isForeground = false;
      _emit('logged out');
    }

    // Logged in → RE-EVALUATE polling
    if (isValidNow && !_lastAuthValid) {
      _emit('auth became valid');
    }

    _lastAuthValid = isValidNow;
  }

  /// Listen to application life cycle events
  /// Currently we are considering only resumed and paused
  /// In resumed we start the polling mechanism
  /// Polling mechanism internally checks for location
  /// and authentication states to send updates
  /// In paused state we stop polling mechanism
  void onAppLifecycleChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _log.fine('PollAgent: AppLifecycleState.resumed');
        _isForeground = true;
        _emit('resumed');
        break;
      case AppLifecycleState.paused:
        _log.fine('PollAgent: AppLifecycleState.paused');
        _isForeground = false;
        _emit('paused');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _log.fine('PollAgent: AppLifecycleState.inactive/detached');
        _isForeground = false;
        _emit('backgrounded');
        break;
      default:
        break;
    }
  }

  void onRouteChanged() {
    _emit('route changed');
  }

  void _emit(String reason) {
    _log.fine(
      '_emit: → '
      'route=${_routeNotifier.value}, '
      'foreground=$_isForeground, '
      'shouldPoll=$shouldPoll'
      '($reason)',
    );
    _debounce?.cancel();
    // This is absolutely needed otherwise it wont update dashboard
    // auth state changes may take a moment so we wait for it and update
    _debounce = Timer(const Duration(milliseconds: 150), () {
      pollingState.value = shouldPoll;
    });
  }
}
