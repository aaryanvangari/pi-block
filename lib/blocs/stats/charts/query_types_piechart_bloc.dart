import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/summary_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

class QueryTypesPiechartBloc
    extends Bloc<QueryTypesPiechartEvent, QueryTypesPiechartState> {
  final PiholeRepository piholeRepository;
  QueryTypesPiechartBloc(this.piholeRepository)
    : super(QueryTypesPiechartInitial()) {
    on<LoadQueryTypesPiechart>(_getQueryTypesPiechart);
  }

  void _getQueryTypesPiechart(
    LoadQueryTypesPiechart event,
    Emitter<QueryTypesPiechartState> emit,
  ) async {
    emit(QueryTypesPiechartLoading());
    try {
      final statsQueryTypes = await piholeRepository.getQueryTypes();
      emit(QueryTypesPiechartLoaded(statsQueryTypes));
    } catch (e) {
      emit(QueryTypesPiechartError(e.toString()));
    }
  }
}

@immutable
abstract class QueryTypesPiechartEvent {}

class LoadQueryTypesPiechart extends QueryTypesPiechartEvent {
  LoadQueryTypesPiechart();
}

@immutable
abstract class QueryTypesPiechartState {}

class QueryTypesPiechartInitial extends QueryTypesPiechartState {}

class QueryTypesPiechartLoading extends QueryTypesPiechartState {}

class QueryTypesPiechartLoaded extends QueryTypesPiechartState {
  final StatsQueryTypes statsQueryTypes;
  QueryTypesPiechartLoaded(this.statsQueryTypes);
}

class QueryTypesPiechartEmpty extends QueryTypesPiechartState {}

class QueryTypesPiechartError extends QueryTypesPiechartState {
  final String errorMessage;
  QueryTypesPiechartError(this.errorMessage);
}
