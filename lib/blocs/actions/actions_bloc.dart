import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/gravity_log_model.dart';

class ActionsBloc extends Bloc<ActionsEvent, ActionsState> {
  final PiholeRepository piholeRepository;

  ActionsBloc(this.piholeRepository)
    : super(
        ActionsState(
          status: ActionsStateStatus.initial,
          gravityStatus: GravityStateStatus.initial,
          message: "",
        ),
      ) {
    on<UpdateGravity>(_onUpdateGravity);
  }

  Future<void> _onUpdateGravity(
    UpdateGravity event,
    Emitter<ActionsState> emit,
  ) async {
    emit(
      state.copyWith(
        gravityStatus: GravityStateStatus.loading,
        gravityOutput: [],
        error: '',
      ),
    );

    bool hasError = false;

    await emit.forEach<GravityLog>(
      piholeRepository.getGravityLogs(),
      onData: (log) {
        // JSON error from stream
        if (log.type == GravityLogType.streamError) {
          hasError = true;

          return state.copyWith(
            gravityStatus: GravityStateStatus.failure,
            error: log.message,
          );
        }

        // Normal log from stream
        final updated = List<GravityLog>.from(state.gravityOutput)..add(log);
        return state.copyWith(gravityOutput: updated);
      },
      onError: (error, stackTrace) {
        hasError = true;
        return state.copyWith(
          gravityStatus: GravityStateStatus.failure,
          error: error.toString(),
        );
      },
    );
    if (!hasError) {
      emit(
        state.copyWith(
          gravityStatus: GravityStateStatus.success,
          message: 'Successfully Completed',
        ),
      );
    }
  }
}

sealed class ActionsEvent extends Equatable {
  const ActionsEvent();

  @override
  List<Object> get props => [];
}

final class UpdateGravity extends ActionsEvent {
  const UpdateGravity();
}

enum ActionsStateStatus { initial, loading, success, failure, empty }

enum GravityStateStatus { initial, loading, success, failure }

class ActionsState extends Equatable {
  final ActionsStateStatus status;
  final GravityStateStatus gravityStatus;
  final List<GravityLog> gravityOutput;
  final String error;
  final String message;
  const ActionsState({
    this.status = ActionsStateStatus.initial,
    this.gravityStatus = GravityStateStatus.initial,
    this.gravityOutput = const [],
    this.error = "",
    this.message = "",
  });

  ActionsState copyWith({
    ActionsStateStatus? status,
    GravityStateStatus? gravityStatus,
    List<GravityLog>? gravityOutput,
    String? error,
    String? message,
  }) {
    return ActionsState(
      status: status ?? this.status,
      gravityStatus: gravityStatus ?? this.gravityStatus,
      gravityOutput: gravityOutput ?? this.gravityOutput,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    gravityStatus,
    gravityOutput,
    error,
    message,
  ];
}
