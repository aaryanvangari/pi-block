import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/clients_update_model.dart';
import 'package:pi_block/models/client_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:rxdart/subjects.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final PiholeRepository piholeRepository;

  late final _clientstreamController =
      BehaviorSubject<List<ClientModel>>.seeded(const []);

  ClientsBloc(this.piholeRepository) : super(ClientsState()) {
    on<LoadClients>(_loadClients);
    on<UpdateClientsItem>(_updateClientsItem);
    on<AddClientsItem>(_addClientsItem);
    on<DeleteClientsItem>(_deleteClientsItem);
    _clientstreamController.add(const []);
  }

  Stream<List<ClientModel>> getClients() =>
      _clientstreamController.asBroadcastStream();

  void _loadClients(LoadClients event, Emitter<ClientsState> emit) async {
    emit(
      state.copyWith(
        status: ClientsStateStatus.loading,
        itemStatus: ClientsItemStateStatus.initial,
      ),
    );
    try {
      final clients = await piholeRepository.getClientsData();
      _clientstreamController.add(clients);
      await emit.forEach<List<ClientModel>>(
        getClients(),
        onData: (clients) => state.copyWith(
          status: ClientsStateStatus.success,
          clients: clients,
        ),
        onError: (_, _) => state.copyWith(status: ClientsStateStatus.failure),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ClientsStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _updateClientsItem(
    UpdateClientsItem event,
    Emitter<ClientsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: ClientsItemStateStatus.loading));
    try {
      final newClient = event.clientModel.copyWith(
        comment: event.comment,
        groups: event.groups,
      );

      ClientsUpdateModel clientsUpdateModel = await piholeRepository
          .updateClientItem(newClient);
      final clients = [..._clientstreamController.value];
      final clientIndex = clients.indexWhere(
        (t) => t.id == event.clientModel.id,
      );
      if (clientIndex >= 0) {
        clients[clientIndex] = clientsUpdateModel.clients[0];
      }
      _clientstreamController.add(clients);
      emit(
        state.copyWith(
          itemStatus: ClientsItemStateStatus.success,
          message: "Successfully Updated",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: ClientsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: ClientsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _addClientsItem(
    AddClientsItem event,
    Emitter<ClientsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: ClientsItemStateStatus.loading));
    try {
      ClientsUpdateModel clientsUpdateModel = await piholeRepository
          .addClientsItem(event.clientModel);
      final clients = [..._clientstreamController.value];
      clients.add(clientsUpdateModel.clients[0]);
      _clientstreamController.add(clients);
      emit(
        state.copyWith(
          itemStatus: ClientsItemStateStatus.success,
          message: "Successfully Added",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: ClientsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: ClientsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _deleteClientsItem(
    DeleteClientsItem event,
    Emitter<ClientsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: ClientsItemStateStatus.loading));
    try {
      bool isDeleted = await piholeRepository.deleteClientsItem(
        event.clientModel,
      );
      if (isDeleted) {
        final clients = [..._clientstreamController.value];
        final clientIndex = clients.indexWhere(
          (t) => t.id == event.clientModel.id,
        );
        if (clientIndex >= 0) {
          clients.removeAt(clientIndex);
        }
        _clientstreamController.add(clients);
        emit(
          state.copyWith(
            itemStatus: ClientsItemStateStatus.success,
            message: "Successfully Deleted",
          ),
        );
      }

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: ClientsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: ClientsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _clientstreamController.close();
    return super.close();
  }
}
