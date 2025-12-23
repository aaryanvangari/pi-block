import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/host_model.dart';

class HostInfoBloc extends Bloc<HostInfoEvent, HostInfoState> {
  final PiholeRepository piholeRepository;

  HostInfoBloc(this.piholeRepository)
    : super(
        HostInfoState(
          status: HostStateStatus.initial,
          hostModel: HostModel.empty(),
        ),
      ) {
    on<LoadHostInfo>(_onLoadHost);
  }

  /// Initial load + start polling
  Future<void> _onLoadHost(
    LoadHostInfo event,
    Emitter<HostInfoState> emit,
  ) async {
    emit(state.copyWith(status: HostStateStatus.loading));

    try {
      HostModel hostModel = await piholeRepository.getHostInfo();

      emit(
        state.copyWith(status: HostStateStatus.success, hostModel: hostModel),
      );
    } catch (e) {
      emit(
        state.copyWith(status: HostStateStatus.failure, error: e.toString()),
      );
    }
  }
}

sealed class HostInfoEvent extends Equatable {
  const HostInfoEvent();

  @override
  List<Object> get props => [];
}

final class LoadHostInfo extends HostInfoEvent {
  const LoadHostInfo();
}

enum HostStateStatus { initial, loading, success, failure, empty }

class HostInfoState extends Equatable {
  final HostModel hostModel;
  final HostStateStatus status;
  final String error;
  final String message;
  const HostInfoState({
    required this.hostModel,
    this.status = HostStateStatus.initial,
    this.error = "",
    this.message = "",
  });

  HostInfoState copyWith({
    HostModel? hostModel,
    HostStateStatus? status,
    String? error,
    String? message,
  }) {
    return HostInfoState(
      hostModel: hostModel ?? this.hostModel,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [hostModel, status, error, message];
}
