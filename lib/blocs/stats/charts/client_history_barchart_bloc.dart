import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/clients_history_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

class ClientHistoryBarchartBloc
    extends Bloc<ClientHistoryBarchartEvent, ClientHistoryBarchartState> {
  final PiholeRepository piholeRepository;
  ClientHistoryBarchartBloc(this.piholeRepository)
    : super(ClientHistoryBarchartInitial()) {
    on<LoadClientHistoryBarchart>(_getClientHistoryBarchart);
  }

  void _getClientHistoryBarchart(
    LoadClientHistoryBarchart event,
    Emitter<ClientHistoryBarchartState> emit,
  ) async {
    emit(ClientHistoryBarchartLoading());
    try {
      final clientHistoryModel = await piholeRepository.getClientsHistory();
      emit(ClientHistoryBarchartLoaded(clientHistoryModel));
    } catch (e) {
      emit(ClientHistoryBarchartError(e.toString()));
    }
  }
}

@immutable
abstract class ClientHistoryBarchartEvent {}

class LoadClientHistoryBarchart extends ClientHistoryBarchartEvent {
  LoadClientHistoryBarchart();
}

@immutable
abstract class ClientHistoryBarchartState {}

class ClientHistoryBarchartInitial extends ClientHistoryBarchartState {}

class ClientHistoryBarchartLoading extends ClientHistoryBarchartState {}

class ClientHistoryBarchartLoaded extends ClientHistoryBarchartState {
  final ClientHistoryModel clientHistoryModel;
  ClientHistoryBarchartLoaded(this.clientHistoryModel);
}

class ClientHistoryBarchartEmpty extends ClientHistoryBarchartState {}

class ClientHistoryBarchartError extends ClientHistoryBarchartState {
  final String errorMessage;
  ClientHistoryBarchartError(this.errorMessage);
}
