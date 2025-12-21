import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/summary_model.dart';


class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final PiholeRepository piholeRepository;
  Timer? _timer;

  SummaryBloc(this.piholeRepository)
    : super(
        SummaryState(
          status: SummaryStateStatus.initial,
          summaryModel: SummaryModel.empty(),
        ),
      ) {
    on<LoadSummary>(_onLoadSummary);
    on<SummaryTick>(_onSummaryTick);
  }

  /// Initial load + start polling
  Future<void> _onLoadSummary(
    LoadSummary event,
    Emitter<SummaryState> emit,
  ) async {
    emit(state.copyWith(status: SummaryStateStatus.loading));

    try {
      final summary = await piholeRepository.getSummary();

      emit(
        state.copyWith(
          status: SummaryStateStatus.success,
          summaryModel: summary,
        ),
      );

      _startPolling();
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
      final summary = await piholeRepository.getSummary();
      emit(
        state.copyWith(
          status: SummaryStateStatus.success,
          summaryModel: summary,
        ),
      );
    } catch (_) {
      // Optional: keep last success instead of failing UI
    }
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: KTimers.summary),
      (_) => add(SummaryTick()),
    );
  }

  @override
  Future<void> close() {
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


enum SummaryStateStatus { initial, loading, success, failure, empty }

class SummaryState extends Equatable {
  final SummaryModel summaryModel;
  final SummaryStateStatus status;
  final String error;
  final String message;
  const SummaryState({
    required this.summaryModel,
    this.status = SummaryStateStatus.initial,
    this.error = "",
    this.message = "",
  });

  SummaryState copyWith({
    SummaryModel? summaryModel,
    SummaryStateStatus? status,
    String? error,
    String? message,
  }) {
    return SummaryState(
      summaryModel: summaryModel ?? this.summaryModel,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [summaryModel, status, error, message];
}

