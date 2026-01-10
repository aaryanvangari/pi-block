import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/models/system_model.dart';

class SystemInfoBloc extends Bloc<SystemInfoEvent, SystemInfoState> {
  final PiholeRepository piholeRepository;
  Timer? _timer;
  final _log = AppLogger.get('SystemInfoBloc');

  SystemInfoBloc(this.piholeRepository)
    : super(
        SystemInfoState(
          status: SystemStateStatus.initial,
          systemModel: SystemModel.empty(),
        ),
      ) {
    on<LoadSystemInfo>(_onLoadSystem);
    on<SystemTick>(_onSystemTick);
    on<StartPolling>(_startPolling);
    on<StopPolling>(_stopPolling);
    pollingState.addListener(() => _onPollingState(pollingState.value));
    _log.fine('PollAgent: SystemInfoBloc hash=${identityHashCode(this)}');
  }

  void _onPollingState(bool shouldPoll) {
    if (shouldPoll) {
      _log.fine('PollAgent: _onPollingState shouldPoll $shouldPoll');
      add(StartPolling());
    } else {
      _log.fine('PollAgent: _onPollingState shouldPoll $shouldPoll');
      add(StopPolling());
    }
  }

  /// Initial load
  Future<void> _onLoadSystem(
    LoadSystemInfo event,
    Emitter<SystemInfoState> emit,
  ) async {
    emit(state.copyWith(status: SystemStateStatus.loading));

    try {
      SystemModel systemModel = await piholeRepository.getSystemInfo();

      emit(
        state.copyWith(
          status: SystemStateStatus.success,
          systemModel: systemModel,
          version: state.version + 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SystemStateStatus.failure, error: e.toString()),
      );
    }
  }

  /// Runs every 15 seconds
  Future<void> _onSystemTick(
    SystemTick event,
    Emitter<SystemInfoState> emit,
  ) async {
    try {
      _log.fine('PollAgent: _onSystemTick');
      SystemModel systemModel = await piholeRepository.getSystemInfo();
      emit(
        state.copyWith(
          status: SystemStateStatus.success,
          systemModel: systemModel,
          version: state.version + 1,
        ),
      );
      _log.fine(
        'PollAgent: _onSystemTick uptime: ${systemModel.system.uptime} status: ${state.status} version: ${state.version}',
      );
    } catch (_) {
      // Optional: keep last success instead of failing UI
    }
  }

  void _startPolling(StartPolling event, Emitter<SystemInfoState> emit) {
    _log.fine('PollAgent: _startPolling');
    // Prevent duplicate timers
    if (_timer != null) return;

    // Immediate refresh when polling starts
    add(SystemTick());

    // Next set of refresh based on timer
    _timer = Timer.periodic(
      const Duration(seconds: KTimers.system),
      (_) => add(SystemTick()),
    );
  }

  void _stopPolling(StopPolling event, Emitter<SystemInfoState> emit) {
    _log.fine('PollAgent: _stopPolling');
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _log.fine('PollAgent: close');
    _timer?.cancel();
    return super.close();
  }
}

sealed class SystemInfoEvent extends Equatable {
  const SystemInfoEvent();

  @override
  List<Object> get props => [];
}

final class LoadSystemInfo extends SystemInfoEvent {
  const LoadSystemInfo();
}

final class SystemTick extends SystemInfoEvent {
  const SystemTick();
}

final class StartPolling extends SystemInfoEvent {}

final class StopPolling extends SystemInfoEvent {}

enum SystemStateStatus { initial, loading, success, failure, empty }

class SystemInfoState extends Equatable {
  final SystemModel systemModel;
  final SystemStateStatus status;
  final String error;
  final String message;
  final int version;
  const SystemInfoState({
    required this.systemModel,
    this.status = SystemStateStatus.initial,
    this.error = "",
    this.message = "",
    this.version = 0,
  });

  SystemInfoState copyWith({
    SystemModel? systemModel,
    SystemStateStatus? status,
    String? error,
    String? message,
    int? version,
  }) {
    return SystemInfoState(
      systemModel: systemModel ?? this.systemModel,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [systemModel, status, error, message, version];
}
