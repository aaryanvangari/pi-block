import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/history_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

class QueryHistoryBarchartBloc
    extends Bloc<QueryHistoryBarchartEvent, QueryHistoryBarchartState> {
  final PiholeRepository piholeRepository;
  QueryHistoryBarchartBloc(this.piholeRepository)
    : super(QueryHistoryBarchartInitial()) {
    on<LoadQueryHistoryBarchart>(_getQueryHistoryBarchart);
  }

  void _getQueryHistoryBarchart(
    LoadQueryHistoryBarchart event,
    Emitter<QueryHistoryBarchartState> emit,
  ) async {
    emit(QueryHistoryBarchartLoading());
    try {
      final historyModel = await piholeRepository.getQueriesHistory();
      emit(QueryHistoryBarchartLoaded(historyModel));
    } catch (e) {
      emit(QueryHistoryBarchartError(e.toString()));
    }
  }
}

@immutable
abstract class QueryHistoryBarchartEvent {}

class LoadQueryHistoryBarchart extends QueryHistoryBarchartEvent {
  LoadQueryHistoryBarchart();
}

@immutable
abstract class QueryHistoryBarchartState {}

class QueryHistoryBarchartInitial extends QueryHistoryBarchartState {}

class QueryHistoryBarchartLoading extends QueryHistoryBarchartState {}

class QueryHistoryBarchartLoaded extends QueryHistoryBarchartState {
  final HistoryModel historyModel;
  QueryHistoryBarchartLoaded(this.historyModel);
}

class QueryHistoryBarchartEmpty extends QueryHistoryBarchartState {}

class QueryHistoryBarchartError extends QueryHistoryBarchartState {
  final String errorMessage;
  QueryHistoryBarchartError(this.errorMessage);
}
