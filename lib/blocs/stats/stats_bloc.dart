import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(StatsState(version: 0)) {
    on<RefreshStats>(_refreshStats);
  }

  void _refreshStats(RefreshStats event, Emitter<StatsState> emit) async {
    emit(StatsState(version: state.version + 1));
  }
}

sealed class StatsEvent extends Equatable {}

final class RefreshStats extends StatsEvent {
  RefreshStats();

  @override
  List<Object?> get props => [];
}

class StatsState extends Equatable {
  final int version;
  const StatsState({required this.version});

  @override
  List<Object?> get props => [version];
}
