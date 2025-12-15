import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/clients_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

class ClientsPermittedBloc
    extends Bloc<ClientsPermittedEvent, ClientsPermittedState> {
  final PiholeRepository piholeRepository;
  ClientsPermittedBloc(this.piholeRepository)
    : super(ClientsPermittedInitial()) {
    on<LoadPermittedClients>(_getClientsPermitted);
  }

  void _getClientsPermitted(
    LoadPermittedClients event,
    Emitter<ClientsPermittedState> emit,
  ) async {
    emit(ClientsPermittedLoading());
    try {
      final clients = await piholeRepository.getClients(event.blocked);
      if (clients.clients.isEmpty) {
        emit(ClientsPermittedEmpty());
      } else {
        emit(ClientsPermittedLoaded(clients));
      }
    } catch (e) {
      emit(ClientsPermittedError(e.toString()));
    }
  }
}

@immutable
abstract class ClientsPermittedEvent {}

class LoadPermittedClients extends ClientsPermittedEvent {
  final Map<String, dynamic> blocked;
  LoadPermittedClients(this.blocked);
}

@immutable
abstract class ClientsPermittedState {}

class ClientsPermittedInitial extends ClientsPermittedState {}

class ClientsPermittedLoading extends ClientsPermittedState {}

class ClientsPermittedLoaded extends ClientsPermittedState {
  final ClientsModel clients;
  ClientsPermittedLoaded(this.clients);
}

class ClientsPermittedEmpty extends ClientsPermittedState {}

class ClientsPermittedError extends ClientsPermittedState {
  final String errorMessage;
  ClientsPermittedError(this.errorMessage);
}
