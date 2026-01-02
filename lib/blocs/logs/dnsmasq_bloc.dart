import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/logs_model.dart';

class DnsmasqBloc extends Bloc<DnsmasqEvent, DnsmasqState> {
  final PiholeRepository piholeRepository;
  Timer? _timer;

  DnsmasqBloc(this.piholeRepository)
    : super(
        DnsmasqState(
          status: DnsmasqStateStatus.initial,
          logsModel: LogsModel.empty(),
        ),
      ) {
    on<LoadDnsmasq>(_onLoadDnsmasq);
    on<SystemTick>(_onSystemTick);
    on<AutoRefreshDnsmasq>(_onAutoRefresh);
    on<DisableAutoRefreshDnsmasq>(_onDisableAutoRefresh);
  }

  LogsModel _reverseLogs(LogsModel logsModel) {
    return logsModel.copyWith(log: logsModel.log.reversed.toList());
  }

  Future<void> _onLoadDnsmasq(
    LoadDnsmasq event,
    Emitter<DnsmasqState> emit,
  ) async {
    emit(state.copyWith(status: DnsmasqStateStatus.loading));

    try {
      LogsModel logsModel = await piholeRepository.getDnsmasqLogs(event.nextID);

      emit(
        state.copyWith(
          status: DnsmasqStateStatus.success,
          logsModel: _reverseLogs(logsModel),
          nextID: logsModel.nextID,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DnsmasqStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _onSystemTick(
    SystemTick event,
    Emitter<DnsmasqState> emit,
  ) async {
    try {
      // Capture existing logs first
      final existingLogs = state.logsModel.log;

      LogsModel logsModel = await piholeRepository.getDnsmasqLogs(event.nextID);

      // Normalize API logs to newest → oldest
      final newLogs = logsModel.log.reversed.toList();

      // new logs after nextID + old logs which are in state
      final merged = [...newLogs, ...existingLogs];
      
      // Trimming to 100 because we dont want to deal with huge lists
      final trimmed = merged.take(100).toList();

      // Updated new logs model to send to frontend
      final updatedLogs = logsModel.copyWith(log: trimmed);

      // log(
      //   'Existing: ${existingLogs.length}, '
      //   'New: ${logsModel.log.length}, '
      //   'Merged: ${merged.length}, '
      //   'Trimmed: ${trimmed.length}',
      // );

      emit(
        state.copyWith(
          status: DnsmasqStateStatus.success,
          logsModel: updatedLogs,
          nextID: logsModel.nextID,
        ),
      );
    } catch (_) {
      // Optional: keep last success instead of failing UI
    }
  }

  Future<void> _onAutoRefresh(
    AutoRefreshDnsmasq event,
    Emitter<DnsmasqState> emit,
  ) async {
    _startPolling();
    emit(state.copyWith(autoRefreshOn: true));
  }

  Future<void> _onDisableAutoRefresh(
    DisableAutoRefreshDnsmasq event,
    Emitter<DnsmasqState> emit,
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

sealed class DnsmasqEvent extends Equatable {
  const DnsmasqEvent();

  @override
  List<Object> get props => [];
}

final class LoadDnsmasq extends DnsmasqEvent {
  final int nextID;
  const LoadDnsmasq(this.nextID);
}

final class SystemTick extends DnsmasqEvent {
  final int nextID;
  const SystemTick(this.nextID);
}

final class AutoRefreshDnsmasq extends DnsmasqEvent {
  const AutoRefreshDnsmasq();
}

final class DisableAutoRefreshDnsmasq extends DnsmasqEvent {
  const DisableAutoRefreshDnsmasq();
}

enum DnsmasqStateStatus { initial, loading, success, failure, empty }

class DnsmasqState extends Equatable {
  final LogsModel logsModel;
  final DnsmasqStateStatus status;
  final String error;
  final String message;
  final bool autoRefreshOn;
  final int nextID;
  const DnsmasqState({
    required this.logsModel,
    this.status = DnsmasqStateStatus.initial,
    this.error = "",
    this.message = "",
    this.autoRefreshOn = false,
    this.nextID = 0,
  });

  DnsmasqState copyWith({
    LogsModel? logsModel,
    DnsmasqStateStatus? status,
    String? error,
    String? message,
    bool? autoRefreshOn,
    int? nextID,
  }) {
    return DnsmasqState(
      logsModel: logsModel ?? this.logsModel,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      autoRefreshOn: autoRefreshOn ?? this.autoRefreshOn,
      nextID: nextID ?? this.nextID,
    );
  }

  @override
  List<Object?> get props => [
    logsModel,
    status,
    error,
    message,
    autoRefreshOn,
    nextID,
  ];
}
