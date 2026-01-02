import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/logs_model.dart';

class FtlBloc extends Bloc<FtlEvent, FtlState> {
  final PiholeRepository piholeRepository;
  Timer? _timer;

  FtlBloc(this.piholeRepository)
    : super(
        FtlState(status: FtlStateStatus.initial, logsModel: LogsModel.empty()),
      ) {
    on<LoadFtl>(_onLoadFtl);
    on<SystemTick>(_onSystemTick);
    on<AutoRefreshFtl>(_onAutoRefresh);
    on<DisableAutoRefreshFtl>(_onDisableAutoRefresh);
  }

  LogsModel _reverseLogs(LogsModel logsModel) {
    return logsModel.copyWith(log: logsModel.log.reversed.toList());
  }

  Future<void> _onLoadFtl(LoadFtl event, Emitter<FtlState> emit) async {
    emit(state.copyWith(status: FtlStateStatus.loading));

    try {
      LogsModel logsModel = await piholeRepository.getFtlLogs(event.nextID);

      emit(
        state.copyWith(
          status: FtlStateStatus.success,
          logsModel: _reverseLogs(logsModel),
          nextID: logsModel.nextID,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: FtlStateStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onSystemTick(SystemTick event, Emitter<FtlState> emit) async {
    try {
      // Capture existing logs first
      final existingLogs = state.logsModel.log;

      LogsModel logsModel = await piholeRepository.getFtlLogs(event.nextID);

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
          status: FtlStateStatus.success,
          logsModel: updatedLogs,
          nextID: logsModel.nextID,
        ),
      );
    } catch (_) {
      // Optional: keep last success instead of failing UI
    }
  }

  Future<void> _onAutoRefresh(
    AutoRefreshFtl event,
    Emitter<FtlState> emit,
  ) async {
    _startPolling();
    emit(state.copyWith(autoRefreshOn: true));
  }

  Future<void> _onDisableAutoRefresh(
    DisableAutoRefreshFtl event,
    Emitter<FtlState> emit,
  ) async {
    _stopPolling();
    emit(state.copyWith(autoRefreshOn: false));
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: KTimers.ftl),
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

sealed class FtlEvent extends Equatable {
  const FtlEvent();

  @override
  List<Object> get props => [];
}

final class LoadFtl extends FtlEvent {
  final int nextID;
  const LoadFtl(this.nextID);
}

final class SystemTick extends FtlEvent {
  final int nextID;
  const SystemTick(this.nextID);
}

final class AutoRefreshFtl extends FtlEvent {
  const AutoRefreshFtl();
}

final class DisableAutoRefreshFtl extends FtlEvent {
  const DisableAutoRefreshFtl();
}

enum FtlStateStatus { initial, loading, success, failure, empty }

class FtlState extends Equatable {
  final LogsModel logsModel;
  final FtlStateStatus status;
  final String error;
  final String message;
  final bool autoRefreshOn;
  final int nextID;
  const FtlState({
    required this.logsModel,
    this.status = FtlStateStatus.initial,
    this.error = "",
    this.message = "",
    this.autoRefreshOn = false,
    this.nextID = 0,
  });

  FtlState copyWith({
    LogsModel? logsModel,
    FtlStateStatus? status,
    String? error,
    String? message,
    bool? autoRefreshOn,
    int? nextID,
  }) {
    return FtlState(
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
