import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/version_model.dart';

class VersionInfoBloc extends Bloc<VersionInfoEvent, VersionInfoState> {
  final PiholeRepository piholeRepository;

  VersionInfoBloc(this.piholeRepository)
    : super(
        VersionInfoState(
          status: VersionStateStatus.initial,
          versionModel: VersionModel.empty(),
        ),
      ) {
    on<LoadVersionInfo>(_onLoadVersion);
  }

  /// Initial load + start polling
  Future<void> _onLoadVersion(
    LoadVersionInfo event,
    Emitter<VersionInfoState> emit,
  ) async {
    emit(state.copyWith(status: VersionStateStatus.loading));

    try {
      VersionModel versionModel = await piholeRepository.getVersion();

      emit(
        state.copyWith(
          status: VersionStateStatus.success,
          versionModel: versionModel,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: VersionStateStatus.failure, error: e.toString()),
      );
    }
  }
}

sealed class VersionInfoEvent extends Equatable {
  const VersionInfoEvent();

  @override
  List<Object> get props => [];
}

final class LoadVersionInfo extends VersionInfoEvent {
  const LoadVersionInfo();
}

enum VersionStateStatus { initial, loading, success, failure, empty }

class VersionInfoState extends Equatable {
  final VersionModel versionModel;
  final VersionStateStatus status;
  final String error;
  final String message;
  const VersionInfoState({
    required this.versionModel,
    this.status = VersionStateStatus.initial,
    this.error = "",
    this.message = "",
  });

  VersionInfoState copyWith({
    VersionModel? versionModel,
    VersionStateStatus? status,
    String? error,
    String? message,
  }) {
    return VersionInfoState(
      versionModel: versionModel ?? this.versionModel,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [versionModel, status, error, message];
}
