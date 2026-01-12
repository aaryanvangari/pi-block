import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/clients_suggestion_model.dart';
import 'package:pi_block/models/clients_update_model.dart';
import 'package:pi_block/models/client_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final PiholeRepository piholeRepository;

  ClientsBloc(this.piholeRepository) : super(ClientsState()) {
    on<LoadClients>(_loadClients);
    on<UpdateClientsItem>(_updateClientsItem);
    on<AddClientsItem>(_addClientsItem);
    on<DeleteClientsItem>(_deleteClientsItem);
    on<LoadClientsSuggestions>(_loadClientsSuggestions);
  }

  void _loadClients(LoadClients event, Emitter<ClientsState> emit) async {
    emit(
      state.copyWith(
        status: ClientsStateStatus.loading,
        itemStatus: ClientsItemStateStatus.initial,
      ),
    );
    try {
      final clients = await piholeRepository.getClientsData();
      emit(
        state.copyWith(status: ClientsStateStatus.success, clients: clients),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ClientsStateStatus.failure, error: e.toString()),
      );
    }
  }

  void _loadClientsSuggestions(
    LoadClientsSuggestions event,
    Emitter<ClientsState> emit,
  ) async {
    emit(
      state.copyWith(suggestionStatus: ClientsSuggestionsStateStatus.loading),
    );
    try {
      final suggestions = await piholeRepository.getClientsSuggestionsData();
      emit(
        state.copyWith(
          suggestionStatus: ClientsSuggestionsStateStatus.success,
          suggestions: suggestions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          suggestionStatus: ClientsSuggestionsStateStatus.failure,
          error: e.toString(),
        ),
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

      final updatedClient = clientsUpdateModel.clients.first;

      final updatedClients = state.clients
          .map((d) => d.id == updatedClient.id ? updatedClient : d)
          .toList();

      emit(
        state.copyWith(
          clients: updatedClients,
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
      final clients = [...state.clients, clientsUpdateModel.clients.first];

      emit(
        state.copyWith(
          clients: clients,
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
      if (!isDeleted) {
        emit(
          state.copyWith(
            itemStatus: ClientsItemStateStatus.failure,
            error: "Failed to delete",
          ),
        );
        return;
      }

      // ignoring the deleted item
      final updatedClients = state.clients
          .where((d) => d.id != event.clientModel.id)
          .toList();
      emit(
        state.copyWith(
          clients: updatedClients,
          itemStatus: ClientsItemStateStatus.success,
          message: "Successfully Deleted",
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
}
