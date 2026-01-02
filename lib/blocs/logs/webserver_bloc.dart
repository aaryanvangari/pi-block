import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/logs_model.dart';

class WebserverBloc extends Bloc<WebserverEvent, WebserverState> {
  final PiholeRepository piholeRepository;
  Timer? _timer;

  WebserverBloc(this.piholeRepository)
    : super(
        WebserverState(
          status: WebserverStateStatus.initial,
          logsModel: LogsModel.empty(),
        ),
      ) {
    on<LoadWebserver>(_onLoadWebserver);
    on<SystemTick>(_onSystemTick);
    on<AutoRefreshWebserver>(_onAutoRefresh);
    on<DisableAutoRefreshWebserver>(_onDisableAutoRefresh);
  }

  LogsModel _reverseLogs(LogsModel logsModel) {
    return logsModel.copyWith(log: logsModel.log.reversed.toList());
  }

  Future<void> _onLoadWebserver(
    LoadWebserver event,
    Emitter<WebserverState> emit,
  ) async {
    emit(state.copyWith(status: WebserverStateStatus.loading));

    try {
      LogsModel logsModel = await piholeRepository.getWebserverLogs(event.nextID);

      emit(
        state.copyWith(
          status: WebserverStateStatus.success,
          logsModel: _reverseLogs(logsModel),
          nextID: logsModel.nextID
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: WebserverStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSystemTick(
    SystemTick event,
    Emitter<WebserverState> emit,
  ) async {
    try {
      // Capture existing logs first
      final existingLogs = state.logsModel.log;

      LogsModel logsModel = await piholeRepository.getWebserverLogs(event.nextID);

      // Normalize API logs to newest → oldest
      final newLogs = logsModel.log.reversed.toList();

      // new logs after nextID + old logs which are in state
      final merged = [...newLogs, ...existingLogs];
      
      // Trimming to 100 because we dont want to deal with huge lists
      final trimmed = merged.take(100).toList();

      // Updated new logs model to send to frontend
      final updatedLogs = logsModel.copyWith(log: trimmed);

      log(
        'Existing: ${existingLogs.length}, '
        'New: ${logsModel.log.length}, '
        'Merged: ${merged.length}, '
        'Trimmed: ${trimmed.length}',
      );

      emit(
        state.copyWith(
          status: WebserverStateStatus.success,
          logsModel: updatedLogs,
          nextID: logsModel.nextID
        ),
      );
    } catch (_) {
      // Optional: keep last success instead of failing UI
    }
  }

  Future<void> _onAutoRefresh(
    AutoRefreshWebserver event,
    Emitter<WebserverState> emit,
  ) async {
    _startPolling();
    emit(state.copyWith(autoRefreshOn: true));
  }

  Future<void> _onDisableAutoRefresh(
    DisableAutoRefreshWebserver event,
    Emitter<WebserverState> emit,
  ) async {
    _stopPolling();
    emit(state.copyWith(autoRefreshOn: false));
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: KTimers.dnsmasq),
      (_) => add(SystemTick(state.nextID)),
    );
  }

  void _stopPolling() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

sealed class WebserverEvent extends Equatable {
  const WebserverEvent();

  @override
  List<Object> get props => [];
}

final class LoadWebserver extends WebserverEvent {
  final int nextID;
  const LoadWebserver(this.nextID);
}

final class SystemTick extends WebserverEvent {
  final int nextID;
  const SystemTick(this.nextID);
}

final class AutoRefreshWebserver extends WebserverEvent {
  const AutoRefreshWebserver();
}

final class DisableAutoRefreshWebserver extends WebserverEvent {
  const DisableAutoRefreshWebserver();
}

enum WebserverStateStatus { initial, loading, success, failure, empty }

class WebserverState extends Equatable {
  final LogsModel logsModel;
  final WebserverStateStatus status;
  final String error;
  final String message;
  final bool autoRefreshOn;
  final int nextID;
  const WebserverState({
    required this.logsModel,
    this.status = WebserverStateStatus.initial,
    this.error = "",
    this.message = "",
    this.autoRefreshOn = false,
    this.nextID = 0,
  });

  WebserverState copyWith({
    LogsModel? logsModel,
    WebserverStateStatus? status,
    String? error,
    String? message,
    bool? autoRefreshOn,
    int? nextID,
  }) {
    return WebserverState(
      logsModel: logsModel ?? this.logsModel,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      autoRefreshOn: autoRefreshOn ?? this.autoRefreshOn,
      nextID: nextID ?? this.nextID
    );
  }

  @override
  List<Object?> get props => [logsModel, status, error, message, autoRefreshOn, nextID];
}
