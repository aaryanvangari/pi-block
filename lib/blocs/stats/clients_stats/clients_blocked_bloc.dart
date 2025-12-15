import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/clients_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

class ClientsBlockedBloc
    extends Bloc<ClientsBlockedEvent, ClientsBlockedState> {
  final PiholeRepository piholeRepository;
  ClientsBlockedBloc(this.piholeRepository) : super(ClientsBlockedInitial()) {
    on<LoadBlockedClients>(_getClientsBlocked);
  }

  void _getClientsBlocked(
    LoadBlockedClients event,
    Emitter<ClientsBlockedState> emit,
  ) async {
    emit(ClientsBlockedLoading());
    try {
      final clients = await piholeRepository.getClients(event.blocked);
      if (clients.clients.isEmpty) {
        emit(ClientsBlockedEmpty());
      } else {
        emit(ClientsBlockedLoaded(clients));
      }
    } catch (e) {
      emit(ClientsBlockedError(e.toString()));
    }
  }
}

@immutable
abstract class ClientsBlockedEvent {}

class LoadBlockedClients extends ClientsBlockedEvent {
  final Map<String, dynamic> blocked;
  LoadBlockedClients(this.blocked);
}

@immutable
abstract class ClientsBlockedState {}

class ClientsBlockedInitial extends ClientsBlockedState {}

class ClientsBlockedLoading extends ClientsBlockedState {}

class ClientsBlockedLoaded extends ClientsBlockedState {
  final ClientsModel clients;
  ClientsBlockedLoaded(this.clients);
}

class ClientsBlockedEmpty extends ClientsBlockedState {}

class ClientsBlockedError extends ClientsBlockedState {
  final String errorMessage;
  ClientsBlockedError(this.errorMessage);
}
