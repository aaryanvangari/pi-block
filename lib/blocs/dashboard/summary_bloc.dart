import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/models/summary_model.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final PiholeRepository piholeRepository;
  Timer? _timer;
  final _log = AppLogger.get('SummaryBloc');

  SummaryBloc(this.piholeRepository)
    : super(
        SummaryState(
          status: SummaryStateStatus.initial,
          summaryModel: SummaryModel.empty(),
        ),
      ) {
    on<LoadSummary>(_onLoadSummary);
    on<SummaryTick>(_onSummaryTick);
    on<StartPolling>(_startPolling);
    on<StopPolling>(_stopPolling);
    pollingState.addListener(() => _onPollingState(pollingState.value));
    _log.fine(
      'PollAgent: SummaryBloc hash=${identityHashCode(this)}',
    );
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
  Future<void> _onLoadSummary(
    LoadSummary event,
    Emitter<SummaryState> emit,
  ) async {
    emit(state.copyWith(status: SummaryStateStatus.loading));

    try {
      SummaryModel summaryModel = await piholeRepository.getSummary();

      emit(
        state.copyWith(
          status: SummaryStateStatus.success,
          summaryModel: summaryModel,
          version: state.version + 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SummaryStateStatus.failure, error: e.toString()),
      );
    }
  }

  /// Runs every 15 seconds
  Future<void> _onSummaryTick(
    SummaryTick event,
    Emitter<SummaryState> emit,
  ) async {
    try {
      _log.fine('PollAgent: _onSummaryTick');
      SummaryModel summaryModel = await piholeRepository.getSummary();
      emit(
        state.copyWith(
          status: SummaryStateStatus.success,
          summaryModel: summaryModel,
          version: state.version + 1,
        ),
      );
      _log.fine(
        'PollAgent: _onSummaryTick total: ${summaryModel.queries.total} status: ${state.status} version: ${state.version}',
      );
    } catch (_) {
      // Optional: keep last success instead of failing UI
    }
  }

  void _startPolling(StartPolling event, Emitter<SummaryState> emit) {
    _log.fine('PollAgent: _startPolling');
    // Prevent duplicate timers
    if (_timer != null) return;

    // Immediate refresh when polling starts
    add(SummaryTick());

    // Next set of refresh based on timer
    _timer = Timer.periodic(
      const Duration(seconds: KTimers.summary),
      (_) => add(SummaryTick()),
    );
  }

  void _stopPolling(StopPolling event, Emitter<SummaryState> emit) {
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

sealed class SummaryEvent extends Equatable {
  const SummaryEvent();

  @override
  List<Object> get props => [];
}

final class LoadSummary extends SummaryEvent {
  const LoadSummary();
}

final class SummaryTick extends SummaryEvent {
  const SummaryTick();
}

final class StartPolling extends SummaryEvent {}

final class StopPolling extends SummaryEvent {}

enum SummaryStateStatus { initial, loading, success, failure, empty }

class SummaryState extends Equatable {
  final SummaryModel summaryModel;
  final SummaryStateStatus status;
  final String error;
  final String message;
  final int version;
  const SummaryState({
    required this.summaryModel,
    this.status = SummaryStateStatus.initial,
    this.error = "",
    this.message = "",
    this.version = 0,
  });

  SummaryState copyWith({
    SummaryModel? summaryModel,
    SummaryStateStatus? status,
    String? error,
    String? message,
    int? version,
  }) {
    return SummaryState(
      summaryModel: summaryModel ?? this.summaryModel,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [summaryModel, status, error, message, version];
}
