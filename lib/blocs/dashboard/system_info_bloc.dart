import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/system_model.dart';

class SystemInfoBloc extends Bloc<SystemInfoEvent, SystemInfoState> {
  final PiholeRepository piholeRepository;
  Timer? _timer;

  SystemInfoBloc(this.piholeRepository)
    : super(
        SystemInfoState(
          status: SystemStateStatus.initial,
          systemModel: SystemModel.empty(),
        ),
      ) {
    on<LoadSystemInfo>(_onLoadSystem);
    on<SystemTick>(_onSystemTick);
  }

  /// Initial load + start polling
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
        ),
      );

      _startPolling();
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
      SystemModel systemModel = await piholeRepository.getSystemInfo();
      emit(
        state.copyWith(
          status: SystemStateStatus.success,
          systemModel: systemModel,
        ),
      );
    } catch (_) {
      // Optional: keep last success instead of failing UI
    }
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: KTimers.system),
      (_) => add(SystemTick()),
    );
  }

  @override
  Future<void> close() {
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

enum SystemStateStatus { initial, loading, success, failure, empty }

class SystemInfoState extends Equatable {
  final SystemModel systemModel;
  final SystemStateStatus status;
  final String error;
  final String message;
  const SystemInfoState({
    required this.systemModel,
    this.status = SystemStateStatus.initial,
    this.error = "",
    this.message = "",
  });

  SystemInfoState copyWith({
    SystemModel? systemModel,
    SystemStateStatus? status,
    String? error,
    String? message,
  }) {
    return SystemInfoState(
      systemModel: systemModel ?? this.systemModel,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [systemModel, status, error, message];
}
